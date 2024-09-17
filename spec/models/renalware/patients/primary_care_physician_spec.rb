# frozen_string_literal: true

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
  end
end
