module Renalware::Drugs
  class TradeFamily < ApplicationRecord
    has_many :drug_classifications, class_name: "TradeFamilyClassification",
                                    dependent: :nullify
    has_many :drugs, through: :drug_classifications

    scope :for_drug_id, lambda { |drug_id|
                          joins(:drug_classifications)
                            .merge(TradeFamilyClassification.where(drug_id: drug_id))
                        }
  end
end
