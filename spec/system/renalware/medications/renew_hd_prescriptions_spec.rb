# frozen_string_literal: true

describe "Renewing all Give On HD prescriptions via a button", js: true do
  let(:hd_prescriber_role) { create(:role, :hd_prescriber, enforce: true) }

  def create_prescription(patient, drug_name, hd:, by:)
    create(
      :prescription,
      drug: create(:drug, name: drug_name),
      patient: patient,
      administer_on_hd: hd,
      by: by
    )
  end

  context "when the user does not have the hd_prescriber role" do
    it "hides the Renew HD Prescriptions button if the role is enforced" do
      hd_prescriber_role.update(enforce: true)
      user = login_as_clinical
      patient = create(:patient, by: user)

      visit patient_prescriptions_path(
        patient,
        treatable_type: patient.class.to_s,
        treatable_id: patient
      )

      expect(page).to have_no_css("#renew_hd_prescriptions")
    end

    it "shows the Renew HD Prescriptions button if the role is not enforced" do
      hd_prescriber_role.update(enforce: false)
      user = login_as_clinical
      patient = create(:patient, by: user)

      visit patient_prescriptions_path(
        patient,
        treatable_type: patient.class.to_s,
        treatable_id: patient
      )

      expect(page).to have_css("#renew_hd_prescriptions")
    end
  end

  context "when the user has the hd_prescriber role" do
    it "displays the Renew HD Prescriptions button" do
      user = login_as_clinical.tap { |u| u.roles << hd_prescriber_role }
      patient = create(:patient, by: user)

      visit patient_prescriptions_path(
        patient,
        treatable_type: patient.class.to_s,
        treatable_id: patient,
        by: user
      )

      expect(page).to have_css("#renew_hd_prescriptions")
    end

    it "ss" do
      user = login_as_clinical.tap { |u| u.roles << hd_prescriber_role }
      patient = create(:patient, by: user)
      non_hd_prescription = create_prescription(patient, "Drug1", hd: false, by: user)
      hd_prescription1 = create_prescription(patient, "Drug2", hd: true, by: user)
      hd_prescription2 = create_prescription(patient, "Drug3", hd: true, by: user)

      visit patient_prescriptions_path(
        patient,
        treatable_type: patient.class.to_s,
        treatable_id: patient
      )

      expect(page).to have_css("#current-prescriptions tbody tr", count: 3)
      expect(page).to have_css("#historical-prescriptions tbody tr", count: 3)

      click_on "Renew HD Prescriptions"

      within "#new_prescription_batch" do
        expect(page).to have_css("#renew_#{dom_id(hd_prescription1)}")
        expect(page).to have_css("#renew_#{dom_id(hd_prescription2)}")

        # uncheck
        find(:css, "#prescription_batch_prescription_ids_#{hd_prescription1.id}").set(false)

        click_on "Renew"
      end

      expect(page).to have_current_path(patient_prescriptions_path(patient))

      renewed_prescription = Renalware::Medications::Prescription.last

      # The single HD prescription we left selected will have been terminated and re-created
      #
      # There will still be 3 current, but now 4 historical:
      # - the unaffected non-hd
      # - the un-renewed (unchecked above) hd_prescription1
      # - the now terminated hd_prescription2 (will have a stopped on of today)
      # - the new hd_prescription2 prescription
      # ones, but there will now be
      within "#current-prescriptions" do
        expect(page).to have_css("tbody tr", count: 3)
        expect(page).to have_css("tbody tr.#{dom_id(non_hd_prescription)}")
        expect(page).to have_css("tbody tr.#{dom_id(hd_prescription1)}")
        expect(page).to have_css("tbody tr.#{dom_id(renewed_prescription)}")
      end

      within "#historical-prescriptions" do
        expect(page).to have_css("tbody tr", count: 4)
        expect(page).to have_css("tbody tr.#{dom_id(non_hd_prescription)}")
        expect(page).to have_css("tbody tr.#{dom_id(hd_prescription1)}")
        expect(page).to have_css("tbody tr.#{dom_id(hd_prescription2)}")
        expect(page).to have_css("tbody tr.#{dom_id(renewed_prescription)}")
      end
    end
  end
end
