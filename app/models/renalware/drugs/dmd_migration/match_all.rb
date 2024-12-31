module Renalware
  module Drugs
    module DMDMigration
      class MatchAll
        def call
          populate_missing_match_data

          DrugMatcher.new.call
          FormMatcher.new.call
          TradeFamilyMatcher.new.call
        end

        private

        def populate_missing_match_data
          upserts = Medications::Prescription.joins(:drug).group("drug_id", "name")
            .pluck("name", "drug_id", Arel.sql("count(*) as count"))
            .map do |drug_name, drug_id, count|
            {
              prescriptions_count: count,
              drug_name: drug_name,
              drug_id: drug_id
            }
          end

          return if upserts.blank?

          DMDMatch.upsert_all(upserts, unique_by: :drug_id)
        end
      end
    end
  end
end
