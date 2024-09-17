# frozen_string_literal: true

describe Renalware::Patients::NagsComponent, type: :component do
  let(:user) { create(:patients_user) }
  let(:patient) { create(:patient, by: user) }

  it "renders nothing when no nag_definitions are defined" do
    component = described_class.new(patient: patient, current_user: user)

    expect(component.render?).to be(false)
  end

  describe "#definitions" do
    it "returns the top 5 definitions for a patient ordered by importance" do
      create(:patient_nag_definition, importance: 1)
      create(:patient_nag_definition, importance: 4)
      create(:patient_nag_definition, importance: 3)
      create(:patient_nag_definition, importance: 99)
      create(:patient_nag_definition, importance: 2)
      create(:patient_nag_definition, importance: 5)

      component = described_class.new(patient: patient, current_user: user)

      expect(component.definitions.map(&:importance)).to eq([1, 2, 3, 4, 5])
    end

    it "omits definitions that are disabled" do
      create(:patient_nag_definition, importance: 1, enabled: false)
      create(:patient_nag_definition, importance: 2, enabled: true)

      component = described_class.new(patient: patient, current_user: user)

      expect(component.definitions.map(&:importance)).to eq([2])
    end
  end
end
