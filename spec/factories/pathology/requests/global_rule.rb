FactoryGirl.define do
  factory :pathology_requests_global_rule,
    class: "Renalware::Pathology::Requests::GlobalRule" do
      param_type "ObservationResult"
      param_comparison_operator "<"
      param_comparison_value "100"
  end
end
