FactoryBot.define do
  factory :access_plan, class: "Renalware::Accesses::Plan" do
    accountable
    patient factory: %i(accesses_patient)
    plan_type factory: %i(access_plan_type)
    notes { "Lorem ipsum dolor sit amet.." }
    decided_by { accountable_actor }
    terminated_at { nil }
  end
end
