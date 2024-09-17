# frozen_string_literal: true

module Renalware::HD::Scheduling
  describe MasterDiary do
    it { is_expected.to have_many(:weekly_diaries) }

    describe "#master" do
      it "defaults to false" do
        expect(described_class.new).to be_master
      end
    end

    describe "only allows one master diary per hospital unit" do
      subject { create(:hd_master_diary, hospital_unit_id: unit.id, by: user) }

      let(:unit) { create(:hospital_unit) }
      let(:user) { create(:user) }

      it { is_expected.to validate_uniqueness_of(:hospital_unit_id) }
    end
  end
end
