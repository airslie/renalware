require_relative "../page_object"

module Pages
  module Accesses
    class ProfilePage < PageObject
      include CapybaraHelper

      pattr_initialize :patient

      def visit_add
        visit patient_accesses_dashboard_path(patient)
        within(".page-actions") do
          click_on t("btn.add")
          click_on "Access Profile"
        end
      end

      def visit_edit
        visit patient_accesses_dashboard_path(patient)
        within_article "Access Profile History" do
          click_on t("btn.edit")
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
        submit_form
      end
    end
  end
end
