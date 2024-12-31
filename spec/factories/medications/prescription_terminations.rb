FactoryBot.define do
  factory :prescription_termination, class: "Renalware::Medications::PrescriptionTermination" do
    accountable
    terminated_on { "2016-07-26" }
  end
end
