require_relative "../page_object"

module Pages
  module Accesses
    class ProcedurePage < PageObject
      include CapybaraHelper

      pattr_initialize :patient

      def visit_add
        visit patient_accesses_dashboard_path(patient)
        within(".page-actions") do
          click_on t("btn.add")
          click_on "Access Procedure"
        end
      end

      def visit_edit
        visit patient_accesses_dashboard_path(patient)
        within_article "Procedure History" do
          click_on t("btn.edit")
        end
      end

      def performed_on=(value)
        fill_in "Performed On", with: value
      end

      def performed_by=(value)
        fill_in "Performed By", with: value
      end

      def procedure_type=(value)
        select(value, from: "Access Procedure")
      end

      def side=(value)
        select value, from: "Access Side"
      end

      def catetheter_insertion_technique=(value)
        select value, from: "PD Catheter Insertion Technique"
      end

      def save
        submit_form
      end
    end
  end
end
