RSpec.describe "Recording an HD session", :js do
  let(:prescriber) { create(:user, role: "clinical") }
  let(:other_nurse) { create(:user, role: "clinical") }
  let(:nurse) { create(:user, role: "clinical") }
  let(:patient) { create(:hd_patient, :with_hd_modality) }
  let(:hospital_unit) { create(:hd_hospital_unit) }

  before do
    create(:hd_station, hospital_unit_id: hospital_unit.id, by: nurse)

    login_as nurse
  end

  it "allows a nurse to record pre-session observations" do
    visit patient_hd_dashboard_path(patient)

    within ".page-actions" do
      click_on t("btn.add")
      click_on "HD Session"
    end

    select hospital_unit.to_s, from: "Hospital Unit"
    expect(page).to have_content "StationA"
    select "StationA", from: "Station"
    fill_in "Start time", with: "00:00"

    # Force invalid HD session
    # This will normally default to the todays date
    fill_in "Start date", with: nil

    within ".form-actions", match: :first do
      click_on t("btn.create")
    end

    expect(page).to have_content("HD session could not be added")
    expect(page).to have_content("can't be blank")
    expect(Renalware::HD::Session.count).to eq(0)

    # Correct the invalid HD session so the form submits
    fill_in "Start date", with: l(Time.zone.now.to_date)
    within ".form-actions", match: :first do
      click_on t("btn.create")
    end

    expect(page).to have_content("HD session added")
    expect(Renalware::HD::Session.for_patient(patient)).to be_present
  end

  it "allows a nurse to update an existing HD session" do
    create(:hd_session, patient:, by: other_nurse)

    visit patient_hd_dashboard_path(patient)

    within "article.hd-sessions" do
      label = I18n.t("open", scope: "renalware.hd.sessions_types.edit")
      click_on label
    end

    fill_in "End time", with: "23:59"

    within ".form-actions", match: :first do
      click_on t("btn.save")
    end

    expect(page).to have_current_path(patient_hd_dashboard_path(patient))
  end

  it "allows a nurse to sign off an HD session" do
    create(:hd_session, patient:, by: other_nurse)

    create(:hd_dialysate, name: "Dialysate1")
    create(:hd_cannulation_type, name: "Buttonhole")
    create(:access_type)

    visit patient_hd_dashboard_path(patient)

    within_article "Recent Activity" do
      expect(all(:css, "#hd-sessions tbody").count).to eq(1)
      label = I18n.t(".edit", scope: "renalware.hd.sessions.open")
      click_on label
    end

    fill_in "End time", with: "23:59"
    slim_select nurse.to_s, from: "Taken Off By"

    within_fieldset "Session Info" do
      choose "HD"
      within_fieldset "Access" do
        select "Tunnelled subclav", from: "Access Type Used"
        select "Left", from: "Access Side Used"
        check "Confirm this access was used"
        select "Clean and Dry", from: "Access Site Status"
        select "1", from: "MR VICTOR (line exit site assessment)"
        select "Buttonhole", from: "Cannulation Type"
        select "17", from: "Needle Size"
      end
    end

    within_fieldset "AVF/AVG Assessment" do
      select "2", from: "AVF score"
      within ".hd_session_document_avf_avg_assessment_aneurysm" do
        choose "Yes"
      end
      within ".hd_session_document_avf_avg_assessment_bruit" do
        choose "Abnormal"
      end
      within ".hd_session_document_avf_avg_assessment_thrill" do
        choose "Abnormal"
      end
      within ".hd_session_document_avf_avg_assessment_feel" do
        choose "Hard"
      end
      within ".hd_session_document_avf_avg_assessment_safe_to_use" do
        choose "No"
      end
    end

    within_fieldset "Pre-Dialysis Observations" do
      fill_in "Weight (kg)", with: "111"
      fill_in "Pulse", with: "80"
      fill_in "Temperature", with: "37"
      find_by_id("hd_session_document_observations_before_blood_pressure_systolic").set("120")
      find_by_id("hd_session_document_observations_before_blood_pressure_diastolic").set("80")
      fill_in "BM Stix", with: "1.0"
      fill_in "Respiratory rate", with: "11"
    end

    within_fieldset "Post-Dialysis Observations" do
      fill_in "Weight (kg)", with: "112"
      fill_in "Pulse", with: "81"
      fill_in "Temperature", with: "36"
      find_by_id("hd_session_document_observations_after_blood_pressure_systolic").set("121")
      find_by_id("hd_session_document_observations_after_blood_pressure_diastolic").set("81")
      fill_in "BM Stix", with: "1.0"
      fill_in "Respiratory rate", with: "12"
    end

    within_fieldset "Dialysis" do
      fill_in "Arterial Pressure", with: "11"
      fill_in "Venous pressure", with: "11"
      fill_in "Fluid Removed", with: "30"
      select "100", from: "Dialysate Flow Rate"
      fill_in "Blood Flow Rate", with: "100"
      select "Very good", from: "Washback quality"
      fill_in "Machine URR", with: "1.0"
      fill_in "Machine KTV", with: "1.0"
      fill_in "Litres Processed", with: "10"
      fill_in "Machine No", with: "123"
      select "Dialysate1", from: "Dialysis Solution Used"
    end

    page.first("input[name='signoff']").click

    expect(page).to have_current_path(patient_hd_dashboard_path(patient))
    expect(page).to have_no_content "failed"
    hd_patient = Renalware::HD.cast_patient(patient)
    sessions = hd_patient.reload.hd_sessions
    expect(sessions.length).to eq(1)
    new_session = sessions.first

    avf_avg_assessment = new_session.document.avf_avg_assessment
    expect(avf_avg_assessment.score).to eq(2)
    expect(avf_avg_assessment.aneurysm).to eq("Y")
    expect(avf_avg_assessment.bruit).to eq("A")
    expect(avf_avg_assessment.thrill).to eq("A")
    expect(avf_avg_assessment.feel).to eq("H")
    expect(avf_avg_assessment.safe_to_use).to eq("N")

    info = new_session.document.info
    expect(info).to have_attributes(
      needle_size: "17",
      cannulation_type: "Buttonhole"
    )

    pre_observations = new_session.document.observations_before
    expect(pre_observations.respiratory_rate).to eq(11)

    post_observations = new_session.document.observations_after
    expect(post_observations.respiratory_rate).to eq(12)
  end
end
