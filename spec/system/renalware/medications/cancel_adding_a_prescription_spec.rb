# frozen_string_literal: true

require "rails_helper"

describe "Configuring Modality Descriptions", js: true do
  describe "when cancelling out of the new prescription form" do
    it "returns the the original location" do
      user = login_as_clinical
      patient = create(:patient, by: user)

      visit patient_prescriptions_path(patient,
                                       treatable_type: patient.class.to_s,
                                       treatable_id: patient)

      check_we_are_on_the_medications_list
      load_the_new_prescription_form_via_remote_js_call

      cancel_the_add_prescription_form_via_remote_js_call

      check_we_are_on_the_medications_list
    end
  end

  def check_we_are_on_the_medications_list
    expect(page).to have_css(".medications-filter")
  end

  def load_the_new_prescription_form_via_remote_js_call
    within ".page-actions" do
      click_on t("btn.add")
    end
  end

  def cancel_the_add_prescription_form_via_remote_js_call
    within "form .actions" do
      click_on "Cancel"
    end
  end
end
