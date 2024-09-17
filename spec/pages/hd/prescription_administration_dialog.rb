# frozen_string_literal: true

require_relative "../page_object"
require "capybara-select-2"

module Pages
  module HD
    class PrescriptionAdministrationDialog < PageObject
      include CapybaraSelect2
      include SlimSelectHelper

      pattr_initialize [:prescription!]
      MODAL_CONTAINER_ID = "#hd-prescription-administration-modal"

      def container_css
        MODAL_CONTAINER_ID
      end

      # Assumes we are the HD Summary
      def open_by_clicking_on_drug_name
        visit patient_hd_dashboard_path(prescription.patient)
        within(".page-heading") do
          click_on "Record HD Drugs" # will dropdown the menu so we can select...
          click_on prescription.drug_name
        end
      end

      def visible?
        page.has_css?("#{MODAL_CONTAINER_ID} .modal")
      end

      def displaying_prescription?
        within(MODAL_CONTAINER_ID) do
          page.has_content?(prescription.drug_name)
        end
      end

      def not_administered_reason=(reason)
        select reason, from: "hd_prescription_administration_reason_id"
      end

      def notes=(value)
        within(MODAL_CONTAINER_ID) do
          fill_in "Notes", with: value
        end
      end

      def recorded_on=(value)
        fill_in "Recorded on", with: value
      end

      def administered=(value)
        return if value.nil?

        selection = value ? "Yes" : "No"
        within(".hd_prescription_administration_administered") do
          choose selection
        end
      end

      def administered_by=(user)
        within ".user-and-password--administrator" do
          slim_select user.given_name, from: "hd_prescription_administration_administered_by_id"
        end
      end

      def administered_by_password=(password)
        fill_password(:administrator, password)
      end

      def administered_by_id
        within ".user-and-password--administrator" do
          find("select option[selected='selected']", visible: :all)&.value&.to_i
        end
      end

      def witnessed_by=(user)
        return if user.blank?

        within ".user-and-password--witness" do
          slim_select user.given_name, from: "hd_prescription_administration_witnessed_by_id"
        end
      end

      def witnessed_by_password=(password)
        fill_password(:witness, password)
      end

      # Returns an array of captions for visible submit buttons on the form
      def save_button_captions
        within(MODAL_CONTAINER_ID) do
          all("input[type='submit']").map(&:value)
        end
      end

      def save
        within(MODAL_CONTAINER_ID) do
          click_on t("btn.save")
        end
      end

      def save_and_witness_later
        within(MODAL_CONTAINER_ID) do
          click_on "Save and Witness Later"
        end
      end

      # Cancel the dialog
      def cancel
        within(MODAL_CONTAINER_ID) do
          click_on "Cancel"
        end
      end

      # def submit
      #   within".form-actions:last" do
      #     click_on t("btn.create")
      #   end
      # end

      private

      # Fill in the password field and then simulate a tab which will cause a
      # blur and the handler will authenticate the password
      def fill_password(user_type, password)
        within ".user-and-password--#{user_type}" do
          find("input[type='password']").set(password)
          # find(".user-password").send_keys :tab
        end
      end
    end
  end
end
