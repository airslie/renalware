module Renalware
  module Research
    class ParticipationQuery
      pattr_initialize [:study!, :options!]

      def call
        search.result
      end

      def search
        study
          .participations
          .eager_load(patient: [:worry, :hospital_centre])
          .ransack(options)
      end
    end
  end
end
