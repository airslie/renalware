# frozen_string_literal: true

describe "Advanced Kidney Care Patients" do
  include PatientsSpecHelper
  let(:user) { create(:user) }

  describe "GET index" do
    def each_filter
      Renalware::LowClearance::MDM_FILTERS.each do |filter_name|
        filter_label = t(
          filter_name,
          scope: "renalware.low_clearance.mdm_patients.tabs.tab"
        )
        filter_path = low_clearance_filtered_mdm_patients_path(named_filter: filter_name)
        yield filter_label, filter_path
      end
    end

    it "responds successfully" do
      login_as_clinical
      visit low_clearance_mdm_patients_path

      expect(page).to have_content("AKCC MDM Patients")
    end

    it "clicking on filters works" do
      login_as_clinical
      visit low_clearance_mdm_patients_path
      each_filter do |filter_label, filter_path|
        within ".filters" do
          expect(page).to have_content(filter_label)
          click_on filter_label
          expect(page).to have_current_path(filter_path)
        end
      end
    end
  end
end
