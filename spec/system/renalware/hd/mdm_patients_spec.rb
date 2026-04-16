describe "HD MDM Patients" do
  include PatientsSpecHelper

  let(:user) { create(:user) }
  let(:hospital) { create(:hospital_centre) }
  let(:unit1) { create(:hd_hospital_unit, name: "Unit1", hospital_centre: hospital) }
  let(:unit2) { create(:hd_hospital_unit, name: "Unit2", hospital_centre: hospital) }

  def create_hd_patient(unit:, family_name:, schedule_definition: nil, incremental: nil, by: user)
    document = { dialysis: { hd_type: :hd } }
    document[:dialysis][:incremental] = incremental if incremental.present?

    create(:hd_patient, :with_hd_modality, family_name:, by: user).tap do |patient|
      patient.hd_profile = create(:hd_profile,
                                  patient:,
                                  hospital_unit: unit,
                                  schedule_definition:,
                                  document:,
                                  by:)

      create(:prescription, patient:, by: user)
      pres = create(:prescription, patient:, prescribed_on: 1.day.ago, by: user)
      create(:prescription_termination,
             prescription: pres,
             terminated_on: Time.zone.now,
             by: user)
    end
  end

  describe "GET index" do
    it "responds successfully" do
      patient = create(:hd_patient,
                       family_name: "Rabbit",
                       local_patient_id: "12345",
                       by: user)

      set_modality(patient:,
                   modality_description: create(:hd_modality_description),
                   by: user)

      login_as_clinical
      visit hd_mdm_patients_path

      expect(page).to have_content(patient.family_name.upcase)
    end

    it "filters by hospital unit and HD schedule" do
      mon_wed_fri_am = create(:schedule_definition, :mon_wed_fri_am)
      mon_wed_fri_pm = create(:schedule_definition, :mon_wed_fri_pm)

      patient1 = create_hd_patient(
        unit: unit1,
        family_name: "XXXX",
        schedule_definition: mon_wed_fri_am
      )
      patient2 = create_hd_patient(
        unit: unit2,
        family_name: "YYYY",
        schedule_definition: mon_wed_fri_pm
      )

      login_as_clinical
      visit hd_mdm_patients_path

      # See all
      expect(page).to have_content(patient1.family_name)
      expect(page).to have_content(patient2.family_name)

      # Show only those patients dialysing in unit1
      select unit1.name, from: "Dialysing at"
      click_on t("btn.filter")

      expect(page).to have_content(patient1.family_name)
      expect(page).to have_no_content(patient2.family_name)

      # Reset filters to see all
      click_on t("btn.reset").downcase
      expect(page).to have_content(patient1.family_name)
      expect(page).to have_content(patient2.family_name)

      # Show only those patients scheduled at this time
      select "Mon Wed Fri PM", from: "Schedule"
      click_on t("btn.filter")

      expect(page).to have_content(patient2.family_name)
      expect(page).to have_no_content(patient1.family_name)
    end

    it "filters by incremental dialysis" do
      patient1 = create_hd_patient(unit: unit1, family_name: "XXXX", incremental: "yes")
      patient2 = create_hd_patient(unit: unit2, family_name: "YYYY", incremental: "no")

      login_as_clinical
      visit hd_mdm_patients_path

      expect(page).to have_content(patient1.family_name)
      expect(page).to have_content(patient2.family_name)

      select "Yes", from: "Incremental"
      click_on t("btn.filter")

      expect(page).to have_content(patient1.family_name)
      expect(page).to have_no_content(patient2.family_name)
    end

    it "treats missing incremental values as no when filtering" do
      patient1 = create_hd_patient(unit: unit1, family_name: "XXXX", incremental: "yes")
      patient2 = create_hd_patient(unit: unit2, family_name: "YYYY", incremental: "no")
      patient3 = create_hd_patient(unit: unit2, family_name: "ZZZZ")

      login_as_clinical
      visit hd_mdm_patients_path

      select "No", from: "Incremental"
      click_on t("btn.filter")

      expect(page).to have_no_content(patient1.family_name)
      expect(page).to have_content(patient2.family_name)
      expect(page).to have_content(patient3.family_name)
    end

    describe "Named filters" do
      it "'all' filter displays all HD patients" do
        patient1 = create_hd_patient(unit: unit1, family_name: "XXXX")
        patient2 = create_hd_patient(unit: unit1, family_name: "YYYY")
        patient2.build_worry(by: user).save!

        login_as_clinical

        visit hd_mdm_patients_path
        click_on t("renalware.hd.mdm_patients.tabs.tab.all")

        expect(page).to have_content(patient2.family_name)
        expect(page).to have_content(patient1.family_name)
      end

      it "'on worryboard' filter displays patients on the worryboard" do
        patient1 = create_hd_patient(unit: unit1, family_name: "XXXX")
        patient2 = create_hd_patient(unit: unit1, family_name: "YYYY")
        patient2.build_worry(by: user).save!

        login_as_clinical

        visit hd_mdm_patients_path
        click_on t("renalware.hd.mdm_patients.tabs.tab.on_worryboard")

        expect(page).to have_content(patient2.family_name)
        expect(page).to have_no_content(patient1.family_name)
      end

      it "'on worryboard' tab remains active if the user filters by hospital unit" do
        wb_patient_at_unit1 = create_hd_patient(unit: unit1, family_name: "XXXX")
        wb_patient_at_unit2 = create_hd_patient(unit: unit2, family_name: "YYYY")
        nonwb_patient_at_unit1 = create_hd_patient(unit: unit1, family_name: "ZZZZ")

        wb_patient_at_unit1.build_worry(by: user).save!
        wb_patient_at_unit2.build_worry(by: user).save!

        login_as_clinical

        visit hd_mdm_patients_path
        click_on t("renalware.hd.mdm_patients.tabs.tab.on_worryboard")

        # Do not use have_current_path here
        expect(page).to have_current_path(
          hd_filtered_mdm_patients_path(named_filter: :on_worryboard)
        )

        # Show only those patients dialysing in unit1
        select unit1.name, from: "Dialysing at"
        click_on t("btn.filter")

        # Ensure we are still at the on worryboard path
        # !! Do not use have_current_path here
        expect(page).to have_current_path(
          hd_filtered_mdm_patients_path(named_filter: :on_worryboard), ignore_query: true
        )
        # We should only see patients on the worryboard dialysing at unit1
        expect(page).to have_content(wb_patient_at_unit1.family_name)
        expect(page).to have_no_content(wb_patient_at_unit2.family_name)
        expect(page).to have_no_content(nonwb_patient_at_unit1.family_name) # not on wb
      end
    end
  end
end
