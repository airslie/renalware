FactoryBot.define do
  factory :internal_author,
          class: "Renalware::Messaging::Internal::Author",
          parent: :user
end
