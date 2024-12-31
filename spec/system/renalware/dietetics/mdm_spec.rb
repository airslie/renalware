describe "Patient Dietetics MDM" do
  include PatientsSpecHelper
  include PathologySpecHelper

  let(:user) { create(:user, :clinical, family_name: "Dietician", given_name: "Doris") }

  let(:patient) {
    create(
      :patient,
      named_consultant: consultant,
      given_name: "Jack",
      family_name: "Jones",
      by: user
    ).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: create(:modality_description, :hd),
        by: user
      )
    end
  }

  let(:other_patient) {
    create(
      :patient,
      named_consultant: consultant,
      family_name: "Smith",
      by: user
    ).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: create(:modality_description, :hd),
        by: user
      )
    end
  }

  let(:dietetic_clinic_visit) do
    create(:dietetic_clinic_visit,
           patient: Renalware::Clinics.cast_patient(patient),
           by: user,
           clinic: create(:clinic, :dietetic, code: "D1"),
           height: 1.90,
           weight: 80,
           date: Date.parse("2022-09-09"),
           document: { ideal_body_weight: 28,
                       dietary_protein_intake: 70,
                       dietary_protein_requirement: 66,
                       energy_intake: 2300,
                       energy_requirement: 2800,
                       high_biological_value: 20,
                       handgrip_left: 40,
                       waist_circumference: 94,
                       previous_weight: 70,
                       plan: "To be decided",
                       next_review_on: Date.parse("2022-10-09"),
                       sga_assessment: "well_nourished" })
  end

  let(:other_clinic_visit) do
    create(:clinic_visit,
           patient: Renalware::Clinics.cast_patient(other_patient),
           by: user,
           clinic: create(:clinic, visit_class_name: nil),
           height: 1.90,
           weight: 80,
           date: Date.parse("2023-09-09"))
  end

  let(:consultant) { create(:user, :consultant, family_name: "Consultant", given_name: "Clive") }
  let(:phos) { create(:pathology_observation_description, :phos) }

  describe "GET index" do
    before do
      dietetic_clinic_visit
      other_clinic_visit
      create_observations(
        Renalware::Pathology.cast_patient(patient),
        [phos],
        result: 1.99
      )
    end

    it "shows a table with patients that have a dietetic visit" do
      create(:view_metadata,
             view_name: "dietetic_mdm_patients",
             scope: "dietetics",
             category: "mdm",
             slug: "all",
             schema_name: "renalware",
             title: "All",
             filters: [
               { code: :on_worryboard, type: :list },
               { code: :dietician_name, type: :list },
               { code: :hospital_centre, type: :list },
               { code: :modality_name, type: :list },
               { code: :consultant_name, type: :list },
               { code: :outstanding_dietetic_visit, type: :list }
             ])
      Scenic.database.refresh_materialized_view("dietetic_mdm_patients", concurrently: false)

      login_as user

      visit patients_mdms_path("dietetics")

      expect(page).to have_css("#mdm-patients-table tbody tr", count: 1)
      expect(page).to have_content("Dietetics MDMS")
      expect(page).to have_content("Consultant, Clive")
      expect(page).to have_content("Dietician, Doris")
      expect(page).to have_content("JONES, Jack")
      expect(page).to have_content("01-Jan-1988")
      expect(page).to have_content("HD")
      expect(page).to have_content("1.99") # Phos
      expect(page).to have_content("22.2") # BMI
      expect(page).to have_content("80") # weight
      expect(page).to have_content("09-Sep-2022")
      expect(page).to have_content("09-Oct-2022")
      expect(page).to have_content(/Dietetic r v/i)
      expect(page).to have_content("14.3%") # weight change
      expect(page).to have_content("80") # current weight
      expect(page).to have_content("overdue") # outstanding dietetic visit
      expect(page).to have_content("King's College Hospital")
    end
  end

  describe "GET show" do
    before do
      dietetic_clinic_visit
      create(:pathology_code_group, name: :dietetics_mdm)
    end

    it "shows the MDM show page" do
      login_as user

      visit patient_dietetics_mdm_path(patient)

      expect(page).to have_content("JONES, Jack")

      within "article", text: "Dietetic Visits" do
        expect(page).to have_content("Dietetic D1")
        expect(page).to have_content("1.9") # Height
        expect(page).to have_content("22.2") # BMI
        expect(page).to have_content("112/71") # BP
        expect(page).to have_content("100") # Pulse
        expect(page).to have_content("2.08") # BSA
        # expect(page).to have_content("46.54") # TBW; This changes depending on age
      end

      within "article", text: "Clinic Visits" do
        expect(page).to have_content("Dietetic D1")
        expect(page).to have_content("1.9") # Height
        expect(page).to have_content("22.2") # BMI
        expect(page).to have_content("112/71") # BP
        expect(page).to have_content("100") # Pulse
        expect(page).to have_content("2.08") # BSA
        # expect(page).to have_content("46.54") # TBW; This changes depending on age
      end

      within "article", text: "Dietetic Profile" do
        expect(page).to have_content "Date09-Sep-2022"
        expect(page).to have_content "Ideal body weight28 kg"
        expect(page).to have_content "SgaA - Well nourished"
        expect(page).to have_content "Estimated energy requirement2800 kcal"
        expect(page).to have_content "Estimated energy intake2300 kcal"
        expect(page).to have_content "Estimated protein intake70 g/day"
        expect(page).to have_content "Estimated protein requirement66 g/day"
      end

      within "article", text: "Recent Weights" do
        expect(page).to have_content "09-Sep-2022"
        expect(page).to have_content "80.0 kg"
      end

      within "article", text: "Recent Handgrips" do
        expect(page).to have_content "09-Sep-2022"
        expect(page).to have_content "40 kg"
      end
    end
  end
end
