module Renalware
  module Accesses
    class ProfileAtTimeQuery
      include Callable

      pattr_initialize [:patient!, :at!]

      def call
        accesses_patient.profiles.where(
          "started_on <= ? AND (terminated_on IS NULL OR terminated_on >= ?)", at, at
        ).order(started_on: :asc, terminated_on: :desc).first
      end

      private

      def accesses_patient = patient.becomes(Renalware::Accesses::Patient)
    end
  end
end
