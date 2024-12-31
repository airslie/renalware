module Renalware
  describe PDRegimeBagsHelper do
    let(:bag_type) { build_stubbed(:bag_type) }
    let(:invalid_pd_regime_bag) do
      build(
        :pd_regime_bag,
        bag_type_id: nil,
        volume: nil,
        sunday: false,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false
      )
    end

    let(:valid_pd_regime_bag) do
      build(
        :pd_regime_bag,
        bag_type_id: bag_type,
        volume: 600,
        sunday: true,
        monday: true,
        tuesday: true,
        wednesday: true,
        thursday: true,
        friday: true,
        saturday: true
      )
    end

    describe "highlight_days_invalid" do
      context "when invalid" do
        it 'applies class "show-form"' do
          invalid_pd_regime_bag.save
          expect(highlight_days_invalid(invalid_pd_regime_bag)).to eq("validate-days-of-week")
        end
      end

      context "when valid" do
        it 'does not apply class "show-form"' do
          valid_pd_regime_bag.save
          expect(highlight_days_invalid(invalid_pd_regime_bag)).to be_nil
        end
      end
    end
  end
end
