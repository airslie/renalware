describe "renalware/patients/_header" do
  helper(Renalware::ApplicationHelper, Renalware::PatientHelper)

  it "includes the correctly formatted NHS number" do
    patient = build(:patient, nhs_number: "9999999999")

    render partial: "renalware/patients/header", locals: { patient: patient }

    expect(rendered).to include("999 999 9999")
  end

  context "when sex is nil" do
    it "renders without 'no implicit conversion of nil into String' error" do
      patient = build(:patient, nhs_number: "9999999999", sex: nil)

      expect {
        render partial: "renalware/patients/header", locals: { patient: patient }
      }.not_to raise_error
    end
  end
end
