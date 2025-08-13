FactoryBot.define do
  factory :appointment, class: "Renalware::Clinics::Appointment" do
    patient factory: :clinics_patient
    clinic
    starts_at { Time.zone.now }
    consultant
  end
end
