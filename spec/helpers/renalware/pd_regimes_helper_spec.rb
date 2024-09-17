# frozen_string_literal: true

module Renalware
  describe PDRegimesHelper do
    describe "default_daily_glucose_average" do
      let(:patient) { build_stubbed(:patient) }
      let(:capd_regime) do
        bag_type_13_6 = create(
          :bag_type,
          manufacturer: "Baxter",
          description: "Dianeal PD2 1.36% (Yellow)",
          glucose_content: 1.3,
          glucose_strength: :low
        )

        bag_type_22_7 = create(
          :bag_type,
          manufacturer: "Baxter",
          description: "Dianeal PD2 2.27% (Green)",
          glucose_content: 2.2,
          glucose_strength: :medium
        )

        pd_regime_bag_13_6_1 = build(
          :pd_regime_bag,
          bag_type: bag_type_13_6,
          volume: 1500,
          sunday: false,
          monday: true,
          tuesday: false,
          wednesday: true,
          thursday: true,
          friday: false,
          saturday: false
        )

        pd_regime_bag_13_6_2 = build(
          :pd_regime_bag,
          bag_type: bag_type_13_6,
          volume: 1500,
          sunday: false,
          monday: true,
          tuesday: false,
          wednesday: true,
          thursday: false,
          friday: false,
          saturday: false
        )

        pd_regime_bag_22_7 = build(
          :pd_regime_bag,
          bag_type: bag_type_22_7,
          volume: 2500,
          sunday: false,
          monday: true,
          tuesday: true,
          wednesday: false,
          thursday: true,
          friday: true,
          saturday: true
        )

        build(:capd_regime).tap do |regime|
          regime.bags << pd_regime_bag_13_6_1
          regime.bags << pd_regime_bag_13_6_2
          regime.bags << pd_regime_bag_22_7
          regime.save
        end
      end

      context "when there is glucose content" do
        it "returns the correct low strength glucose volume" do
          expect(
            default_daily_glucose_average(capd_regime.glucose_volume_low_strength)
          ).to eq(1071)
        end

        it "returns the correct medium strength glucose volume" do
          expect(
            default_daily_glucose_average(capd_regime.glucose_volume_medium_strength)
          ).to eq(1785)
        end
      end

      context "when there is no glucose content" do
        it "returns 0" do
          expect(
            default_daily_glucose_average(capd_regime.glucose_volume_high_strength)
          ).to eq(0)
        end
      end
    end
  end
end
