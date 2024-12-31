describe "Managing files attached to a patient" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }
  let(:attachment_type) do
    create(:patient_attachment_type, store_file_externally: false)
  end
  let(:file) { fixture_file_upload(file_fixture("cat.png"), "image/png") }

  describe "GET new" do
    it "renders the new form" do
      get new_patient_attachment_path(patient)

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "when creating a locally-stored/uploaded attachment" do
      context "when attributes are valid" do
        it "creates a new attachment" do
          params = {
            patients_attachment: {
              attachment_type_id: attachment_type.id,
              name: "name",
              description: "desc",
              document_date: "31-01-2019",
              file: file
            }
          }

          post(patient_attachments_path(patient), params: params)
          expect(response).to be_redirect
          follow_redirect!
          expect(response).to be_successful
          expect(response).to render_template(:index)

          attachment = Renalware::Patients::Attachment.find_by(patient_id: patient.id)
          expect(attachment).to have_attributes(
            attachment_type: attachment_type,
            name: "name",
            description: "desc",
            document_date: Date.parse("31-01-2019")
          )
          expect(attachment.file).to be_attached
        end
      end

      context "when attributes are invalid" do
        it "returns validation error and does not create a new attachment" do
          params = {
            patients_attachment: {
              attachment_type_id: attachment_type.id,
              name: nil
            }
          }

          post(patient_attachments_path(patient), params: params)

          expect(response).to be_successful
          expect(response).to render_template(:new)
          expect(patient.attachments.count).to eq(0)
        end
      end
    end

    context "when creating an externally stored attachment" do
      let(:attachment_type) {  create(:patient_attachment_type, store_file_externally: true) }

      context "when attributes are valid" do
        it "creates a new attachment and does not store any uploaded file that happens be posted" do
          params = {
            patients_attachment: {
              attachment_type_id: attachment_type.id,
              name: "name",
              description: "desc",
              document_date: "31-01-2019",
              external_location: "external path",
              file: file # should not be stored
            }
          }

          post(patient_attachments_path(patient), params: params)

          expect(response).to be_redirect
          follow_redirect!
          expect(response).to be_successful
          expect(response).to render_template(:index)

          attachment = Renalware::Patients::Attachment.find_by(patient_id: patient.id)

          # Although we uploaded a file it should not have been stored
          expect(attachment.file).not_to be_attached

          expect(attachment).to have_attributes(
            attachment_type: attachment_type,
            name: "name",
            description: "desc",
            external_location: "external path",
            document_date: Date.parse("31-01-2019")
          )
        end
      end

      context "when attributes are invalid" do
        it "returns validation error and does not create a new attachment" do
          params = {
            patients_attachment: {
              attachment_type_id: attachment_type.id,
              name: nil
            }
          }

          post(patient_attachments_path(patient), params: params)

          expect(response).to be_successful
          expect(response).to render_template(:new)
          expect(patient.attachments.count).to eq(0)
        end
      end
    end
  end

  describe "GET edit" do
    it "display a form to edit an attachment" do
      attachment = create(:patient_attachment, :with_file, by: user, patient: patient)

      get edit_patient_attachment_path(patient, attachment)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH update" do
    context "when there are no validation errors" do
      it "updates an attachment" do
        attachment = create(:patient_attachment, :with_file, by: user, patient: patient)
        params = {
          patients_attachment: {
            attachment_type_id: attachment_type.id,
            name: "name",
            description: "desc",
            document_date: "31-01-2019"
          }
        }

        patch patient_attachment_path(patient, attachment, params: params)

        expect(response).to be_redirect
        follow_redirect!
        expect(response).to be_successful
        expect(response).to render_template(:index)
      end
    end

    context "when there are validation errors" do
      it "re-renders the edit form" do
        attachment = create(:patient_attachment, :with_file, by: user, patient: patient)
        params = {
          patients_attachment: {
            attachment_type_id: nil
          }
        }

        patch patient_attachment_path(patient, attachment, params: params)

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET show" do
    it "displays an attachment by redirecting to ActiveStorage::BlobsController#show and thence " \
       "to another ActiveStorage url, rending the file directly in the browser" do
      attachment = create(:patient_attachment, :with_file, by: user, patient: patient)

      get patient_attachment_path(patient, attachment)

      expect(response).to be_redirect
      follow_redirect!
      expect(response).to be_redirect
      follow_redirect!
      expect(response.media_type).to eq("image/png")
    end
  end

  describe "DELETE destroy" do
    it "soft deletes the alert" do
      attachment = create(:patient_attachment, :with_file, patient: patient, by: user)

      delete patient_attachment_path(patient, attachment)

      expect(response).to be_redirect
      follow_redirect!
      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(Renalware::Patients::Attachment.count).to eq(0)
      expect(Renalware::Patients::Attachment.deleted.count).to eq(1)
    end
  end
end
