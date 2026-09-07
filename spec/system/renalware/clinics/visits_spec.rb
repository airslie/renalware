describe "Clinic Visits" do
  around do |example|
    original = Renalware.config.heidi_enabled
    Renalware.config.heidi_enabled = false
    example.run
  ensure
    Renalware.config.heidi_enabled = original
  end

  let(:clinician) { create(:user, :clinical) }
  let!(:clinic) { create(:clinic) }
  let!(:patient) { create(:clinics_patient, by: clinician, nhs_number: "2717073604") }

  before { login_as clinician }

  describe "Global Clinic Visits list" do
    it "responds successfully" do
      create(:clinic_visit, patient:, by: clinician)

      visit clinic_visits_path

      expect(page.status_code).to eq(200)
      expect(page).to have_text("271 707 3604")
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
        find("textarea[name='clinic_visit[admin_notes]']").set("Admin notes")
        fill_trix_editor with: "Notes"

        click_on t("btn.create")
      end

      expect_clinic_visit_row(
        date: "20-Jul-2015",
        clinic: clinic.description,
        body_measurements: %w(1.78 82.5 26.0),
        blood_pressures: %w(110/75 107/71 100 37.3)
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
      fill_in "clinic_visit[admin_notes]", with: "Updated admin notes"
      # Fill Trix last so its deferred selection updates cannot steal focus while typing elsewhere.
      fill_trix_editor with: "Updated notes"

      submit_form

      expect_clinic_visit_row(
        date: today,
        clinic: clinic.description,
        body_measurements: %w(1.71 75.0 25.6),
        blood_pressures: %w(128/95 124/92 101 37.7)
      )

      expect(clinic_visit.reload.admin_notes).to eq("Updated admin notes")
      expect(clinic_visit.notes).to eq("<div>Updated notes</div>")

      all("a.toggler")[1].click

      expect(page).to have_text "Updated notes"
      expect(page).to have_text "Updated admin notes"
    end
  end

  def expect_clinic_visit_row(date:, clinic:, body_measurements:, blood_pressures:)
    within(first("table.clinics tbody tr")) do
      expect(page).to have_css("td.date-time", text: date)
      expect(page).to have_css("td.clinic-type", text: clinic)
      expect(all("td.bmi").map(&:text)).to eq(body_measurements)
      expect(all("td.bp").map(&:text)).to eq(blood_pressures)
      expect(page).to have_css("td", text: "No")
    end
  end
end
