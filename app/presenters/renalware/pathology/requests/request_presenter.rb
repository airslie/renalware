# frozen_string_literal: true

module Renalware
  module Pathology
    module Requests
      class RequestPresenter < SimpleDelegator
        def self.present(requests)
          requests.map { |request| new request }
        end

        def patient_name
          patient.full_name.upcase
        end

        def date
          I18n.l Date.current
        end

        def date_of_birth
          I18n.l patient.born_on
        end

        def consultant
          request_form.consultant&.name
        end

        def clinical_detail
          clinic.name
        end
        alias_method :contact, :clinical_detail

        def requested_by
          return "" if created_by.nil?

          created_by.full_name
        end

        def patient_rules
          ::Renalware::Pathology::Requests::PatientRulePresenter.present(super)
        end

        def global_requests_by_lab_and_bottle_type
          request_descriptions.group_by do |request_description|
            [request_description.lab.name, request_description.bottle_type]
          end
        end

        def patient_requests_by_lab
          patient_rules.group_by { |patient_rule| patient_rule.lab.name }
        end

        private

        def request_form
          __getobj__
        end
      end
    end
  end
end
