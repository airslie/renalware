FactoryBot.define do
  factory :practice_membership, class: "Renalware::Patients::PracticeMembership" do
    practice
    primary_care_physician
    deleted_at { nil }
  end
end
