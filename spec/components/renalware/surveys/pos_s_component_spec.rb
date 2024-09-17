# frozen_string_literal: true

describe Renalware::Surveys::PosSComponent, type: :component do
  let(:patient) { build_stubbed(:patient) }

  describe "#render?" do
    context "when the pos-s survey is not found in the database" do
      it "returns false" do
        component = described_class.new(patient: patient)

        expect(component.render?).to be(false)
      end
    end

    context "when the pos-s survey is found in the database" do
      it "returns true" do
        create(:pos_s_survey)
        component = described_class.new(patient: patient)

        expect(component.render?).to be(true)
      end
    end
  end
end
