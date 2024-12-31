module Renalware
  module HD
    describe Session::DNA do
      it "defines a policy class" do
        expect(described_class.policy_class).to eq(DNASessionPolicy)
      end
    end
  end
end
