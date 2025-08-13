FactoryBot.define do
  factory :pathology_requests_global_rule_set,
          class: "Renalware::Pathology::Requests::GlobalRuleSet" do
    frequency_type { Renalware::Pathology::Requests::Frequency.all_names.sample }
    clinic
    request_description factory: %i(
      pathology_request_description
      serum
      with_required_observation_description
    )
  end
end
