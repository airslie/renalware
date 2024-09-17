# frozen_string_literal: true

describe "PD MDM Patients" do
  include PatientsSpecHelper

  let(:user) { create(:user) }

  describe "GET index" do
    it "responds successfully" do
      patient = create(:pd_patient,
                       family_name: "Rabbit",
                       local_patient_id: "KCH12345")

      set_modality(patient: patient,
                   modality_description: create(:pd_modality_description),
                   by: user)

      login_as_clinical
      visit pd_mdm_patients_path

      click_on t("renalware.pd.mdm_patients.tabs.tab.all")

      expect(page).to have_content(patient.family_name.upcase)
    end

    describe "Named filters" do
      it "'all' filter displays all patients" do
        patient1 = create(:pd_patient, :with_pd_modality, family_name: "XXXX")
        patient2 = create(:pd_patient, :with_pd_modality, family_name: "YYYY")

        login_as_clinical
        visit pd_mdm_patients_path

        click_on t("renalware.pd.mdm_patients.tabs.tab.all")

        expect(page).to have_content(patient1.family_name)
        expect(page).to have_content(patient2.family_name)
      end

      it "'on worryboard' filter displays patients on the worryboard" do
        patient1 = create(:pd_patient, :with_pd_modality, family_name: "XXXX")
        patient2 = create(:pd_patient, :with_pd_modality, family_name: "YYYY")
        patient2.build_worry(by: user).save!

        login_as_clinical

        visit pd_mdm_patients_path
        click_on t("renalware.pd.mdm_patients.tabs.tab.on_worryboard")

        expect(page).to have_content(patient2.family_name)
        expect(page).to have_no_content(patient1.family_name)
      end
    end
  end
end
