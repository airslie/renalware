module Renalware::Medications
  describe PrescriptionsByDrugTypeQuery do
    subject(:esa_presciption) { described_class.new(drug_type_name: "ESA") }

    describe "#call" do
      it "returns only patients with one or more current ESA prescription"
    end
  end
end
