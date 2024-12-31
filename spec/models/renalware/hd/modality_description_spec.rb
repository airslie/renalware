module Renalware
  describe HD::ModalityDescription do
    it { is_expected.to respond_to(:to_sym) }

    describe "#augmented_name_for(patient)" do
      subject(:augmented_name) {
        described_class.new(name: "HD").augmented_name_for(patient)
      }

      let(:patient) { build_stubbed(:hd_patient) }

      context "when the patient has no hd_profile" do
        before { patient.hd_profile = nil }

        it { is_expected.to eq("HD") }
      end

      context "when the patient has an hd_profile but no hd site specified" do
        before do
          profile = build_stubbed(:hd_profile, patient: patient, hospital_unit: nil)
          allow(patient).to receive(:hd_profile).and_return(profile)
        end

        it { is_expected.to eq("HD") }
      end

      context "when the patient has an hd_profile with a site specified" do
        before do
          hospital_unit = build_stubbed(:hospital_unit, unit_code: "XYZ")
          profile = build_stubbed(:hd_profile, patient: patient, hospital_unit: hospital_unit)
          allow(patient).to receive(:hd_profile).and_return(profile)
          allow(HD).to receive(:cast_patient).and_return(patient)
        end

        it { is_expected.to eq("HD (XYZ)") }
      end
    end
  end
end
