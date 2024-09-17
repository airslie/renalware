# frozen_string_literal: true

module Renalware
  module Transplants
    describe ".current_transplant_status_for_patient" do
      let(:transplant_registration) { nil }
      let(:patient) { instance_double(Patient) }

      before do
        allow(Transplants::Registration)
          .to receive(:for_patient)
          .with(patient)
          .and_return([transplant_registration])
      end

      context "when registration is not available" do
        it "returns nil" do
          expect(Transplants.current_transplant_status_for_patient(patient)).to be_nil
        end
      end

      context "when registration is available" do
        let(:status) { RegistrationStatus.new }
        let(:transplant_registration) {
          build_stubbed(:transplant_registration, current_status: status)
        }

        it "returns the current status" do
          expect(Transplants.current_transplant_status_for_patient(patient)).to eq status
        end
      end
    end
  end
end
