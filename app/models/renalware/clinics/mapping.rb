module Renalware
  module Clinics
    # Maps HL7 clinic names to Renalware clinic IDs.
    # In an HL7 message we might have a clinic name of e.g. "Nephrology Clinic at OPU" which
    # we might want to map to a Renalware clinic called "Nephrology Clinic" with eg ID 2.
    # We might also want to have a default clinic to use if we get an HL7 message with a clinic
    # name that we don't recognise.
    # We enforce that there can only be one default clinic.
    class Mapping < ApplicationRecord
      has_paper_trail(
        versions: { class_name: "Renalware::Clinics::Version" },
        on: %i(create update destroy)
      )

      validates :name_in_feed, presence: true, uniqueness: { case_sensitive: false }
      validates :default_clinic, uniqueness: { scope: :default_clinic, if: :default_clinic? }
      belongs_to :clinic, class_name: "Renalware::Clinics::Clinic"

      # If this HL7 clinic name has been seen before, return the mapped clinic_id.
      # If not, create a new mapping to the default clinic (if any) and return that clinic_id.
      # If no default clinic exists, the new row will be created but we return nil.
      def self.clinic_for(hl7_clinic_name)
        return nil if hl7_clinic_name.nil?

        matching = where("lower(name_in_feed) = lower(?)", hl7_clinic_name)
        mapping = matching.first
        return mapping.clinic if mapping

        # Roll back a conflicting insert to a savepoint before retrying the lookup.
        transaction(requires_new: true) do
          create!(name_in_feed: hl7_clinic_name, clinic_id: default_clinic_id)
        end.clinic
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        mapping = matching.first
        raise unless mapping

        mapping.clinic
      end

      def self.default_clinic_id = where(default_clinic: true).pick(:clinic_id)
    end
  end
end
