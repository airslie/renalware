module Renalware
  module Patients
    describe AttachmentType do
      it_behaves_like "a Paranoid model"
      it { is_expected.to validate_presence_of(:name) }

      describe "uniqueness" do
        subject { build(:patient_attachment_type) }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end
  end
end
