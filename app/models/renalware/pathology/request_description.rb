module Renalware
  module Pathology
    class RequestDescription < ApplicationRecord
      belongs_to :required_observation_description, class_name: "ObservationDescription"
      belongs_to :lab
      has_many :global_rule_sets, class_name: "::Renalware::Pathology::Requests::GlobalRuleSet"
      has_and_belongs_to_many :requests,
                              class_name: "::Renalware::Pathology::Requests::Request"

      validates :lab, presence: true

      scope :with_global_rule_set, -> { joins(:global_rule_sets).uniq }

      def to_s
        code
      end
    end
  end
end
