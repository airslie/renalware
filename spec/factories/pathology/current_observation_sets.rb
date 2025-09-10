FactoryBot.define do
  factory :current_observation_set, class: "Renalware::Pathology::CurrentObservationSet" do
    patient { association(:pathology_patient) }
    values do
      {
        "LTAX" => { "result" => 123, "observed_at" => "2018-12-12 12:12:12" },
        "CYA" => { "result" => 124, "observed_at" => "2017-12-12 12:12:12" }
      }
    end
  end
end
