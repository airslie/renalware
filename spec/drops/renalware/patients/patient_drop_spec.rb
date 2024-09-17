# frozen_string_literal: true

module Renalware::Patients
  describe PatientDrop, type: :model do
    subject(:drop) { described_class.new(patient) }

    let(:patient) { build(:patient) }

    it "delegates to #hospital_identifier" do
      expect(drop.hospital_identifier).to eq(patient.hospital_identifier.to_s)
    end

    it "delegates to #current_modality" do
      allow(patient).to receive(:current_modality).and_return(build(:hd_modality_description))

      expect(drop.current_modality).to eq(patient.current_modality.to_s)
    end

    it "delegates to #name" do
      expect(drop.name).to eq(patient.to_s(:default))
    end

    it "delegates to #diabetic" do
      patient.document.diabetes.diagnosis = true

      expect(drop.diabetic).to eq("Yes") # May become eg "Type 1" in the future.
    end
  end
end
