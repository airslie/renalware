# frozen_string_literal: true

require_relative "../page_object"

module Pages
  module Accesses
    class ProfilePage < PageObject
      include CapybaraHelper
      pattr_initialize :patient

      def visit_add
        visit patient_accesses_dashboard_path(patient)
        within(".page-actions") do
          click_on "Add"
          click_on "Access Profile"
        end
      end

      def visit_edit
        visit patient_accesses_dashboard_path(patient)
        within_article "Access Profile History" do
          click_on "Edit"
        end
      end

      def formed_on=(value)
        fill_in "Formed On", with: value
      end

      def access_type=(value)
        select(value, from: "Access Type")
      end

      def side=(value)
        select value, from: "Access Side"
      end

      def save
        within ".top" do
          find('input[name="commit"]').click
        end
      end
    end
  end
end
