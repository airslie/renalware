module Renalware
  describe System::DashboardPlacement do
    it { is_expected.to belong_to(:dashboard) }
    it { is_expected.to belong_to(:widget) }
    it { is_expected.to validate_presence_of(:dashboard) }
    it { is_expected.to validate_presence_of(:widget) }
    it { is_expected.to validate_presence_of(:position) }

    it "allows a widget to be placed only once on a dashboard" do
      placement = create(:dashboard_placement)
      duplicate = build(:dashboard_placement, dashboard: placement.dashboard,
                                              widget: placement.widget)

      expect(duplicate).not_to be_valid
    end

    it "allows two placements to share a position" do
      dashboard = create(:dashboard)
      create(:dashboard_placement, dashboard:, position: 10)
      other_widget = create(:dashboard_widget, :user_activity)

      expect(
        build(:dashboard_placement, dashboard:, widget: other_widget, position: 10)
      ).to be_valid
    end

    describe "#wrapper_classes" do
      it "returns the classes stored in settings" do
        placement = build(:dashboard_placement, settings: { "wrapper_classes" => "min-w-0" })

        expect(placement.wrapper_classes).to eq("min-w-0")
      end

      it "is blank when not set" do
        expect(build(:dashboard_placement).wrapper_classes).to be_blank
      end
    end
  end
end
