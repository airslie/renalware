module Renalware
  module Pathology
    describe KFRE::Listener do
      include PathologySpecHelper

      subject(:listener) { described_class.new }

      let(:egfr) { "5.0" }
      let(:acr) { 300 } # > 300 = severely increased
      let(:local_patient_id) { "Z999990" }
      let(:dob) { "2015-04-01" }
      let(:observation_datetime) { "200911111841" }
      let(:patient) do
        create(:pathology_patient,
               local_patient_id: local_patient_id,
               born_on: Time.zone.today - 34.years) do |pat|
          create(
            :modality,
            started_on: Date.parse(dob),
            patient: pat,
            description: create(:modality_description, :aki)
          )
        end
      end

      before do
        Renalware.config.hl7_patient_locator_strategy[:oru] = :simple
        create(:pathology_lab, :unknown)
        create(:user, username: Renalware::SystemUser.username)
      end

      def give_patient_an_egfr(patient, value)
        create_request_with_observations(
          patient: patient,
          obx_codes: ["EGFR"],
          requested_at: 1.month.ago,
          result: value
        )
      end

      describe "KFRE generation" do
        describe "#after_observation_request_persisted" do
          context "when the obr does not contain an ACR result" do
            it "does not create a KFRE" do
              obr = create(:pathology_observation_request, patient: patient)
              expect(obr.observations.count).to eq(0)

              expect {
                described_class.new.after_observation_request_persisted(obr)
              }.not_to change(Renalware::Pathology::Observation, :count)
            end
          end

          context "when the obr contains an ACR result" do
            context "when the patient has no recent egfr" do
              it "does not create a KFRE" do
                obr = create_request_with_observations(
                  patient: patient,
                  obx_codes: ["ACR"],
                  result: acr.to_s
                )
                # Sanity check
                expect(patient.current_observation_set.values.dig("ACR", "result")).to eq(acr.to_s)
                expect(obr.observations.count).to eq(1)

                expect {
                  described_class.new.after_observation_request_persisted(obr)
                }.not_to change(Renalware::Pathology::Observation, :count)
              end
            end

            context "when the patient has an egfr" do
              before { give_patient_an_egfr(patient, egfr) }

              it "creates 5 and 2 yr KFREs" do
                # Sanity check that the patient has the expected egfr
                expect(patient.current_observation_set.values.dig("EGFR", "result")).to eq(egfr)

                expected_date_time = Time.zone.parse(observation_datetime)

                obr = create_request_with_observations(
                  patient: patient,
                  obx_codes: ["ACR"],
                  requested_at: expected_date_time,
                  result: "10.0",
                  observed_at: expected_date_time
                )

                # Stub the actual calculation - we are testing the listener
                # not the calc service
                allow(KFRE::CalculateKFRE)
                  .to receive(:call)
                  .and_return(KFRE::Result.new(yr2: 10.1, yr5: 20.2))

                # The listener should create 2 observations, one for each of the 2 and 5 year
                # results. We use configured OBX codes for the ACR input and KFRE outputs.
                # See config/initializers/renalware.rb
                expect {
                  described_class.new.after_observation_request_persisted(obr)
                }.to change(Renalware::Pathology::Observation, :count).by(2)

                # Check the KFRE calc service was called with expected args
                expect(KFRE::CalculateKFRE)
                  .to have_received(:call)
                  .with(acr: 10.0, age: 34, egfr: egfr, sex: "M")

                patient.reload

                # Find the KFRE request created by the listener
                kfre_obr = patient.observation_requests.joins(:description)
                  .find_by(pathology_request_descriptions: { code: "KFRE" })
                expect(kfre_obr).to be_present
                expect(kfre_obr).to have_attributes(requested_at: expected_date_time)
                expect(kfre_obr.observations.count).to eq(2)

                # There should be a 2 year KFRE observation
                kfre_obx = kfre_obr.observations.detect do |obx|
                  obx.description.code == Renalware.config.pathology_kfre_2y_obx_code
                end
                expect(kfre_obx).to have_attributes(
                  result: "10.1",
                  observed_at: expected_date_time
                )

                # There should be a 5 year KFRE observation
                kfre_obx = kfre_obr.observations.detect do |obx|
                  obx.description.code == Renalware.config.pathology_kfre_5y_obx_code
                end
                expect(kfre_obx).to have_attributes(
                  result: "20.2",
                  observed_at: expected_date_time
                )
              end
            end
          end
        end
      end
    end
  end
end
