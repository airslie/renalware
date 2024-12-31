module Renalware
  module Drugs
    module DMDMigration
      # In cases where a Trade Family has been identified and approved,
      # it's possible to uniquely identify the matching VTM.
      class IdentifyVtmByTradeFamily
        def call
          trade_family_ids_by_name = Drugs::TradeFamily.pluck(:name, :id).to_h

          dmd_matches = DMDMatch.where(approved_trade_family_match: true)
            .where(vtm_name: nil)

          dmd_matches.each do |dmd_match|
            trade_family_id = trade_family_ids_by_name[dmd_match.trade_family_name]

            next if trade_family_id.nil?

            classification = Drugs::VMPClassification
              .where("? = ANY(trade_family_ids)", trade_family_id).first

            next if classification.nil?

            dmd_match.update(
              vtm_name: classification.drug.name,
              approved_vtm_match: true
            )
          end
        end
      end
    end
  end
end
