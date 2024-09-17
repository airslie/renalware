# frozen_string_literal: true

describe "Cancel out of the new prescription form" do
  it "returns the original location" do
    user = login_as_clinical(:prescriber)
    patient = create(:patient, by: user)

    visit patient_prescriptions_path(patient,
                                     treatable_type: patient.class.to_s,
                                     treatable_id: patient)

    check_we_are_on_the_medications_list
    load_the_new_prescription_form

    cancel_the_add_prescription_form

    check_we_are_on_the_medications_list
  end

  def check_we_are_on_the_medications_list
    expect(page).to have_css(".medications-filter")
  end

  def load_the_new_prescription_form
    within ".page-actions" do
      click_on t("btn.add")
    end
  end

  def cancel_the_add_prescription_form
    within ".form-actions" do
      click_on "Cancel"
    end
  end
end
