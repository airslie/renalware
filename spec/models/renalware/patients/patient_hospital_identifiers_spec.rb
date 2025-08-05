module Renalware::Patients
  describe PatientHospitalIdentifiers do
    include ConfigHelper

    before { configure_patient_hospital_identifiers }

    describe "#all" do
      it "lists local_patient_ids in use in the correct order" do
        patient = build(:patient,
                        local_patient_id: "LP1",
                        local_patient_id_2: "",
                        local_patient_id_3: nil,
                        local_patient_id_4: "LP4",
                        local_patient_id_5: "LP5")

        expected = {
          HOSP1: "LP1",
          HOSP2: "LP4",
          HOSP5: "LP5"
        }
        expect(described_class.new(patient).all).to eq(expected)
      end

      it "returns an empty hash if the patient has no local_patient_ids" do
        patient = build(:patient,
                        local_patient_id: nil,
                        local_patient_id_2: nil,
                        local_patient_id_3: nil,
                        local_patient_id_4: "",
                        local_patient_id_5: "")
        expect(described_class.new(patient).all).to eq({})
      end
    end

    describe "to_s" do
      it "renders patient's complete hospital numbers list in the format HOSP1: XX HOSP2: YY.." do
        patient = build(:patient,
                        local_patient_id: "A",
                        local_patient_id_2: "B",
                        local_patient_id_3: nil,
                        local_patient_id_4: "",
                        local_patient_id_5: "C")

        expected = "HOSP1: A HOSP3: B HOSP5: C"
        expect(described_class.new(patient).to_s).to eq(expected)
      end
    end

    describe "#id and #name" do
      it "returns the value of name of the topmost found local_patient_id in order of preference" do
        patient = build(:patient,
                        local_patient_id: "",
                        local_patient_id_2: "",
                        local_patient_id_3: nil,
                        local_patient_id_4: "LP4",
                        local_patient_id_5: "LP5")

        identifiers = described_class.new(patient)
        expect(identifiers.id).to eq("LP4")
        # expect(identifiers.to_s).to eq("HOSP2: LP4")

        # see configure_local_patient_id_map
        # HOSP2 is mapped to local_patient_id_4 as the second-most preferred column
        expect(identifiers.name).to eq(:HOSP2)
        expect(identifiers.to_sym).to eq(:HOSP2)
      end

      context "when the patient has no local_patient_ids" do
        it ":id and :name return nil" do
          patient = build(:patient,
                          local_patient_id: nil,
                          local_patient_id_2: nil,
                          local_patient_id_3: nil,
                          local_patient_id_4: "",
                          local_patient_id_5: "")

          identifiers = described_class.new(patient)
          expect(identifiers.id).to be_nil
          expect(identifiers.name).to be_nil
        end
      end
    end

    describe ".patient_at?" do
      subject(:identifiers) { described_class.new(patient).patient_at?(hospital_code) }

      context "when the patient has a local_patient_id for the requested hospital" do
        let(:hospital_code) { "HOSP1" }
        let(:patient) { build_stubbed(:patient, local_patient_id: "111") }

        it { is_expected.to be(true) }
      end

      context "when the patient does not have local_patient_id for the requested hospital" do
        let(:hospital_code) { "HOSP1" }
        let(:patient) { build_stubbed(:patient, local_patient_id: "") }

        it { is_expected.to be_falsey }
      end

      context "when the hospital code is not configured" do
        let(:patient) { build_stubbed(:patient, local_patient_id: "111") }
        let(:hospital_code) { "XXX" }

        it { is_expected.to be_falsey }
      end

      context "when the hospital code is blank" do
        let(:patient) { build_stubbed(:patient) }
        let(:hospital_code) { "" }

        it { is_expected.to be_falsey }
      end
    end
  end
end
