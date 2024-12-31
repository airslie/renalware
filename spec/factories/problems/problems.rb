FactoryBot.define do
  factory :problem, class: "Renalware::Problems::Problem" do
    accountable
    description { "further description of the patient problem" }
  end
end
