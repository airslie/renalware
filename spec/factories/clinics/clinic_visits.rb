# frozen_string_literal: true

FactoryBot.define do
  factory :clinic_visit, class: "Renalware::Clinics::ClinicVisit" do
    accountable
    patient
    date { Time.zone.today }
    time { Time.zone.now }
    did_not_attend { false }
    height { 1.5 }
    weight { 1.5 }
    pulse { 100 }
    systolic_bp { 112 }
    diastolic_bp { 71 }
    clinic { create(:clinic) }
  end

  factory :dietetic_clinic_visit, class: "Renalware::Dietetics::ClinicVisit",
                                  parent: :clinic_visit do
  end
end
