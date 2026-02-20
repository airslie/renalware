RSpec.describe "Copy HD session to clipboard", :js do
  let(:nurse) { create(:user, role: "clinical") }
  let(:patient) { create(:hd_patient, :with_hd_modality) }
  let(:hospital_unit) { create(:hd_hospital_unit) }
  let!(:hd_session) do
    create(
      :hd_closed_session,
      patient:,
      hospital_unit:,
      by: nurse
    )
  end

  before do
    login_as nurse
  end

  describe "copying session details to clipboard" do
    it "displays a copy icon in the sessions list with the correct data attributes" do
      visit patient_hd_dashboard_path(patient)

      within_article "Latest HD Sessions" do
        # Verify the copy link exists with correct Stimulus attributes
        copy_link = find('a[data-controller="clipboard-async"]')
        expect(copy_link).to be_present
        expect(copy_link["data-action"]).to eq("clipboard-async#copy")

        # Check the URL value (Stimulus converts to url-value in HTML)
        url_value = copy_link["data-clipboard-async-url-value"]
        expect(url_value).to include("/hd/session_clipboards/#{hd_session.id}")
      end
    end

    it "displays a copy button on the session show page" do
      visit patient_hd_session_path(patient, hd_session)

      # Verify the copy link exists in the actions bar
      copy_link = find('a[data-controller="clipboard-async"]')
      expect(copy_link).to be_present
      expect(copy_link["data-action"]).to eq("clipboard-async#copy")

      # Check the URL value
      url_value = copy_link["data-clipboard-async-url-value"]
      expect(url_value).to include("/hd/session_clipboards/#{hd_session.id}")
    end

    it "renders the correct text format when fetching clipboard content" do
      # Make a direct request to the clipboard endpoint to verify the format
      visit patient_hd_session_clipboard_path(patient, hd_session, format: :text)

      expect(page).to have_content("NHS: #{patient.nhs_number}")
      expect(page).to have_content("MRN: #{patient.local_patient_id}")
      expect(page).to have_content("Hospital Unit:")
      expect(page).to have_content(hospital_unit.unit_code)
      expect(page).to have_content("Duration:")
      expect(page).to have_content("Put On By:")
      expect(page).to have_content("Pre-weight:")
      expect(page).to have_content("Post-weight:")
    end
  end
end
