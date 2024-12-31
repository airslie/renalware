module Renalware
  describe PatientPresenter do
    subject(:presenter) { described_class.new(patient) }

    describe "#salutation" do
      before { Renalware.config.salutation_prefix = "Dear" }

      context "when the patient a title" do
        it "formats as Ms Smith" do
          patient = Patient.new(title: "Ms", family_name: "Smith", given_name: "Jane")

          expect(described_class.new(patient).salutation).to eq("Dear Ms Smith")
        end
      end

      context "when the patient has no title" do
        it "formats as in Jane Smith" do
          patient = Patient.new(title: "", family_name: "Smith", given_name: "Jane")

          expect(described_class.new(patient).salutation).to eq("Dear Jane Smith")
        end
      end
    end
  end
end
