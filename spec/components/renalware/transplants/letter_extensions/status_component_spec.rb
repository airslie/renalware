# frozen_string_literal: true

module Renalware
  module Transplants
    module LetterExtensions
      # rubocop:disable Layout/LineLength
      describe StatusComponent do
        let(:patient) { build_stubbed(:hd_patient) }
        let(:component) { described_class.new(patient: patient) }

        let(:transplant_status) do
          build_stubbed(:transplant_registration_status,
                        description: build_stubbed(:transplant_registration_status_description,
                                                   name: "Not started"),
                        started_on: Date.parse("2022-10-10"))
        end

        let(:values) do
          {
            URR: {
              result: 123,
              observed_at: "2017-12-12 12:12:12"
            }
          }.deep_stringify_keys
        end

        let(:current_observation_set) do
          Pathology::CurrentObservationSet.new(values: values)
        end

        describe "#call" do
          before do
            allow(Transplants).to receive(:current_transplant_status_for_patient).with(patient).and_return(transplant_status)
            allow(patient).to receive(:current_observation_set).and_return(current_observation_set)
          end

          context "when all data is present" do
            it "renders" do
              expect(component.call).to eq \
                "<dl><dt>URR</dt><dd>123</dd><dd>12-Dec-2017</dd><dt>Transplant status</dt><dd>Not started</dd><dd>10-Oct-2022</dd></dl>"
            end
          end

          context "when transplant_status is not present" do
            let(:transplant_status) { nil }

            it "renders without it" do
              expect(component.call).to eq "<dl><dt>URR</dt><dd>123</dd><dd>12-Dec-2017</dd></dl>"
            end
          end

          context "when urr value is not present" do
            let(:values) { {} }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>Transplant status</dt><dd>Not started</dd><dd>10-Oct-2022</dd></dl>"
            end
          end

          context "when current_observation_set is not present" do
            let(:current_observation_set) { nil }

            it "renders without URR value" do
              expect(component.call).to eq \
                "<dl><dt>Transplant status</dt><dd>Not started</dd><dd>10-Oct-2022</dd></dl>"
            end
          end
        end
      end
      # rubocop:enable Layout/LineLength
    end
  end
end
