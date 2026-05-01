describe "Managing a list of HD Slot Requests" do
  include PatientsSpecHelper

  let(:location) { create(:hd_slot_request_location, name: "ABC") }
  let(:access_state) { create(:hd_slot_request_access_state) }

  before do
    location
    access_state
  end

  it "listing slot requests" do
    user = login_as_admin
    patient = create(:hd_patient, by: user, local_patient_id: "MRN1")
    create(:hd_slot_request,
           patient:,
           created_at: "2023-10-01 03:03:03",
           urgency: "highly_urgent",
           access_state:,
           location:)

    visit hd_slot_requests_path

    expect(page).to have_text("HD Slot Requests")

    within("table#slot-requests") do
      expect(page).to have_text("01-Oct-2023")
      expect(page).to have_text(patient.to_s)
      expect(page).to have_text(patient.local_patient_id)
      expect(page).to have_text("Highly urgent")
      expect(page).to have_text(location.name)
      expect(page).to have_text(access_state.name)
    end
  end

  it "adding a slot request from the HD Slots Requests page", :js do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

      visit hd_slot_requests_path

      within(".page-actions") do
        click_on "Add"
      end
      within("#new_hd_slot_request") do
        expect(page).to have_css(".hd_slot_request_patient_id .ss-main .ss-arrow")
        slim_select(patient.to_s(:long), from: "Patient", wait_for: "Enter at least 3 characters")
        select "urgent", from: "Urgency"
        select "Yes", from: "Requires BBV Slot (hep B+)"
        select location.name, from: "Location"
        select access_state.name, from: "Current Access"
        check "MFFD"
        check "Late presenter"
        check "Suitable for twilight slots"
        check "External referral"
        fill_in "Notes", with: "some notes"
        click_on "Create"
      end

      expect(page).to have_current_path(hd_slot_requests_path)

      within("table#slot-requests") do
        expect(page).to have_text("01-Oct-2023")
        expect(page).to have_text(patient.to_s)
        expect(page).to have_text(patient.local_patient_id)
        expect(page).to have_text("urgent")
      end

      slot_request = Renalware::HD::SlotRequest.last
      expect(slot_request).to have_attributes(
        location_id: location.id,
        access_state_id: access_state.id,
        medically_fit_for_discharge: true,
        late_presenter: true,
        suitable_for_twilight_slots: true,
        external_referral: true
      )
      # if medically_fit_for_discharge was set to true then it should have stored the datetime
      # and user who made that change
      expect(slot_request).to have_attributes(
        medically_fit_for_discharge_at: Time.zone.now,
        medically_fit_for_discharge_by_id: user.id
      )
    end
  end

  it "adding a slot request via patient's page", :js do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_super_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

      visit patient_path(patient)

      within(".patient-side-nav") do
        click_on "Request HD Slot"
      end

      within("#modal") do
        select "urgent", from: "Urgency"
        select location.name, from: "Location"
        select access_state.name, from: "Current Access"
        select "No", from: "Requires BBV Slot (hep B+)"
        check "Late presenter"
        check "Suitable for twilight slots"
        check "External referral"
        fill_in "Notes", with: "some notes"
        click_on "Create"
      end

      expect(page).to have_text "HD slot requested"

      expect(Renalware::HD::SlotRequest.last).to have_attributes(
        location_id: location.id,
        access_state_id: access_state.id,
        late_presenter: true,
        suitable_for_twilight_slots: true,
        external_referral: true
      )
    end
  end

  it "marking a slot as allocated", :js do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

      slot_request = create(
        :hd_slot_request,
        patient:,
        location:,
        access_state:,
        created_at: "2023-10-01 03:03:03",
        urgency: "highly_urgent"
      )

      visit hd_slot_requests_path

      # Allocate the slot request
      within("table#slot-requests") do
        expect(page).to have_text(patient.to_s)
        click_on "Resolve"
        click_on "Allocate"
      end
      # alert pops up but this is skipped in this test
      # The #allocate action on the controller has now been called and the page.
      expect(page).to have_current_path(hd_slot_requests_path)

      # Check the patient has been removed
      within("table#slot-requests") do
        expect(page).to have_no_text(patient.to_s)
      end

      # Find and inspect the slot_request to check the allocated_at
      expect(slot_request.reload).to have_attributes(
        allocated_at: Time.zone.now
      )
    end
  end

  it "marking a slot as deleted for some reason", :js do
    travel_to("01-Oct-2023 03:03") do
      user = login_as_admin
      patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

      slot_request = create(
        :hd_slot_request,
        patient:,
        location:,
        access_state:,
        created_at: "2023-10-01 03:03:03",
        urgency: "highly_urgent"
      )
      reason = create(:hd_slot_request_deletion_reason, reason: "Some Reason")

      visit hd_slot_requests_path

      # Allocate the slot request
      within("table#slot-requests") do
        expect(page).to have_text(patient.to_s)
        click_on "Resolve"
        click_on "Some Reason"
      end
      # alert pops up but this is skipped in this test
      # The #allocate action on the controller has now been called and the page.
      expect(page).to have_current_path(hd_slot_requests_path)

      # Check the patient has been removed
      within("table#slot-requests") do
        expect(page).to have_no_text(patient.to_s)
      end

      # Find and inspect the slot_request to check the allocated_at
      expect(slot_request.reload).to have_attributes(
        allocated_at: nil,
        deleted_at: Time.zone.now,
        deletion_reason_id: reason.id
      )
    end
  end

  describe "editing a patient", :js do
    context "when setting MFFD to true" do
      it "stores the user and time when MFFD was checked" do
        freeze_time do
          user = login_as_admin
          patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

          create(
            :hd_slot_request,
            patient:,
            location:,
            access_state:,
            medically_fit_for_discharge: false,
            created_at: "2023-10-01 03:03:03",
            urgency: "highly_urgent",
            notes: "ABC"
          )

          visit hd_slot_requests_path

          within("table#slot-requests") do
            expect(page).to have_text(patient.to_s)
            click_on "Edit"
          end

          check "MFFD"
          click_on "Save"

          # wait for modal to be dismissed by checking a field on the modal is no longer there
          expect(page).to have_no_css("#hd_slot_request_urgency")

          # if medically_fit_for_discharge was set to true then it should have stored the datetime
          # and user who made that change
          expect(Renalware::HD::SlotRequest.last).to have_attributes(
            medically_fit_for_discharge: true,
            medically_fit_for_discharge_at: Time.zone.now,
            medically_fit_for_discharge_by_id: user.id
          )
        end
      end

      context "when setting MFFD to false" do
        it "clears the user and time when MFFD was checked", :js do
          freeze_time do
            user = login_as_admin
            patient = create(:hd_patient, by: user, local_patient_id: "MRN1")

            create(
              :hd_slot_request,
              patient:,
              created_at: "2023-10-01 03:03:03",
              location:,
              access_state:,
              medically_fit_for_discharge: true,
              medically_fit_for_discharge_at: Time.zone.now,
              medically_fit_for_discharge_by_id: user.id
            )

            visit hd_slot_requests_path

            within("table#slot-requests") do
              expect(page).to have_text(patient.to_s)
              click_on "Edit"
            end

            uncheck "MFFD"
            click_on "Save"

            # wait for modal to be dismissed by checking a field on the modal is no longer there
            expect(page).to have_no_css("#hd_slot_request_urgency")

            # if medically_fit_for_discharge was set to true then it should have stored the datetime
            # and user who made that change
            expect(Renalware::HD::SlotRequest.last).to have_attributes(
              medically_fit_for_discharge: false,
              medically_fit_for_discharge_at: nil,
              medically_fit_for_discharge_by_id: nil
            )
          end
        end
      end
    end
  end
end
