FactoryBot.define do
  factory :hospital_ward, class: "Renalware::Hospitals::Ward" do
    initialize_with do
      Renalware::Hospitals::Ward.find_or_create_by!(name: name, hospital_unit: hospital_unit)
    end
    hospital_unit
    name { "Ward A" }
  end
end
