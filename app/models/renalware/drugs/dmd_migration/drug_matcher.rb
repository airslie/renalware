module Renalware
  module Drugs
    module DMDMigration
      class DrugMatcher
        # Find the closest match of a drug that is not a VTM
        # to a drug that is VTM using fulltext search;
        # Can easily be extended to show the second and third closest matches;

        SQL = <<-SQL.squish
          with matches AS (
            select
              regexp_replace(drug_name, 'Coil|coil|oil|Oil|Beta| C |Ointment|ointment|-C|Sodium|Light|Citralock V|Duralock-C|Human | Sulphate|Iron-Hydroxide|Kay Cee L|L-Thyroxine|Omega-3-Acid|Polytar Liquid|Acetate Tablets|Vitamin B|Vitamin E|Vitamins Capsules|', '', 'g') as drug_name,
              id
            from renalware.drug_dmd_matches
          )
          select
            matches.id as id,
            vtm_search.name as match_name,
            vtm_search.id as match_id
          from
            matches
            cross join lateral (
              select
                *,
                ts_rank(to_tsvector('english', vtm_search.name), query, 1) as rank
              FROM
                renalware.drug_dmd_virtual_therapeutic_moieties vtm_search,
                to_tsquery(
                  'english',
                  REPLACE( plainto_tsquery(matches.drug_name)::varchar, '&', '|' )
                ) query
              WHERE
                query @@ to_tsvector('english', vtm_search.name)
              order by
                rank desc
              limit
                1
            ) vtm_search
        SQL

        def call
          ActiveRecord::Base.connection.execute(SQL).each do |result|
            Drugs::DMDMatch.where(id: result["id"]).where(vtm_name: nil).update_all(
              vtm_name: result["match_name"]
            )
          end
        end
      end
    end
  end
end
