# frozen_string_literal: true

module Renalware
  module Pathology
    describe CurrentObservationSet do
      include PathologySpecHelper
      it :aggregate_failures do
        is_expected.to belong_to(:patient)
        is_expected.to validate_presence_of(:patient)
      end

      describe "values" do
        it "defaults to an empty hash" do
          expect(described_class.new.values).to eq({})
        end

        it "persists ok" do
          patient = create(:pathology_patient)
          obs_set = patient.fetch_current_observation_set
          hgb = { "result" => "23.1", "observed_at" => "2016-12-12 12:12:12" }
          obs_set.values["HGB"] = hgb
          obs_set.save!

          obs_set = patient.reload.fetch_current_observation_set
          expect(obs_set.values["HGB"]).to eq(hgb)
        end
      end

      describe "values_for_codes" do
        it "returns only the values matching the requested codes aray" do
          patient = create(:pathology_patient)
          set = patient.fetch_current_observation_set
          hgb = { "result" => 23.1, "observed_at" => "2016-12-12 12:12:12" }
          cre = { "result" => 2.1, "observed_at" => "2016-12-12 12:12:12" }
          set.values["HGB"] = hgb
          set.values["CRE"] = cre
          set.save!

          set.reload
          expect(set.values_for_codes("HGB")).to eq("HGB" => hgb)
          expect(set.values_for_codes("XXX")).to eq("XXX" => {})
        end

        context "when the patient has nothing in their current_observation_set" do
          it "returns an empty hash for each requested code" do
            patient = create(:pathology_patient)
            set = patient.fetch_current_observation_set

            expect(set).not_to be_nil # we build one if missing
            values = set.values_for_codes(%w(HGB XXX))
            expect(values).to eq("HGB" => {}, "XXX" => {})
            expect(values.hgb_result).to be_nil
            expect(values.hgb_observed_at).to be_nil
          end
        end
      end

      describe "the TRIGGER on pathology_observations that updates current_observation_set" do
        context "when a patient has no current_observation_set yet" do
          it "creating an observation adds it to the current_observation_set jsonb hash" do
            time = Time.now.utc
            patient = create(:pathology_patient)
            expect {
              create_hgb_observation(patient: patient, observed_at: time, result: 123.1)
            }.to change(described_class, :count).by(1)
            # trigger has now updated the current_observation_set

            obs_set = described_class.find_by(patient_id: patient.id)
            hgb = obs_set.values[:HGB]
            expect_obs_to_match(hgb, "123.1", time)
          end
        end

        context "when a patient has a current_observation_set with an entry for HGB" do
          context "when a new HGB observation is created (importantly with a newer date)" do
            it "updates the values hash with the new result and time" do
              time = Time.now.utc
              patient = create(:pathology_patient)
              obs = create_hgb_observation(patient: patient, observed_at: time, result: 111.1)

              obs_set = described_class.find_by(patient_id: patient.id)
              hgb = obs_set.values[:HGB]
              expect_obs_to_match(hgb, 111.1, time)

              new_time = time + 1.hour
              expect {
                obs = create_hgb_observation(patient: patient, observed_at: new_time, result: 222.2)
              }.not_to change(described_class, :count)
              # trigger has now updated the current_observation_set

              new_hgb = obs_set.reload.values[:HGB]
              expect(new_hgb).not_to eq(hgb)
              expect_obs_to_match(new_hgb, obs.result, new_time)
            end
          end

          context "when another HGB observation is created but with an OLDER date" do
            it "does not update the values hash" do
              time = Time.now.utc
              patient = create(:pathology_patient)
              obs = create_hgb_observation(patient: patient, observed_at: time, result: 111.1)
              # trigger has now updated the current_observation_set

              obs_set = described_class.find_by(patient_id: patient.id)
              hgb = obs_set.values[:HGB]
              expect_obs_to_match(hgb, obs.result, time)

              expect {
                obs = create_hgb_observation(
                  patient: patient,
                  observed_at: time - 1.hour, # an older date,
                  result: 222.2
                )
              }.not_to change(described_class, :count)

              expect(obs_set.reload.values[:HGB]).to eq(hgb)
            end
          end

          context "when another HGB observation is updated and has a NEWER date" do
            it "updates the values hash with the new result and time" do
              time = Time.now.utc
              patient = create(:pathology_patient)
              obs = create_hgb_observation(patient: patient, observed_at: time, result: 111.1)
              # trigger has now updated the current_observation_set

              new_time = time + 1.hour
              obs.update!(observed_at: new_time, result: 222.2)

              obs.reload
              obs_set = described_class.find_by(patient_id: patient.id)
              hgb = obs_set.values[:HGB]
              expect_obs_to_match(hgb, obs.result, new_time)
            end
          end

          context "when an HGB observation is updated with the same date but different result" do
            it "updates the values hash with the new result and time" do
              time = Time.now.utc
              patient = create(:pathology_patient)
              obs = create_hgb_observation(patient: patient, observed_at: time, result: 111.1)
              # trigger has now updated the current_observation_set

              obs.update!(result: 222.2)

              obs_set = described_class.find_by(patient_id: patient.id)
              hgb = obs_set.values[:HGB]
              expect_obs_to_match(hgb, obs.result, time)
            end
          end

          describe "#updated_at" do
            let(:time_format) { "%d-%m-%Y %Hh" }
            let(:patient) { create(:pathology_patient) }
            let(:obs_set) { described_class.find_by(patient_id: patient.id) }

            context "when the triggered fn updates the obs set because a new value arrives" do
              it "sets updated_at to the current time" do
                old_time = 1.day.ago
                travel_to(old_time) do
                  create_hgb_observation(
                    patient: patient,
                    observed_at: Time.zone.now,
                    result: 111.1
                  )
                  # Because we can't affect the PG server time here we simulate the fact that
                  # inserting a new obs changes  updated_at to the CURRENT_TIMESTAMP
                  # which would occur if PG as travelling though time with us
                  obs_set.update!(updated_at: old_time)
                end

                expect(obs_set.updated_at).to eq(old_time)

                create_hgb_observation(patient: patient, observed_at: Time.zone.now, result: 111.2)

                expect(obs_set.reload.updated_at.strftime(time_format))
                  .to eq(Time.zone.now.strftime(time_format))
              end
            end

            context "when the triggered fn skips updating the obs set cos inserted obs is older" do
              it "does not change #updated_at" do
                newer_time = 1.day.from_now
                travel_to(newer_time) do
                  create_hgb_observation(
                    patient: patient,
                    observed_at: Time.zone.now,
                    result: 111.1
                  )
                  # Because we can't affect the PG server time here we simulate the fact that
                  # inserting a new obs changes  updated_at to the CURRENT_TIMESTAMP
                  # which would occur if PG as travelling though time with us
                  obs_set.update!(updated_at: newer_time)
                end

                expect(obs_set.updated_at).to eq(newer_time)

                create_hgb_observation(patient: patient, observed_at: Time.zone.now, result: 111.2)

                expect(obs_set.updated_at).to eq(newer_time)
              end
            end
          end
        end
      end

      def create_hgb_observation(patient:, **)
        request = create(:pathology_observation_request, patient: patient)
        create(
          :pathology_observation,
          request: request,
          description: create(:pathology_observation_description, code: "HGB"),
          **
        )
      end

      # rubocop:disable Rails/TimeZone
      def expect_obs_to_match(obs, result, time)
        observed_at = l(Time.parse(obs[:observed_at]))
        expect(obs[:result]).to eq(result.to_s)
        expect(observed_at).to eq(l(time))
      end
      # rubocop:enable Rails/TimeZone
    end
  end
end
