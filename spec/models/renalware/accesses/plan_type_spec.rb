module Renalware::Accesses
  describe PlanType do
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of(:name) }

    describe "ordered scope" do
      it "orders by position then name" do
        create(:access_plan_type, name: "C", position: 1)
        create(:access_plan_type, name: "A", position: 1)
        create(:access_plan_type, name: "B", position: 0)

        expect(described_class.ordered.pluck(:name)).to eq(%w(B A C))
      end
    end
  end
end
