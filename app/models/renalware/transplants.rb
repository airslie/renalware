module Renalware
  module Transplants
    WAITLIST_FILTERS = %w(
      all
      active
      suspended
      active_and_suspended
      working_up
      status_mismatch
    ).freeze

    def self.table_name_prefix = "transplant_"
    def self.cast_patient(patient) = patient.becomes(Transplants::Patient)

    concerning :Queries do
      class_methods do
        def current_transplant_status_for_patient(patient)
          Registration.for_patient(patient).first&.current_status
        end
      end
    end
  end
end
