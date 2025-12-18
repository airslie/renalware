RSpec.describe Renalware::Clinics::Consultant do
  it_behaves_like "an Accountable model"
  it_behaves_like "a Paranoid model"
  it { is_expected.to validate_presence_of :name }

  describe "uniqueness validation of sds_user_id" do
    it "is not valid with a duplicate sds_user_id" do
      create(:consultant, sds_user_id: "SDS123", name: "A")
      consultant = build(:consultant, sds_user_id: "SDS123", name: "B")
      expect(consultant).not_to be_valid
      expect(consultant.errors[:sds_user_id]).to include("has already been taken")
    end
  end

  describe "uniqueness validation of code" do
    it "is not valid with a duplicate code" do
      create(:consultant, code: "CODE123", name: "A")
      consultant = build(:consultant, code: "CODE123", name: "B")
      expect(consultant).not_to be_valid
      expect(consultant.errors[:code]).to include("has already been taken")
    end
  end

  describe ".find_or_create_by_code!" do
    context "when code starts with C or G" do
      it "creates a new consultant when code is not found" do
        consultant = described_class.find_or_create_by_code!(
          code: "C12345",
          name: "Dr. New Consultant"
        )
        expect(consultant).to be_persisted
        expect(consultant.code).to eq "C12345"
        expect(consultant.name).to eq "Dr. New Consultant"
      end

      it "finds an existing consultant by code" do
        existing_consultant = create(
          :consultant,
          code: "C12345",
          name: "Dr. Existing Consultant"
        )
        consultant = described_class.find_or_create_by_code!(
          code: "C12345",
          name: "Dr. New Name"
        )
        expect(consultant.id).to eq existing_consultant.id
        expect(consultant.name).to eq "Dr. Existing Consultant"
      end

      it "returns nil when code is blank" do
        consultant = described_class.find_or_create_by_code!(
          code: "",
          name: "Dr. No Code"
        )
        expect(consultant).to be_nil
      end
    end

    context "when code starts with something lets assume its an SDS User ID" do
      it "creates a new consultant when sds_user_id is not found" do
        consultant = described_class.find_or_create_by_code!(
          code: "SDS12345",
          name: "Dr. New Consultant"
        )
        expect(consultant).to be_persisted
        expect(consultant.sds_user_id).to eq "SDS12345"
        expect(consultant.name).to eq "Dr. New Consultant"
      end

      it "finds an existing consultant by code" do
        existing_consultant = create(
          :consultant,
          sds_user_id: "SDS12345",
          name: "Dr. Existing Consultant"
        )
        consultant = described_class.find_or_create_by_code!(
          code: "SDS12345",
          name: "Dr. New Name"
        )
        expect(consultant.id).to eq existing_consultant.id
        expect(consultant.name).to eq "Dr. Existing Consultant"
      end

      it "returns nil when code is blank" do
        consultant = described_class.find_or_create_by_code!(
          code: "",
          name: "Dr. No Code"
        )
        expect(consultant).to be_nil
      end
    end
  end
end
