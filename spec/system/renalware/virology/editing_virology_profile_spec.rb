# frozen_string_literal: true

describe "Editing the virology profile" do
  let(:patient) { create(:virology_patient) }

  it "builds a new profile for the form if the patient had none" do
    login_as_clinical
    visit patient_virology_dashboard_path(patient)

    within ".page-actions" do
      click_on "Edit Profile"
    end

    expect(page).to have_current_path(edit_patient_virology_profile_path(patient))

    within(".hiv") do
      choose("Yes")
      select("2012", from: "Diagnosed")
    end

    within(".hepatitis_b") do
      choose("No")
      select("2011", from: "Diagnosed")
    end

    within(".hepatitis_b_core_antibody") do
      choose("Yes")
      select("2010", from: "Diagnosed")
    end

    within(".hepatitis_c") do
      choose("Unknown")
    end

    within(".htlv") do
      choose("Yes")
      select("2018", from: "Diagnosed")
    end

    within ".patient-content" do
      click_on t("btn.create")
    end

    expect(page).to have_current_path(patient_virology_dashboard_path(patient))

    document = patient.reload.profile.document
    expect(document.hiv.status.to_s).to eq("yes")
    expect(document.hiv.confirmed_on_year).to eq(2012)
    expect(document.hepatitis_b.status.to_s).to eq("no")
    expect(document.hepatitis_b.confirmed_on_year).to eq(2011)
    expect(document.hepatitis_b_core_antibody.status.to_s).to eq("yes")
    expect(document.hepatitis_b_core_antibody.confirmed_on_year).to eq(2010)
    expect(document.hepatitis_c.status.to_s).to eq("unknown")
    expect(document.hepatitis_c.confirmed_on_year).to be_blank
    expect(document.htlv.status.to_s).to eq("yes")
    expect(document.htlv.confirmed_on_year).to eq(2018)
  end
end
