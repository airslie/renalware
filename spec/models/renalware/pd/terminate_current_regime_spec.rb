module Renalware
  module PD
    describe TerminateCurrentRegime do
      subject(:service) { described_class.new(patient:) }

      let(:user) { create(:user) }

      describe "#call" do
        context "when the patient has a current regime" do
          let(:patient) { create(:pd_patient, :with_pd_modality) }
          let!(:regime) { create(:capd_regime, patient:, start_date: "2026-01-01", end_date: nil) }

          it "terminates the current regime and sets its end date" do
            service.call(by: user, terminated_on: Date.parse("2026-03-01"))

            expect(regime.reload).to be_terminated
            expect(regime.end_date).to eq(Date.parse("2026-03-01"))
            expect(regime.termination).to have_attributes(
              created_by: user,
              updated_by: user,
              terminated_on: Date.parse("2026-03-01")
            )
          end

          it "preserves an existing end date" do
            regime.update!(end_date: Date.parse("2026-02-15"))

            service.call(by: user, terminated_on: Date.parse("2026-03-01"))

            expect(regime.reload.end_date).to eq(Date.parse("2026-02-15"))
          end
        end

        context "when the patient does not have a current regime" do
          let(:patient) { create(:pd_patient, :with_pd_modality) }

          it "does nothing" do
            expect {
              service.call(by: user, terminated_on: Date.parse("2026-03-01"))
            }.not_to change(RegimeTermination, :count)
          end
        end
      end
    end
  end
end
