module Renalware
  module Dietetics
    describe ClinicVisit do
      it { is_expected.to respond_to(:document) }

      describe "#set_weight_change" do
        let(:weight) { 55 }
        let(:previous_weight) { 40 }

        let(:instance) {
          described_class.new(
            weight: weight,
            document: {
              previous_weight: previous_weight
            }
          )
        }

        context "with no weight" do
          let(:weight) { nil }

          it do
            instance.set_weight_change
            expect(instance.document.weight_change).to be_nil
          end
        end

        context "with no previous_weight" do
          let(:previous_weight) { nil }

          it do
            instance.set_weight_change
            expect(instance.document.weight_change).to be_nil
          end
        end

        context "when weight and previous weight are present" do
          it "assigns weight change" do
            instance.set_weight_change
            expect(instance.document.weight_change).to eq(37.5)
          end
        end
      end

      describe "#set_next_review_on" do
        let(:next_review_in) { "three_months" }

        let(:instance) {
          described_class.new(
            document: {
              next_review_in: next_review_in
            }
          )
        }

        context "with no next_review_in" do
          let(:next_review_in) { nil }

          it do
            instance.set_next_review_on
            expect(instance.document.next_review_on).to be_nil
          end
        end

        context "with next_review_in 3 months" do
          it "assigns next_review_on" do
            instance.set_next_review_on
            expect(instance.document.next_review_on).to eq Time.zone.today + 3.months
          end
        end

        context "with next_review_in 6 months" do
          let(:next_review_in) { "six_months" }

          it "assigns next_review_on" do
            instance.set_next_review_on
            expect(instance.document.next_review_on).to eq Time.zone.today + 6.months
          end
        end

        context "with next_review_in 12 months" do
          let(:next_review_in) { "twelve_months" }

          it "assigns next_review_on" do
            instance.set_next_review_on
            expect(instance.document.next_review_on).to eq Time.zone.today + 12.months
          end
        end
      end

      describe ClinicVisit::Document do
        it :aggregate_failures do
          is_expected.to respond_to(:assessment_type)
          is_expected.to respond_to(:visit_type)
          is_expected.to respond_to(:attendance)
          is_expected.to respond_to(:weight_notes)
          is_expected.to respond_to(:previous_weight_date)
          is_expected.to respond_to(:weight_change)

          is_expected.to validate_numericality_of(:previous_weight)
            .is_greater_than_or_equal_to(15)
            .is_less_than_or_equal_to(300)

          is_expected.to validate_numericality_of(:ideal_body_weight)
            .is_greater_than_or_equal_to(15)
            .is_less_than_or_equal_to(300)

          is_expected.to validate_numericality_of(:waist_circumference)
            .is_greater_than_or_equal_to(30)
            .is_less_than_or_equal_to(300)

          is_expected.to validate_numericality_of(:dietary_protein_intake)
            .is_greater_than_or_equal_to(5)
            .is_less_than_or_equal_to(250)

          is_expected.to validate_numericality_of(:dietary_protein_requirement)
            .is_greater_than_or_equal_to(5)
            .is_less_than_or_equal_to(250)

          is_expected.to validate_numericality_of(:high_biological_value)
            .is_greater_than_or_equal_to(0)
            .is_less_than_or_equal_to(100)

          is_expected.to validate_numericality_of(:energy_requirement)
            .is_greater_than_or_equal_to(500)
            .is_less_than_or_equal_to(4000)

          is_expected.to validate_numericality_of(:energy_intake)
            .is_greater_than_or_equal_to(500)
            .is_less_than_or_equal_to(4000)

          is_expected.to validate_numericality_of(:handgrip_left)
            .is_greater_than_or_equal_to(1)
            .is_less_than_or_equal_to(150)

          is_expected.to validate_numericality_of(:handgrip_right)
            .is_greater_than_or_equal_to(1)
            .is_less_than_or_equal_to(150)

          is_expected.to respond_to(:sga_assessment)
          is_expected.to respond_to(:plan)
          is_expected.to respond_to(:intervention_a)
          is_expected.to respond_to(:intervention_b)
          is_expected.to respond_to(:intervention_c)

          is_expected.to respond_to(:time_for_consultation)
          is_expected.to respond_to(:time_for_documentation)
          is_expected.to respond_to(:next_review_in)
          is_expected.to respond_to(:next_review_on)
        end
      end
    end
  end
end
