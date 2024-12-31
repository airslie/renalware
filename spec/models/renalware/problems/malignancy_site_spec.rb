module Renalware::Problems
  describe MalignancySite do
    it { is_expected.to validate_presence_of(:description) }

    describe "validation" do
      subject { described_class.new(rr_19_code: "123", description: "abc") }

      it { is_expected.to validate_uniqueness_of(:description) }
    end
  end
end
