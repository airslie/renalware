module Renalware
  module Pathology
    module Requests
      class Drug < Renalware::Drugs::Drug
        has_and_belongs_to_many :drug_categories,
                                join_table: "pathology_requests_drugs_drug_categories"
      end
    end
  end
end
