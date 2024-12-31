FactoryBot.define do
  factory :pd_training_session, class: "Renalware::PD::TrainingSession" do
    accountable
    patient
    training_site factory: %i(pd_training_site)
    training_type factory: %i(pd_training_type)
    document {
      {
        started_on: Time.zone.today,
        trainer: "Flo Nightengale RN",
        outcome: :successful
      }
    }
  end
end
