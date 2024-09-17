# frozen_string_literal: true

describe "Editing a patient's current HD profile", js: false do
  include PatientsSpecHelper

  let(:nurse) { create(:user) }
  let(:centre) { create(:hospital_centre) }
  let(:dialysate) { create(:hd_dialysate, name: "Dialysate1") }
  let(:dialyser) { create(:hd_dialyser, name: "FX80") }
  let(:cannulation_type) { create(:hd_cannulation_type, name: "Buttonhole") }
  let(:schedule_definition) { create(:schedule_definition, :mon_wed_fri_am) }
  let(:hospital_unit) { create(:hd_hospital_unit, unit_code: "Unit1", hospital_centre: centre) }
  let(:patient) do
    create(:hd_patient).tap do |pat|
      # we need to add the HD modality in order to add an HD Profile otherwise the option is
      # greyed out
      set_modality(
        patient: pat,
        modality_description: create(:hd_modality_description),
        by: nurse
      )
    end
  end

  context "when the patient does not yet have an HD Profile" do
    it "creates a new profile" do
      centre
      hospital_unit
      schedule_definition
      dialysate
      dialyser
      cannulation_type

      user = login_as_clinical
      visit patient_hd_dashboard_path(patient)
      within ".page-actions" do
        click_on t("btn.add")
        click_on "HD Profile"
      end

      expect(page).to have_current_path(edit_patient_hd_current_profile_path(patient))

      select "Unit1", from: "Hospital Unit"
      select user.to_s, from: "Prescriber"
      select "Mon Wed Fri AM", from: "Schedule definition"
      select "2:00", from: "Prescribed Time on HD"
      select nurse.to_s, from: "Named nurse"
      fill_in "Prescription Date", with: "01 Feb 2018"

      # Dialysis
      choose "HDF-PRE"
      select "Buttonhole", from: "Cannulation Type"
      select "15", from: "Needle Size"
      within ".hd_profile_document_dialysis_single_needle" do
        choose "Yes"
      end
      select "Dialysate1", from: "Dialysis Solution"
      select "100", from: "Solution Flow Rate"
      fill_in "Blood Flow", with: "123"
      select "FX80", from: "Dialyser"
      select "36.0", from: "Temperature"
      select "32", from: "Bicarbonate"
      within ".hd_profile_document_dialysis_has_sodium_profiling" do
        choose "Yes"
      end
      select "136", from: "Sodium (first half)"
      select "137", from: "Sodium (2nd half)"

      within ".hd-profile-form-anticoagulant" do
        select "Heparin", from: "Type"
        fill_in "Loading Dose", with: "123"
        fill_in "Hourly Dose", with: "234"
        select "1:00", from: "Stop Time"
      end

      within ".hd-profile-form-drugs" do
        within ".hd_profile_document_drugs_on_esa" do
          choose "Yes"
        end
        within ".hd_profile_document_drugs_on_iron" do
          choose "No"
        end
        within ".hd_profile_document_drugs_on_warfarin" do
          choose "Unknown"
        end
      end

      within ".hd-profile-form-transport" do
        choose "Yes"
        select "Car", from: "Transport Type"
        fill_in "Decision Date", with: "01-03-2018"
        select user.to_s, from: "Transport Decider"
      end

      within ".hd-profile-form-care-level" do
        select "3 - Bed bound, needs hoist", from: "Level"
        fill_in "Assessment Date", with: "01-04-2018"
      end

      fill_in "Home Machine Identifier", with: "ABC123"

      submit_form

      expect(page).to have_current_path(patient_hd_dashboard_path(patient))

      within ".hd-profile-summary" do
        expect(page).to have_content(user.to_s)
        expect(page).to have_content(hospital_unit.unit_code)
      end

      expect(Renalware::HD::Profile.for_patient(patient).count).to eq(1)
      expect(Renalware::HD::Profile.for_patient(patient).deleted.count).to eq(0)

      patient.reload
      profile = patient.hd_profile

      expect(patient.named_nurse).to eq(nurse)

      expect(profile).to have_attributes(
        hospital_unit: hospital_unit,
        prescriber: user,
        schedule_definition: schedule_definition,
        home_machine_identifier: "ABC123"
      )

      expect(profile.document.dialysis).to have_attributes(
        hd_type: "hdf_pre",
        needle_size: "15",
        cannulation_type: cannulation_type.name,
        single_needle: "yes",
        flow_rate: 100,
        blood_flow: 123,
        dialyser: "FX80",
        temperature: 36.0,
        bicarbonate: 32,
        has_sodium_profiling: "yes",
        sodium_first_half: 136,
        sodium_second_half: 137
      )

      expect(profile.document.anticoagulant).to have_attributes(
        type: "heparin",
        loading_dose: "123",
        hourly_dose: "234",
        stop_time: "60"
      )

      expect(profile.document.drugs).to have_attributes(
        on_esa: "yes",
        on_iron: "no",
        on_warfarin: "unknown"
      )

      expect(profile.document.transport).to have_attributes(
        has_transport: "yes",
        type: "car",
        decided_on: Date.parse("2018-03-01")
      )

      expect(profile.document.care_level).to have_attributes(
        level: "level3",
        assessed_on: Date.parse("2018-04-01")
      )
    end
  end

  context "when the patient already has an HD Profile" do
    it "creates a new current profile" do
      current_profile = create(:hd_profile, patient: patient)
      expect(patient.hd_profile).to eq(current_profile)

      user = login_as_clinical
      visit patient_hd_dashboard_path(patient)

      within ".hd-profile-summary" do
        click_on t("btn.edit")
      end

      select "17", from: "Needle Size"

      submit_form

      expect(page).to have_current_path(patient_hd_dashboard_path(patient))

      # Check the changes stuck
      profile = patient.reload.hd_profile
      expect(profile.document.dialysis).to have_attributes(
        needle_size: "17"
      )

      # Check the user making the change was captured
      expect(profile.updated_by).to eq(user)

      # Check it created a new profile
      expect(Renalware::HD::Profile.for_patient(patient).with_deleted.count).to eq(2)
      expect(Renalware::HD::Profile.for_patient(patient).deleted.count).to eq(1)
    end
  end
end
