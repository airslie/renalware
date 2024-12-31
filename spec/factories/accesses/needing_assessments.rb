FactoryBot.define do
  factory :access_needling_assessment, class: "Renalware::Accesses::NeedlingAssessment" do
    accountable
    patient factory: %i(accesses_patient)
    difficulty { "moderate" }
  end
end
