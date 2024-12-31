Given("the high risk rule set contains these rules:") do |table|
  table.hashes.each do |params|
    create_global_rule(
      params.merge("rule_set_type" => "Renalware::Pathology::Requests::HighRiskRuleSet")
    )
  end
end

Given("Patty is a high risk patient") do
  code = "HIV"
  create_global_rule(
    "rule_set_type" => "Renalware::Pathology::Requests::HighRiskRuleSet",
    "type" => "ObservationResult",
    "id" => code,
    "operator" => "==",
    "value" => "positive"
  )
  record_observations(
    patient: @patty,
    observations_attributes: [
      { "code" => code, "result" => "positive", "observed_at" => Date.current.to_s }
    ]
  )
end

When("the high risk algorithm is run for Patty") do
  @high_risk = run_high_risk_algorithm(@patty)
end

Then("Patty is determined to be high risk") do
  expect(@high_risk).to be_truthy
end

Then("Patty is determined not to be high risk") do
  expect(@high_risk).to be_falsey
end
