# frozen_string_literal: true

module Renalware
  module Surveys
    describe Question do
      it_behaves_like "a Paranoid model"
      it :aggregate_failures do
        is_expected.to belong_to :survey
        is_expected.to have_many :responses
        is_expected.to validate_presence_of :code
        is_expected.to validate_presence_of :label
        is_expected.to validate_presence_of :position
      end

      describe "uniqueness scoped to survey" do
        subject { described_class.new(code: "x", survey: survey) }

        let(:survey) { Survey.create(name: "Survey1", code: "x") }

        it { is_expected.to validate_uniqueness_of(:code).scoped_to(:survey_id) }
      end

      describe "#admin_label" do
        it "uses label_abbrv if present" do
          expect(described_class.new(label: "x", label_abbrv: "y").admin_label).to eq("y")
        end

        it "uses label if label_abbrv missing" do
          expect(described_class.new(label: "x", label_abbrv: "").admin_label).to eq("x")
          expect(described_class.new(label: "x", label_abbrv: nil).admin_label).to eq("x")
        end
      end
    end
  end
end
