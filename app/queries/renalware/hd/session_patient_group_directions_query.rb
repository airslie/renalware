module Renalware
  module HD
    class SessionPatientGroupDirectionsQuery
      pattr_initialize [:patient!]

      def call(page: nil, per: 10) # rubocop:disable Metrics/MethodLength
        session_table = Session.table_name
        pgd_table = Drugs::PatientGroupDirection.table_name

        SessionPatientGroupDirection
          .includes(:patient_group_direction, :session)
          .joins(:session)
          .merge(Session.for_patient(patient))
          .order(
            "#{session_table}.started_at DESC, " \
            "#{pgd_table}.name ASC, " \
            "#{SessionPatientGroupDirection.table_name}.created_at DESC"
          )
          .page(page)
          .per(per)
      end
    end
  end
end
