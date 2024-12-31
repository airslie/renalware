describe "Managing a patient's comorbidities", :js do
  include ActionView::RecordIdentifier

  describe "viewing comorbidities" do
    it "displays date + Yes/No/Unknown for any patient comorbidities, and Unknown for others" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      malignancy_site = Renalware::Problems::MalignancySite.create!(description: "Neck")

      malignancy_desc = Renalware::Problems::Comorbidities::Description.create!(
        name: "Xxx",
        position: 1,
        has_malignancy_site: true
      )

      diabetes_desc = Renalware::Problems::Comorbidities::Description.create!(
        name: "Yyy",
        position: 2,
        has_diabetes_type: true
      )

      other_desc = Renalware::Problems::Comorbidities::Description.create!(name: "Zzz", position: 3)

      malignancy_comob = patient.comorbidities.create!(
        description: malignancy_desc,
        recognised: "yes",
        recognised_at: "2010-02-01",
        malignancy_site: malignancy_site,
        by: user
      )

      diabetes_comob = patient.comorbidities.create!(
        description: diabetes_desc,
        recognised: "yes",
        recognised_at: "2010-02-02",
        diabetes_type: "TYPE1",
        by: user
      )

      visit renalware.patient_comorbidities_path(patient)

      # Toggle open all rows
      page.find_all("td a.toggler").map(&:click) # toggle open details

      within("table.comorbidities tbody##{dom_id(malignancy_desc)}") do
        expect(page).to have_content malignancy_desc.name
        expect(page).to have_content I18n.l(malignancy_comob.recognised_at)
        expect(page).to have_content "Yes"
        expect(page).to have_content "Malignancy site"
        expect(page).to have_content "Neck"
      end

      within("table.comorbidities ##{dom_id(diabetes_desc)}") do
        expect(page).to have_content diabetes_desc.name
        expect(page).to have_content I18n.l(diabetes_comob.recognised_at)
        expect(page).to have_content "Yes"
        expect(page).to have_content "Diabetes type"
        expect(page).to have_content "TYPE1"
      end

      within("table.comorbidities ##{dom_id(other_desc)}") do
        expect(page).to have_content other_desc.name
        expect(page).to have_no_content "Unknown"
        expect(page).to have_no_content "Yes"
        expect(page).to have_no_content "No"
        expect(page).to have_no_content "Malignancy site"
        expect(page).to have_no_content "Diabetes type"
      end
    end
  end

  describe "editing comorbidities" do
    it do
      user = login_as_clinical
      patient = create(:patient, by: user)

      desc1 = Renalware::Problems::Comorbidities::Description.create!(name: "Xxx", position: 1)
      desc2 = Renalware::Problems::Comorbidities::Description.create!(name: "Yyy", position: 2)

      visit renalware.edit_patient_comorbidities_path(patient)

      expect(page).to have_content desc1.name
      expect(page).to have_content desc2.name

      within("##{dom_id(desc1)}") do
        select "Yes"
        find(:css, ".flatpickr-input").set("01-01-2001")
      end

      within("##{dom_id(desc2)}") do
        select "No"
      end

      within "#comorbidities-form" do
        click_on "Create"
      end

      expect(
        patient.reload.comorbidities.find_by(description_id: desc1.id)
      ).to have_attributes(
        recognised_at: Date.parse("01-01-2001"),
        recognised: "yes"
      )
    end
  end
end
