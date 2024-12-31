module Renalware
  module UKRDC
    describe TreatmentTimeline::Transplant::Generator do
      include PatientsSpecHelper
      subject(:generator) { described_class.new(modality) }

      let(:user) { create(:user) }
      let!(:unknown_ukrdc_modality_code) { create(:ukrdc_modality_code, :type_unknown) }
      let!(:cadaver_ukrdc_modality_code) { create(:ukrdc_modality_code, :cadaver) }
      let!(:nhb_ukrdc_modality_code) { create(:ukrdc_modality_code, :non_heart_beating) }
      let!(:live_related_sibling_modality_code) {
        create(:ukrdc_modality_code, :live_related_sibling)
      }
      let!(:live_related_father_modality_code) {
        create(:ukrdc_modality_code, :live_related_father)
      }
      let!(:live_related_mother_modality_code) {
        create(:ukrdc_modality_code, :live_related_mother)
      }
      let!(:live_related_child_modality_code) { create(:ukrdc_modality_code, :live_related_child) }
      let!(:live_related_other_modality_code) { create(:ukrdc_modality_code, :live_related_other) }
      let!(:live_unrelated_ukrdc_modality_code) { create(:ukrdc_modality_code, :live_unrelated) }
      let(:tx_mod_desc) { create(:transplant_modality_description) }

      context "when the patient has the RW Transplant modality" do
        let(:patient) { create(:transplant_patient) }
        let(:modality) do
          set_modality(
            patient: patient,
            modality_description: tx_mod_desc,
            by: user
          )
        end

        before { modality }

        context "when the patient has no recipient operations" do
          it "creates a Treatment with type Tx unknown" do
            expect {
              generator.call
            }.to change(UKRDC::Treatment, :count).by(1)

            expect(UKRDC::Treatment.first).to have_attributes(
              patient_id: patient.id,
              hd_profile_id: nil,
              modality_code: unknown_ukrdc_modality_code,
              modality_description_id: tx_mod_desc.id,
              started_on: modality.started_on,
              ended_on: modality.ended_on,
              modality_id: modality.id
            )
          end
        end

        context "when the patient has a recipient operation outside the Tx modality start/end" do
          subject { UKRDC::Treatment.first.modality_code }

          before do
            create_operation(type: :cadaver, performed_on: modality.started_on - 1.day)
            generator.call
          end

          it { is_expected.to eq(unknown_ukrdc_modality_code) }
        end

        context "when the patient has a recipient operation inside the modality's date span" do
          context "when the donor is a cadaver" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :cadaver)
              generator.call
            end

            it { is_expected.to eq(cadaver_ukrdc_modality_code) }
          end

          context "when the donor is non heart beating" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :non_heart_beating)
              generator.call
            end

            it { is_expected.to eq(nhb_ukrdc_modality_code) }
          end

          context "when the donor is non live_unrelated" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :live_unrelated)
              generator.call
            end

            it { is_expected.to eq(live_unrelated_ukrdc_modality_code) }
          end

          context "when the donor is a live_related and relationship is unset" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :live_related)
              generator.call
            end

            it { is_expected.to eq(live_related_other_modality_code) }
          end

          context "when the donor is a live_related sibling" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :live_related, relationship: :sibling)
              generator.call
            end

            it { is_expected.to eq(live_related_sibling_modality_code) }
          end

          context "when the donor is a live_related father" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :live_related, relationship: :father)
              generator.call
            end

            it { is_expected.to eq(live_related_father_modality_code) }
          end

          context "when the donor is a live_related mother" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :live_related, relationship: :mother)
              generator.call
            end

            it { is_expected.to eq(live_related_mother_modality_code) }
          end

          context "when the donor is a live_related child" do
            subject { UKRDC::Treatment.first.modality_code }

            before do
              create_operation(type: :live_related, relationship: :child)
              generator.call
            end

            it { is_expected.to eq(live_related_child_modality_code) }
          end
        end
      end

      def create_operation(
        type:,
        performed_on: modality.started_on,
        relationship: nil
      )
        create(
          :transplant_recipient_operation,
          patient: patient,
          performed_on: performed_on
        ).tap do |op|
          op.document.donor.type = type
          op.document.donor.relationship = relationship
          op.save!
        end
      end
    end
  end
end
