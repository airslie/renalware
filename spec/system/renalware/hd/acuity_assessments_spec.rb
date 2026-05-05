RSpec.describe "Acuity Assessment", :js do
  let(:clinician) { create(:user, :clinical) }
  let(:patient) { create(:hd_patient) }
  let(:patient_assessments) { Renalware::HD::AcuityAssessment.for_patient(patient) }

  before { login_as clinician }

  describe "viewing a patients assessments" do
    let!(:assessment) { create(:hd_acuity_assessment, patient:) }

    it "responds with a list" do
      visit patient_hd_acuity_assessments_path(patient)

      expect(page).to have_text("1:4")
      expect(page).to have_text(assessment.created_by.to_s)
      expect(page).to have_text(I18n.l(assessment.created_at.to_date))
    end
  end

  describe "creating an assessment" do
    context "with valid attributes" do
      it "creates a new record" do
        visit patient_hd_acuity_assessments_path(patient)

        click_on "Add"
        choose "1:4"
        click_on "Create"

        expect(page).to have_text("Acuity assessment added")
        expect(patient_assessments.count).to eq(1)
        expect(page).to have_text("1:4")
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        visit patient_hd_acuity_assessments_path(patient)

        click_on "Add"

        expect(page).to have_text("Select the HD acuity ratio")

        click_on "Create"

        expect(page).to have_text("Ratio can't be blank")
        expect(patient_assessments.count).to eq(0)
      end
    end
  end

  describe "deleting an assessment" do
    before { create(:hd_acuity_assessment, by: clinician, patient:) }

    it "deletes the record" do
      visit patient_hd_acuity_assessments_path(patient)

      within(".acuity-assessments") do
        accept_confirm do
          find("a[data-method=delete]").click
        end
      end

      expect(page).to have_text("HD acuity assessment removed")
      expect(patient_assessments.count).to eq(0)
      expect(page).to have_no_text("1:4")
      expect(page).to have_link("Add")
    end
  end
end
