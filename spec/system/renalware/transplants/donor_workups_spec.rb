describe "Donor workup", :js do
  it "sets comorbidities to No without changing other radio groups or diagnosis years" do
    user = login_as_clinical
    patient = create(:patient, by: user)

    visit edit_patient_transplants_donor_workup_path(patient)

    within ".year-dated-confirmation--smoking" do
      choose "Yes"
      select "1990"
    end
    corrected_gfr = "transplants_donor_workup_document_glomerular_filtration_rate_" \
                    "is_measured_value_corrected_true"
    find("##{corrected_gfr}").choose

    click_on "Set all comorbidities to No"

    within "table.comorbidities" do
      expect(page).to have_css('input[type="radio"][value="no"]:checked', count: 16)
    end
    within ".year-dated-confirmation--smoking" do
      expect(page).to have_select(selected: "1990")
    end
    expect(find("##{corrected_gfr}")).to be_checked
  end
end
