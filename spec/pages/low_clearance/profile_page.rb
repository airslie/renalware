require_relative "../page_object"

module Pages
  module LowClearance
    class ProfilePage < Pages::PageObject
      pattr_initialize :patient

      def add_or_edit
        visit patient_low_clearance_dashboard_path(patient)

        within ".page-actions" do
          click_on t("btn.add")
          click_on "Profile"
        end
      end

      def save
        within ".form-actions" do
          find("input[name='commit']").click
        end
      end

      def referred_by=(value)
        select value, from: "Referred by"
      end

      def referred_by_notes=(value)
        fill_in "Referred by notes", with: value
      end

      def date_first_seen=(value)
        fill_in "Date first seen", with: value
      end

      def dialysis_plan=(value)
        select value, from: "Dialysis plan"
      end

      def dialysis_plan_date=(value)
        fill_in "Dialysis plan date", with: value
      end

      def predicted_esrf_date=(value)
        fill_in "Predicted ESRF date", with: value
      end

      def referral_cre=(value)
        fill_in "Referral CRE", with: value
      end

      def referral_efgr=(value)
        fill_in "Referral eGFR", with: value
      end

      def education_status=(value)
        select value, from: "Education status"
      end

      def education_type=(value)
        select value, from: "Education type"
      end

      def date_attending=(value)
        fill_in "Date attended educ.", with: value
      end
    end
  end
end
