describe "Clinic Visits" do
  let(:clinician) { create(:user, :clinical) }
  let!(:clinic) { create(:clinic) }
  let!(:patient) { create(:clinics_patient, by: clinician, nhs_number: "2717073604") }

  before { login_as clinician }

  describe "Global Clinic Visits list" do
    it "responds successfully" do
      create(:clinic_visit, patient:, by: clinician)

      visit clinic_visits_path

      expect(page.status_code).to eq(200)
      expect(page).to have_content("271 707 3604")
    end
  end

  describe "Recording a clinic visit", :js do
    it "creates a clinic visit" do
      visit new_patient_clinic_visit_path(patient_id: patient)

      within(".document") { fill_in "Date", with: "20-07-2015" }
      slim_select "Access", from: "Clinic"

      within ".document" do
        fill_in "Height", with: "1.78"
        fill_in "Weight", with: "82.5"
        fill_in "Pulse", with: "100"
        fill_in "Temperature", with: "37.3"
        fill_in "Blood Pressure", with: "110/75"
        fill_in "Standing BP", with: "107/71"
        find("trix-editor").set("Notes")
        find("textarea[name='clinic_visit[admin_notes]']").set("Admin notes")

        click_on t("btn.create")
      end

      expect(page).to have_content(
        "20-Jul-2015\tNo\t#{clinic.description}\t1.78\t82.5\t26.0\t110/75\t107/71\t100\t37.3"
      )
    end
  end

  describe "Updating a clinic visit", :js do
    let(:patient) { clinic_visit.patient }
    let!(:clinic_visit) { create(:clinic_visit, clinic:, by: clinician) }
    let(:today) { l(Date.current) }

    it "updates a clinic visit" do
      visit edit_patient_clinic_visit_path(
        patient_id: patient,
        id: clinic_visit.id
      )

      fill_in "Height", with: "1.71"
      fill_in "Weight", with: "75"
      fill_in "Pulse", with: "101"
      fill_in "Temperature", with: "37.7"
      fill_in "Blood Pressure", with: "128/95"
      fill_in "Standing BP", with: "124/92"
      find("trix-editor").set("Updated notes")
      fill_in "clinic_visit[admin_notes]", with: "Updated admin notes"

      submit_form

      expect(page).to have_content(
        "#{today}\tNo\t#{clinic.description}\t1.71\t75.0\t25.6\t128/95\t124/92\t101\t37.7"
      )

      all("a.toggler")[1].click

      expect(page).to have_content "Updated notes"
      expect(page).to have_content "Updated admin notes"
    end
  end
end
