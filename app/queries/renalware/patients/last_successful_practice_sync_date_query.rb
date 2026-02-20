module Renalware
  module Patients
    class LastSuccessfulPracticeSyncDateQuery
      pattr_initialize :identifier

      def call
        max_created_at&.to_date&.to_s
      end

      private

      def max_created_at
        System::APILog
          .where(
            identifier: identifier,
            dry_run: false,
            status: Renalware::System::APILog::STATUS_DONE
          )
          .group(:identifier)
          .maximum(:created_at)[identifier]
      end
    end
  end
end
