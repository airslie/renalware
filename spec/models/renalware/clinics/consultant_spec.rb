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
    before { create(:user, :system) }

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

      context "when the consultant exists by name but has only an sds id and no code" do
        it "matches on name and then update the code column" do
          existing_consultant = create(
            :consultant,
            sds_user_id: "12345",
            name: "Existing SDS Consultant",
            code: ""
          )

          consultant = described_class.find_or_create_by_code!(
            code: "C12345",
            name: "Existing SDS Consultant"
          )

          expect(consultant).to eq(existing_consultant)
          expect(consultant).to have_attributes(
            code: "C12345",
            sds_user_id: "12345",
            name: "Existing SDS Consultant"
          )
        end
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

      context "when the consultant exists by name but has only a gmc code and no sds_id" do
        it "matches on name and then update the sds id column" do
          existing_consultant = create(
            :consultant,
            code: "C12345",
            name: "Existing SDS Consultant",
            sds_user_id: ""
          )

          consultant = described_class.find_or_create_by_code!(
            code: "12345",
            name: "Existing SDS Consultant"
          )

          expect(consultant).to eq(existing_consultant)
          expect(consultant).to have_attributes(
            name: "Existing SDS Consultant",
            code: "C12345",
            sds_user_id: "12345"
          )
        end
      end
    end
  end
end
