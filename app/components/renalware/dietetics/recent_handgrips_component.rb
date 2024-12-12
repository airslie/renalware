# frozen_string_literal: true

module Renalware
  module Dietetics
    class RecentHandgripsComponent < ApplicationComponent
      DEFAULT_COUNT = 5

      HandgripsRowPresenter = Struct.new(:clinic_visit) do
        def date
          I18n.l(clinic_visit.date)
        end

        def handgrip_left
          Clinics::WeightValuePresenter.new(clinic_visit.document.handgrip_left).to_s
        end

        def handgrip_right
          Clinics::WeightValuePresenter.new(clinic_visit.document.handgrip_right).to_s
        end
      end

      def initialize(
        patient:,
        dietetic_clinic_visits_loader: Queries::ClinicVisitsQuery.new,
        display_count: DEFAULT_COUNT
      )
        @patient = Clinical.cast_patient(patient)

        @clinic_visits = dietetic_clinic_visits_loader.call(
          patient: patient,
          limit: display_count
        )
        super
      end

      attr_reader :patient

      def handgrips
        @handgrips ||= @clinic_visits.map { |clinic_visit|
          HandgripsRowPresenter.new(clinic_visit)
        }
      end
    end
  end
end
