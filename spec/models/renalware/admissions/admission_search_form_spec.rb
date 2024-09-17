# frozen_string_literal: true

module Renalware
  describe Admissions::AdmissionSearchForm do
    it "extracts inputs and invokes the query object with them" do
      form = described_class.new(
        hospital_unit_id: "1",
        hospital_ward_id: "2",
        status: "test_scope_selected_from_dropdown",
        term: "123"
      )

      allow(Admissions::AdmissionQuery).to receive(:call)

      form.submit

      expect(Admissions::AdmissionQuery).to have_received(:call).with(
        hospital_ward_hospital_unit_id_eq: 1,
        hospital_ward_id_eq: 2,
        test_scope_selected_from_dropdown: true,
        identity_match: "123"
      )
    end
  end
end
