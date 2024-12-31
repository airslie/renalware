require_relative "../page_object"

module Pages
  module Admissions
    class Consults < PageObject
      def go
        visit admissions_consults_path
        self
      end

      def sort_by_modality
        within ".admissions-consults-table thead" do
          click_on "Modality"
        end
      end

      def has_patient?(patient)
        within ".admissions-consults-table" do
          has_content?(patient.to_s)
        end
      end
    end
  end
end
