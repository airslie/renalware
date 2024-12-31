module Renalware
  module Accesses
    module LetterExtensions
      # rubocop:disable Layout/LineLength
      describe AccessComponent do
        let(:patient) { build_stubbed(:hd_patient) }
        let(:access_plan) { build_stubbed(:access_plan) }
        let(:access_profile) { nil }

        let(:component) { described_class.new(patient: patient) }

        let(:accesses_patient) {
          instance_double Accesses::Patient,
                          current_plan: access_plan,
                          current_profile: access_profile
        }

        let(:presented_access_profile) do
          instance_double Accesses::ProfilePresenter,
                          type: type,
                          side: side,
                          plan_type: plan_type,
                          plan_date: plan_date
        end

        let(:side) { "left" }
        let(:type) { "Tunnelled subclav" }
        let(:plan_type) { "Continue Plan" }
        let(:plan_date) { "2022-10-01 12:22" }

        describe "#call" do
          before do
            allow(Accesses).to receive(:cast_patient).with(patient).and_return(accesses_patient)
            allow(Accesses::ProfilePresenter).to receive(:new).with(access_profile).and_return(presented_access_profile)
          end

          context "when access profile is present" do
            let(:access_profile) {
              instance_double(Accesses::Profile)
            }

            it "renders" do
              expect(component.call).to eq \
                "<dl><dt>HD Access</dt> <dd>Tunnelled subclav left</dd><dd>Continue Plan 01-Oct-2022</dd></dl>"
            end
          end

          context "when access profile is not present" do
            it "doesn't render" do
              expect(component.render?).to be false
            end
          end

          context "when side is not present" do
            let(:side) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>HD Access</dt> <dd>Tunnelled subclav</dd><dd>Continue Plan 01-Oct-2022</dd></dl>"
            end
          end

          context "when type is not present" do
            let(:type) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>HD Access</dt> <dd>left</dd><dd>Continue Plan 01-Oct-2022</dd></dl>"
            end
          end

          context "when plan_type is not present" do
            let(:plan_type) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>HD Access</dt> <dd>Tunnelled subclav left</dd><dd>01-Oct-2022</dd></dl>"
            end
          end

          context "when plan_date is not present" do
            let(:plan_date) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>HD Access</dt> <dd>Tunnelled subclav left</dd><dd>Continue Plan</dd></dl>"
            end
          end
        end
      end
      # rubocop:enable Layout/LineLength
    end
  end
end
