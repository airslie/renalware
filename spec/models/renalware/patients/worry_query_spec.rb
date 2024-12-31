module Renalware
  module Patients
    describe WorryQuery do
      describe "#call" do
        context "when no scope supplied" do
          it "returns Worries" do
            user = create(:user)
            patient = create(:patient, by: user)
            worry = Worry.create!(patient: patient, by: user)

            result = described_class.new(query_params: {}).call.to_a

            expect(result).to eq [worry]
          end
        end

        context "when a scope is supplied" do
          it "returns Worries with scope applied" do
            user = create(:user)
            larry = create(:patient, by: user, given_name: "Larry")
            fred = create(:patient, by: user, given_name: "Fred")
            Worry.create!(patient: larry, by: user)
            fred_worry = Worry.create!(patient: fred, by: user)
            scope = Patient.where(given_name: "Fred")

            result = described_class.new(query_params: {}, patient_scope: scope).call.to_a

            expect(result).to eq [fred_worry]
          end
        end
      end
    end
  end
end
