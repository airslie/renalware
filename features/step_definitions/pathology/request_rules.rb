When("the request algorithm rules are viewed by Clyde") do
  @rules_table = view_request_algorithm_rules(@clyde)
end

Then("Clyde see rules for these request_descriptions and clinics:") do |table|
  table.hashes.each do |rule_params|
    request_description = Renalware::Pathology::RequestDescription.find_by(
      code: rule_params[:request_description_code]
    )
    clinic = Renalware::Clinics::Clinic.find_by(name: rule_params[:clinic])

    expect_rules_table_to_have_rule(
      @rules_table,
      request_description,
      clinic
    )
  end
end
