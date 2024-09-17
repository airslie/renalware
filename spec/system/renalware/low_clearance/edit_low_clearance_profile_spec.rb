# frozen_string_literal: true

describe "Edit Advanced Kidney Care" do
  include PatientsSpecHelper

  let(:user) { create(:user) }
  let(:patient) do
    create(:low_clearance_patient).tap do |pat|
      set_modality(
        patient: pat,
        modality_description: create(:low_clearance_modality_description),
        by: user
      )
    end
  end

  describe "edit Advanced Kidney Care data for a patient" do
    context "with valid attributes" do
      it "saves" do
        referrer = Renalware::LowClearance::Referrer.create(name: "TestReferrer")
        login_as_clinical

        po = Pages::LowClearance::ProfilePage.new(patient)
        po.add_or_edit

        fake_date_string = "12-Dec-2017"
        fake_date = Date.parse(fake_date_string)
        po.date_first_seen = fake_date_string
        po.dialysis_plan = "CAPD LA"
        po.dialysis_plan_date = fake_date_string
        po.predicted_esrf_date = fake_date_string
        po.referral_cre = "123"
        po.referral_efgr = "234"
        po.education_status = "Invited"
        po.education_type = "Day"
        po.date_attending = fake_date_string
        po.referred_by = referrer.name
        po.referred_by_notes = referrer.name
        po.save

        expect(page).to have_current_path(patient_low_clearance_dashboard_path(patient))

        profile = Renalware::LowClearance.cast_patient(patient).profile
        expect(profile.referrer).to eq(referrer)
        expect(profile.document).to have_attributes(
          first_seen_on: fake_date,
          dialysis_plan: "capd_la",
          dialysis_planned_on: fake_date,
          predicted_esrf_date: fake_date,
          referral_creatinine: 123,
          referred_by: referrer.name,
          referral_egfr: 234.0,
          education_status: "invited",
          education_type: "day"
        )
      end
    end
  end
end
