module Renalware::Patients
  describe PrimaryCarePhysician do
    subject(:primary_care_physician) { create(:primary_care_physician) }

    it :aggregate_failures do
      is_expected.to have_many(:practice_memberships)
      is_expected.to have_many(:practices).through(:practice_memberships)
    end

    it_behaves_like "a Paranoid model"

    describe "validation" do
      it :aggregate_failures do
        is_expected.to validate_uniqueness_of :code
        is_expected.to validate_presence_of :name
        is_expected.to validate_presence_of :practitioner_type
      end
    end

    describe "#current_address" do
      it "raises an error" do
        expect {
          primary_care_physician.current_address
        }.to raise_error(
          Renalware::Patients::PrimaryCarePhysician::PrimaryCarePhysicianAddressAccessError
        )
      end
    end

    describe ".generic" do
      it "finds or creates a system-level default GP" do
        # Initially does not exists but will create JIT
        gp = nil
        expect {
          gp = described_class.generic
        }.to change(described_class, :count).by(1)
        expect(gp).to have_attributes(name: "General Practitioner", code: "GENERIC")

        # look again and it will be there already so this tests that branch
        gp = nil
        expect {
          gp = described_class.generic
        }.not_to change(described_class, :count)
        expect(gp).to have_attributes(name: "General Practitioner", code: "GENERIC")
      end
    end
  end
end
