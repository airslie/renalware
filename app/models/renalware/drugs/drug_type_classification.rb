module Renalware
  module Drugs
    class DrugTypeClassification < ApplicationRecord
      self.table_name = "drug_types_drugs" # a relic from migrating from habtm
      belongs_to :drug, touch: true
      belongs_to :drug_type, class_name: "Type", inverse_of: :drug_type_classifications
      has_paper_trail(
        versions: { class_name: "Renalware::Drugs::Version" }
      )
    end
  end
end
