# frozen_string_literal: true

require "renalware/clinics"

module Clinics
  class MyVisit < Renalware::Clinics::ClinicVisit
    include ::Document::Base

    def self.policy_class
      ::Renalware::BasePolicy
    end

    def to_form_partial_path
      "/clinics/my_visits/visit_specific_form_fields"
    end

    def to_toggled_row_partial_path
      "/clinics/my_visits/toggled_row"
    end

    def superclass_to_partial_path
      becomes(Renalware::Clinics::ClinicVisit).to_partial_path
    end

    class Document < MyBaseDocument
      attribute :visit_number, Integer
      attribute :physical_activity, ::Document::Enum

      validates :visit_number,
                allow_nil: true,
                numericality: {
                  only_integer: true,
                  greater_than_or_equal_to: 0,
                  less_than_or_equal_to: 5
                }

      class Smoking < MyBaseDocument
        attribute :history, ::Document::Enum
        attribute :number, Integer
        attribute :ecigarettes, ::Document::Enum

        validates :number,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 0,
                    less_than_or_equal_to: 100
                  },
                  allow_nil: true
      end
      attribute :smoking, Smoking
    end
    has_document
  end
end
