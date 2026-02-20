describe Renalware::Medications::ExpiringPrescriptionsListComponent, type: :component do
  let(:consultant)    { create(:user, consultant: true) }
  let(:user)          { create(:user, consultant: false) }
  let(:component)     { described_class.new(current_user: user) }
  let(:patient)       { create(:hd_patient) }
  let(:prescription)  { create(:prescription, patient:, drug:) }
  let(:drug)          { create(:drug, name: "Blue pill") }

  context "when the user is not a consultant" do
    it "does not render the component" do
      component = described_class.new(current_user: user)

      render_inline(component)

      expect(component.render?).to be(false)
    end
  end

  context "when the consultant has no patients with expiring HD prescriptions" do
    it "displays a 'nothing here' message" do
      component = described_class.new(current_user: consultant)

      render_inline(component)

      expect(component.render?).to be(true)
      expect(page.text).to include("HD Prescriptions due to expire")
      expect(page.text).to include("None")
    end
  end

  context "when the consultant has patients with some expiring HD prescriptions" do
    it "lists them" do
      component = described_class.new(current_user: consultant)

      allow(Renalware::Medications::ExpiringHDPrescriptionsForConsultantQuery)
        .to receive(:call).and_return([prescription])

      render_inline(component)

      expect(component.render?).to be(true)
      expect(page.text).to include("Blue pill")
    end
  end
end
