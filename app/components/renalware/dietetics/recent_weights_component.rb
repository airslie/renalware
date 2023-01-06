# frozen_string_literal: true

module Renalware
  module Dietetics
    module Queries
      class RecentWeightsQuery
        DEFAULT_LIMIT = 100

        def call(patient:, limit: DEFAULT_LIMIT)
          Renalware::Clinics.cast_patient(patient)
            .clinic_visits
            .order(date: :desc)
            .limit(limit)
        end
      end
    end

    class RecentWeightsComponent < ApplicationComponent
      DEFAULT_COUNT = 5

      WeightRowPresenter = Struct.new(:clinic_visit) do
        def date
          I18n.l(clinic_visit.date)
        end

        def weight
          WeightValuePresenter.new(clinic_visit.weight).to_s
        end
      end

      def initialize(
        patient:,
        clinic_visits_loader: Queries::RecentWeightsQuery.new,
        display_count: DEFAULT_COUNT
      )

        @patient = Clinical.cast_patient(patient)

        @clinic_visits = clinic_visits_loader.call(
          patient: patient,
          limit: display_count
        )
      end

      attr_reader :patient

      def weights
        @weights ||= @clinic_visits.map { |clinic_visit|
          WeightRowPresenter.new(clinic_visit)
        }
      end
    end
  end
end
