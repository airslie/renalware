module Renalware
  describe Medications::PrescriptionTermination do
    it_behaves_like "an Accountable model"
    it { is_expected.to belong_to(:prescription).touch(true) }

    describe "validations" do
      describe "terminated_on" do
        let(:prescription) { build(:prescription, prescribed_on: "2011-01-01") }

        context "when the date is after prescribed on" do
          let(:termination) do
            build(:prescription_termination,
                  terminated_on: "2012-01-01", prescription: prescription)
          end

          it { expect(termination).to be_valid }
        end

        context "when the date is before prescribed on" do
          let(:termination) do
            build(:prescription_termination,
                  terminated_on: "2010-01-10", prescription: prescription)
          end

          before { termination.valid? }

          it {
            expect(termination.errors[:terminated_on]&.first).to match(/after/)
          }
        end

        context "when Give On HD" do
          let(:prescription) do
            build(:prescription, prescribed_on: "2011-01-01", administer_on_hd: true)
          end
          let(:max_period) { 1.year }

          before do
            allow(Renalware.config)
              .to receive(:auto_terminate_hd_prescriptions_after_period).and_return(max_period)
          end

          context "when there is no restriction on hd prescription length ie (" \
                  "auto_terminate_hd_prescriptions_after_period = nil)" do
            let(:max_period) { nil }

            it "allows far future termination dates" do
              termination = build(
                :prescription_termination,
                terminated_on: prescription.prescribed_on + 20.years,
                prescription: prescription
              )

              expect(termination).to be_valid
            end
          end

          context "when terminated_on is more than the max configured period after " \
                  "prescribed_on plus one day" do
            let(:max_period) { 1.year }
            let(:termination) do
              build(
                :prescription_termination,
                terminated_on: prescription.prescribed_on + 2.years, # 2013-01-01
                prescription: prescription
              )
            end

            it do
              expect(termination).not_to be_valid
              expect(termination.errors.full_messages).to eq(
                ["Terminated on must be before #{prescription.prescribed_on + max_period + 1.day}"]
              )
            end
          end

          context "when terminated_on is less than the max configured period after prescribed_on" do
            let(:termination) do
              build(
                :prescription_termination,
                terminated_on: prescription.prescribed_on + 11.months,
                prescription: prescription
              )
            end

            it { expect(termination).to be_valid }
          end
        end
      end
    end
  end
end
