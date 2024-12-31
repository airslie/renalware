FactoryBot.define do
  factory :pathology_requests_request, class: "Renalware::Pathology::Requests::Request" do
    accountable
    telephone { Faker::PhoneNumber.phone_number }
    template { Renalware::Pathology::Requests::Request::TEMPLATES.sample }
    high_risk { [true, false].sample }
  end
end
