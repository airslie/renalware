# frozen_string_literal: true

describe "Transplants MDM Patients" do
  include PatientsSpecHelper
  let(:user) { create(:user) }

  describe "GET index" do
    it "`all` filter displays all Transplant patients" do
      patient = create_recip_operation_patient(user)

      login_as_clinical
      visit transplants_mdm_patients_path

      expect(page).to have_content(patient.family_name.upcase)
    end

    it "`recent` filter displays patients with an operation within 3 months" do
      patient1 = create_recip_operation_patient(user, with_recent_operation: false)
      patient2 = create_recip_operation_patient(user, with_recent_operation: true)
      login_as_clinical

      visit transplants_mdm_patients_path
      click_on t("renalware.transplants.mdm_patients.tabs.tab.recent")

      expect(page).to have_content(patient2.local_patient_id)
      expect(page).to have_no_content(patient1.local_patient_id)
    end

    it "'on worryboard' filter displays transplant patients on the worryboard" do
      patient1 = create_recip_operation_patient(user)
      patient2 = create_recip_operation_patient(user)
      patient2.build_worry(by: user).save!

      login_as_clinical

      visit transplants_mdm_patients_path
      click_on t("renalware.transplants.mdm_patients.tabs.tab.on_worryboard")

      expect(page).to have_content(patient2.local_patient_id)
      expect(page).to have_no_content(patient1.local_patient_id)
    end

    it "`past_year` filter displays transplant patients in the last year" do
      no_op_patient = create_recip_operation_patient(
        user,
        with_recent_operation: false
      )
      matched_patient = create_recip_operation_patient(
        user,
        with_recent_operation: true,
        operation_performed_on: 51.weeks.ago
      )
      unmatched_patient = create_recip_operation_patient(
        user,
        with_recent_operation: true,
        operation_performed_on: 53.weeks.ago
      )

      login_as_clinical

      visit transplants_mdm_patients_path
      click_on t("renalware.transplants.mdm_patients.tabs.tab.past_year")

      expect(page).to have_content(matched_patient.local_patient_id)
      expect(page).to have_no_content(no_op_patient.local_patient_id)
      expect(page).to have_no_content(unmatched_patient.local_patient_id)
    end

    def create_donor_patient(user)
      create(:transplant_patient).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:transplant_donor_modality_description),
                     by: user)
      end
    end

    def create_recip_operation_patient(user,
                                       with_recent_operation: false,
                                       operation_performed_on: 2.months.ago)
      create(:transplant_patient).tap do |patient|
        set_modality(patient: patient,
                     modality_description: create(:transplant_modality_description),
                     by: user)

        if with_recent_operation
          create(:transplant_recipient_operation,
                 patient: patient,
                 performed_on: operation_performed_on)
        end
      end
    end
  end
end
