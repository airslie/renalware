# frozen_string_literal: true

module Renalware
  describe Research::StudyEvent do
    describe "#document" do
      subject { described_class::Document.new }

      it :aggregate_failures do
        is_expected.to have_attributes(
          number1: nil,
          number2: nil,
          number3: nil,
          number4: nil,
          number5: nil,
          text1: nil,
          text2: nil,
          text3: nil,
          text4: nil,
          text5: nil,
          date1: nil,
          date2: nil,
          date3: nil,
          date4: nil,
          date5: nil
        )
        is_expected.to validate_numericality_of(:number1)
      end
    end

    describe "class method .subtypes?" do
      it "is true" do
        expect(described_class.subtypes?).to be(true)
      end
    end
  end
end
