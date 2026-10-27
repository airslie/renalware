module Renalware
  describe System::DashboardWidget do
    it { is_expected.to have_many(:widget_roles) }
    it { is_expected.to have_many(:roles).through(:widget_roles) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:class_name) }

    describe "uniqueness" do
      subject { create(:dashboard_widget) }

      it { is_expected.to validate_uniqueness_of(:key) }
      it { is_expected.to validate_uniqueness_of(:name) }
      it { is_expected.to validate_uniqueness_of(:class_name) }
    end

    describe "#class_name" do
      it "is invalid when not in the component registry" do
        widget = build(:dashboard_widget, class_name: "Kernel")

        expect(widget).not_to be_valid
        expect(widget.errors[:class_name]).to be_present
      end

      it "is valid when in the component registry" do
        expect(build(:dashboard_widget)).to be_valid
      end
    end

    describe "#component_class" do
      it "returns the registered component class" do
        widget = build(:dashboard_widget)

        expect(widget.component_class).to eq(System::UsersAwaitingApprovalComponent)
      end
    end

    describe ".visible_to" do
      let(:admin) { create(:user, :admin) }
      let(:super_admin) { create(:user, :super_admin) }

      it "includes widgets sharing a role with the user" do
        widget = create(:dashboard_widget, role_names: %i(admin super_admin))

        expect(described_class.visible_to(admin)).to eq([widget])
        expect(described_class.visible_to(super_admin)).to eq([widget])
      end

      it "excludes widgets the user has no matching role for" do
        create(:dashboard_widget, role_names: %i(super_admin))

        expect(described_class.visible_to(admin)).to be_empty
      end

      it "excludes widgets with no roles from everyone" do
        create(:dashboard_widget, role_names: [])

        expect(described_class.visible_to(super_admin)).to be_empty
      end

      it "returns a widget once when the user matches several of its roles" do
        widget = create(:dashboard_widget, role_names: %i(admin super_admin))
        admin.roles << create(:role, :super_admin)

        expect(described_class.visible_to(admin)).to eq([widget])
      end
    end
  end
end
