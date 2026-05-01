describe "Advanced Kidney Care MDM" do
  it "view an MDM" do
    patient = create(:patient, family_name: "Rabbit", local_patient_id: "12345")
    create(:pathology_observation_description, code: "HGB")
    create(:pathology_code_group, :default)

    login_as_clinical

    visit patient_low_clearance_mdm_path(patient)

    expect(page).to have_text(patient.to_s)
    expect(page).to have_text("Current Problems")
    expect(page).to have_text("Prescriptions")
    expect(page).to have_text("Events")
    expect(page).to have_text("Letters")
    expect(page).to have_text("Pathology")
    expect(page).to have_text("AKCC")
    expect(page).to have_text("Date first seen")
  end
end
