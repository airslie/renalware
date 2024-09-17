# frozen_string_literal: true

describe "Viewing the Recipient Summary (Dashboard)" do
  let(:modality_description) { create(:modality_description, :transplant) }

  context "when the patient has the tx recipient modality" do
    it "user follows the MDM link" do
      user = login_as_clinical
      patient = create(:transplant_patient, family_name: "Rabbit", local_patient_id: "KCH12345")
      hgb = create(:pathology_observation_description, code: "HGB")
      cmvd = create(:pathology_observation_description, code: "CMVD")
      default_cg = create(:pathology_code_group, :default)
      default_cg.memberships.create!(observation_description: hgb)
      default_cg.memberships.create!(observation_description: cmvd)
      create(:modality_change_type, :default)
      Renalware::Modalities::ChangePatientModality
        .new(patient: patient, user: user)
        .call(description: modality_description, started_on: Time.zone.now)

      visit patient_transplants_recipient_dashboard_path(patient)
      within ".page-actions" do
        click_on "MDM"
      end

      expect(page).to have_current_path(patient_transplants_mdm_path(patient))
    end
  end
end
