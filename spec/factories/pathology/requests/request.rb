FactoryBot.define do
  factory :pathology_requests_request, class: "Renalware::Pathology::Requests::Request" do
    accountable
    patient factory: :pathology_patient
    telephone { Faker::PhoneNumber.phone_number }
    template { Renalware::Pathology::Requests::Request::TEMPLATES.sample }
    high_risk { [true, false].sample }
    clinic
    consultant
  end
end
