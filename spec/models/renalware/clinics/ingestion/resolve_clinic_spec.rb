module Renalware::Clinics::Ingestion
  describe ResolveClinic do
    describe "#call" do
      context "when feeds_outpatient_clinic_resolution_strategy is by_code" do
        before do
          allow(Renalware.config).to receive_messages(
            feeds_outpatient_clinic_resolution_strategy: :by_code
          )
        end

        it "finds a clinic by code when strategy is :by_code" do
          clinic = create(:clinic, code: "123", name: "Clinic 123")
          result = described_class.call(name_in_feed: "Some Clinic", code_in_feed: "123")

          expect(result).to eq(clinic)
        end
      end

      context "when feeds_outpatient_clinic_resolution_strategy is by_name_mapping" do
        before do
          allow(Renalware.config).to receive_messages(
            feeds_outpatient_clinic_resolution_strategy: :by_name_mapping
          )
        end

        it "finds a clinic by mapping when strategy is :by_name_mapping" do
          clinic = create(:clinic, code: "456", name: "Mapped Clinic")
          create(
            :clinics_mapping,
            name_in_feed: "HL7 Clinic Name",
            clinic: clinic,
            default_clinic: false
          )

          result = described_class.call(name_in_feed: "HL7 Clinic Name", code_in_feed: 456)

          expect(result).to eq(clinic)
        end

        it "returns nil if no mapping exists and no default clinic is set" do
          result = described_class.call(name_in_feed: "Unknown Clinic", code_in_feed: "999")

          expect(result).to be_nil
        end

        it "returns the default clinic if no mapping exists but a default clinic is set" do
          default_clinic = create(:clinic, code: "789", name: "Default Clinic")
          create(
            :clinics_mapping,
            name_in_feed: "Any Other Clinic",
            clinic: default_clinic,
            default_clinic: true
          )

          result = described_class.call(name_in_feed: "Unknown Clinic", code_in_feed: "999")

          expect(result).to eq(default_clinic)
        end

        it "raises an error for an unknown strategy" do
          allow(Renalware.config).to receive_messages(
            feeds_outpatient_clinic_resolution_strategy: :unknown_strategy
          )

          expect {
            described_class.call(name_in_feed: "Clinic", code_in_feed: "123")
          }.to raise_error("Unknown strategy unknown_strategy for resolving the outpatient clinic")
        end
      end
    end
  end
end
