module Renalware
  module Transplants
    class RecipientFollowupDocument < Document::Embedded
      class CardiovascularComplication < Document::Embedded
        attribute :myocardial_infact, DatedConfirmation
        attribute :peripheral_vascular_disease, DatedConfirmation
        attribute :stroke, DatedConfirmation
        attribute :transient_ischaemic_attack, DatedConfirmation
      end
      attribute :cardiovascular_complication, CardiovascularComplication

      attribute :malignancy_within_first_3_months, DatedConfirmation
      attribute :malignancy_within_first_12_months, DatedConfirmation
      attribute :recipient_pregnancy, DatedConfirmation
      attribute :acute_rejection_biopsy_proven, DatedConfirmation
      attribute :primary_or_recurrent_renal_disease, DatedConfirmation
    end
  end
end
