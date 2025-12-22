RSpec.describe Renalware::Clinics::Consultant do
  it_behaves_like "an Accountable model"
  it_behaves_like "a Paranoid model"
  it { is_expected.to validate_presence_of :name }

  describe "uniqueness validation of code" do
    it "is not valid with a duplicate code" do
      create(:consultant, code: "CODE123", name: "A")
      consultant = build(:consultant, code: "CODE123", name: "B")
      expect(consultant).not_to be_valid
      expect(consultant.errors[:code]).to include("has already been taken")
    end
  end

  describe ".find_or_create_by_code!" do
    before { create(:user, :system) }

    it "finds a consultant by code" do
      existing_consultant = create(
        :consultant,
        code: "C12345",
        name: "Dr. Existing Consultant"
      )

      consultant = described_class.find_or_create_by_code!(
        code: "C12345",
        name: "another name"
      )

      expect(consultant).to eq(existing_consultant)
    end

    it "finds a consultant by name if no match on code" do
      existing_consultant = create(
        :consultant,
        code: "no",
        name: "Dr. Existing Consultant"
      )

      consultant = described_class.find_or_create_by_code!(
        code: "C12345",
        name: "Dr. Existing Consultant"
      )

      expect(consultant).to eq(existing_consultant)
    end

    it "creates the consultant if no match on code or name" do
      consultant = described_class.find_or_create_by_code!(
        code: "C12345",
        name: "Dr. New Consultant"
      )
      expect(consultant).to be_persisted
      expect(consultant.code).to eq "C12345"
      expect(consultant.name).to eq "Dr. New Consultant"
    end
  end
end
