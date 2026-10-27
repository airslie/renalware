module Renalware
  describe System::DashboardWidgetRole do
    it { is_expected.to belong_to(:widget) }
    it { is_expected.to belong_to(:role) }
    it { is_expected.to validate_presence_of(:widget) }
    it { is_expected.to validate_presence_of(:role) }

    it "does not allow the same role twice on a widget" do
      widget = create(:dashboard_widget, role_names: %i(admin))
      duplicate = described_class.new(widget:, role: Role.find_by!(name: :admin))

      expect(duplicate).not_to be_valid
    end
  end
end
