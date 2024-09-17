# frozen_string_literal: true

module Renalware
  module HD
    module Sessions
      describe AuditableSessionCollection do
        subject(:audit) { described_class.new(@sessions) }

        let(:patient) { build_stubbed(:hd_patient) }

        def stub_sessions(observations:, systolic_range:, diastolic_range:)
          systolic = *systolic_range
          diastolic = *diastolic_range
          # Coerce to Array in case there was a single value
          systolic = Array(systolic)
          diastolic = Array(diastolic)
          fail unless systolic.count == diastolic.count

          @sessions = []
          systolic.each_with_index do |systolic_value, count|
            bp = BloodPressure.new(systolic: systolic_value, diastolic: diastolic[count - 1])
            sesh = Session::Closed.new
            sesh.document[observations].blood_pressure = bp
            @sessions << sesh
          end
        end

        it { is_expected.to be_a(described_class) }

        # Most of the mean calculations use this strategy class
        # so we test all possible edge cases here.
        describe AuditableSessionCollection::MeanValueStrategy do
          subject(:strategy) { described_class }

          it "calculates the mean from a number of values" do
            sessions = [{ x: 1.1 }, { x: 1.2 }, { x: 1.3 }]
            selector = ->(session) { session[:x] }
            result = strategy.new(sessions: sessions, selector: selector).call
            expect(result).to eq(1.2)
          end

          it "returns the only value if there is just one" do
            sessions = [{ x: 1.99999 }]
            selector = ->(session) { session[:x] }
            result = strategy.new(sessions: sessions, selector: selector).call
            expect(result).to eq(2.0) # 1.9999 rounded up to 2.0
          end

          it "excludes nil values from the mean calculation" do
            sessions = [{ x: 1.1 }, { x: 1.2 }, { x: nil }, { x: 1.3 }]
            selector = ->(session) { session[:x] }
            result = strategy.new(sessions: sessions, selector: selector).call
            expect(result).to eq(1.2)
          end

          it "returns 0 if there are sessions" do
            selector = ->(session) { session[:x] }
            result = strategy.new(sessions: [], selector: selector).call
            expect(result).to eq(0)
          end

          it "returns 0 if there are only nil values" do
            sessions = [{ x: nil }, { x: nil }]
            selector = ->(session) { session[:x] }
            result = strategy.new(sessions: sessions, selector: selector).call
            expect(result).to eq(0)
          end
        end

        describe "Mean blood pressure" do
          it "ignores values strings that cannot be coerced into numbers" do
            bad_stringy_bp = BloodPressure.new(systolic: "asas", diastolic: "100,90")
            good_bp = BloodPressure.new(systolic: 100.1, diastolic: 100.2)
            @sessions = [
              Session::Closed.new.tap do |session|
                session.document.observations_before.blood_pressure = bad_stringy_bp
                session.document.observations_after.blood_pressure = good_bp
              end,
              Session::Closed.new.tap do |session|
                session.document.observations_before.blood_pressure = good_bp
                session.document.observations_after.blood_pressure = good_bp
              end
            ]

            expect(audit.pre_mean_systolic_blood_pressure).to eq(100)
            expect(audit.pre_mean_diastolic_blood_pressure).to eq(100)
            expect(audit.lowest_systolic_blood_pressure).to eq(good_bp)
            expect(audit.highest_systolic_blood_pressure).to eq(good_bp)
          end

          it "calculates pre mean blood pressures" do
            stub_sessions(observations: :observations_before,
                          systolic_range: (101..112),
                          diastolic_range: (81..92))

            expect(audit.pre_mean_systolic_blood_pressure).to eq(106.5)
            expect(audit.pre_mean_diastolic_blood_pressure).to eq(86.5)
          end

          it "calculates post mean blood pressures" do
            stub_sessions(observations: :observations_after,
                          systolic_range: (101..112),
                          diastolic_range: (81..92))

            expect(audit.post_mean_systolic_blood_pressure).to eq(106.5)
            expect(audit.post_mean_diastolic_blood_pressure).to eq(86.5)
          end
        end

        describe "Blood pressure extents" do
          let(:highest_systolic_bp) { BloodPressure.new(systolic: 200, diastolic: 100) }
          let(:lowest_systolic_bp)  { BloodPressure.new(systolic: 100, diastolic: 100) }
          let(:unmatched_bp)        { BloodPressure.new(systolic: 150, diastolic: 100) }

          before do
            @sessions = [
              Session::Closed.new.tap do |session|
                session.document.observations_before.blood_pressure = unmatched_bp
                session.document.observations_after.blood_pressure = lowest_systolic_bp
              end,
              Session::Closed.new.tap do |session|
                session.document.observations_before.blood_pressure = unmatched_bp
                session.document.observations_after.blood_pressure = unmatched_bp
              end,
              Session::Closed.new.tap do |session|
                session.document.observations_before.blood_pressure = highest_systolic_bp
                session.document.observations_after.blood_pressure = unmatched_bp
              end
            ]
          end

          describe "lowest_systolic_blood_pressure" do
            it "returns a BloodPressure object" do
              bp = audit.lowest_systolic_blood_pressure

              expect(bp).to be(lowest_systolic_bp)
            end
          end

          describe "highest_systolic_blood_pressure" do
            it "returns a BloodPressure object" do
              bp = audit.highest_systolic_blood_pressure

              expect(bp).to be(highest_systolic_bp)
            end
          end
        end

        describe "#mean_weight_loss" do
          it "calculates the mean weight loss across a number of sessions " \
             "from the first pre obs to the last post obs" do
            pre_obs_weights = [100, 100, 100]
            post_obs_weights = [97, 98, 99]

            @sessions = (0..2).map do |idx|
              Session::Closed.new.tap do |session|
                session.document.observations_before.weight = pre_obs_weights[idx]
                session.document.observations_after.weight = post_obs_weights[idx]
              end
            end

            # effective weight loss = [3, 2, 1] so the mean = 1.99999 rounded to 2 places
            expect(audit.mean_weight_loss).to eq(2.0)
          end

          it "excludes sessions where either pre or post is missing a value" do
            # Here the last 2 session weights shold be ignored.
            # In session 2 the pre weight has been declared as unmeasureable.
            # In session 3 the post weight has been declared as unmeasureable.
            pre_obs_weights = [100, 1000, nil]
            post_obs_weights = [99, nil, 10]

            @sessions = (0..2).map do |idx|
              Session::Closed.new.tap do |session|
                session.document.observations_before.weight = pre_obs_weights[idx]
                session.document.observations_after.weight = post_obs_weights[idx]
              end
            end

            # Only 1 session has a weight_loss - the others will have returned
            # nil for weight_loss as either pre or post was nil, and so they
            # are not included in the mean calculation.
            # So mean calc = just one valie (100-99 = 1)
            expect(audit.mean_weight_loss).to eq(1.0)
          end
        end

        describe "#mean_machine_ktv" do
          it "calculates the mean machine ktv over a series of sessions" do
            ktvs = [0.5, 1.5, 2.2]
            mean = 1.4
            @sessions = (0..2).map do |idx|
              Session::Closed.new.tap do |session|
                session.document.dialysis.machine_ktv = ktvs[idx]
              end
            end

            expect(audit.mean_machine_ktv).to eq(mean)
          end
        end

        describe "#mean_fluid_removal" do
          it "calculates the mean value of fluid removed" do
            @sessions = [1.2, 1.3, 1.4, 1.5].map do |fluid_removed|
              Session::Closed.new.tap do |session|
                session.document.dialysis.fluid_removed = fluid_removed
              end
            end

            expect(audit.mean_fluid_removal).to eq(1.35)
          end
        end

        describe "#mean_blood_flow aka pump speed" do
          it "calculates the mean value of dialysis flow rate" do
            @sessions = [200, 250, 300].map do |blood_flow| # a rate
              Session::Closed.new.tap do |session|
                session.document.dialysis.blood_flow = blood_flow
              end
            end

            expect(audit.mean_blood_flow).to eq(250)
          end
        end

        describe "#mean_litres_processed" do
          it "calculates the mean value of dialysis flow rate" do
            @sessions = [5.1, 10.2, 15.3].map do |litres_processed| # a rate
              Session::Closed.new.tap do |session|
                session.document.dialysis.litres_processed = litres_processed
              end
            end

            expect(audit.mean_litres_processed).to eq(10.2)
          end

          context "when a session.document.dialysis.litres_processed is not a valid float" do
            it "excludes that session from the mean value calculation" do
              good_session = Session::Closed.new
              good_session.document.dialysis.litres_processed = "15.1"

              bad_session = Session::Closed.new
              bad_session.document.dialysis.litres_processed = "23.1L"

              @sessions = [good_session, bad_session]

              expect(audit.mean_litres_processed).to eq(15.1)
            end
          end
        end

        describe "Missed HD time methods" do
          before do
            profile1 = build_stubbed(:hd_profile, patient: patient, prescribed_time: nil)
            profile2 = build_stubbed(:hd_profile, patient: patient, prescribed_time: 100)
            profile3 = build_stubbed(:hd_profile, patient: patient, prescribed_time: 200)

            sessions_with_no_profile = [
              Session::Closed.new(duration: 100, profile: nil)
            ] # expected shortfall across these sessions is  0 because there is no profile to
            # indicate what the prescribed time is

            sessions_using_profile1 = [
              Session::Closed.new(duration: 100, profile: profile1)
            ] # expected shortfall across these sessions is 0 because the profile does not specify
            # a prescribed time

            sessions_using_profile2 = [
              Session::Closed.new(duration: 90, profile: profile2),
              Session::Closed.new(duration: 101, profile: profile2)
            ] # expected shortfall across these sessions is -10 + 1 = 9

            sessions_using_profile3 = [
              Session::Closed.new(duration: 150, profile: profile3),
              Session::Closed.new(duration: 190, profile: profile3)
            ] # expected shortfall across these sessions is  -50 - 10 = -60

            # Profile | Prescribed time | Actual | Shortfall | % Shortfall
            # None    | 100 effectively | 100    | 0         | 0
            # 1       | 100 effectively | 100    | 0         | 0
            # 2       | 100             | 90     | -10       | -10
            # 2       | 100             | 101    | +1        | 1
            # 3       | 200             | 150    | -50       | -25
            # 3       | 200             | 190    | -10       | -5
            # =========================================================
            #         | 800            | 731     | -69       | -6.50 %

            @sessions = [
              sessions_with_no_profile,
              Session::DNA.new,
              sessions_using_profile1,
              Session::DNA.new,
              sessions_using_profile2,
              Session::DNA.new,
              sessions_using_profile3
            ].flatten
          end

          describe "#dialysis_minutes_shortfall" do
            it "returns the number of HD minutes missed across the sessions which is to say " \
               "total prescribed time - total actual time on HD" do
              # expected shortfall = 69 - see above
              expect(audit.dialysis_minutes_shortfall).to eq(69)
            end
          end

          describe "#dialysis_minutes_shortfall_percentage" do
            it "returns the percentage of HD minutes missed across all sessions" do
              expect(audit.dialysis_minutes_shortfall_percentage).to eq(6.5)
            end
          end

          describe "#number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct" do
            it "returns the number of sessions with >5% shortfall" do
              expect(audit.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct).to eq(2)
            end
          end
        end

        describe "#number_of_missed_sessions" do
          it "returns the number of dna sessions" do
            @sessions = [
              Session::Closed.new,
              Session::DNA.new,
              Session::Closed.new,
              Session::DNA.new
            ]
            expect(audit.number_of_missed_sessions).to eq(2)
          end
        end

        # Mean weight loss as percentage body weight last 12 sessions
        # Use dry weight for each HD session
        # (pre dialysis weight - post dialysis weight)/dry weight * 100
        describe "#mean_weight_loss_as_percentage_of_body_weight" do
          it do
            clinical_patient = Clinical.cast_patient(patient)
            dry_weight1 = build_stubbed(:dry_weight, patient: clinical_patient, weight: 100.0)
            dry_weight2 = build_stubbed(:dry_weight, patient: clinical_patient, weight: 200.0)

            session_with_no_dry_weight = Session::Closed.new(dry_weight: nil)
            session_with_no_dry_weight.document.observations_before.weight = 100.0
            session_with_no_dry_weight.document.observations_after.weight = 99.0

            session_with_dry_weight1 = Session::Closed.new(dry_weight: dry_weight1)
            session_with_dry_weight1.document.observations_before.weight = 100.0
            session_with_dry_weight1.document.observations_after.weight = 99.0

            session_with_dry_weight2 = Session::Closed.new(dry_weight: dry_weight2)
            session_with_dry_weight2.document.observations_before.weight = 200.0
            session_with_dry_weight2.document.observations_after.weight = 190.0

            session_with_dry_weight3 = Session::Closed.new(dry_weight: dry_weight1)
            session_with_dry_weight3.document.observations_before.weight = nil
            session_with_dry_weight3.document.observations_after.weight = 99.0

            @sessions = [
              session_with_no_dry_weight,
              session_with_dry_weight1,
              session_with_dry_weight2,
              session_with_dry_weight3
            ]

            # dryweight | weight loss | weight loss as % of body weight
            # nil       | 1           | 0
            # 100       | 1           | 1
            # 200       | 10          | 5
            # 100       | nil (unmeasured) | nil so excluded from mean
            # ===========================
            #                           % Mean = (0 + 1 + 5) / 2 = 3%

            expect(audit.mean_weight_loss_as_percentage_of_body_weight).to eq(3.0)
          end
        end

        describe "#mean_ufr" do
          it "returns fluid removed (ml) / HD time in hours / dry weight (kg) " \
             "in units of ml/hr/kg" do
            clinical_patient = Clinical.cast_patient(patient)
            dry_weight1 = build_stubbed(:dry_weight, patient: clinical_patient, weight: 100.0)
            dry_weight2 = build_stubbed(:dry_weight, patient: clinical_patient, weight: 120.0)

            session1 = Session::Closed.new(dry_weight: dry_weight1, duration: 225)
            session1.document.dialysis.fluid_removed = 1.0 # L

            session2 = Session::Closed.new(dry_weight: dry_weight2, duration: 225)
            session2.document.dialysis.fluid_removed = 2.0 # L

            @sessions = [session1, session2]

            # 225 mins = 3.75 hours
            # session 1 = 1000.0 ml / 3.75 hrs / 100.0 kg = 2.666
            # session 2 = 2000.0 ml / 3.75 hrs / 120.0 kg = 4.444
            # Mean = (2.666 + 4.444) / 2 = 3.555
            expect(audit.mean_ufr).to eq(3.56)
          end

          it "returns the mean UFR for a single session if only one supplied" do
            clinical_patient = Clinical.cast_patient(patient)
            dry_weight1 = build_stubbed(:dry_weight, patient: clinical_patient, weight: 100.0)
            session1 = Session::Closed.new(dry_weight: dry_weight1, duration: 225)
            session1.document.dialysis.fluid_removed = 1.0 # ml
            @sessions = [session1]
            # 225 mins = 3.75 hours
            # 1000.0 ml / 3.75 hrs / 100.0 kg = 2.67
            expect(audit.mean_ufr).to eq(2.67)
          end

          it "returns just one session UFR if another other session has a fluid_removed " \
             "which is not a number (i.e. 0) i.e. we do not include the 'bad' session when " \
             "generating the mean value" do
            clinical_patient = Clinical.cast_patient(patient)
            dry_weight1 = build_stubbed(:dry_weight, patient: clinical_patient, weight: 100.0)

            session1 = Session::Closed.new(dry_weight: dry_weight1, duration: 225)
            session1.document.dialysis.fluid_removed = 10.5

            session2 = Session::Closed.new(dry_weight: dry_weight1, duration: 225)
            session2.document.dialysis.fluid_removed = "not a number"

            @sessions = [session1, session2]
            # session2 excluded as fluid_removed effectively = 0
            # Hence:
            # 225 mins = 3.75 hours
            # 10.5 l / 3.75 hrs / 100.0 kg = 0.03
            expect(audit.mean_ufr).to eq(28.0)
          end
        end
      end
    end
  end
end
