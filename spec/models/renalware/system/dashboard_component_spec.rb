# frozen_string_literal: true

module Renalware
  describe System::DashboardComponent do
    it { is_expected.to belong_to(:dashboard) }
    it { is_expected.to belong_to(:component) }
    it { is_expected.to validate_presence_of(:dashboard) }
    it { is_expected.to validate_presence_of(:component) }
    it { is_expected.to validate_presence_of(:position) }

    describe "#uniqueness" do
      it { is_expected.to validate_uniqueness_of(:position).scoped_to(:dashboard_id) }
    end
  end
end
