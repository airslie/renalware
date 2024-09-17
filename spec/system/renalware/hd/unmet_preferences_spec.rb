# frozen_string_literal: true

describe "Viewing patients whose HD preferences do not match their profile" do
  let(:hospital) { create(:hospital_centre) }
  let(:current_unit) do
    create(:hospital_unit, name: "X", hospital_centre: hospital, is_hd_site: true)
  end
  let(:preferred_unit) do
    create(:hospital_unit, name: "Y", hospital_centre: hospital, is_hd_site: true)
  end
  let(:user) { Renalware::User.first }
  let(:mon_wed_fri_am) { create(:schedule_definition, :mon_wed_fri_am) }
  let(:mon_wed_fri_pm) { create(:schedule_definition, :mon_wed_fri_pm) }

  def mon_wed_fri(am_pm_eve)
    period = Renalware::HD::DiurnalPeriodCode.find_or_create_by!(code: am_pm_eve)
    Renalware::HD::ScheduleDefinition.find_or_create_by!(
      diurnal_period: period,
      days: [1, 3, 5]
    )
  end

  def patient_preferring_another_schedule(name: "Jones")
    create(:hd_patient, family_name: name).tap do |patient|
      create(:hd_profile,
             patient: patient,
             schedule_definition: mon_wed_fri_am,
             hospital_unit: current_unit)
      create(:hd_preference_set,
             patient: patient,
             schedule_definition: mon_wed_fri_pm,
             hospital_unit: current_unit,
             by: user)
    end
  end

  def patient_preferring_another_hospital_unit(name: "Smith")
    create(:hd_patient, family_name: name).tap do |patient|
      create(:hd_profile,
             patient: patient,
             schedule_definition: mon_wed_fri_am,
             hospital_unit: current_unit) # !
      create(:hd_preference_set,
             patient: patient,
             hospital_unit: preferred_unit, # !
             by: user)
    end
  end

  def patient_whose_preferences_are_met(name: "Metpost")
    create(:hd_patient, family_name: name).tap do |patient|
      create(:hd_profile,
             patient: patient,
             hospital_unit: current_unit,
             schedule_definition: mon_wed_fri_am)
      create(:hd_preference_set,
             patient: patient,
             hospital_unit: current_unit,
             schedule_definition: mon_wed_fri_am,
             by: user)
    end
  end

  describe "GET index" do
    it "responds with a list of patients with unmet preferences" do
      login_as_clinical
      patient_met = patient_whose_preferences_are_met
      patient_schedule = patient_preferring_another_schedule
      patient_unit = patient_preferring_another_hospital_unit

      visit hd_unmet_preferences_path

      expect(page).to have_content(patient_schedule.family_name.upcase)
      expect(page).to have_content(patient_unit.family_name.upcase)
      expect(page).to have_no_content(patient_met.family_name.upcase)
    end

    context "when filtering" do
      it "responds with a list of patients matching filters" do
        login_as_clinical
        patient_met = patient_whose_preferences_are_met
        patient_schedule = patient_preferring_another_schedule
        patient_unit = patient_preferring_another_hospital_unit

        visit hd_unmet_preferences_path

        # Select the hospital unit Y which patient_unit prefers
        select "Y", from: "q_hd_preference_set_hospital_unit_id_eq"
        click_on t("btn.filter")

        expect(page).to have_content(patient_unit.family_name.upcase)
        expect(page).to have_no_content(patient_met.family_name.upcase)
        expect(page).to have_no_content(patient_schedule.family_name.upcase)
      end
    end
  end
end
