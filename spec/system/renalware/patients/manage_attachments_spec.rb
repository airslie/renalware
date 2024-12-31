describe "Manage a patient's attachments (linked files)" do
  # include PatientsSpecHelper
  let(:patient) { create(:patient) }

  describe "viewing a patients attachments" do
    it "displays a paginated table" do
      user = login_as_clinical
      attachment = create(:patient_attachment, :with_file, patient: patient, by: user)

      visit patient_path(patient)

      within(".patient-side-nav .side-nav") do
        click_on "Linked Files"
      end

      expect(page).to have_current_path(patient_attachments_path(patient))

      expect(page).to have_content("Linked Files")
      expect(page).to have_content(attachment.name)
      expect(page).to have_content(attachment.attachment_type.name)
      expect(page).to have_content(I18n.l(attachment.document_date))
    end
  end

  describe "viewing an attachment" do
    it "clicking on the attachment name views the attachment in a new window using " \
       "ActiveStorage::BlobsController#show" do
      user = login_as_clinical
      attachment = create(:patient_attachment, :with_file, patient: patient, by: user)

      visit patient_attachments_path(patient)

      within(".attachments--table") do
        click_on attachment.name
      end

      expect(page).to have_current_path(%r{rails/active_storage.*})
    end
  end
end
