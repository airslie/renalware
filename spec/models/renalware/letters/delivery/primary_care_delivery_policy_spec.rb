module Renalware::Letters
  describe Delivery::PrimaryCareDeliveryPolicy do
    subject(:policy) { described_class.new(letter) }

    let(:patient) { instance_double(Patient, confidentiality_restricted?: false) }
    let(:letter) { instance_double(Letter, patient:, gp_is_a_recipient?: true) }

    before { allow(Renalware.config).to receive(:send_gp_letters_over_mesh).and_return(true) }

    describe "#send_electronically?" do
      it "is true when enabled, the patient is not restricted and the GP is a recipient" do
        expect(policy.send_electronically?).to be(true)
      end

      it "is false when sending GP letters electronically is not enabled" do
        allow(Renalware.config).to receive(:send_gp_letters_over_mesh).and_return(false)

        expect(policy.send_electronically?).to be(false)
      end

      it "is false when the patient's confidentiality is restricted" do
        allow(patient).to receive(:confidentiality_restricted?).and_return(true)

        expect(policy.send_electronically?).to be(false)
      end

      it "is false when the GP is not a recipient" do
        allow(letter).to receive(:gp_is_a_recipient?).and_return(false)

        expect(policy.send_electronically?).to be(false)
      end
    end
  end
end
