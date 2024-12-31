module Renalware
  module Admissions
    class Admission < ApplicationRecord
      include Accountable
      include RansackAll
      # PatientsRansackHelper adds the :identity_match scope for querying by patient name,
      # local hospital id or NHS number. We use this scope from the filters on the admissions list
      # to enable searching for a patient. *Note* you must join onto the patients table first
      # if calling this scope or using it with ransack, e.g.
      #   Admission.joins(:patient).identity_match("rab rog")

      include PatientsRansackHelper
      extend Enumerize

      acts_as_paranoid

      validates :patient_id, presence: true
      validates :hospital_ward_id, presence: true
      validates :admitted_on, presence: true
      validates :reason_for_admission, presence: true
      validates :admission_type, presence: true

      belongs_to :patient, touch: true
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"
      belongs_to :summarised_by, class_name: "User"
      belongs_to :modality_at_admission, class_name: "Modalities::Modality"

      enumerize :admission_type, in: %i(unknown routine elective emergency consult transfer)
      enumerize :discharge_destination, in: %i(home other_ward other_hosp itu death other)

      scope :currently_admitted, lambda {
        where(discharged_on: nil)
      }

      scope :discharged_but_missing_a_summary, lambda {
        where("discharge_summary is null or discharge_summary = ?", "")
          .where.not(discharged_on: nil)
      }
    end
  end
end
