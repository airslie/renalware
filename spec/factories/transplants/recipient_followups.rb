FactoryBot.define do
  factory :transplant_recipient_followup, class: "Renalware::Transplants::RecipientFollowup" do
    operation factory: :transplant_recipient_operation
  end
end
