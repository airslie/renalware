module Renalware
  describe Patient do # rubocop:disable RSpec/SpecFilePathFormat
    before do
      allow(Renalware.config).to receive(:patient_hospital_identifiers).and_return(
        HOSP1: :local_patient_id,
        HOSP2: :local_patient_id_2,
        HOSP3: :local_patient_id_3,
        HOSP4: :local_patient_id_4,
        HOSP5: :local_patient_id_5
      )
    end

    describe "#local_patient_id" do
      it "resolves correctly using the patient_hospital_identifiers" do
        patient = build(
          :patient,
          local_patient_id: "",
          local_patient_id_2: "",
          local_patient_id_3: nil,
          local_patient_id_4: "LP4"
        )

        expect(patient.hospital_identifier.id).to eq("LP4")
        expect(patient.hospital_identifier.name).to eq(:HOSP4)
      end
    end
  end
end
