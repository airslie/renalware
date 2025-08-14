FactoryBot.define do
  factory :prescription_termination, class: "Renalware::Medications::PrescriptionTermination" do
    accountable
    prescription
    terminated_on { Date.current }
  end
end
