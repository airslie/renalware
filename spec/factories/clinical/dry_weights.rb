FactoryBot.define do
  factory :dry_weight, class: "Renalware::Clinical::DryWeight" do
    accountable
    patient factory: :clinical_patient

    assessed_on { 1.week.ago }
    weight { 156.1 }
    assessor { accountable_actor }
  end
end
