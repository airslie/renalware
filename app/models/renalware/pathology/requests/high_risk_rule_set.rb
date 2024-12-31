# This class used to include https://github.com/softace/activerecord-tableless but that does not
# support Rails 5. The alternative I have used here is to massage this class to get the specs to
# pass by stubbing out various methods.
# I'm not really sure yet how this class works and why its tableless.
module Renalware
  module Pathology
    module Requests
      class HighRiskRuleSet
        def self.rules
          GlobalRule.where(rule_set_type: name)
        end

        def self.primary_key
          :id
        end

        # Added for rails 7.1
        def self.has_query_constraints?
          false
        end

        # Added for rails 7.1
        def self.composite_primary_key?
          false
        end

        def self.base_class
          Renalware::Pathology::Requests::HighRiskRuleSet
        end

        # Required for Rails 5.2
        def self.polymorphic_name
          name
        end

        # NOTE: required so ActiveRecord doesn't try to create a new associated HighRiskRuleSet
        #       record with the audit
        def new_record?
          false
        end

        def to_model
          # noop
        end

        def id
          nil
        end

        def _read_attribute(name)
          # noop
        end

        def marked_for_destruction?
          false
        end

        def destroyed?
          false
        end
      end
    end
  end
end
