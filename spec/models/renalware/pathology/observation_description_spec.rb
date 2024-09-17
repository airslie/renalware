# frozen_string_literal: true

module Renalware
  describe Pathology::ObservationDescription do
    it :aggregate_failures do
      is_expected.to belong_to(:measurement_unit)
      is_expected.to have_db_index(:code).unique(true)
      is_expected.to have_many(:obx_mappings)
      is_expected.to have_many(:code_group_memberships)
      is_expected.to have_many(:code_groups).through(:code_group_memberships)
      is_expected.to validate_numericality_of(:lower_threshold)
      is_expected.to validate_numericality_of(:upper_threshold)
      # Chartable 'interface'
      is_expected.to respond_to(:chart_series_json)
      is_expected.to respond_to(:axis_label)
      is_expected.to respond_to(:axis_type)
      is_expected.to respond_to(:title)
    end

    describe "#rr_type enum" do
      it "defaults to 0 (simple)" do
        expect(described_class.new.rr_type).to eq("rr_type_simple")
      end
    end

    describe "#rr_coding_standard enum" do
      it "defaults to 0 (ukrr)" do
        expect(described_class.new.rr_coding_standard).to eq("ukrr")
      end
    end

    describe "#lower_threshold validation" do
      let(:message) { "Lower threshold must be less than the upper threshold" }

      [
        [10, 9, false],
        [9.8, 9.7, false],
        [10, 10, false],
        [10, 11, true],
        [10, nil, true],
        [nil, 11, true]
      ].each do |rules|
        lower, upper, expect_valid = rules

        context "when lower_threshold is #{lower} and upper_threshold is #{upper}" do
          it "valid is #{expect_valid}" do
            desc = described_class.new(lower_threshold: lower, upper_threshold: upper)

            desc.valid?

            if expect_valid
              expect(desc.errors).not_to contain_exactly(message)
            else
              expect(desc.errors).to contain_exactly(message)
            end
          end
        end
      end
    end
  end
end
