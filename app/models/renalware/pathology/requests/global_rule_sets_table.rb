module Renalware
  module Pathology
    module Requests
      class GlobalRuleSetsTable
        def initialize(request_descriptions, clinics, rule_sets)
          @request_descriptions = request_descriptions
          @clinics = clinics
          @rule_sets = rule_sets
        end

        def rows
          @request_descriptions.map do |request_description|
            Row.new(request_description, @clinics, @rule_sets)
          end
        end
      end

      class Row
        attr_reader :request_description

        def initialize(request_description, clinics, rule_sets)
          @request_description = request_description
          @clinics = clinics
          @rule_sets = rule_sets
        end

        def columns
          @clinics.map do |clinic|
            Cell.new(request_description, clinic, @rule_sets)
          end
        end
      end

      class Cell
        attr_reader :request_description, :clinic

        def initialize(request_description, clinic, rule_sets)
          @request_description = request_description
          @clinic = clinic
          @rule_sets = rule_sets
        end

        def rule_sets
          grouped_rule_sets.fetch([request_description.id, clinic.id], [])
        end

        def grouped_rule_sets
          @grouped_rule_sets ||= @rule_sets.group_by do |rule_set|
            [rule_set.request_description_id, rule_set.clinic_id]
          end
        end
      end
    end
  end
end
