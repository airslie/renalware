FactoryBot.define do
  factory :pathology_request_description, class: "Renalware::Pathology::RequestDescription" do
    initialize_with {
      Renalware::Pathology::RequestDescription.find_or_create_by!(code: code) do |x|
        x.name = name
        x.lab = lab
      end
    }
    lab factory: %i(pathology_lab)
    code { "FBC" }
    name { "FBC" }
  end
end
