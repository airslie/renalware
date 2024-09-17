# frozen_string_literal: true

module Renalware
  module Pathology
    describe ObservationsDiff do
      let(:patient) { build_stubbed(:patient) }

      describe "ctor" do
        it "accepts all args" do
          described_class.new(
            patient: patient,
            observation_set_a: {},
            observation_set_b: {},
            descriptions: []
          )
        end
      end

      describe ".to_h" do
        # rubocop:disable RSpec/MultipleExpectations
        it "returns a hash of differences" do
          hgb_old = { result: 2.1, observed_at: "2017-12-12 00:01:01" }
          hgb_new = { result: 1.0, observed_at: "2018-12-12 00:01:01" }
          pthi_new = { result: 9, observed_at: "2017-12-12 00:01:01" }
          cre_old = { result: 1.1, observed_at: "2017-12-12 00:01:01" }
          cre_new = { result: 1.1, observed_at: "2017-12-11 00:01:01" } # no change!
          obj = described_class.new(
            patient: patient,
            observation_set_a: { HGB: hgb_old, CRE: cre_old },
            observation_set_b: { HGB: hgb_new, PTHI: pthi_new, CRE: cre_new },
            descriptions: %w(HGB CRE PTHI).map { |code| OpenStruct.new(code: code) } # mock ob descs
          )

          diff_hash = obj.to_h

          # The diff is hash keyed by OBX code each containing a 3 d array of results eg
          # {
          #   HGB: [
          #    set a obs for this OBX, if exists in set a
          #    set b obs for this OBX, if exists and date is >= set a one, and result is different,
          #    numeric change in result (b.result - a.result) if a and b present above
          #   ]
          # }
          expect(diff_hash.keys).to eq(%i(HGB CRE PTHI))

          expect(diff_hash[:HGB][0].result).to eq(hgb_old[:result])
          expect(diff_hash[:HGB][0].observed_at).to eq(hgb_old[:observed_at])
          expect(diff_hash[:HGB][1].result).to eq(hgb_new[:result])
          expect(diff_hash[:HGB][1].observed_at).to eq(hgb_new[:observed_at])
          expect(diff_hash[:HGB][2]).to eq(-1.1) # 2.1 - 1.0 (new - old)

          expect(diff_hash[:PTHI][0]).to be_nil
          expect(diff_hash[:PTHI][1].result).to eq(9)
          expect(diff_hash[:PTHI][1].observed_at).to eq("2017-12-12 00:01:01")
          expect(diff_hash[:PTHI][2]).to eq(9)

          expect(diff_hash[:CRE][0].result).to eq(cre_old[:result])
          expect(diff_hash[:CRE][0].observed_at).to eq(cre_old[:observed_at])
          expect(diff_hash[:CRE][1]).to be_nil # no change so no new observation here
          expect(diff_hash[:CRE][2]).to be_nil # no change so no difference value here
        end
        # rubocop:enable RSpec/MultipleExpectations
      end

      describe "#to_html" do
        it "renders html" do
          diff = described_class.new(
            patient: patient,
            observation_set_a: { HGB: { result: 2.1, observed_at: "2017-12-12 00:01:01" } },
            observation_set_b: { HGB: { result: 1.0, observed_at: "2017-12-13 00:01:01" } },
            descriptions: %w(HGB).map { |code| OpenStruct.new(code: code) } # mock obs descs
          )
          html = diff.to_html
          expect(html).not_to be_blank
          expect(html).to match(/<table/)
        end
      end
    end
  end
end
