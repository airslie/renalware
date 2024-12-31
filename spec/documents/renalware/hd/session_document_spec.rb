module Renalware
  module HD
    describe SessionDocument, type: :model do
      describe SessionDocument::Dialysis do
        it do
          is_expected.to validate_numericality_of(:blood_flow)
            .is_greater_than_or_equal_to(50)
            .is_less_than_or_equal_to(800)
        end

        %i(
          arterial_pressure
          venous_pressure
          fluid_removed
          flow_rate
          machine_urr
          machine_ktv
          litres_processed
          blood_flow
        ).each do |att|
          it { is_expected.to validate_numericality_of(att) }
          it { is_expected.to allow_value("", nil).for(att) }
        end
      end

      describe SessionDocument::Observations, type: :model do
        %i(
          temperature
          weight
          bm_stix
          pulse
          respiratory_rate
        ).each do |att|
          it { is_expected.to validate_numericality_of(att) }
          it { is_expected.to allow_value("", nil).for(att) }
        end
      end

      describe SessionDocument::HDF, type: :model do
        %i(
          subs_fluid_pct
          subs_goal
          subs_rate
          subs_volume
        ).each do |att|
          it { is_expected.to validate_numericality_of(att) }
          it { is_expected.to allow_value("", nil).for(att) }
        end
      end

      describe "validation of pre- and post- weight difference" do
        subject(:document) { described_class.new }

        it "accepts a post-weight up to 7kg over the pre weight" do
          document.observations_before.weight = 13.1
          document.observations_after.weight = 20.1

          document.valid?

          expect(document.observations_after.errors).not_to include(:weight)
        end

        it "accepts a post-weight up to 7kg below the pre-weight" do
          document.observations_before.weight = 20.1
          document.observations_after.weight = 13.1

          document.valid?

          expect(document.observations_after.errors).not_to include(:weight)
        end

        it "validates that post-weight cannot be >7kg more than pre weight" do
          document.observations_before.weight = 100.1
          document.observations_after.weight = 107.2

          document.valid?

          expect(document.observations_after.errors).to include(:weight)
        end

        it "validates that pre-weight cannot be >7kg more than post weight" do
          document.observations_before.weight = 108
          document.observations_after.weight = 100

          document.valid?

          expect(document.observations_after.errors).to include(:weight)
        end
      end
    end
  end
end
