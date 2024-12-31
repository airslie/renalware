module Renalware
  module Patients
    describe Attachment do
      it_behaves_like "a Paranoid model"
      it_behaves_like "an Accountable model"

      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:attachment_type_id) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to belong_to(:attachment_type) }

      describe "#file via ActiveStorage" do
        subject(:attachment) { create(:patient_attachment, :with_file) }
        let(:user) { attachment.updated_by }

        it "can accept an uploaded file" do
          attachment.file.attach(
            io: File.open(file_fixture("cat.png")),
            filename: "cat2.png",
            content_type: "image/png"
          )
          attachment.save_by!(user)

          expect(attachment.file).to be_attached
        end

        it "validates the file size" do
          attachment = build(:patient_attachment)
          max_bytes = 2
          allow(Renalware.config).to receive(:max_file_upload_size).and_return(max_bytes)

          attachment.file.attach(
            io: File.open(file_fixture("cat.png")),
            filename: "cat2.png",
            content_type: "image/png"
          )

          expect(attachment).not_to be_valid
          expect(attachment.errors[:file]&.first).to eq(
            "Sorry, the file is too large. The maximum is #{max_bytes} bytes."
          )
        end

        context "when the attachment.attachment_type is internal" do
          let(:attachment_type) { create(:patient_attachment_type, store_file_externally: false) }

          it "validates the presence of #file" do
            attachment = build(:patient_attachment, attachment_type: attachment_type, file: nil)

            expect(attachment).not_to be_valid
            expect(attachment.errors.full_messages)
              .to include("File Please specify a file to upload")
          end
        end

        context "when the attachment.attachment_type is external" do
          let(:attachment_type) { create(:patient_attachment_type, store_file_externally: true) }

          it "validates the presence of #external_location" do
            attachment = build(
              :patient_attachment,
              attachment_type: attachment_type,
              file: nil,
              external_location: nil
            )

            expect(attachment).not_to be_valid
            expect(attachment.errors.full_messages).to include("External location can't be blank")
          end

          it "does not validate the presence of #file" do
            attachment = build(
              :patient_attachment,
              attachment_type: attachment_type,
              file: nil,
              external_location: "some path"
            )

            expect(attachment).to be_valid
          end
        end
      end
    end
  end
end
