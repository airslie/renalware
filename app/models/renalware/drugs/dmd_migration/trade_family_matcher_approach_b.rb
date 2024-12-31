module Renalware
  module Drugs
    module DMDMigration
      class TradeFamilyMatcherApproachB
        def call
          trade_family_names = TradeFamily.pluck(:name)
          names = DMDMatch.pluck(:drug_name)

          names.each do |name|
            # trade names are only in brackets
            next unless name.include?("(")

            match = find_match(name, trade_family_names)

            if match
              DMDMatch.where(drug_name: name).update_all(trade_family_name: match)
            end
          end
        end

        private

        def find_match(name, trade_family_names)
          trade_family_names.each do |trade_family_name|
            trade_family_name.downcase.tr("()", "").split.each do |word|
              if name.include? word
                return trade_family_name
              end
            end
          end
        end
      end
    end
  end
end
