require_relative "../page_object"

module Pages
  module Clinical
    class AllergyPage < PageObject
      pattr_initialize :patient

      def go
        visit patient_clinical_profile_path(patient)
        self
      end

      def add_allergy(description)
        within ".clinical-allergies" do
          click_on t("btn.add")
        end
        within "#add-allergy-modal.open" do
          fill_in "clinical_allergy_description", with: description
          click_on modal_t("btn.save")
        end
      end

      def remove_allergy(allergy)
        within ".clinical-allergies table" do
          row_css = row_css_for(allergy)
          row = page.find(row_css)
          within row do
            click_on t_allergies(".delete")
            page.driver.browser.switch_to.alert.accept
          end
        end
      end

      def exists?(allergy)
        within ".clinical-allergies table" do
          row_css = row_css_for(allergy)
          page.has_selector?(row_css)
        end
      end

      def status_form_disabled?
        page.has_no_css?(".clinical-allergies .allergy-status-form .disabled")
      end

      def mark_patient_as_having_no_known_allergies
        within ".clinical-allergies" do
          check(t_allergy_status(".no_known_allergies"))
          click_on t("btn.save")
        end
      end

      private

      def row_css_for(allergy)
        "tbody tr[data-allergy-id='#{allergy.id}']"
      end

      def t_allergies(key, scope: "renalware.clinical.allergies.list", required: false)
        translation = I18n.t(key, scope: scope)
        required ? "* #{translation}" : translation
      end

      def modal_t(key, required: false)
        t_allergies(key, scope: "renalware.clinical.allergies.new", required: required)
      end

      def t_allergy_status(key, required: false)
        t_allergies(key, scope: "renalware.clinical.allergy_statuses.form", required: required)
      end
    end
  end
end
