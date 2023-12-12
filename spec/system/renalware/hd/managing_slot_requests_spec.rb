# frozen_string_literal: true

require "rails_helper"

describe "Managing a list of HD Slot Requests" do
  include PatientsSpecHelper

  it "listing slot requests" do
    user = login_as_admin
    patient = create(:hd_patient, by: user, local_patient_id: "MRN1")
    create(:hd_slot_request,
           patient: patient,
           created_at: "2023-10-01 03:03:03",
           urgency: "highly_urgent")

    visit renalware.hd_slot_requests_path

    expect(page).to have_content("HD Slot Requests")

    within("table#slot-requests") do
      expect(page).to have_content("01-Oct-2023")
      expect(page).to have_content(patient.to_s)
      expect(page).to have_content(patient.local_patient_id)
      expect(page).to have_content("Highly urgent")
    end
  end

  it "adding a slot request from the HD Slots Requests page", js: true do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

      visit renalware.hd_slot_requests_path

      within(".page-actions") do
        click_on "Add"
      end
      select2(patient.to_s(:long), css: "#person-id-select2", search: true)
      select "urgent", from: "Urgency"
      check "Inpatient"
      check "Late presenter"
      check "Suitable for twilight slots"
      check "External referral"
      fill_in "Notes", with: "some notes"
      click_on "Create"

      expect(page).to have_current_path(renalware.hd_slot_requests_path)

      within("table#slot-requests") do
        expect(page).to have_content("01-Oct-2023")
        expect(page).to have_content(patient.to_s)
        expect(page).to have_content(patient.local_patient_id)
        expect(page).to have_content("urgent")
      end

      expect(Renalware::HD::SlotRequest.last).to have_attributes(
        inpatient: true,
        late_presenter: true,
        suitable_for_twilight_slots: true,
        external_referral: true
      )
    end
  end

  it "adding a slot request patient's page", js: true do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_super_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

      visit renalware.patient_path(patient)

      within(".patient-side-nav") do
        click_on "Request HD Slot"
      end

      within("#modal") do
        # select2(patient.to_s(:long), css: "#person-id-select2", search: true)
        select "urgent", from: "Urgency"
        check "Inpatient"
        check "Late presenter"
        check "Suitable for twilight slots"
        check "External referral"
        fill_in "Notes", with: "some notes"
        click_on "Create"
      end

      expect(page).to have_current_path(renalware.patient_path(patient))

      sleep 0.5
      # TODO: Check the nag is displayed here on the page refresh!

      expect(Renalware::HD::SlotRequest.last).to have_attributes(
        inpatient: true,
        late_presenter: true,
        suitable_for_twilight_slots: true,
        external_referral: true
      )
    end
  end

  it "marking a slot as allocated", js: true do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")
      slot_request = create(
        :hd_slot_request,
        patient: patient,
        created_at: "2023-10-01 03:03:03",
        urgency: "highly_urgent"
      )

      visit renalware.hd_slot_requests_path

      # Allocate the slot request
      within("table#slot-requests") do
        expect(page).to have_content(patient.to_s)
        click_on "Resolve"
        click_on "Allocate"
      end
      # alert pops up but this is skipped in this test
      # The #allocate action on the controller has now been called and the page.
      expect(page).to have_current_path(renalware.hd_slot_requests_path)

      # Check the patient has been removed
      within("table#slot-requests") do
        expect(page).not_to have_content(patient.to_s)
      end

      # Find and inspect the slot_request to check the allocated_at
      expect(slot_request.reload).to have_attributes(
        allocated_at: Time.zone.now
      )
    end
  end

  it "marking a slot as deleted for some reason", js: true do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")
      slot_request = create(
        :hd_slot_request,
        patient: patient,
        created_at: "2023-10-01 03:03:03",
        urgency: "highly_urgent"
      )
      reason = create(:hd_slot_request_deletion_reason, reason: "Some Reason")

      visit renalware.hd_slot_requests_path

      # Allocate the slot request
      within("table#slot-requests") do
        expect(page).to have_content(patient.to_s)
        click_on "Resolve"
        click_on "Some Reason"
      end
      # alert pops up but this is skipped in this test
      # The #allocate action on the controller has now been called and the page.
      expect(page).to have_current_path(renalware.hd_slot_requests_path)

      # Check the patient has been removed
      within("table#slot-requests") do
        expect(page).not_to have_content(patient.to_s)
      end

      # Find and inspect the slot_request to check the allocated_at
      expect(slot_request.reload).to have_attributes(
        allocated_at: nil,
        deleted_at: Time.zone.now,
        deletion_reason_id: reason.id
      )
    end
  end

  it "edit a slot request" do
    user = login_as_admin
    patient = create(:hd_patient, by: user, local_patient_id: "MRN1")
    create(
      :hd_slot_request,
      patient: patient,
      created_at: "2023-10-01 03:03:03",
      urgency: "highly_urgent"
    )

    visit renalware.hd_slot_requests_path

    within("table#slot-requests") do
      expect(page).to have_content(patient.to_s)
      click_on "Edit"
    end

    select "Routine", from: "Urgency"
    click_on "Save"

    expect(page).to have_current_path(renalware.hd_slot_requests_path)

    within("table#slot-requests") do
      expect(page).to have_content("Routine")
    end
  end
end
