module Renalware
  module Events
    describe Investigation do
      describe "#document" do
        subject { described_class.new.document }

        it :aggregate_failures do
          is_expected.to validate_presence_of(:modality)
          is_expected.to validate_presence_of(:type)
          is_expected.to validate_presence_of(:result)
        end
      end

      describe "scopes" do
        let(:patient) { create(:patient) }
        let!(:donor_investig) do
          create(:investigation, :transplant_donor, patient: patient)
        end
        let!(:recip_investig) do
          create(:investigation, :transplant_recipient, patient: patient)
        end

        describe ".transplant_donors" do
          context "when 2 Investigations for the patient but only one is as a donor" do
            subject { described_class.transplant_donors.reload }

            it { is_expected.to eq([donor_investig]) }
          end
        end

        describe ".transplant_recipients" do
          context "when 2 Investigations for the patient but only one is as a donor" do
            subject { described_class.transplant_recipients.reload }

            it { is_expected.to eq([recip_investig]) }
          end
        end
      end
    end
  end
end
