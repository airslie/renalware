describe Renalware::Pathology::ObservationForPatientObservationDescriptionQuery do
  describe "#call" do
    it "returns the most recent observation for the specified observation description" do
      patient_a = build(:pathology_patient)
      patient_b = build(:pathology_patient)
      description = build(:pathology_observation_description)
      most_recent_observation = create_observation(
        patient: patient_a,
        description:,
        observed_at: 1.week.ago
      )
      create_observation(patient: patient_a, description:, observed_at: 2.weeks.ago)
      create_observation(patient: patient_b, description:, observed_at: 2.weeks.ago)

      expect(
        described_class.new(patient_a, description).call
      ).to eq(most_recent_observation)
    end
  end
end

def create_observation(patient:, description:, observed_at:)
  request = create(:pathology_observation_request, patient:)
  create(
    :pathology_observation,
    request:,
    description:,
    observed_at:
  )
end
