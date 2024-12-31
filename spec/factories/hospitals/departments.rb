FactoryBot.define do
  factory :hospital_department, class: "Renalware::Hospitals::Department" do
    initialize_with do
      Renalware::Hospitals::Department.find_or_create_by!(
        name: name,
        hospital_centre: hospital_centre
      )
    end

    name { "Renal Department" }
    hospital_centre
  end
end
