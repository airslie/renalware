module Renalware
  module Pathology
    module Requests
      class PatientRulePresenter < SimpleDelegator
        def self.present(patient_rules)
          patient_rules.map { |patient_rule| new patient_rule }
        end

        def to_s
          test_description.to_s + sample_description.to_s
        end

        private

        def sample_description
          Requests::SampleDescription.new(sample_type, sample_number_bottles)
        end
      end
    end
  end
end
