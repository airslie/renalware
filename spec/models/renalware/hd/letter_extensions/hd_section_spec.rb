require "rails_helper"
require "renalware/hd/letter_extensions/hd_section"

module Renalware
  module HD
    module LetterExtensions
      describe HDScheduleComponent do
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
            allow(HD::ProfilePresenter).to receive(:new).with(hd_profile).and_return(presented_profile)
          end

          context "when hd profile is present" do
            it "renders" do
              expect(component.call).to eq "HD Unit: <b>MyUnit</b>; Schedule: <b>SCHEDULE</b>; Time: <b>3:30</b>"
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
              expect(component.call).to eq "HD Unit: <b>MyUnit</b>; Time: <b>3:30</b>"
            end
          end

          context "when prescribed_time is not present" do
            let(:prescribed_time) { nil }

            it "renders without it" do
              expect(component.call).to eq "HD Unit: <b>MyUnit</b>; Schedule: <b>SCHEDULE</b>"
            end
          end

          context "when unit_code is not present" do
            let(:unit_code) { nil }

            it "renders without it" do
              expect(component.call).to eq "Schedule: <b>SCHEDULE</b>; Time: <b>3:30</b>"
            end
          end
        end
      end

      describe HDAccessComponent do
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
              expect(component.call).to eq "HD Access: <b>Tunnelled subclav</b> <b>left</b>; <b>Continue Plan</b> <b>01-Oct-2022</b>"
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
              expect(component.call).to eq "HD Access: <b>Tunnelled subclav</b>; <b>Continue Plan</b> <b>01-Oct-2022</b>"
            end
          end

          context "when type is not present" do
            let(:type) { nil }

            it "renders without it" do
              expect(component.call).to eq "HD Access: <b>left</b>; <b>Continue Plan</b> <b>01-Oct-2022</b>"
            end
          end

          context "when plan_type is not present" do
            let(:plan_type) { nil }

            it "renders without it" do
              expect(component.call).to eq "HD Access: <b>Tunnelled subclav</b> <b>left</b>; <b>01-Oct-2022</b>"
            end
          end

          context "when plan_date is not present" do
            let(:plan_date) { nil }

            it "renders without it" do
              expect(component.call).to eq "HD Access: <b>Tunnelled subclav</b> <b>left</b>; <b>Continue Plan</b>"
            end
          end
        end
      end

      describe PatientObservationsComponent do
        let(:patient) { build_stubbed(:patient) }
        let(:statistics) do
          build_stubbed :hd_patient_statistics,
                        pre_mean_systolic_blood_pressure: pre_mean_systolic_blood_pressure,
                        pre_mean_diastolic_blood_pressure: pre_mean_diastolic_blood_pressure,
                        post_mean_systolic_blood_pressure: post_mean_systolic_blood_pressure,
                        post_mean_diastolic_blood_pressure: post_mean_diastolic_blood_pressure
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
            allow(HD).to receive(:cast_patient).with(patient).and_return(hd_patient)
            allow(Clinical).to receive(:cast_patient).with(patient).and_return(clinical_patient)
            allow(Clinics::CurrentObservations).to receive(:new).with(patient).and_return(current_observation)
          end

          context "when all data is present" do
            it "renders" do
              expect(component.call).to eq "Mean pre HD BP: <b>13</b> / <b>9</b>; Mean post HD BP: <b>80</b> / <b>6</b>; Dry Weight: <b>72.6</b>; BMI: <b>24.5</b>"
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
              expect(component.call).to eq "Mean pre HD BP: <b>13</b> / <b>9</b>; Mean post HD BP: <b>80</b> / <b>6</b>"
            end
          end

          context "when height is not present" do
            let(:height) { nil }

            it "renders without it" do
              expect(component.call).to eq "Mean pre HD BP: <b>13</b> / <b>9</b>; Mean post HD BP: <b>80</b> / <b>6</b>; Dry Weight: <b>72.6</b>"
            end
          end

          context "when pre_mean_systolic_blood_pressure is not present" do
            let(:pre_mean_systolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq "Mean post HD BP: <b>80</b> / <b>6</b>; Dry Weight: <b>72.6</b>; BMI: <b>24.5</b>"
            end
          end

          context "when pre_mean_diastolic_blood_pressure is not present" do
            let(:pre_mean_diastolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq "Mean post HD BP: <b>80</b> / <b>6</b>; Dry Weight: <b>72.6</b>; BMI: <b>24.5</b>"
            end
          end

          context "when post_mean_systolic_blood_pressure is not present" do
            let(:post_mean_systolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq "Mean pre HD BP: <b>13</b> / <b>9</b>; Dry Weight: <b>72.6</b>; BMI: <b>24.5</b>"
            end
          end

          context "when post_mean_diastolic_blood_pressure is not present" do
            let(:post_mean_diastolic_blood_pressure) { nil }

            it "renders without it" do
              expect(component.call).to eq "Mean pre HD BP: <b>13</b> / <b>9</b>; Dry Weight: <b>72.6</b>; BMI: <b>24.5</b>"
            end
          end
        end
      end

      describe URRAndTransplantStatusComponent do
        let(:patient) { build_stubbed(:hd_patient) }
        let(:component) { described_class.new(patient: patient) }

        let(:transplant_status) do
          build_stubbed :transplant_registration_status,
                        description: build_stubbed(:transplant_registration_status_description,
                                                   name: "Not started"),
                        started_on: Date.parse("2022-10-10")
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
              expect(component.call).to eq "Mean URR: <b>123</b> <b>12-Dec-2017</b>; Transplant status: <b>Not started</b> <b>10-Oct-2022</b>"
            end
          end

          context "when transplant_status is not present" do
            let(:transplant_status) { nil }

            it "renders without it" do
              expect(component.call).to eq "Mean URR: <b>123</b> <b>12-Dec-2017</b>"
            end
          end

          context "when urr value is not present" do
            let(:values) { {} }

            it "renders without it" do
              expect(component.call).to eq "Transplant status: <b>Not started</b> <b>10-Oct-2022</b>"
            end
          end

          context "when current_observation_set is not present" do
            let(:current_observation_set) { nil }

            it "renders without URR value" do
              expect(component.call).to eq "Transplant status: <b>Not started</b> <b>10-Oct-2022</b>"
            end
          end
        end
      end
    end
  end
end
