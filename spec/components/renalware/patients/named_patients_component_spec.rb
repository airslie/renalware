describe Renalware::Patients::NamedPatientsComponent, type: :component do
  subject(:component) { described_class.new(current_user: user) }

  let(:user) { create(:user) }

  context "when the user is not a named nurse for any patients" do
    it "does not render the component at all" do
      render_inline(component)

      expect(page.text).to be_blank
    end
  end

  context "when the user is a named nurse" do
    it "renders the user's patients" do
      my_patient1 = create(:patient, by: user, named_nurse: user, family_name: "Patient1")
      my_patient2 = create(:patient, by: user, named_nurse: user, family_name: "Patient2")
      not_my_patient = create(:patient, by: user, named_nurse: nil, family_name: "Zzz")

      render_inline(component)

      expect(page).to have_content("Named Patients (2)")
      expect(page).to have_content(my_patient1.family_name.upcase)
      expect(page).to have_content(my_patient2.family_name.upcase)
      expect(page).to have_no_content(not_my_patient.family_name.upcase)
    end
  end
end
