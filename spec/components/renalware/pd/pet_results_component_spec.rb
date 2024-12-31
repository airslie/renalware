describe Renalware::PD::PETResultsComponent, type: :component do
  context "when there are no results" do
    it "renders nothing" do
      user = build_stubbed(:user)
      patient = build_stubbed(:pd_patient)
      component = described_class.new(patient: patient, current_user: user)
      allow(component).to receive(:results).and_return([])

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when there are results" do
    it "renders nothing" do
      patient = build_stubbed(:pd_patient)
      user = build_stubbed(:user)
      component = described_class.new(patient: patient, current_user: user)
      result = build_stubbed(:pd_pet_result, patient: patient, performed_on: "2020-01-01")
      allow(component).to receive_messages(
        results: [result],
        pagination: Renalware::NullObject.instance
      )

      render_inline(component).to_html

      expect(page).to have_content "01-Jan-2020"
    end
  end
end
