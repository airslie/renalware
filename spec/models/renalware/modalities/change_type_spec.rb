module Renalware
  describe Modalities::ChangeType do
    it_behaves_like "a Paranoid model"
    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :code }

    describe "#uniqueness" do
      subject { described_class.new(code: "A", name: "B", by: create(:user)) }

      it { is_expected.to validate_uniqueness_of :code }
      it { is_expected.to validate_uniqueness_of :name }
    end

    describe "self.default" do
      it "finds the change type flagged as default or having a code of 'other'" do
        user = create(:user)

        other = create(:modality_change_type, default: false, code: "other", name: "B", by: user)
        expect(described_class.default).to eq(other)

        default = create(:modality_change_type, default: true, code: "X", name: "A", by: user)
        expect(described_class.default).to eq(default)
      end

      it "raises an error if there is no default set and not 'other' code" do
        expect {
          described_class.default
        }.to raise_error(Modalities::ChangeType::ChangeTypeWithDefaultFlagOrCodeOfOtherNotFound)
      end
    end

    it "there can only be one default= true change type" do
      user = create(:user)
      create(:modality_change_type, default: true, code: "A", name: "A", by: user)

      expect {
        create(:modality_change_type, default: true, code: "B", name: "B", by: user)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
