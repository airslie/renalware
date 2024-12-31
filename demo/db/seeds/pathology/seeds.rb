require_relative "pathology_observation_descriptions"
require_relative "pathology_labs"
require_relative "pathology_request_descriptions"
require_relative "requests_drug_categories"
require_relative "requests_drugs_drug_categories"
require_relative "request_algorithm_global_rule_sets"
require_relative "request_algorithm_global_rules"
require_relative "request_algorithm_patient_rules"
require_relative "request_algorithm_sample_types"
require_relative "observation_requests"
require_relative "pathology_seeder"
require_relative "code_groups"
require_relative "charts"

module Renalware
  PathologySeeder.new.seed_pathology_for(local_patient_id: "Z100001") # Roger
  PathologySeeder.new.seed_pathology_for(local_patient_id: "Z100003") # Francois
end
