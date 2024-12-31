FactoryBot.define do
  factory :hospital_centre, class: "Renalware::Hospitals::Centre" do
    initialize_with do
      Renalware::Hospitals::Centre.find_or_create_by!(code: code, name: name)
    end

    name { "King's College Hospital" }
    code { "RJZ" }
    host_site { true }
  end
end
