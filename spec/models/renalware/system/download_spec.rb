# frozen_string_literal: true

module Renalware
  describe System::Download do
    it_behaves_like "a Paranoid model"
    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:name) }

    describe "uniqueness" do
      subject { described_class.new(by: create(:user), name: "A") }

      it { is_expected.to validate_uniqueness_of(:name) }
    end

    describe "#file via ActiveStorage" do
      subject(:download) { create(:system_download, :with_file, by: create(:user)) }

      let(:user) { download.updated_by }

      it "can accept an uploaded file" do
        download.file.attach(
          io: File.open(file_fixture("dog.jpg")),
          filename: "dog.jpg",
          content_type: "image/jpeg"
        )
        download.save_by!(user)

        expect(download.file).to be_attached
      end

      it "validates the presence of #file" do
        download = build(:system_download, file: nil)

        expect(download).not_to be_valid
        expect(download.errors[:file]).to include("can't be blank")
        expect(download.errors[:file]).to include("Please specify a file to upload")
      end
    end
  end
end
