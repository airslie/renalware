module Renalware
  describe Pathology::Observation do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:description)
      # is_expected.to validate_presence_of(:result)
      is_expected.to validate_presence_of(:observed_at)
      is_expected.to belong_to(:request).touch(true)
    end

    describe "SQL trigger to derive nresult from result" do
      let(:description) { create(:pathology_observation_description) }
      let(:request) { create(:pathology_observation_request, patient: create(:pathology_patient)) }

      let(:expectations) do
        [
          ["", nil],
          ["*", nil],
          ["**", nil],
          ["+", nil],
          ["++", nil],
          ["+/-", nil],
          ["?", nil],
          ["<1", nil],
          ["0.1 0.2", nil],
          ["01/02/2020", nil],
          ["Test cancelled", nil],
          ["#Test cancelled", nil],
          ["1mg", nil],
          ["1 mg", nil],
          ["test 123", nil],
          ["1.1.1", nil],
          ["10%", nil],
          [".29%", nil],
          ["-0.1", -0.1],
          ["1001", 1001],
          ["  1001  ", 1001],
          [".1001", 0.1001],
          ["123", 123.0],
          ["123.4", 123.4],
          ["100000.899", 100000.899]
        ]
      end

      def create_observation(result:)
        observation = described_class.new(
          description: description,
          request: request,
          result: result,
          observed_at: Time.current
        )
        observation.save!(validate: false)
        observation
      end

      context "when inserting a new observation" do
        it "coerces result column into float nresult column correctly" do
          expectations.each do |arr|
            result, nresult = arr

            observation = create_observation(result: result)

            expect(observation.reload.nresult).to eq(nresult)
          end
        end
      end

      context "when updating an existing observation" do
        it "coerces result column into float nresult column correctly" do
          expectations.each do |arr|
            result, nresult = arr
            observation = create_observation(result: "xyz")

            observation.result = result
            observation.save!(validate: false)

            expect(observation.reload.nresult).to eq(nresult)
          end
        end
      end
    end
  end
end
