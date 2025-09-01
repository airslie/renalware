FactoryBot.define do
  factory :clinics_mapping, class: "Renalware::Clinics::Mapping" do
    name_in_feed { "Some Clinic Name" }
    clinic
    default_clinic { false }
  end
end
