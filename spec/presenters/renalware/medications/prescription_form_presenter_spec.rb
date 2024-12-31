module Renalware::Medications
  describe PrescriptionFormPresenter do
    let(:prescription) { Prescription.new }
    let(:selected_drug_id) { "21" }

    let(:instance) {
      described_class.new(
        prescription: prescription,
        selected_drug_id: selected_drug_id
      )
    }

    describe "#frequencies" do
      let(:frequency) { create(:drug_frequency, name: "test") }

      it "includes 'Other' as frequency" do
        expect(instance.frequencies.size).to eq 1
        expect(instance.frequencies[0].name).to eq "other"
      end

      context "when Frequency row is present" do
        before do
          frequency
        end

        it "includes the frequencies + other" do
          expect(instance.frequencies.size).to eq 2
          expect(instance.frequencies[0].name).to eq "test"
          expect(instance.frequencies[1].name).to eq "other"
        end
      end
    end

    describe "#vmps" do
      context "when trade family is not selected" do
        let(:selected_drug_id) { drug.id }
        let(:prescription) do
          Prescription.new(
            drug: drug
          )
        end

        let(:drug) { create(:drug, name: "Drug X") }

        let(:instance) {
          described_class.new \
            prescription: prescription,
            selected_drug_id: selected_drug_id
        }

        let(:active_vmp) { create(:drug_vmp_classification, drug: drug, inactive: false) }
        let(:inactive_vmp) { create(:drug_vmp_classification, drug: drug, inactive: true) }

        before do
          active_vmp && inactive_vmp
        end

        it "returns active VMPs for selected drug" do
          expect(instance.send(:vmps).size).to eq 1
          expect(instance.send(:vmps).first).to eq active_vmp
        end
      end

      context "when trade family is selected" do
        let(:selected_drug_id) { drug.id }
        let(:prescription) do
          Prescription.new(
            drug: drug
          )
        end

        let(:drug) { create(:drug, name: "Drug X") }

        let(:instance) {
          described_class.new \
            prescription: prescription,
            selected_drug_id: selected_drug_id,
            selected_trade_family_id: "14"
        }

        let(:matching_trade_family) {
          create(:drug_vmp_classification, drug: drug, trade_family_ids: %w(12 14))
        }
        let(:not_matching_trade_family) {
          create(:drug_vmp_classification, drug: drug, trade_family_ids: ["18"])
        }

        before do
          matching_trade_family && not_matching_trade_family
        end

        it "returns active VMPs for selected drug" do
          expect(instance.send(:vmps).size).to eq 1
          expect(instance.send(:vmps).first).to eq matching_trade_family
        end
      end
    end
  end
end
