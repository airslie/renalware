module Renalware
  module Transplants
    class RecipientWorkupDocument < Document::Embedded
      CONFIRMATION = %i(yes no).freeze

      class Historicals < Document::Embedded
        attribute :tb, Document::Enum, enums: CONFIRMATION
        attribute :dvt, Document::Enum, enums: CONFIRMATION
        attribute :reflux, Document::Enum, enums: CONFIRMATION
        attribute :neurogenic_bladder, Document::Enum, enums: CONFIRMATION
        attribute :recurrent_utis, Document::Enum, enums: CONFIRMATION
        attribute :family_diabetes, Document::Enum, enums: CONFIRMATION
      end
      attribute :historicals, Historicals

      class Scores < Document::Embedded
        module Karnofsky
          class DatedInteger < Renalware::DatedInteger
            validates :result, inclusion: { in: 0..100, allow_blank: true }
          end
        end

        module Prisma
          class DatedInteger < Renalware::DatedInteger
            validates :result, inclusion: { in: 0..7, allow_blank: true }
          end
        end

        attribute :karnofsky, Karnofsky::DatedInteger
        attribute :prisma, Prisma::DatedInteger
      end
      attribute :scores, Scores

      class CervicalSmear < Document::Embedded
        attribute :result
        attribute :recorded_on, Date

        validates :recorded_on, timeliness: { type: :date, allow_blank: true }
      end

      class ObstetricsAndgynaecology < Document::Embedded
        attribute :pregnancies_count, Integer
        attribute :cervical_smear, CervicalSmear
      end
      attribute :obstetrics_and_gynaecology, ObstetricsAndgynaecology

      class Examination < Document::Embedded
        attribute :femoral_pulse, LeftRightConfirmation
        attribute :dorsalis_pedis_pulse, LeftRightConfirmation
        attribute :posterior_tibial_pulse, LeftRightConfirmation
        attribute :carotid_bruit, LeftRightConfirmation
        attribute :femoral_bruit, LeftRightConfirmation
        attribute :heart_sounds, Integer
      end
      attribute :examination, Examination

      class BaseConsent < Document::Embedded
        attribute :value
        attribute :consented_on, Date
        attribute :full_name
        validates :consented_on, timeliness: { type: :date, allow_blank: true }
      end

      class Consent < BaseConsent
        attribute :value, Document::Enum, enums: %i(full partial refused)
        validates :consented_on, presence: true, if: ->(consent) { consent.value.present? }
        validates :full_name, presence: true, if: ->(consent) { consent.value.present? }
      end
      attribute :consent, Consent

      class YesNoUnknownConsent < BaseConsent
        attribute :value, Document::Enum, enums: %i(yes no unknown)
        validates :consented_on, presence: true, if: ->(consent) { consent.value == :yes }
        validates :full_name, presence: true, if: ->(consent) { consent.value == :yes }
      end

      class NHBConsent < YesNoUnknownConsent
      end
      attribute :nhb_consent, NHBConsent

      class MarginalConsent < YesNoUnknownConsent
      end
      attribute :marginal_consent, MarginalConsent

      class Education < Document::Embedded
        attribute :waiting_list, Document::Enum, enums: CONFIRMATION
        attribute :transport_benefits, Document::Enum, enums: CONFIRMATION
        attribute :procedure, Document::Enum, enums: CONFIRMATION
        attribute :infection, Document::Enum, enums: CONFIRMATION
        attribute :rejection, Document::Enum, enums: CONFIRMATION
        attribute :success_rate, Document::Enum, enums: CONFIRMATION
        attribute :drugs_shortterm, Document::Enum, enums: CONFIRMATION
        attribute :drugs_longterm, Document::Enum, enums: CONFIRMATION
        attribute :cancer, Document::Enum, enums: CONFIRMATION
        attribute :followup, Document::Enum, enums: CONFIRMATION
        attribute :recurrence, Document::Enum, enums: CONFIRMATION
      end
      attribute :education, Education

      # Misc
      attribute :hla_data
    end
  end
end
