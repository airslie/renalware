# frozen_string_literal: true

module Renalware
  module Drugs
    class Classification < ApplicationRecord
      self.table_name = "drug_types_drugs" # a relic from migrating from habtm
      belongs_to :drug, touch: true
      belongs_to :drug_type, class_name: "Type", inverse_of: :classifications
      has_paper_trail(
        versions: { class_name: "Renalware::Drugs::Version" }
      )
    end
  end
end
