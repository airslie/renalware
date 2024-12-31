module Renalware
  module Drugs
    module DMDMigration
      class TradeFamilyMatcher
        SQL = <<-SQL.squish
          with matches AS (
            select
              regexp_replace(drug_name, 'Adult|Activated|Blue|Clear|dose|Rectal|Tube|Continuous|ORAL|use|HB|Human|Free|1 |Alpha|alpha|Cream|Adrenaline|Nail|HC | HC|Efferveschent|Liquid|1%|Inhaler|-C|Eye|Calcium|cream|Syrup|Ear|Bisulphate|Sulphate|Light|liquid| V|Co-|Oil|Q10|Linctus|Phosphate|Vitamin|hydrochloride|Cranberry|gel|10%|Sodium|MR|Tabs|tabs|FolicComplete|Gentamicin|GlucosaminePowder|Patch|Decanoate|Hydrocortisone|Patch|Ibuprofen|Ibesartan|iron|SR|Shampoo|Carbonate|Hydrochloride|Lidocaine|Lidocain|White|50%|Paraffin|Lithium|Loratadine|Citrate|Carboate|Mebeverine|2%|eye|Methionin|Methionine|Multivitamin|EC|Beta|Drop|LA|Powder|100,|Emollient|XL|Paracetamol|Water|Potassium|Effervescent|beta|Senna|1-|drop|Budesonide|200 |Carbomer|Chlorhexidine|Chrlorphenamine|Clotrimazole|co-|Salicylate|Gel|Evening|Fluconazole|Flupentixol|Decanoate|Folic| bd|Glucosamine|Iron|L-|Gel|B6|Phenol|Neo-|Nystatin|Oral|XL|Phenytoin|Standard|Bicarbonate|Chloride|patch|Salbutamol|effervescent|Selenium|50 |carbonate|Sodium|Compound|Vitamin B| B | A,| D |Vitamin E| C |Zinc|zuclopenthixol|Menthol|15%|300|Isophane|Irbesartan|Supplementation|Supplement|Biopatch|Chlorphenamine|Tropical|Vitamin D|Chewable|Retard', '', 'g') as drug_name,
              id
            from renalware.drug_dmd_matches
          )
          select
            matches.id,
            matches.drug_name,
            trade_family_search.name as match_name,
            trade_family_search.id as match_id
          from
            matches
            cross join lateral (
              select
                *,
                ts_rank(to_tsvector('english', trade_family_search.name), query, 1) as rank
              FROM
                renalware.drug_trade_families trade_family_search,
                to_tsquery(
                  'english',
                  REPLACE( plainto_tsquery( matches.drug_name )::varchar, '&', '|' )
                ) query
              WHERE
                query @@ to_tsvector('english', trade_family_search.name)
              order by
                rank desc
              limit
                1
            ) trade_family_search
        SQL

        def call
          ActiveRecord::Base.connection.execute(SQL).each do |result|
            Drugs::DMDMatch.where(id: result["id"]).where(trade_family_name: nil).update_all(
              trade_family_name: result["match_name"]
            )
          end
        end
      end
    end
  end
end
