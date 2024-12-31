FactoryBot.define do
  factory :access_assessment, class: "Renalware::Accesses::Assessment" do
    accountable
    patient factory: %i(accesses_patient)
    type factory: %i(access_type)
    side { :left }
    performed_on { Time.zone.now }
    document {
      {
        results: {
          method: :hand_doppler
        }
      }
    }
  end
end
