# frozen_string_literal: true

describe Renalware::Pathology::ObservationForPatientRequestDescriptionQuery do
  describe "#call" do
    it "returns the most recent observation for the specified request description" do
      patient_a = create(:pathology_patient)
      patient_b = create(:pathology_patient)
      description = create(:pathology_observation_description)
      request_description_a = create(
        :pathology_request_description,
        required_observation_description: description
      )
      create_observation(patient: patient_b, description: description, observed_at: 2.weeks.ago)
      create_observation(patient: patient_a, description: description, observed_at: 2.weeks.ago)
      create_observation(
        patient: patient_a,
        description: description,
        observed_at: 1.week.ago,
        result: 999.9
      )

      query = described_class.new(patient_a, request_description_a)

      expect(query.call).to have_attributes(
        observed_on: 1.week.ago.to_date,
        result: 999.9
      )
    end
  end
end

def create_observation(patient:, description:, observed_at:, result: 1.0)
  request = create(:pathology_observation_request, patient: patient)
  create(
    :pathology_observation,
    request: request,
    description: description,
    observed_at: observed_at,
    result: result
  )
end
