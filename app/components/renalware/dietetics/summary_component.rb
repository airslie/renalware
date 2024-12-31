module Renalware
  module Dietetics
    module Queries
      class LastDieteticClinicVisitQuery
        def call(patient:)
          Renalware::Clinics
            .cast_patient(patient)
            .clinic_visits
            .where(type: Renalware::Dietetics::ClinicVisit.name)
            .last
        end
      end
    end

    class SummaryComponent < ApplicationComponent
      def initialize(
        patient:,
        last_dietetic_visit_loader: Queries::LastDieteticClinicVisitQuery.new
      )
        @patient = Clinical.cast_patient(patient)
        @last_dietetic_clinic_visit = last_dietetic_visit_loader.call(patient: patient)
        super
      end

      attr_reader :patient, :last_dietetic_clinic_visit
    end
  end
end
