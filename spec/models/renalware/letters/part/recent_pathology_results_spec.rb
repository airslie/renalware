module Renalware::Letters
  describe Part::RecentPathologyResults do
    subject(:part) { described_class.new(letter: letter, event: event) }

    let(:user) { create(:user) }
    let(:patient) { create(:letter_patient, by: user) }
    let(:event) { nil }
    let(:letter) { Letter.new(patient: patient) }

    it { is_expected.to respond_to(:results) }

    describe "#results" do
      subject(:results) { part.results }

      context "when there is pathology_snapshot is nil" do
        let(:letter) { instance_double(Letter, patient: patient, pathology_snapshot: nil) }

        it { is_expected.to be_nil }
      end

      context "when there is pathology_snapshot is an empty hash" do
        let(:letter) { instance_double(Letter, patient: patient, pathology_snapshot: {}) }

        it { is_expected.to be_nil }
      end

      # The setup here is a little involved. We want to replicate a patient
      # with a full set of OBX results. These will have been added to the jsonb hash in
      # pathology_current_observation_sets by a pg triggeras new HL7 results come in, and then
      # when the letter is create, that hash is copied in the jsonb letter.pathology_snapshot,
      # so at that point pathology_current_observation_sets.values == letter.pathology_snapshot.
      # The order in the jsonb is unlikely to match the required order for display in the letter.
      context "when we have a pathology snapshot stored on the letter" do
        let(:letter) {
          instance_double(Letter, patient: patient, pathology_snapshot: pathology_snapshot)
        }
        # These are dates we will assign to various OBX results. Note that certain OBX results will
        # arrive together (the were part of the same request, e.g. HG PLT and WBC always
        # come back together if requested in the OBR Full Blood Count (FBC).
        # So in assigning the dates we need to realistic about that, otherwise the output string
        # could get mixed up.
        let(:obr_1_date) { "2016-12-12 00:01:01" }
        let(:obr_2_date) { "2017-12-12 00:12:01" }
        let(:obr_3_date) { "2017-11-11 00:01:01" }
        let(:obr_4_date) { "2017-11-11 00:23:59" }
        let(:obr_5_date) { "2017-10-11 00:23:59" }

        # Randomise the order of entries in the pathology_snapshot in order to
        # mimic how it might be stored. See comment above.
        # This is not the complete set of letter codes in
        # Letters::RelevantObservationDescription.codes, but enough to determine we are
        # outputting the result correctly
        let(:pathology_snapshot) do
          {
            NA: { result: 134, observed_at: obr_3_date },
            POT: { result: 6.0, observed_at: obr_3_date },
            PLT: { result: 329, observed_at: obr_1_date },
            WBC: { result: 15.32, observed_at: obr_1_date },
            ALB: { result: 41, observed_at: obr_5_date },
            HGB: { result: 122, observed_at: obr_1_date },
            CRE: { result: 782, observed_at: obr_3_date },
            EGFR: { result: 782, observed_at: obr_3_date },
            CCA: { result: 2.29, observed_at: obr_5_date },
            PHOS: { result: 2.52, observed_at: obr_5_date },
            URE: { result: 2.52, observed_at: obr_1_date },
            BIC: { result: 2.52, observed_at: obr_1_date },
            PTHI: { result: 2.52, observed_at: obr_1_date },
            BIL: { result: 2.52, observed_at: obr_2_date },
            AST: { result: 2.52, observed_at: obr_2_date },
            ALP: { result: 2.52, observed_at: obr_2_date },
            GGT: { result: 2.52, observed_at: obr_2_date },
            HBA: { result: 2.52, observed_at: obr_1_date },
            CHOL: { result: 2.52, observed_at: obr_1_date }
          }
        end

        # See comments in letters/part/recent_pathology_results.rb for an understanding here.
        it "returns a string of observations grouped by OBR date " \
           "and ordered correctly" do
          create_all_letter_observation_descriptions

          expect(results).to eq(
            "<span>12-Dec-2016</span>: HGB 122, WBC 15.32, PLT 329; " \
            "<span>12-Dec-2016</span>: URE 2.52; <span>11-Nov-2017</span>: CRE 782, (EGFR 782); " \
            "<span>11-Nov-2017</span>: NA 134, POT 6.0; <span>12-Dec-2016</span>: BIC 2.52; " \
            "<span>11-Oct-2017</span>: CCA 2.29, PHOS 2.52; " \
            "<span>12-Dec-2016</span>: PTHI 2.52; <span>11-Oct-2017</span>: ALB 41; " \
            "<span>12-Dec-2017</span>: BIL 2.52, AST 2.52, ALP 2.52, GGT 2.52; " \
            "<span>12-Dec-2016</span>: HBA 2.52; <span>12-Dec-2016</span>: CHOL 2.52;"
          )
        end
      end

      context "when we only have say Full Blood Count results (HGB PLT WBC)" do
        let(:date) { "2016-12-12 00:01:01" }
        let(:pathology_snapshot) do
          {
            PLT: { result: 329, observed_at: date },
            WBC: { result: 15.32, observed_at: date },
            HGB: { result: 122, observed_at: date }
          }
        end
        let(:letter) {
          instance_double(Letter, patient: patient, pathology_snapshot: pathology_snapshot)
        }

        it "displays those results and nothing for the others" do
          create_all_letter_observation_descriptions

          expect(results).to eq("<span>12-Dec-2016</span>: HGB 122, WBC 15.32, PLT 329;")
        end
      end

      context "when for some reason in Full Blood Count group PLT has a separate date" do
        let(:date1) { "2016-12-12 00:01:01" }
        let(:date2) { "2016-12-13 00:01:01" }
        let(:pathology_snapshot) do
          {
            PLT: { result: 329, observed_at: date2 },
            WBC: { result: 15.32, observed_at: date1 },
            HGB: { result: 122, observed_at: date1 }
          }
        end
        let(:letter) {
          instance_double(Letter, patient: patient, pathology_snapshot: pathology_snapshot)
        }

        it "displays those results and nothing for the others" do
          create_all_letter_observation_descriptions

          expect(results).to eq(
            "<span>12-Dec-2016</span>: HGB 122, WBC 15.32; <span>13-Dec-2016</span>: PLT 329;"
          )
        end
      end

      # rubocop:disable Layout/LineLength
      def create_all_letter_observation_descriptions
        create(:pathology_observation_description, code: "HGB", name: "HGB", letter_group: 1, letter_order: 1)
        create(:pathology_observation_description, code: "WBC", name: "WBC", letter_group: 1, letter_order: 2)
        create(:pathology_observation_description, code: "PLT", name: "PLT", letter_group: 1, letter_order: 3)
        create(:pathology_observation_description, code: "URE", name: "URE", letter_group: 2, letter_order: 1)
        create(:pathology_observation_description, code: "CRE", name: "CRE", letter_group: 3, letter_order: 1)
        create(:pathology_observation_description, code: "EGFR", name: "EGFR", letter_group: 3, letter_order: 2)
        create(:pathology_observation_description, code: "NA", name: "NA", letter_group: 4, letter_order: 1)
        create(:pathology_observation_description, code: "POT", name: "POT", letter_group: 4, letter_order: 2)
        create(:pathology_observation_description, code: "BIC", name: "BIC", letter_group: 5, letter_order: 1)
        create(:pathology_observation_description, code: "CCA", name: "CCA", letter_group: 6, letter_order: 1)
        create(:pathology_observation_description, code: "PHOS", name: "PHOS", letter_group: 6, letter_order: 2)
        create(:pathology_observation_description, code: "PTHI", name: "PTHI", letter_group: 7, letter_order: 1)
        create(:pathology_observation_description, code: "ALB", name: "ALB", letter_group: 8, letter_order: 1)
        create(:pathology_observation_description, code: "BIL", name: "BIL", letter_group: 9, letter_order: 1)
        create(:pathology_observation_description, code: "AST", name: "AST", letter_group: 9, letter_order: 2)
        create(:pathology_observation_description, code: "ALP", name: "ALP", letter_group: 9, letter_order: 3)
        create(:pathology_observation_description, code: "GGT", name: "GGT", letter_group: 9, letter_order: 4)
        create(:pathology_observation_description, code: "HBA", name: "HBA", letter_group: 10, letter_order: 1)
        create(:pathology_observation_description, code: "CHOL", name: "CHOL", letter_group: 11, letter_order: 1)
      end
      # rubocop:enable Layout/LineLength
    end
  end
end
