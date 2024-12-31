require "./spec/support/login_macros"

module Renalware
  describe PD::RegimeBag do
    before do
      @patient = build_stubbed(:patient)
      @pd_regime_bag_1 = described_class.new
      @pd_regime_bag_2 = build(:pd_regime_bag,
                               sunday: true,
                               monday: false,
                               tuesday: true,
                               wednesday: false,
                               thursday: false,
                               friday: true,
                               saturday: false)
    end

    it :aggregate_failures do
      is_expected.to belong_to(:regime).touch(true)
      is_expected.to validate_presence_of :bag_type
      is_expected.to validate_presence_of :volume
      is_expected.to enumerize(:role).in(:ordinary, :additional_manual_exchange, :last_fill)
    end

    it "defaults all days of week to true" do
      expect(described_class.new).to have_attributes(
        monday: true,
        tuesday: true,
        wednesday: true,
        thursday: true,
        friday: true,
        saturday: true,
        sunday: true
      )
    end

    it {
      is_expected.to(
        validate_numericality_of(:volume)
        .is_greater_than_or_equal_to(100)
        .is_less_than_or_equal_to(10000)
        .allow_nil
      )
    }

    describe "days" do
      it "returns days of the week which have been checked as true or false" do
        expect(@pd_regime_bag_2.days).to eq([true, false, true, false, false, true, false])
      end
    end

    describe "Date::DAYNAME_SYMBOLS" do
      it "converts rails date daynames module to become lowercase and to symbol" do
        days = %i(sunday monday tuesday wednesday thursday friday saturday)
        expect(Date::DAYNAME_SYMBOLS).to eq(days)
      end
    end
  end
end
