# frozen_string_literal: true

module Renalware
  module Clinics
    class Patient < ActiveType::Record[Renalware::Patient]
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
    end
  end
end
