FactoryBot.define do
  factory :admissions_request_reason, class: "Renalware::Admissions::RequestReason" do
    initialize_with do
      Renalware::Admissions::RequestReason.find_or_create_by!(description: description)
    end
    description { "AKI" }
  end
end
