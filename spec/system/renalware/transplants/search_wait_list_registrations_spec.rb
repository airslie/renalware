describe "Search wait list registrations by UKT number" do
  def create_tx_patient_with_active_status_and_ukt_number(ukt_number, user)
    modality_description = create(:modality_description, :transplant)
    create(:transplant_patient).tap do |patient|
      registration = create(
        :transplant_registration,
        :in_status,
        status: "active",
        patient: patient
      )
      registration.document.codes.uk_transplant_patient_recipient_number = ukt_number
      registration.save!
      create(:modality_change_type, :default)
      Renalware::Modalities::ChangePatientModality
        .new(patient: patient, user: user)
        .call(description: modality_description, started_on: Time.zone.now)
    end
  end
  context "when a patient with a status of active has a UKT number" do
    it "the patient is listed under the All tab" do
      user = login_as_clinical
      patient = create_tx_patient_with_active_status_and_ukt_number("X123", user)

      registration = Renalware::Transplants::Registration.for_patient(patient).first
      expect(registration.document.codes.uk_transplant_patient_recipient_number).to eq("X123")

      visit transplants_wait_list_path(named_filter: "all")

      expect(page).to have_content("Transplant Wait List Registrations")
      expect(page).to have_css("dl.sub-nav dd:first-child.active:contains('All')")
      within(".wait-list-registrations-table") do
        expect(page).to have_content(patient.to_s)
      end
    end

    context "when I search with a string that only partially matches their UKT number" do
      it "doesn't find them" do
        user = login_as_clinical
        patient = create_tx_patient_with_active_status_and_ukt_number("X123", user)

        visit transplants_wait_list_path(named_filter: "all")

        within ".main-content" do
          fill_in "UKT recipient number", with: "X12"
          page.find(".search-registrations").click
          expect(page).to have_no_content(patient.to_s)
        end
      end
    end

    context "when I search with a string that exactly matches their UKT number" do
      it "finds them" do
        user = login_as_clinical
        patient = create_tx_patient_with_active_status_and_ukt_number("X123", user)

        visit transplants_wait_list_path(named_filter: "all")

        within ".main-content" do
          fill_in "UKT recipient number", with: "X123"
          page.find(".search-registrations").click
          expect(page).to have_content(patient.to_s)
        end
      end
    end
  end
end
