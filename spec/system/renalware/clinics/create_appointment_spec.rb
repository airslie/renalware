describe "Create new appointment manually (not via HL7 message)", :js do
  context "when selecting appointments for request forms" do
    it "can uncheck all appointments and rebuild the request form patient ids" do
      user = login_as_clinical
      first_patient = create(:clinics_patient, by: user)
      second_patient = create(:clinics_patient, by: user)
      create(:appointment, patient: first_patient, starts_at: 1.day.from_now)
      create(:appointment, patient: second_patient, starts_at: 2.days.from_now)

      visit appointments_path

      expect(request_form_patient_ids).to contain_exactly(
        first_patient.id.to_s,
        second_patient.id.to_s
      )

      click_on "(Uncheck all)"

      expect(page).to have_unchecked_field(
        type: "checkbox",
        with: first_patient.id.to_s
      )
      expect(page).to have_unchecked_field(
        type: "checkbox",
        with: second_patient.id.to_s
      )
      expect(request_form_patient_ids).to be_empty

      find(".patient_checkbox[value='#{first_patient.id}']").check

      expect(request_form_patient_ids).to eq([first_patient.id.to_s])
    end
  end

  context "with valid inputs" do
    it "creates a new clinic appointment" do
      user = login_as_clinical
      patient = create(:clinics_patient, by: user)
      clinic = create(:clinic, name: "Clinic A")

      visit appointments_path

      within(".page-heading") do
        click_on t("btn.add")
      end

      expect(page).to have_current_path(new_appointment_path)
      expect(page).to have_content("Clinic Appointments / New")

      # Patient visibility testing...
      # Use and patient should have a hospital centre set, and the hosp must be a host site
      # otherwise.. nada
      expect(patient.hospital_centre).to eq(user.hospital_centre)
      expect(patient.hospital_centre.host_site).to be(true)

      within(".new_clinics_appointment") do
        slim_select(
          patient.to_s(:long),
          from: "Patient",
          wait_for: "Enter at least 3 characters"
        )

        select clinic.name, from: "Clinic"
        fill_in "Starts at", with: 10.days.from_now.strftime("%Y-%m-%d %H:%M")
        fill_in "Outcome notes", with: "Outcome notes"
        fill_in "DNA notes", with: "DNA notes"
        click_on t("btn.create")
      end

      expect(page).to have_no_content("Clinic Appointments / New")

      within("#appointments") do
        expect(page).to have_content(patient.to_s)
        expect(page).to have_content(clinic.to_s)
      end

      appointment = Renalware::Clinics::Appointment.last
      expect(appointment).to have_attributes(
        outcome_notes: "Outcome notes",
        dna_notes: "DNA notes"
      )
    end
  end

  def request_form_patient_ids
    all(
      "#appointment-request-form input[name='request[patient_ids][]']",
      visible: :all
    ).map(&:value)
  end
end
