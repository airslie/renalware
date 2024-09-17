# frozen_string_literal: true

module Renalware
  describe UKRDC::TransplantOperationPresenter do
    let(:presenter) { described_class.new(operation) }
    let(:operation_type) { :kidney }

    describe "#performed_at" do
      it "adds time to performed_on so it can be written to XML as as time" do
        operation = build(:transplant_recipient_operation, performed_on: "2019-01-01")

        performed_at = described_class.new(operation).performed_at

        expect(performed_at.to_s).to eq("2019-01-01 00:00:00 +0000")
      end
    end

    describe "#procedure_type_snomed_code" do
      subject { presenter.procedure_type_snomed_code }

      let(:operation) { build(:transplant_recipient_operation, operation_type: operation_type) }

      %i(kidney_dual kidney kidney_dual kidney_liver liver kidney_other).each do |operation_type|
        context "when the operation_type is #{operation_type}" do
          let(:operation_type) { operation_type }

          it { is_expected.to eq("70536003​") }
        end
      end

      context "when the operation_type is kidney_pancreas" do
        let(:operation_type) { :kidney_pancreas }

        it { is_expected.to eq("6471000179103​") }
      end

      context "when the operation_type is pancreas" do
        let(:operation_type) { :pancreas }

        it { is_expected.to eq("62438007​") }
      end
    end

    describe "#rr_tra76_options" do
      subject { presenter.rr_tra76_options }

      let(:donor_type) { nil }
      let(:donor_relationship) { nil }

      let(:operation) do
        build(
          :transplant_recipient_operation,
          operation_type: operation_type,
          document: {
            donor: {
              type: donor_type,
              relationship: donor_relationship
            }
          }
        )
      end

      context "when the donor type is missing" do
        it { is_expected.to be_nil }
      end

      context "when the donor type is live_related" do
        let(:donor_type) { :live_related }

        # 2 example srelationship pecs, no point testing all
        context "when donor relationship is not specified" do
          let(:donor_relationship) { nil }

          it { is_expected.to eq(code: 23, description: "Transplant; Live related - other") }
        end

        context "when donor relationship :mother" do
          let(:donor_relationship) { :mother }

          it { is_expected.to eq(code: 75, description: "Transplant; Live related - mother") }
        end
      end

      context "when the donor type is cadaver" do
        let(:donor_type) { :cadaver }

        it { is_expected.to eq(code: 20, description: "Transplant; Cadaver donor") }
      end

      context "when the donor type is NHB" do
        let(:donor_type) { :non_heart_beating }

        it { is_expected.to eq(code: 28, description: "Transplant; non-heart-beating donor") }
      end

      context "when the donor type is live unrelated" do
        let(:donor_type) { :live_unrelated }

        it { is_expected.to eq(code: 24, description: "Transplant; Live genetically unrelated") }
      end
    end

    describe "nhsbt_type" do
      subject { presenter.nhsbt_type }

      let(:operation) do
        build(
          :transplant_recipient_operation,
          document: {
            donor: {
              type: donor_type
            }
          }
        )
      end

      context "when donor type is nil" do
        let(:donor_type) { nil }

        it { is_expected.to be_nil }
      end

      context "when donor type is live_related" do
        let(:donor_type) { :live_related }

        it { is_expected.to eq "LIVE" }
      end

      context "when donor type is live_unrelated" do
        let(:donor_type) { :live_unrelated }

        it { is_expected.to eq "LIVE" }
      end

      context "when donor type is cadaver" do
        let(:donor_type) { :cadaver }

        it { is_expected.to eq "DBD" }
      end

      context "when donor type is non_heart_beating" do
        let(:donor_type) { :non_heart_beating }

        it { is_expected.to eq "DCD" }
      end
    end
  end
end
