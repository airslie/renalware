FactoryBot.define do
  factory :letter_primary_care_physician,
          class: "Renalware::Letters::PrimaryCarePhysician",
          parent: :primary_care_physician do
    address
  end
end
