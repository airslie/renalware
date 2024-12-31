require_relative "../page_object"

module Pages
  module Letters
    class PatientLetters < PageObject
      def go(patient)
        visit patient_letters_letters_path(patient)
        self
      end

      def create_simple_letter
        click_on t("btn.create_")
        click_on "Simple Letter"
        Pages::Letters::Form.new
      end
    end
  end
end
