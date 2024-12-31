module Renalware
  module Drugs
    class Drug < ApplicationRecord
      include RansackAll
      # The table name of drugs (rather than the correct drug_drugs) is incorrect but changing
      # it will have a wide impact and so needs careful testing and coordination with hospital
      # database users who may run queries against this table.
      self.table_name = "drugs"

      acts_as_paranoid

      has_many :drug_type_classifications, dependent: :destroy
      has_many :drug_types, through: :drug_type_classifications, after_remove: proc { |drug|
                                                                                 drug.touch
                                                                               }
      has_many :drug_medication_routes, class_name: "VMPClassification",
                                        dependent: :destroy
      has_many :medication_routes, through: :drug_medication_routes

      has_many :trade_family_classifications, class_name: "TradeFamilyClassification",
                                              dependent: :destroy
      has_many :trade_families, through: :trade_family_classifications
      has_many :enabled_trade_families, -> { merge(TradeFamilyClassification.enabled) },
               through: :trade_family_classifications,
               class_name: "TradeFamily",
               source: :trade_family

      scope :ordered, -> { order(:name) }
      scope :active, -> { where(inactive: false) }

      validates :name, presence: true

      has_paper_trail(
        versions: { class_name: "Renalware::Drugs::Version" },
        on: %i(create update destroy)
      )

      def self.for(code)
        joins(:drug_types).where(drug_types: { code: code.to_s })
      end

      def display_type
        "Standard Drug"
      end

      def to_s = name
    end
  end
end
