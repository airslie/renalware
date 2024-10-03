# frozen_string_literal: true

module Renalware
  module HD
    describe "Closed Session" do
      describe Session::Closed do
        it :aggregate_failures do
          is_expected.to validate_presence_of(:signed_off_by)
          is_expected.to validate_presence_of(:stopped_at)
          is_expected.to validate_presence_of(:signed_off_at)
          is_expected.to validate_presence_of(:dialysate)
          is_expected.to belong_to(:profile)
          is_expected.to belong_to(:dry_weight)
        end

        it "defines a policy class" do
          expect(described_class.policy_class).to eq(ClosedSessionPolicy)
        end

        describe "immutable?" do
          it "returns true is the appropriate window has elapsed" do
            session = described_class.new(signed_off_at: Time.zone.now - 10.days)
            allow(session).to receive(:persisted?).and_return(true)

            expect(session.immutable?).to be(true)
          end

          it "returns false if the appropriate window has not yet elapsed" do
            session = described_class.new(signed_off_at: Time.zone.now - 1.minute)
            allow(session).to receive(:persisted?).and_return(true)

            expect(session.immutable?).to be(false)
          end

          it "returns true if not yet persisted" do
            session = described_class.new(signed_off_at: Time.zone.now - 1.minute)
            allow(session).to receive(:persisted?).and_return(false)

            expect(session.immutable?).to be(true)
          end
        end

        describe "patient_group_directions validation" do
          context "when Renalware.config.hd_session_require_patient_group_directions is true" do
            before do
              allow(Renalware.config)
                .to receive(:hd_session_require_patient_group_directions)
                .and_return(true)
            end

            it { is_expected.to validate_presence_of(:patient_group_directions) }
          end

          context "when Renalware.config.hd_session_require_patient_group_directions is false" do
            before do
              allow(Renalware.config)
                .to receive(:hd_session_require_patient_group_directions)
                .and_return(false)
            end

            it { is_expected.not_to validate_presence_of(:patient_group_directions) }
          end
        end
      end

      describe Session::Closed::SessionDocument do
        subject(:document) { described_class.new }

        %i(hdf_pre hdf_post).each do |hd_type|
          it "validates presence of #hdf if hd_type is hdf" do
            document.info.hd_type = hd_type
            document.valid?
            expect(document.hdf.errors).to include(:subs_volume)
            expect(document.hdf.errors).not_to include(:subs_goal)
            expect(document.hdf.errors).not_to include(:subs_rate)
            expect(document.hdf.errors).not_to include(:subs_pct)
          end
        end

        it "does not validate presence of hdf if hd_type is HD" do
          document.info.hd_type = :hd
          document.valid?

          expect(document.hdf.errors).not_to include(:subs_fluid_pct)
        end
      end

      describe Session::Closed::SessionDocument::Info do
        it :aggregate_failures do
          is_expected.to validate_presence_of(:hd_type)
          is_expected.to validate_presence_of(:access_confirmed)
        end
      end

      describe Session::Closed::SessionDocument::Dialysis do
        it :aggregate_failures do
          is_expected.to validate_presence_of(:arterial_pressure)
          is_expected.to validate_presence_of(:venous_pressure)
          is_expected.to validate_presence_of(:fluid_removed)
          is_expected.to validate_presence_of(:blood_flow)
          is_expected.to validate_presence_of(:flow_rate)
          is_expected.not_to validate_presence_of(:machine_urr)
          is_expected.not_to validate_presence_of(:machine_ktv)
          is_expected.to validate_presence_of(:litres_processed)
        end
      end

      describe Session::Closed::SessionDocument::AvfAvgAssessment do
        it { is_expected.to validate_presence_of(:score) }
      end

      describe Session::Closed::SessionDocument::Observations do
        subject(:observations) {
          described_class.new(blood_pressure: BloodPressure.new)
        }

        describe "validation" do
          it :aggregate_failures do
            is_expected.to validate_presence_of(:pulse)
            is_expected.not_to validate_presence_of(:bm_stix)
            is_expected.to validate_presence_of(:weight_measured)
            is_expected.to validate_presence_of(:temperature_measured)
            is_expected.to validate_presence_of(:respiratory_rate_measured)
          end

          it "validates presence of blood_pressure" do
            expect(observations).not_to be_valid
            expect(observations.blood_pressure.errors).to include(:systolic, :diastolic)
          end

          describe "#respiratory_rate" do
            context "when respiratory_rate_measured is false" do
              before { observations.respiratory_rate_measured = :no }

              it { is_expected.not_to validate_presence_of(:respiratory_rate) }
            end

            context "when respiratory_rate_measured is true" do
              before { observations.respiratory_rate_measured = :yes }

              it { is_expected.to validate_presence_of(:respiratory_rate) }
            end
          end

          describe "#weight" do
            it "validate weight when weight_measured is true" do
              observations.weight_measured = :yes
              expect(observations).to validate_presence_of(:weight)
            end

            it "does not validate weight when weight_measured is false" do
              observations.weight_measured = :no
              expect(observations).not_to validate_presence_of(:weight)
            end
          end

          describe "#temperature" do
            it "validate temperature when temperature_measured is true" do
              observations.temperature_measured = :yes
              expect(observations).to validate_presence_of(:temperature)
            end

            it "does not validate temperature when weight_measured is false" do
              observations.temperature_measured = :no
              expect(observations).not_to validate_presence_of(:temperature)
            end
          end
        end
      end

      describe Session::Closed::SessionDocument::Complications do
        it { is_expected.to validate_presence_of(:line_exit_site_status) }
      end
    end
  end
end
