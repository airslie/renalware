# frozen_string_literal: true

describe Renalware::HD::VNDRiskAssessmentsComponent, type: :component do
  let(:user) { create(:user) }
  let(:patient) { create(:hd_patient, by: user) }

  it "displays the last 3 needling assessments" do
    component = described_class.new(current_user: user, patient: patient)

    assessment = create(
      :hd_vnd_risk_assessment,
      patient: patient,
      by: user,
      risk1: "0_very_low",
      risk2: "0_low",
      risk3: "0_very_low",
      risk4: "2_high"
    )
    expect(assessment.overall_risk).to eq("2 Low")

    render_inline(component)

    # thead
    expect(page).to have_content("VND Risk Assessments")
    expect(page).to have_content("Overall risk")
    expect(page).to have_content("Assessor")
    # tbody
    expect(page).to have_css("tbody tr td", text: "2")
    expect(page).to have_css("tbody tr td", text: I18n.l(assessment.created_at.to_date))
    expect(page).to have_css("tbody tr td", text: user.to_s)
  end

  it "renders nothing if the patient has no assessments" do
    component = described_class.new(current_user: user, patient: patient)

    render_inline(component)

    expect(component.render?).to be(false)
    expect(page.text).to be_blank
  end
end
