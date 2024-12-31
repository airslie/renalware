module Renalware
  module Letters
    class PrimaryCarePhysician < Renalware::Patients::PrimaryCarePhysician
      has_many :patients, dependent: :restrict_with_exception
      has_many :letters, through: :patients

      def cc_on_letter?(letter)
        return false unless letter.patient.assigned_to_primary_care_physician?(self)

        letter.main_recipient.patient? || letter.main_recipient.contact?
      end
    end
  end
end
