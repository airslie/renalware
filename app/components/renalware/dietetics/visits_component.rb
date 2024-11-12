# frozen_string_literal: true

module Renalware
  module Dietetics
    class VisitsComponent < ApplicationComponent
      include LinkHelper
      include IconHelper

      DEFAULT_COUNT = 5

      def initialize(
        patient:,
        display_count: DEFAULT_COUNT,
        dietetic_clinic_visits_loader: Queries::ClinicVisitsQuery.new,
        dietetic_clinic_visits_counter: Queries::ClinicVisitsCounter.new
      )

        @patient = Clinical.cast_patient(patient)

        @dietetic_clinic_visits = dietetic_clinic_visits_loader.call(
          patient: patient,
          limit: display_count
        )

        @dietetic_clinic_visits_count = dietetic_clinic_visits_counter.call(patient: patient)
        super
      end

      attr_reader :patient, :dietetic_clinic_visits, :dietetic_clinic_visits_count
    end
  end
end
