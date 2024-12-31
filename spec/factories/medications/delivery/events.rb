FactoryBot.define do
  factory :medication_delivery_event, class: "Renalware::Medications::Delivery::Event" do
    homecare_form factory: :homecare_form
    # patient
    accountable
    printed { false }
    reference_number { Time.zone.now.to_i }
    drug_type
    prescription_duration { 1 }
  end
end
