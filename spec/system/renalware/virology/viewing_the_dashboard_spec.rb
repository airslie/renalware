describe "Viewing the dashboard" do
  include PathologySpecHelper

  let(:patient) { create(:virology_patient) }

  it "is accessible from the patient LH menu" do
    login_as_clinical
    visit patient_path(patient)

    within ".side-nav" do
      click_on "Virology"
    end

    expect(page).to have_current_path(patient_virology_dashboard_path(patient))
  end

  it "displays vaccinations" do
    user = login_as_clinical
    date = "2017-12-12 00:00:01"
    create(
      :vaccination,
      patient:,
      date_time: Time.zone.parse(date),
      by: user,
      document: {
        type: :hbv1
      }
    )

    visit patient_virology_dashboard_path(patient)

    within ".patient-content" do
      expect(page).to have_text("Virology")
      expect(page).to have_text("Vaccinations")

      within "article.vaccinations" do
        expect(page).to have_text("Desc")
        expect(page).to have_text("12-Dec-2017")
        within "header" do
          expect(page).to have_text("Add")
        end
      end
    end
  end

  it "displays hiv, hepatitis c, hepatitis b, htlv" do
    user = login_as_clinical
    patient.build_profile
    patient.profile.document.hiv.status = :yes
    patient.profile.document.hiv.confirmed_on_year = 2001
    patient.profile.document.htlv.status = :yes
    patient.profile.document.htlv.confirmed_on_year = 2018
    patient.save_by!(user)

    visit patient_virology_dashboard_path(patient)

    within ".patient-content" do
      expect(page).to have_text("HIV")
      expect(page).to have_text("Yes (2001)")
      expect(page).to have_text("HTLV")
      expect(page).to have_text("Yes (2018)")
    end
  end

  it "displays 5 most recent BHBS pathology results (bhi hep b anti hbs status)" do
    login_as_clinical
    pathology_patient = Renalware::Pathology.cast_patient(patient)
    create_request_with_observations(
      patient: pathology_patient,
      obx_codes: ["BHBS"],
      count: 6, # create 6 BHBS observations..
      result: "1.11" # they will all have this value
    )

    visit patient_virology_dashboard_path(patient)

    within ".hep_b_antibody_path_results #observations" do
      expect(page).to have_text("1.11", count: 5)
      expect(page).to have_text("BHBS")
    end
  end
end
