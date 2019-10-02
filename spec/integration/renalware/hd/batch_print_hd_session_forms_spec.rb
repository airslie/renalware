# frozen_string_literal: true

require "rails_helper"

describe "Batch printing HD Session form PDFs from the HD MDM list", type: :system, js: true do
  include PatientsSpecHelper
  include AjaxHelpers

  let(:patient) { create(:hd_patient) }
  let(:hd_modality_description) { create(:hd_modality_description) }
  let(:adapter) { ActiveJob::Base.queue_adapter }

  before do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end

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

      # it brings up a 'working...' dialog
      expect(page).to have_css("#hd-session-form-batch-print-modal")

      # it has created a batch and 2 batch_items
      expect(Renalware::HD::SessionForms::Batch.count).to eq(1)
      batch = Renalware::HD::SessionForms::Batch.first
      patient_ids = batch.items.pluck(:printable_id)
      expect(patient_ids).to match_array(patients.map(&:id))

      # it has enqueued a job to compile the PDFs
      expect(Delayed::Job.count).to eq 1

      # Simulate a background job marking the batch as successful and assigning the
      # generated filename.
      batch.update_by(
        user,
        status: :awaiting_printing,
        filepath: "X123.pdf"
      )
      # have_css will for batch status polling to find changes and display a link to the compiled
      # PDF in the modal.
      expect(page).to have_css("a.print-batch-letter")
    end
  end
end
