# frozen_string_literal: true

module Renalware
  module Drugs
    # Backed by a materialised SQL view (for speed) that returns all drugs and 'drug (trade family)'
    # combinations.
    class PrescribableDrug < ApplicationRecord
      self.primary_key = :drug_id
      has_many :drug_type_classifications, dependent: :destroy, foreign_key: :drug_id
      has_many :drug_types,
               through: :drug_type_classifications,
               foreign_key: :drug_id

      def self.for(code)
        joins(:drug_types).where(drug_types: { code: code.to_s })
      end

      # Customise the json output suitable for our slimselect ajax/type-ahead approach
      def as_json(_options = {})
        {
          text: compound_name,
          value: compound_id
        }
      end
    end
  end
end
