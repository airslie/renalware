# frozen_string_literal: true

describe Renalware::Surveys::EQ5DComponent, type: :component do
  let(:patient) { build_stubbed(:patient) }

  describe "#render?" do
    context "when the e5qd survey is not found in the database" do
      it "returns false" do
        component = described_class.new(patient: patient)

        expect(component.render?).to be(false)
      end
    end

    context "when the e5qd survey is found in the database" do
      it "returns true" do
        create(:eq5d_survey)
        component = described_class.new(patient: patient)

        expect(component.render?).to be(true)
      end
    end
  end
end
