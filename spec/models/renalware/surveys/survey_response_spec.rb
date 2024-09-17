# frozen_string_literal: true

module Renalware
  module Surveys
    describe Response do
      it :aggregate_failures do
        is_expected.to belong_to :question
        is_expected.to validate_presence_of(:patient_id)
        is_expected.to validate_presence_of(:answered_on)
        is_expected.to validate_presence_of(:question)
        is_expected.to have_db_index([:answered_on, :patient_id, :question_id])
      end

      describe "validation" do
        subject(:response) do
          described_class.new(
            question: question,
            value: value,
            answered_on: 1.day.ago,
            patient_id: 1
          )
        end

        let(:question) do
          Question.new(
            code: "Q1",
            validation_regex: validation_regex
          )
        end

        context "when the question has no validation_regex" do
          let(:validation_regex) { "" }
          let(:value) { 123 }

          it { is_expected.to be_valid }
        end

        context "when the question has a validation_regex" do
          context "when the value is within range" do
            let(:validation_regex) { "[1-5]" }
            let(:value) { 1 }

            it { is_expected.to be_valid }
          end

          context "when the value is out of range" do
            let(:validation_regex) { "^[1-5]$" }
            let(:value) { 10 }

            it { is_expected.not_to be_valid }

            it "has a useful error message" do
              response.valid?
              expect(response.errors[:value]).to include(
                "(10) must comply to regular expression /#{validation_regex}/"
              )
            end
          end
        end
      end
    end
  end
end
