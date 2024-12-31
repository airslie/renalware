module Renalware
  module PD
    describe RegimeForModality do
      describe "#pd_regime_id" do
        subject(:resolved_regime_id) do
          described_class.find_by!(modality_id: modality.id).pd_regime_id
        end

        let(:user) { create(:user) }
        let(:patient) { create(:hd_patient) }
        let(:pd_modality_description) { create(:pd_modality_description) }
        let(:modality_started_on) { 1.week.ago }
        let(:modality) do
          create(
            :modality,
            description: pd_modality_description,
            patient: patient,
            started_on: modality_started_on
          )
        end

        def create_apd_regime(start_date:, end_date:)
          regime = build(:apd_regime, patient: patient, start_date: start_date, end_date: end_date)
          regime.bags << build(:pd_regime_bag, sunday: false)
          regime.save!
          regime
        end

        context "when an PD patient (a patient with the PD modality) has no PD regime" do
          it { is_expected.to be_nil }
        end

        context "when a PD patient has an PD regime created on the same day" do
          it "finds the regime" do
            regime = create_apd_regime(start_date: modality.started_on, end_date: nil)

            expect(resolved_regime_id).to eq(regime.id)
          end
        end

        context "when a PD patient has several regimes created on the same day" do
          it "resolved the last one created that day" do
            regimes = []
            travel_to modality_started_on do
              regimes << create_apd_regime(start_date: Time.zone.now, end_date: nil)
            end

            travel_to modality_started_on + 1.minute do
              result = ReviseRegime.new(regimes[0]).call(by: user, params: { add_hd: true })
              regimes << result.object
            end

            travel_to modality_started_on + 2.minutes do
              result = ReviseRegime.new(regimes[1]).call(by: user, params: { add_hd: false })
              regimes << result.object
            end

            expect(resolved_regime_id).to eq(regimes.last.id)
          end
        end

        context "when a PD patient an active PD regime already" do
          it "resolves it" do
            regime = travel_to modality_started_on - 1.year do
              create_apd_regime(start_date: Time.zone.now, end_date: nil)
            end

            expect(resolved_regime_id).to eq(regime.id)
          end
        end
      end
    end
  end
end
