FactoryBot.define do
  factory :problem, class: "Renalware::Problems::Problem" do
    patient factory: :patient
    accountable
    description { "further description of the patient problem" }
  end
end
