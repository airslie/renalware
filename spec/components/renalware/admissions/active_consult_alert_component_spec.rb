# frozen_string_literal: true

describe Renalware::Admissions::ActiveConsultAlertComponent, type: :component do
  context "when the patient has no active consults" do
    it "renders nothing" do
      patient = create(:patient)
      create(
        :admissions_consult,
        patient: patient,
        started_on: 2.days.ago,
        ended_on: 1.day.ago
      )

      component = described_class.new(patient: patient)
      expect(component.render?).to be(false)
    end
  end

  context "when the patient has >1 active consults" do
    it "renders an alert linking to the latest one" do
      patient = create(:patient)
      admission = create(
        :admissions_consult,
        patient: patient,
        started_on: 1.day.ago,
        ended_on: nil
      )
      create(
        :admissions_consult,
        patient: patient,
        started_on: 10.days.ago,
        ended_on: nil
      )

      component = described_class.new(patient: patient)
      render_inline(described_class.new(patient: patient))

      expect(component.render?).to be(true)
      expect(page).to have_content("Active Consult")
      expect(page).to have_link(nil, href: edit_admissions_consult_path(id: admission.id))
    end
  end
end
