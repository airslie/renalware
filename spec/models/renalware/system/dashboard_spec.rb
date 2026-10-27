module Renalware
  describe System::Dashboard do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:placements) }
    it { is_expected.to have_many(:widgets).through(:placements) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:name) }

    describe "#key uniqueness" do
      subject { create(:dashboard) }

      it { is_expected.to validate_uniqueness_of(:key) }
    end

    describe "#visible_placements_for" do
      let(:dashboard) { create(:dashboard) }
      let(:admin) { create(:user, :admin) }

      it "returns only placements of widgets visible to the user, in position order" do
        second = create(:dashboard_widget, :users_awaiting_approval, role_names: %i(admin))
        first = create(:dashboard_widget, :user_activity, role_names: %i(admin))
        hidden = create(:dashboard_widget, :integration_activity, role_names: %i(super_admin))
        create(:dashboard_placement, dashboard:, widget: second, position: 20)
        create(:dashboard_placement, dashboard:, widget: hidden, position: 15)
        create(:dashboard_placement, dashboard:, widget: first, position: 10)

        placements = dashboard.visible_placements_for(admin)

        expect(placements.map(&:widget)).to eq([first, second])
      end

      it "breaks position ties by id" do
        widget_a = create(:dashboard_widget, :user_activity, role_names: %i(admin))
        widget_b = create(:dashboard_widget, :users_awaiting_approval, role_names: %i(admin))
        create(:dashboard_placement, dashboard:, widget: widget_a, position: 10)
        create(:dashboard_placement, dashboard:, widget: widget_b, position: 10)

        expect(dashboard.visible_placements_for(admin).map(&:widget)).to eq([widget_a, widget_b])
      end
    end
  end
end
