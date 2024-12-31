module Renalware
  module Transplants
    class RegistrationDocument < Document::Embedded
      class Codes < Document::Embedded
        attribute :uk_transplant_centre_code
        attribute :uk_transplant_patient_recipient_number
      end
      attribute :codes, Codes

      class CRF < Document::Embedded
        attribute :highest, CRFDatedResult
        attribute :latest, CRFDatedResult
      end
      attribute :crf, CRF

      class Transplant < Document::Embedded
        attribute :blood_group, BloodGroup
        attribute :nb_of_previous_grafts, Integer
        attribute :sens_status
      end
      attribute :transplant, Transplant

      class UKTransplantCentre < Document::Embedded
        attribute :status, String
        attribute :status_updated_on, Date
      end
      attribute :uk_transplant_centre, UKTransplantCentre

      class Organs < Document::Embedded
        attribute :transplant_type, Document::Enum,
                  enums: %i(kidney kidney_pancreas pancreas kidney_liver liver kidney_other)
        attribute :pancreas_only_type, Document::Enum, enums: %i(solid_organ islets)
        attribute :rejection_risk, Document::Enum, enums: %i(low standard high individualised)
        attribute :also_listed_for_kidney_only, Document::Enum, enums: %i(yes no unknown)
        attribute :to_be_listed_for_other_organs, Document::Enum, enums: %i(yes no unknown)
        attribute :received_previous_kidney_or_pancreas_grafts, Document::Enum,
                  enums: %i(yes no unknown)
      end
      attribute :organs, Organs

      class Consent < Document::Embedded
        attribute :value, Document::Enum, enums: %i(yes no unknown)
        attribute :consented_on, Date
        attribute :full_name

        validates :consented_on, timeliness: { type: :date, allow_blank: true }
        validates :consented_on, presence: true, if: ->(o) { o.value == :yes }
        validates :full_name, presence: true, if: ->(o) { o.value == :yes }
      end
      attribute :nhb_consent, Consent

      class HLA < Document::Embedded
        attribute :a, BinaryMarker
        attribute :b, BinaryMarker
        attribute :cw, BinaryMarker
        attribute :dr, BinaryMarker
        attribute :dq, BinaryMarker
        attribute :drw, BinaryMarker
        attribute :drq, BinaryMarker
        attribute :type
        attribute :recorded_on, Date
      end
      attribute :hla, HLA
    end
  end
end
