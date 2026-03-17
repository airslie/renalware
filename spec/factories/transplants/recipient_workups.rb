FactoryBot.define do
  factory :transplant_recipient_workup, class: "Renalware::Transplants::RecipientWorkup" do
    accountable
    patient factory: %i(transplant_patient)
  end
end
