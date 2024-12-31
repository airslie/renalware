describe Renalware::Pathology::ObservationForPatientObservationDescriptionUsingSetQuery do
  describe "#call" do
    it "returns the most recent observation for the specified observation description" do
      patient_a = build(:pathology_patient)
      patient_b = build(:pathology_patient)
      description = build(:pathology_observation_description)
      most_recent_observation = create_observation(
        patient: patient_a,
        description: description,
        observed_at: 1.week.ago
      )
      # d = Date
      create_observation(patient: patient_a, description: description, observed_at: "2016-01-01")
      create_observation(patient: patient_b, description: description, observed_at: "2016-01-01")

      res = described_class.new(patient_a, description.code).call

      # E.g. { "result"=>"6.0", "observed_at"=>"2019-10-31T18:00:24.032192" }
      expect(res["result"]).to eq(most_recent_observation.result)
      expect(Date.parse(res["observed_at"])).to eq(most_recent_observation.observed_at.to_date)
    end
  end
end

def create_observation(patient:, description:, observed_at:)
  request = create(:pathology_observation_request, patient: patient)
  create(
    :pathology_observation,
    request: request,
    description: description,
    observed_at: observed_at
  )
end
