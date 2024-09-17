# frozen_string_literal: true

module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::DiagnosesComponent, type: :component do
      subject(:component) { described_class.new(letter) }

      let(:letter) { instance_double(Renalware::Letters::Letter, patient: patient) }
      let(:patient) { build_stubbed(:patient) }

      it "displays problems in a table" do
        allow(patient).to receive(:problems).and_return(
          [
            build_stubbed(:problem, description: "new problem", patient: patient),
            build_stubbed(:problem, description: "another problem", patient: patient)
          ]
        )

        render_inline(component)

        expect(page.find_all("table tbody tr th")[0].text).to eq("Diagnosis name")
        expect(page.find_all("table tbody tr td")[0].text).to eq("new problem")
        expect(page.find_all("table tbody tr th")[1].text).to eq("Diagnosis name")
        expect(page.find_all("table tbody tr td")[1].text).to eq("another problem")
      end
    end
  end
end
