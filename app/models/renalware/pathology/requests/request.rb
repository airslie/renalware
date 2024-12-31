module Renalware
  module Pathology
    module Requests
      class Request < ApplicationRecord
        include Accountable
        include RansackAll

        TEMPLATES = %w(crs manual).freeze

        def self.ransackable_attributes(*) = super + %w(created_on)

        belongs_to :patient, class_name: "::Renalware::Pathology::Patient", touch: true
        belongs_to :clinic, -> { with_deleted }, class_name: "::Renalware::Clinics::Clinic"
        belongs_to :consultant, -> { with_deleted }, class_name: "::Renalware::Clinics::Consultant"
        has_and_belongs_to_many :request_descriptions,
                                class_name: "::Renalware::Pathology::RequestDescription"
        has_and_belongs_to_many :patient_rules,
                                class_name: "::Renalware::Pathology::Requests::PatientRule"

        validates :patient, presence: true
        validates :clinic, presence: true
        validates :consultant, presence: true
        validates :template, presence: true
        validates :template, inclusion: { in: TEMPLATES, allow_nil: false }

        def print_form
          save
        end

        def has_global_requests?
          request_descriptions.any?
        end

        def has_patient_requests?
          patient_rules.any?
        end

        def has_tests_required?
          has_global_requests? || has_patient_requests?
        end

        def requested_on
          created_at.to_date
        end
        alias printed_on requested_on
      end
    end
  end
end
