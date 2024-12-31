describe "Editing a swab", :js do
  include AjaxHelpers

  it "allows a swab to be updated" do
    user = login_as_clinical
    patient = create(:patient, by: user)

    swab_site = "The site"
    swab_result = Renalware::Events::Swab::Document.result.values.first.text
    swab = build(:swab, patient: patient, by: user)
    swab.document.result = nil
    swab.document.location = nil
    swab.save!

    visit patient_clinical_profile_path(patient)

    # On Clinical Profile..
    within("article.swabs") do
      expect(page).to have_css("tbody tr", count: 1)
      expect(page).to have_no_content(swab_site)
      expect(page).to have_no_content(swab_result)
      click_on t("btn.edit")
    end

    # Edit..
    fill_in "Site", with: swab_site
    choose swab_result
    click_on t("btn.save")

    # Back on Clinical Profile..
    expect(page).to have_current_path(patient_clinical_profile_path(patient))
    within("article.swabs") do
      expect(page).to have_css("tbody tr", count: 1)
      expect(page).to have_content(swab_site)
      expect(page).to have_content(swab_result)
      click_on t("btn.edit")
    end
  end
end
