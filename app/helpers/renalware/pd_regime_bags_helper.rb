module Renalware
  module PDRegimeBagsHelper
    def highlight_days_invalid(bag)
      if bag.errors.include?(:days)
        "validate-days-of-week"
      end
    end

    def highlight_add_bag_invalid(regime)
      if regime.errors.include?(:pd_regime_bags)
        "validate-add-min-bag"
      end
    end
  end
end
