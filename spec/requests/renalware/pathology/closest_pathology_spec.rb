# frozen_string_literal: true

describe "Patient's closest pathology to a date, filtered by code group" do
  # For example given pathology_code_group A containing OBX codes X,Y,Z, find the results for
  # X,Y,Z which are clostest to the specified date. We use this for example when looking for
  # results closest to a PD PET test date when the lab tests were requested.
  let(:patient) { create(:pathology_patient) }

  describe "GET index JSON" do
    it "responds with json list of observations results" do
      user = create(:user)

      # This creates an obr called FBC and obxes called WBC, HGB, PLT
      create(
        :pathology_observation_request,
        :full_blood_count_with_observations,
        patient: patient,
        requested_at: "2019-01-01"
      )

      # Create the code group and its member OBX codes
      group = create(:pathology_code_group, name: "Group1", description: "TheDesc")
      %w(WBC HGB PLT).each do |obx|
        create(
          :pathology_code_group_membership,
          code_group: group,
          observation_description: Renalware::Pathology::ObservationDescription.find_by(code: obx),
          by: user
        )
      end

      # Sanity check
      expect(group.observation_descriptions.count).to eq(3)
      expect(patient.observations.count).to eq(3)

      # Get the json
      get patient_pathology_nearest_observations_path(
        patient_id: patient.id,
        date: "2020-05-01",
        code_group_id: group.id,
        format: :json
      )

      expect(response).to be_successful
      expect(response.parsed_body).to eq [
        { "code" => "WBC", "observed_on" => "2019-01-01", "result" => "6.0" },
        { "code" => "HGB", "observed_on" => "2019-01-01", "result" => "6.0" },
        { "code" => "PLT", "observed_on" => "2019-01-01", "result" => "6.0" }
      ]
    end
  end

  context "when there are no nearest observation matches" do
    it "returns an empty array" do
      pending "TODO test a date outside of the range to ensure it only returns nearest values"
      raise NotImplementedError
    end
  end

  context "when TODO" do
    it "TODO" do
      pending "TODO"
      raise NotImplementedError
    end
  end
end
