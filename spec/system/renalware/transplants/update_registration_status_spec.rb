describe "Update wait list registration status" do
  # This exercises a bug I am trying to fix, where in certain circumstances
  # (I'm trying to ascertain these) adding a new registration status causes the error
  #   PG::UniqueViolation: ERROR: duplicate key value violates unique constraint
  #     "transplant_registration_statuses_pkey" DETAIL: Key (id)=(1) already exists
  #
  # Params to POST
  #  "transplants_registration_status"=>{
  #    "description_id"=>"1",
  #    "started_on"=>"28-Apr-2017"
  #  },
  #  "commit"=>"Save",
  #  "expect"=>[:index, :destroy],
  #  "patient_id"=>"1"}

  describe "POST create" do
    it "creates a new wait list registration" do
      patient = create(:transplant_patient)
      registration = create(:transplant_registration, patient: patient)
      create(:transplant_registration_status,
             registration: registration,
             started_on: Time.zone.now,
             notes: "Some notes")

      login_as_clinical
      visit new_patient_transplants_registration_status_path(patient)

      within ".document form" do
        select "Active", from: "Description"
        fill_in "Started on", with: "28-Apr-2017"
        fill_in "Notes", with: "My notes"
        click_on t("btn.create")
      end

      expect(page).to have_current_path(patient_transplants_recipient_dashboard_path(patient))

      patient.reload
      registrations = Renalware::Transplants::Registration.for_patient(patient)
      expect(registrations.length).to eq(1)
      registration = registrations.first
      expect(registration.statuses.length).to eq(2)
      status = registration.statuses.last
      expect(status.started_on).to eq(Date.parse("28-Apr-2017"))
      expect(status.notes).to eq("My notes")
    end
  end
end
