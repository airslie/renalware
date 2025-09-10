module Renalware
  module Clinics
    class Patient < Renalware::Patient
      has_many :clinic_visits,
               class_name: "Clinics::ClinicVisit",
               dependent: :restrict_with_exception

      has_one :most_recent_clinic_visit,
              -> { most_recent },
              class_name: "ClinicVisit",
              dependent: :restrict_with_exception

      has_many :appointments,
               class_name: "Clinics::Appointment",
               dependent: :restrict_with_exception

      delegate :height, :weight, :blood_pressure, :bmi, to: :current_observations, prefix: :current

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")

      def current_observations
        @current_observations ||= Clinics::CurrentObservations.new(self)
      end
    end
  end
end
