module Renalware
  module Clinics
    class RecentWeightsComponent < ApplicationComponent
      DEFAULT_COUNT = 5
      pattr_initialize [:patient!, display_count: DEFAULT_COUNT]

      WeightRowPresenter = Struct.new(:clinic_visit) do
        def date = I18n.l(clinic_visit.date)
        def weight = WeightValuePresenter.new(clinic_visit.weight).to_s
      end

      def weights
        clinics_patient.clinic_visits.recent(display_count).map do |clinic_visit|
          WeightRowPresenter.new(clinic_visit)
        end
      end

      def clinics_patient = Clinics.cast_patient(patient)
    end
  end
end
