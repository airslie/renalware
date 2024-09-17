# frozen_string_literal: true

module Renalware::Pathology::Charts
  describe PeriodMap do
    describe "[]" do
      {
        "10y" => "2010-07-05",
        "3y" => "2017-07-05",
        "1y" => "2019-07-05",
        "3m" => "2020-04-05",
        "1m" => "2020-06-05",
        "asasas" => "1920-07-05"
      }.each do |period, date|
        it period.to_s do
          travel_to "2020-07-05 12:00:00" do
            expect(described_class[period]).to eq(date)
          end
        end
      end
    end

    describe ".periods" do
      it "returns all periods as string, in order" do
        expect(described_class.periods).to eq(%w(1m 3m 1y 3y 10y))
      end
    end
  end
end
