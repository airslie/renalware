# frozen_string_literal: true

module Renalware
  describe Patients::PracticeSearchQuery do
    include PatientsSpecHelper

    describe "#call" do
      it "finds a practice by its name" do
        practice = create(:practice, name: "XXX")
        create(:practice, name: "ZZZ")
        expect(
          described_class.new(search_term: "XXX").call
        ).to eq [practice]
      end

      it "finds a practice by its postcode" do
        practice = create(:practice)
        practice.address.update!(postcode: "AA1 1AA")
        create(:practice).address.update!(postcode: "BB1 1BB")
        expect(
          described_class.new(search_term: "AA1 1AA").call
        ).to eq [practice]
      end

      it "finds a practice by first line of address" do
        practice = create(:practice)
        practice.address.update!(street_1: "XX")
        create(:practice).address.update!(street_1: "YY")
        expect(
          described_class.new(search_term: "XX").call
        ).to eq [practice]
      end

      it "finds a practice by its code" do
        create(:practice, code: "A1A1")
        practice = create(:practice, code: "A1")
        expect(
          described_class.new(search_term: "A1").call
        ).to eq [practice]
      end
    end
  end
end
