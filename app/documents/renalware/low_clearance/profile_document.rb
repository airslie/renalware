module Renalware
  module LowClearance
    class ProfileDocument < Document::Embedded
      attribute :first_seen_on, Date
      attribute :dialysis_plan, Document::Enum
      attribute :dialysis_planned_on, Date
      attribute :predicted_esrf_date, Date
      attribute :referral_creatinine, Integer
      # Note that referred_by is now used as 'Referred by notes' as we have a new referrer relation
      # on the profile itself. We need to keep the document version around, so using for notes.
      attribute :referred_by, String
      attribute :education_status, Document::Enum
      attribute :referral_egfr, Decimal
      attribute :education_type, Document::Enum
      attribute :attended_on, Date
      attribute :dvd1_provided, Document::Enum, enums: %i(yes no)
      attribute :dvd2_provided, Document::Enum, enums: %i(yes no)
      attribute :transplant_referral, Document::Enum, enums: %i(yes no)
      attribute :transplant_referred_on, Date
      attribute :home_hd_possible, Document::Enum, enums: %i(yes no)
      attribute :self_care_possible, Document::Enum, enums: %i(yes no)
      attribute :access_notes, String
    end
  end
end
