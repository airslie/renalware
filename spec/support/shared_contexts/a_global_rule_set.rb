# rubocop:disable RSpec/LetSetup
shared_context "with a global_rule_set" do
  let!(:clinic) { create(:clinic) }
  let!(:required_observation_description) { create(:pathology_observation_description) }
  let!(:request_description) do
    create(
      :pathology_request_description,
      required_observation_description: required_observation_description,
      bottle_type: "serum"
    )
  end
  let!(:global_rule_set) do
    create(
      :pathology_requests_global_rule_set,
      clinic: clinic,
      frequency_type: "Once",
      request_description: request_description
    )
  end
end
# rubocop:enable RSpec/LetSetup
