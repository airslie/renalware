# frozen_string_literal: true

describe "Batch printing HD Session form PDFs from the HD MDM list", js: true do
  include PatientsSpecHelper
  include AjaxHelpers

  let(:patient) { create(:hd_patient) }
  let(:hd_modality_description) { create(:hd_modality_description) }
  let(:adapter) { ActiveJob::Base.queue_adapter }

  def create_hd_patient(family_name, user)
    create(:hd_patient, family_name: family_name, by: user).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: hd_modality_description,
        by: user
      )
    end
  end

  context "when a user clicks Print HD Session Forms" do
    it "prints all patients in the currently filtered list" do
      user = login_as_clinical
      patients = [create_hd_patient("SMITH", user), create_hd_patient("JONES", user)]

      visit hd_mdm_patients_path

      patients.each { |patient| expect(page).to have_content(patient.family_name) }

      click_on "Batch Print 2 HD Session Forms"

      # wait for the 'working...' dialog to appear
      expect(page).to have_css("#hd-session-form-batch-print-modal", wait: 10)

      # at this point it will have created a batch and 2 batch_items
      expect(Renalware::HD::SessionForms::Batch.count).to eq(1)
      batch = Renalware::HD::SessionForms::Batch.first
      patient_ids = batch.items.pluck(:printable_id)
      expect(patient_ids).to match_array(patients.map(&:id))

      # Simulate a background job marking the batch as successful and assigning the
      # generated filename.
      batch.update_by(
        user,
        status: :awaiting_printing,
        filepath: "#{batch.id}.pdf"
      )

      # Wait for the Print link to appear signifying the PDF is ready to print.
      expect(page).to have_css("#hd-session-form-batch-print-modal .print-batch-letter", wait: 10)

      batch.reload
      expect(batch.status).to eq("awaiting_printing")
      expect(batch.filepath).to match(/#{batch.id}/)
    end
  end
end
