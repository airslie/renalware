describe "renalware/patients/_header" do
  helper(Renalware::ApplicationHelper, Renalware::PatientHelper)

  it "renders the patient name as plain text for PDFs" do
    patient = build(:patient)

    render partial: "renalware/patients/header", locals: { patient:, skip_hamburger: true }

    header = Nokogiri::HTML.fragment(rendered).at_css("dd.name")
    expect(header.at_css("span").text).to eq(patient.to_s)
    expect(header.css("button, svg")).to be_empty
  end

  it "renders the patient name in the menu toggle by default" do
    patient = build(:patient)

    render partial: "renalware/patients/header", locals: { patient: }

    toggle = Nokogiri::HTML.fragment(rendered).at_css("dd.name button.patient-menu-toggle")
    expect(toggle.at_css("span").text).to eq(patient.to_s)
    expect(toggle["data-action"]).to eq("patient-menu#toggle")
  end

  it "includes the correctly formatted NHS number" do
    patient = build(:patient, nhs_number: "9999999999")

    render partial: "renalware/patients/header", locals: { patient: }

    expect(rendered).to include("999 999 9999")
  end

  context "when sex is nil" do
    it "renders without 'no implicit conversion of nil into String' error" do
      patient = build(:patient, nhs_number: "9999999999", sex: nil)

      expect {
        render partial: "renalware/patients/header", locals: { patient: }
      }.not_to raise_error
    end
  end
end
