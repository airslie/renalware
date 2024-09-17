# frozen_string_literal: true

module Renalware
  describe Pathology::AdjustObservation do
    subject(:service) {
      described_class.new(
        observation_request: observation_request,
        code: obs_desc.code,
        policy: ->(patient, _observation) { patient.ethnicity&.cfh_name&.casecmp?("Time Lord") }
      )
    }

    let(:multiplier) { 1.21 }
    let(:target_ethnicity) { "Time Lord" }
    let(:obs_desc) { create(:pathology_observation_description, code: "MyEGFR") }
    let(:patient) { create(:pathology_patient, ethnicity: nil) }
    let(:observation_request) { create(:pathology_observation_request, patient: patient) }

    def create_original_observation
      create(
        :pathology_observation,
        request: observation_request,
        description: obs_desc,
        result: "1.11"
      )
    end

    class TestAdjustedEgfrObservation < SimpleDelegator
      def adjust
        return self if adjusted?

        self.comment = adjusted_comment
        self.result =  (result.to_f * 1.21).round(2)
        self
      end

      def adjusted?
        comment =~ /adjusted/i
      end

      def adjusted_comment
        "adjusted eGFR original: #{result}"
      end
    end

    context "when the patient has the Time Lord ethnicity" do
      before { patient.ethnicity = create(:ethnicity, cfh_name: "Time Lord") }

      context "when a new observation request arrives that contains an EGFR" do
        it "yields asking for an adjustment" do
          create_original_observation

          expect { |blk| service.call(&blk) }.to yield_control
        end

        it "yields and lets us adjust the observation" do
          egfr_obs = create_original_observation

          service.call do |observation_qualifying_for_adjustment|
            TestAdjustedEgfrObservation
              .new(observation_qualifying_for_adjustment)
              .adjust
              .save!
          end

          observations = observation_request.reload.observations
          expect(observations.count).to eq(1) # still 1

          expect(observations.first).to have_attributes(
            observed_at: egfr_obs.observed_at,
            result: "1.34", # 1.11 * multiplier, rounded to 2 DP
            comment: "adjusted eGFR original: 1.11"
          )
        end
      end

      context "when the a new observation request arrives that does not contains an EGFR" do
        it "does not yield asking for an adjustment" do
          expect { |blk| service.call(&blk) }.not_to yield_control
        end
      end
    end

    context "when the patient has the Vulcan ethnicity" do
      before { patient.ethnicity = create(:ethnicity, cfh_name: "Vulcan") }

      context "when a new observation request arrives that contains an EGFR" do
        it "does not yield asking for an adjustment" do
          expect { |blk| service.call(&blk) }.not_to yield_control
        end
      end
    end
  end
end
