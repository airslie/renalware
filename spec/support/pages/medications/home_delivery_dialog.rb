# frozen_string_literal: true

require "rails_helper"
require_relative "../page_object"
require "capybara-select-2"

module Pages
  module Medications
    class HomeDeliveryDialog < PageObject
      include CapybaraSelect2
      pattr_initialize [:patient!]

      def path
        patient_prescriptions_path(
          patient,
          treatable_type: patient.class.to_s,
          treatable_id: patient
        )
      end

      def open
        visit path
        within ".page-actions" do
          click_on "Print home delivery drugs"
        end
      end

      def drug_type
        within("#print-home-delivery-drugs-modal") do
          find("#event_drug_type_id").find("option[selected]").text
        end
      end

      def prescription_duration
        within("#print-home-delivery-drugs-modal") do
          find("#event_prescription_duration").find("option[selected]").text
        end
      end

      def print
        within("#print-home-delivery-drugs-modal") do
          click_on "Print"
        end
      end

      def drug_type_css
        "#print-home-delivery-drugs-modal #event_drug_type_id"
      end

      def prescription_duration_css
        "#print-home-delivery-drugs-modal #event_prescription_duration"
      end

      def indicate_printing_was_succesful
        within("#print-home-delivery-drugs-modal") do
          click_on "Yes - mark as printed"
        end
      end

      def visible?
        page.has_css?("#print-home-delivery-drugs-modal .modal", visible: true)
      end

      def has_enabled_print_button?
        within("#print-home-delivery-drugs-modal") do
          has_css?("a.home-delivery--print:not([disabled])")
        end
      end

      def has_no_prescriptions_error?
        within("#print-home-delivery-drugs-modal") do
          has_content?("There are no home delivery prescriptions for this drug type")
        end
      end
    end
  end
end
