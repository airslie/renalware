module Renalware
  module Transplants
    class DonorOperationDocument < Document::Embedded
      class Complications < Document::Embedded
        attribute :wound_infection, DatedConfirmation
        attribute :deep_vein_thrombosis, DatedConfirmation
        attribute :donor_pneumothorax_peri_or_post_operative, DatedConfirmation
        attribute :pneumonia, DatedConfirmation
        attribute :pulmonary_thrombo_embolism, DatedConfirmation
        attribute :prescribed_medication_indicator, Document::Enum, enums: %i(yes no unknown)
        attribute :other_peri_or_post_operative_complications, Document::Enum,
                  enums: %i(yes no unknown)
      end
      attribute :diagnosis, Complications

      class Outcome < Document::Embedded
        attribute :subsequent_operation_indicator, Document::Enum, enums: %i(yes no unknown)
        attribute :donor_returned_to_previous_general_activity_level, Document::Enum,
                  enums: %i(yes no unknown)
        attribute :nb_months_to_return_to_previous_general_activity_level, Integer

        validates :nb_months_to_return_to_previous_general_activity_level,
                  numericality: { allow_blank: true, only_integer: true }
      end
      attribute :outcome, Outcome
    end
  end
end
