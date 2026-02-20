module Renalware
  module Medications
    # Returns a list of HD prescriptions that are due to expire soon,
    # and also looking back a few days to find recently expired but not renewed ones,
    # where the patient's consultant
    # is the current user.
    class ExpiringHDPrescriptionsForConsultantQuery
      include Callable

      pattr_initialize [:user!]

      def call # rubocop:disable Metrics/MethodLength
        return [] unless user.consultant?

        date_range_for_expiry = ExpiringHDPrescriptionsDateRange.new.range

        Prescription
          .ordered
          .joins(:termination, :patient)
          .includes([:drug, :trade_family, :unit_of_measure, :termination])
          .where(administer_on_hd: true)
          .where(stat: [false, nil])
          .where(patients: { id: ids_of_hd_patients_where_user_is_named_consultant })
          .where("termination.notes ilike '%scheduled to terminate%'")
          .where(prescribed_on: ..(1.day.ago.end_of_day))
          .where(
            termination: {
              terminated_on_set_by_user: false,
              terminated_on: date_range_for_expiry
            }
          )
      end

      private

      def ids_of_hd_patients_where_user_is_named_consultant
        Patient
          .include(ModalityScopes)
          .with_current_modality_of_class(Renalware::HD::ModalityDescription)
          .where(named_consultant: user)
          .pluck(:id)
      end
    end
  end
end
