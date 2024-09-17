# frozen_string_literal: true

module Renalware
  module HD
    module LetterExtensions
      describe ScheduleComponent do
        let(:patient) { instance_double Renalware::Patient }
        let(:component) { described_class.new(patient: patient) }
        let(:hd_profile) { instance_double HD::Profile }
        let(:hd_patient) { instance_double(HD::Patient, hd_profile: hd_profile) }
        let(:current_schedule) { "SCHEDULE" }

        before do
          allow(HD).to receive(:cast_patient).with(patient).and_return(hd_patient)
        end

        describe "#call" do
          let(:presented_profile) {
            instance_double HD::ProfilePresenter,
                            hospital_unit_unit_code: unit_code,
                            current_schedule: current_schedule,
                            formatted_prescribed_time: prescribed_time
          }

          let(:prescribed_time) { "3:30" }
          let(:unit_code) { "MyUnit" }

          before do
            allow(HD::ProfilePresenter)
              .to receive(:new).with(hd_profile).and_return(presented_profile)
          end

          context "when hd profile is present" do
            it "renders" do
              expect(component.call).to eq \
                "<dl><dt>HD Unit</dt><dd>MyUnit</dd><dt>Schedule</dt><dd>SCHEDULE</dd>" \
                "<dt>Time</dt><dd>3:30</dd></dl>"
            end
          end

          context "when hd profile is not present" do
            let(:hd_profile) { nil }

            it "doesn't render" do
              expect(component.render?).to be false
            end
          end

          context "when current_schedule is not present" do
            let(:current_schedule) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>HD Unit</dt><dd>MyUnit</dd><dt>Time</dt><dd>3:30</dd></dl>"
            end
          end

          context "when prescribed_time is not present" do
            let(:prescribed_time) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>HD Unit</dt><dd>MyUnit</dd><dt>Schedule</dt><dd>SCHEDULE</dd></dl>"
            end
          end

          context "when unit_code is not present" do
            let(:unit_code) { nil }

            it "renders without it" do
              expect(component.call).to eq \
                "<dl><dt>Schedule</dt><dd>SCHEDULE</dd><dt>Time</dt><dd>3:30</dd></dl>"
            end
          end
        end
      end
    end
  end
end
