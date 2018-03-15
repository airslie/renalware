# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Clinic < ActiveType::Record[Renalware::Clinics::Clinic]
      has_many :global_rule_sets, class_name: "Requests::GlobalRuleSet"

      scope :for_algorithm, lambda {
        includes(:global_rule_sets)
          .where
          .not(pathology_requests_global_rule_sets: { id: nil })
          .ordered
      }
    end
  end
end
