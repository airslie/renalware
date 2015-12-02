require "document/embedded"

module Renalware
  module Transplants
    class RecipientOperationDocument < Document::Embedded

      class Kidney < Document::Embedded
        attribute :side, enums: %i(left right both)
        attribute :asyst
        attribute :age, Age
        attribute :weight, Float

        validates :weight, numericality: { allow_blank: true }
      end
      attribute :kidney, Kidney

      class Recipient < Document::Embedded
        attribute :operation_number, Integer
        attribute :age, Age
        attribute :last_dialysis_on, Date
        attribute :cmv_status, enums: %i(unknown positive negative)
        attribute :blood_group, BloodGroup

        validates :operation_number, numericality: { allow_blank: true, only_integer: true }
        validates :last_dialysis_on, timeliness: { type: :date, allow_blank: true }
      end
      attribute :recipient, Recipient

      class Donor < Document::Embedded
        attribute :ukt_donor_number
        attribute :ukt_notified_at, DateTime
        attribute :type, enums: %i(live_related cadaver non_heart_beating live_unrelated)
        attribute :gender, enums: %i(male female)
        attribute :ethnic_category
        attribute :born_on, Date
        attribute :age, Age
        attribute :hla
        attribute :hla_mismatch
        attribute :cmv_status, enums: %i(unknown positive negative)
        attribute :blood_group, BloodGroup
        attribute :blood_group_rhesus, enums: %i(positive negative)
        attribute :organ_donor_register_checked, enums: %i(yes no)

        validates :born_on, timeliness: { type: :date, allow_blank: true }
        validates :ukt_notified_at, timeliness: { type: :datetime, allow_blank: true }
      end
      attribute :donor, Donor

      class CadavericDonor < Document::Embedded
        attribute :cadaveric_donor_type, enums: %i(heart_beating non_heart_beating domino)
        attribute :death_certified_at, DateTime
        attribute :ukt_cause_of_death, enums: :from_localization
        attribute :warm_ischaemic_time_in_minutes, Integer

        validates :death_certified_at, timeliness: { type: :datetime, allow_blank: true }
        validates :warm_ischaemic_time_in_minutes, numericality: { allow_blank: true }
      end
      attribute :cadaveric_donor, CadavericDonor

      class DSA < Document::Embedded
        attribute :tested_on, Date
        attribute :results
        attribute :notes

        validates :tested_on, timeliness: { type: :date, allow_blank: true }
      end
      attribute :dsa, DSA

      class BKV < Document::Embedded
        attribute :tested_on, Date
        attribute :results
        attribute :notes

        validates :tested_on, timeliness: { type: :date, allow_blank: true }
      end
      attribute :bkv, BKV

      class Outcome < Document::Embedded
        attribute :transplant_failed, enums: %i(yes no)
        attribute :failed_on, Date
        attribute :failure_cause
        attribute :failure_description
        attribute :stent_removed_on, Date

        validates :failed_on, timeliness: { type: :date, allow_blank: true }
        validates :stent_removed_on, timeliness: { type: :date, allow_blank: true }
      end
      attribute :outcome, Outcome
    end
  end
end