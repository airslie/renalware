module Renalware
  RSpec.describe Pathology::Handlers::Immunosuppressive do
    let(:values) do
      {
        "LTAX" => {
          "result" => 123,
          "observed_at" => "2019-12-12 12:12:12"
        },
        "CYA" => {
          "result" => 124,
          "observed_at" => "2018-12-12 13:12:12"
        }
      }.with_indifferent_access
    end

    subject(:handler) { described_class.new(values) }

    describe "#level" do
      it "returns the latest level" do
        expect(handler.level).to eq(123)
      end

      context "when only one result" do
        let(:values) do
          {
            "LTAX" => {},
            "CYA" => { "result" => 124, "observed_at" => "2017-12-12" }
          }.with_indifferent_access
        end

        it "returns the latest level" do
          expect(handler.level).to eq(124)
        end
      end
    end

    describe "#date" do
      it "returns the latest date" do
        expect(handler.date).to eq(Date.parse("2019-12-12"))
      end
    end

    describe "#type" do
      before { create(:pathology_code_group, :immunosuppressive) }

      it "returns the correct type" do
        expect(handler.type).to eq("Tacrolimus Level")
      end
    end
  end
end
