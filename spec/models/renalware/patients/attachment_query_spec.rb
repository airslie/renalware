module Renalware
  module Patients
    describe AttachmentQuery do
      let(:user) { create(:user) }
      let(:patient1) { create(:patient, by: user) }
      let(:patient2) { create(:patient, by: user) }

      describe "#call" do
        context "when using default sort and no search argument" do
          it "returns a sorted collection of attachments for a patient" do
            att1 = create(:patient_attachment, :with_file, patient: patient1, by: user)
            att2 = create(:patient_attachment, :with_file, patient: patient1, by: user)
            # Create a soft-deleted attachment for this patient
            create(
              :patient_attachment,
              :with_file,
              patient: patient1,
              deleted_at: 1.minute.ago,
              by: user
            )
            # Create an attachment for another patient
            create(:patient_attachment, :with_file, patient: patient2, by: user)

            attachments = described_class.new(patient: patient1).call

            expect(attachments.to_a).to eq [att2, att1]
          end
        end
      end
    end
  end
end
