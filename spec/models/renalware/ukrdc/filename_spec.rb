module Renalware
  describe UKRDC::Filename do
    describe "#to_s" do
      subject { described_class.new(patient: patient, batch_number: batch_number).to_s }

      let(:batch_number) { instance_double(UKRDC::Batch, to_s: "000001") }
      let(:ukrdc_external_id) { nil }
      let(:nhs_number) { "" }
      let(:local_patient_id) { "" }
      let(:local_patient_id_2) { "" }

      let(:patient) do
        build_stubbed(
          :patient,
          ukrdc_external_id: ukrdc_external_id,
          nhs_number: nhs_number,
          local_patient_id: local_patient_id,
          local_patient_id_2: local_patient_id_2
        )
      end

      before { allow(Renalware.config).to receive(:ukrdc_site_code).and_return("XYZ") }

      context "when the patient has an NHS number" do
        let(:nhs_number) { "9999999999" }

        it { is_expected.to eq("XYZ_000001_9999999999.xml") }
      end

      context "when the patient only has a local_patient_id_2 and no other patient identifier" do
        let(:local_patient_id_2) { "ABC123" }

        it { is_expected.to eq("XYZ_000001_ABC123.xml") }
      end

      context "when the patient no nhs number or patient identifier" do
        let(:ukrdc_external_id) { "00000000-0000-0000-0000-000000000001" }

        it { is_expected.to eq("XYZ_000001_00000000-0000-0000-0000-000000000001.xml") }
      end
    end
  end
end
