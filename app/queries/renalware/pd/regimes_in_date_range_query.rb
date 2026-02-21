module Renalware
  module PD
    class RegimesInDateRangeQuery
      pattr_initialize [:patient!, :from!, :to!]

      def call
        scope = Renalware::PD::Regime.order(start_date: :asc, end_date: :desc)

        scope
          .where(conditions.merge(end_date: from..to))
          .or(
            scope.where(conditions.merge(end_date: nil))
          )
      end

      private

      def conditions
        {
          patient_id: patient.id,
          start_date: from..DateTime::Infinity.new
        }
      end
    end
  end
end
