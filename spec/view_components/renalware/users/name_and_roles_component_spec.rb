describe Renalware::Users::NameAndRolesComponent, type: :component do
  describe "#role_names" do
    it "returns the user's roles as a comma-separated string" do
      user = create(:user)
      user.roles << create(:role, :super_admin)
      user.roles << create(:role, :prescriber)

      component = described_class.new(current_user: user)

      expect(component.role_names).to eq("Clinical, Super Admin, Prescriber")
    end
  end

  it "the user's full name any any roles" do
    user = build_stubbed(:user, family_name: "Smith", given_name: "John")
    allow(user).to receive(:role_names).and_return("Admin, Clinical, Readonly")

    component = described_class.new(current_user: user)

    render_inline(component).to_html

    expect(page).to have_text("John Smith")
    expect(page).to have_text("Admin, Clinical, Readonly")
  end
end
