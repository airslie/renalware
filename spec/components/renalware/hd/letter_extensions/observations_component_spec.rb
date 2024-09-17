# frozen_string_literal: true

module Renalware
  module HD
    # rubocop:disable Layout/LineLength
    module LetterExtensions
      describe ObservationsComponent do
        let(:patient) { build_stubbed(:patient) }
        let(:statistics) do
          build_stubbed(:hd_patient_statistics,
                        pre_mean_systolic_blood_pressure: pre_mean_systolic_blood_pressure,
                        pre_mean_diastolic_blood_pressure: pre_mean_diastolic_blood_pressure,
                        post_mean_systolic_blood_pressure: post_mean_systolic_blood_pressure,
                        post_mean_diastolic_blood_pressure: post_mean_diastolic_blood_pressure)
        end
        let(:dry_weight) {
          build_stubbed(:dry_weight, patient: build_stubbed(:clinical_patient), weight: 72.6)
        }

        let(:pre_mean_systolic_blood_pressure) { 12.71 }
        let(:pre_mean_diastolic_blood_pressure) { 8.9 }
        let(:post_mean_systolic_blood_pressure) { 80.22 }
        let(:post_mean_diastolic_blood_pressure) { 6.2 }

        let(:component) { described_class.new(patient: patient) }

        let(:hd_patient) {
          instance_double HD::Patient,
                          rolling_patient_statistics: statistics
        }

        let(:clinical_patient) {
          instance_double Clinical::Patient,
                          latest_dry_weight: dry_weight
        }

        let(:current_observation) do
          instance_double Clinics::CurrentObservations,
                          height: Clinics::CurrentObservations::Observation.new(nil, height)
        end

        let(:height) { 1.72 }

        describe "#call" do
          before do
            allow(HD)
              .to receive(:cast_patient).with(patient).and_return(hd_patient)
            allow(Clinical)
              .to receive(:cast_patient).with(patient).and_return(clinical_patient)
            allow(Clinics::CurrentObservations)
              .to receive(:new).with(patient).and_return(current_observation)
          end

          context "when all data is present" do
            it "renders" do
              expect(component.call).to eq \
                "<dl><dt>Mean pre HD BP</dt><dd>13 / 9</dd><dt>Mean post HD BP</dt><dd>80 / 6</dd><dt>Dry Weight</dt><dd>72.6</dd><dt>BMI</dt><dd>24.5</dd></dl>"
            end
          end

          context "when patient statistics is not present" do
            let(:statistics) { nil }

            it "doesn't render" do
              expect(component.render?).to be false
            end
          end

          context "when dry weight is not present" do
            let(:dry_weight) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>Mean pre HD BP</dt><dd>13 / 9</dd><dt>Mean post HD BP</dt><dd>80 / 6</dd></dl>"
            end
          end

          context "when height is not present" do
            let(:height) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>Mean pre HD BP</dt><dd>13 / 9</dd><dt>Mean post HD BP</dt><dd>80 / 6</dd><dt>Dry Weight</dt><dd>72.6</dd></dl>"
            end
          end

          context "when pre_mean_systolic_blood_pressure is not present" do
            let(:pre_mean_systolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>Mean post HD BP</dt><dd>80 / 6</dd><dt>Dry Weight</dt><dd>72.6</dd><dt>BMI</dt><dd>24.5</dd></dl>"
            end
          end

          context "when pre_mean_diastolic_blood_pressure is not present" do
            let(:pre_mean_diastolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>Mean post HD BP</dt><dd>80 / 6</dd><dt>Dry Weight</dt><dd>72.6</dd><dt>BMI</dt><dd>24.5</dd></dl>"
            end
          end

          context "when post_mean_systolic_blood_pressure is not present" do
            let(:post_mean_systolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>Mean pre HD BP</dt><dd>13 / 9</dd><dt>Dry Weight</dt><dd>72.6</dd><dt>BMI</dt><dd>24.5</dd></dl>"
            end
          end

          context "when post_mean_diastolic_blood_pressure is not present" do
            let(:post_mean_diastolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq "<dl><dt>Mean pre HD BP</dt><dd>13 / 9</dd><dt>Dry Weight</dt><dd>72.6</dd><dt>BMI</dt><dd>24.5</dd></dl>"
            end
          end
        end
      end
    end
    # rubocop:enable Layout/LineLength
  end
end
