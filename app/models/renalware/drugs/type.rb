module Renalware
  module Drugs
    class Type < ApplicationRecord
      include RansackAll

      has_many :drug_type_classifications, foreign_key: :drug_type_id, dependent: :destroy
      has_many :drugs, through: :drug_type_classifications

      has_paper_trail(
        versions: { class_name: "Renalware::Drugs::Version" },
        on: %i(create update destroy)
      )

      def active_drugs
        drugs.active
      end
    end
  end
end
