# frozen_string_literal: true

describe "Batch printing Pathology request forms (for monthly bloods) from the HD MDM list",
         js: true do
  include PatientsSpecHelper

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

  context "when there are no patients on the HD MDM list" do
    it "disables the Print Request Forms button" do
      login_as_clinical
      visit hd_mdm_patients_path

      expect(page).to have_button("Generate 0 Request Forms", disabled: true)
    end
  end

  context "when there are patients on the HD MDM list" do
    context "when a user clicks Generate n Request Forms" do
      it "posts to the path requests controller" do
        user = login_as_clinical
        create_hd_patient("SMITH", user)

        visit hd_mdm_patients_path

        click_on "Generate 1 Request Forms"

        expect(page).to have_current_path(pathology_requests_new_request_path)
      end
    end
  end
end
