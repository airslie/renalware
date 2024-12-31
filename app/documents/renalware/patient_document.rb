module Renalware
  class PatientDocument < Document::Embedded
    attribute :interpreter_notes, String
    attribute :admin_notes, String
    attribute :special_needs_notes, String
    attribute :diabetes, DatedBooleanDiagnosis

    class Referral < Document::Embedded
      attribute :referring_physician_name, String
      attribute :referral_date, Date
      attribute :referral_type, String
      attribute :referral_notes, String
    end
    attribute :referral, Referral

    class Psychosocial < Document::Embedded
      attribute :housing, String
      attribute :social_network, String
      attribute :care_package, String
      attribute :other, String
      attribute :updated_at, Date
    end
    attribute :psychosocial, Psychosocial

    class History < Document::Embedded
      SMOKING_SNOMED_MAP = {
        "yes" => { code: 77176002, description: "Current" },
        "no" => { code: 8392000, description: "Non" },
        "ex" => { code: 8517006, description: "Ex" }
      }.freeze

      attribute :alcohol, Document::Enum, enums: %i(never rarely social heavy)
      attribute :smoking, Document::Enum, enums: %i(no ex yes)

      def smoking_snomed
        SMOKING_SNOMED_MAP[@smoking]
      end

      def smoking_rr
        @smoking&.upcase
      end
    end
    attribute :history, History
  end
end
