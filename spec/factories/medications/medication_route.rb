# frozen_string_literal: true

FactoryBot.define do
  factory :medication_route, class: "Renalware::Medications::MedicationRoute" do
    initialize_with do
      Renalware::Medications::MedicationRoute
        .find_or_create_by!(code: code, name: name) do |route|
          route.rr_code = Renalware::Medications::MedicationRoute.rr22_code_for("Other")
        end
    end

    code { "PO" }
    name { "Oral" }
    rr_code { "1" }

    trait :po do
      code { "PO" }
      name { "Oral" }
      rr_code { "1" }
    end

    trait :other do
      code { "Other" }
      name { "Other" }
      rr_code { "1" }
    end
  end
end
