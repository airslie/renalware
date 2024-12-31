module Renalware::Drugs
  class Form < ApplicationRecord
    has_many :vmp_classifications, class_name: "VMPClassification",
                                   dependent: :nullify
    has_many :drugs, through: :vmp_classifications

    scope :for_drug_id, lambda { |drug_id|
                          joins(:vmp_classifications)
                            .merge(VMPClassification.where(drug_id: drug_id))
                            .distinct
                        }
  end
end
