FactoryBot.define do
  factory :internal_receipt, class: "Renalware::Messaging::Internal::Receipt" do
    recipient factory: %i(internal_recipient)
    read_at { nil }
    message factory: %i(internal_message)
  end
end
