FactoryBot.define do
  factory :admissions_specialty, class: "Renalware::Admissions::Specialty" do
    initialize_with do
      Renalware::Admissions::Specialty.find_or_create_by!(name: name)
    end
    name { "Other" }
  end
end
