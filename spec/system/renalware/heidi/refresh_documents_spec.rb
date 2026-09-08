module Renalware
  describe "Refreshing Heidi documents", :js do
    let(:user) { create(:user, :clinical) }
    let(:patient) { create(:clinics_patient, by: user) }
    let(:clinic_visit) { create(:clinic_visit, patient:, by: user, notes: "Clinician edits") }
    let(:session) { create(:heidi_session, patient:, clinic_visit:, user:, status: :synced) }
    let(:fetcher) { instance_double(Heidi::SessionDocuments) }

    around do |example|
      original = Renalware.config.heidi_enabled
      Renalware.config.heidi_enabled = true
      example.run
    ensure
      Renalware.config.heidi_enabled = original
    end

    before do
      session
      allow(Heidi::SessionDocuments).to receive(:new).with(session:).and_return(fetcher)
      allow(fetcher).to receive(:call).and_return([
                                                    { id: "consult_note", name: "Main note",
                                                      content: nil },
                                                    { id: "letter", name: "Referral",
                                                      content: "<p>Updated referral</p>" }
                                                  ])
      login_as user
      visit edit_patient_clinic_visit_path(patient, clinic_visit)
    end

    it "previews documents, preserves notes on cancellation and replaces only after confirmation" do
      click_button "Check for updates"
      expect(page).to have_text "This document is not ready"
      expect(page).to have_button "Replace Notes", disabled: true
      select "Referral", from: "Heidi document"
      expect(page).to have_text "Updated referral"
      expect(find("trix-editor")).to have_text "Clinician edits"

      dismiss_confirm { click_button "Replace Notes" }
      expect(find("trix-editor")).to have_text "Clinician edits"
      expect(session.reload.notes_superseded_at).to be_nil

      # An automatic import finishing while the form is open must not be appended on save.
      session.update!(consult_note: "Earlier automatic import",
                      consult_note_inserted_at: Time.current)
      accept_confirm { click_button "Replace Notes" }
      expect(find("trix-editor")).to have_text "Updated referral"
      expect(find("trix-editor")).to have_no_text "Clinician edits"
      expect(clinic_visit.reload.notes).to eq("Clinician edits")
      expect(session.reload.notes_superseded_at).to be_nil
      click_button "Save"
      expect(clinic_visit.reload.notes).to include("Updated referral")
      expect(clinic_visit.notes).not_to include("Earlier automatic import")
      expect(session.reload.notes_superseded_at).to be_present
    end

    it "does not disable imports when the replacement is abandoned" do
      click_button "Check for updates"
      select "Referral", from: "Heidi document"
      accept_confirm { click_button "Replace Notes" }
      visit patient_clinic_visits_path(patient)

      expect(clinic_visit.reload.notes).to eq("Clinician edits")
      expect(session.reload.notes_superseded_at).to be_nil
    end

    it "shows loading inside the button until the fetch completes" do
      page.execute_script(<<~JS)
        const originalFetch = window.fetch;
        window.fetch = async (...args) => {
          const released = new Promise(resolve => { window.releaseHeidiFetch = resolve; });
          const response = await originalFetch(...args);
          await released;
          return response;
        };
      JS
      click_button "Check for updates"
      expect(page).to have_button "Checking Heidi…", disabled: true
      expect(page).to have_css('button[aria-busy="true"] [data-refresh-spinner]', visible: :visible)
      status = find('[data-heidi-session-poller-target="refreshStatus"]', visible: :all)
      expect(status.text).to be_empty
      page.execute_script("window.releaseHeidiFetch()")
      expect(page).to have_button "Check for updates", disabled: false
      expect(page).to have_no_css("[data-refresh-spinner]", visible: :visible)
      expect(page).to have_no_text "Latest available content fetched"
    end

    it "keeps notes when fetching fails and allows retrying" do
      allow(fetcher).to receive(:call).and_raise(Heidi::SessionDocuments::FetchError)
      click_button "Check for updates"
      expect(page).to have_text "Unable to fetch Heidi documents"
      expect(find("trix-editor")).to have_text "Clinician edits"
      expect(page).to have_button "Check for updates", disabled: false
    end
  end
end
