describe "Clinic Visits Management" do
  around do |example|
    original = Renalware.config.heidi_enabled
    example.run
  ensure
    Renalware.config.heidi_enabled = original
  end

  let(:user) { @current_user }
  let(:clinic) { create(:clinic) }
  let(:patient) { create(:clinics_patient, by: user) }
  let(:valid_clinic_visit_params) do
    {
      date: Time.zone.today,
      time: Time.zone.now,
      clinic_id: clinic.id,
      did_not_attend: false,
      height: 1.75,
      weight: 89.2,
      bp: "110/78",
      urine_blood: "neg",
      urine_protein: "neg",
      urine_glucose: "high",
      notes: "Nothing unusual"
    }
  end

  describe "GET index" do
    it "responds successfully" do
      get patient_clinic_visits_path(patient_id: patient.to_param)

      expect(response).to be_successful
    end

    it "shows the latest Heidi session state for linked clinic visits" do
      Renalware.config.heidi_enabled = true
      clinic_visit = create(:clinic_visit, patient:, by: user)
      create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        status: :synced
      )

      get patient_clinic_visits_path(patient_id: patient.to_param)

      expect(response.body).to include("Heidi state")
      expect(response.body).to include("heidi-state--synced")
      expect(response.body).to include("Synced")
    end

    it "hides the Heidi state column when Heidi is disabled" do
      Renalware.config.heidi_enabled = false
      clinic_visit = create(:clinic_visit, patient:, by: user)
      create(:heidi_session, patient:, clinic_visit:, user:, status: :synced)

      get patient_clinic_visits_path(patient_id: patient.to_param)

      expect(response.body).not_to include("Heidi state")
      expect(response.body).not_to include("heidi-state--synced")
    end
  end

  describe "GET new" do
    it "responds successfully" do
      get new_patient_clinic_visit_path(patient_id: patient.to_param)
      expect(response).to be_successful
    end

    it "shows a Heidi launch button when Heidi is configured" do
      Renalware.config.heidi_enabled = true
      allow(Renalware::Heidi::Client).to receive(:configured?).and_return(true)

      get new_patient_clinic_visit_path(patient_id: patient.to_param)

      expect(response.body).to include("Save and launch Heidi")
      expect(response.body).to include(heidi_preparation_path)
      expect(response.body).to include(patient_heidi_linked_account_path(patient))
      expect(response.body).to include(new_patient_heidi_linked_account_path(patient))
    end

    it "hides the Heidi launch button when Heidi is disabled" do
      Renalware.config.heidi_enabled = false
      allow(Renalware::Heidi::Client).to receive(:configured?).and_return(true)

      get new_patient_clinic_visit_path(patient_id: patient.to_param)

      expect(response.body).not_to include("Save and launch Heidi")
      expect(response.body).not_to include(heidi_preparation_path)
    end
  end

  describe "POST create" do
    it "redirects to the clinic visits index" do
      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: { clinic_visit: valid_clinic_visit_params }

      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end

    it "launches Heidi after saving the clinic visit" do
      Renalware.config.heidi_enabled = true
      heidi_session = build_stubbed(:heidi_session, heidi_session_id: "heidi-session-1")
      launcher = instance_double(
        Renalware::Heidi::LaunchClinicVisitSession,
        call: instance_double(
          Renalware::Heidi::LaunchClinicVisitSession::Result,
          success?: true,
          session: heidi_session
        )
      )
      allow(Renalware::Heidi::LaunchClinicVisitSession).to receive(:new).and_return(launcher)

      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: {
             launch_heidi: "Save and launch Heidi",
             clinic_visit: valid_clinic_visit_params
           }

      visit = patient.clinic_visits.order(:created_at).last
      expect(Renalware::Heidi::LaunchClinicVisitSession).to have_received(:new)
        .with(clinic_visit: visit, user:)
      expect(response).to be_successful
      expect(response.body).to include("https://registrar.scribe.heidihealth.com/scribe/session/heidi-session-1")
      expect(response.body).to include(edit_patient_clinic_visit_path(patient, visit))
    end

    it "shows the Heidi launch failure in the preparation tab" do
      Renalware.config.heidi_enabled = true
      launcher = instance_double(
        Renalware::Heidi::LaunchClinicVisitSession,
        call: instance_double(
          Renalware::Heidi::LaunchClinicVisitSession::Result,
          success?: false,
          error: "Your Renalware account is not linked to Heidi yet.",
          link_account_url: "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt"
        )
      )
      allow(Renalware::Heidi::LaunchClinicVisitSession).to receive(:new).and_return(launcher)

      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: {
             launch_heidi: "Save and launch Heidi",
             clinic_visit: valid_clinic_visit_params
           }

      visit = patient.clinic_visits.order(:created_at).last
      expect(response).to be_successful
      expect(response.body).to include("Heidi could not be launched")
      expect(response.body).to include("Your Renalware account is not linked to Heidi yet.")
      expect(response.body).to include(
        "https://registrar.scribe.heidihealth.com/integration/widget/auth?t=jwt"
      )
      expect(response.body).to include(edit_patient_clinic_visit_path(patient, visit))
    end

    it "does not launch Heidi when the clinic visit is invalid" do
      Renalware.config.heidi_enabled = true
      allow(Renalware::Heidi::LaunchClinicVisitSession).to receive(:new)

      post patient_clinic_visits_path(patient_id: patient.to_param),
           params: {
             launch_heidi: "Save and launch Heidi",
             clinic_visit: valid_clinic_visit_params.merge(date: nil)
           }

      expect(Renalware::Heidi::LaunchClinicVisitSession).not_to have_received(:new)
      expect(response).to be_successful
      expect(response.body).to include("Address the validation errors before launching Heidi.")
      expect(response.body).to include(
        'data-heidi-clinic-visit-launch-close-preparation-tab-value="true"'
      )
    end
  end

  describe "GET edit" do
    let(:clinic_visit) { create(:clinic_visit, patient:, by: user) }

    before do
      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end

    it "shows attached Heidi session status" do
      Renalware.config.heidi_enabled = true
      create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        consult_note_status: "CREATED"
      )

      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)

      expect(response.body).to include("Heidi")
      expect(response.body).to include("heidi-state--launched")
      expect(response.body).to include("Launched")
      expect(response.body).to include("CREATED")
    end

    it "polls the latest launched Heidi session" do
      Renalware.config.heidi_enabled = true
      create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        status: :launched
      )

      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)

      expect(response.body).to include("heidi-session-poller")
      expect(response.body).to include(
        patient_clinic_visit_heidi_session_path(patient, clinic_visit)
      )
    end

    it "hides the Heidi progress summary when Heidi is disabled" do
      Renalware.config.heidi_enabled = false
      create(:heidi_session, patient:, clinic_visit:, user:, status: :launched)

      get edit_patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)

      expect(response.body).not_to include('data-controller="heidi-session-poller"')
      expect(response.body).not_to include("heidi-state--launched")
    end
  end

  describe "GET heidi_session" do
    let(:clinic_visit) { create(:clinic_visit, patient:, by: user) }

    it "returns the latest Heidi session status" do
      session = create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        status: :synced,
        consult_note_status: "CREATED",
        consult_note: "Heidi note",
        last_synced_at: Time.zone.parse("2026-09-02 11:30")
      )

      get patient_clinic_visit_heidi_session_path(patient, clinic_visit), headers: {
        "ACCEPT" => "application/json"
      }

      expect(response).to be_successful
      expect(response.parsed_body).to include(
        "present" => true,
        "id" => session.id,
        "status" => "synced",
        "status_label" => "Synced",
        "consult_note_status" => "CREATED",
        "consult_note" => "Heidi note",
        "synced" => true
      )
      expect(response.parsed_body["last_synced_at"]).to be_present
    end

    it "returns a blank payload when there are no Heidi sessions" do
      get patient_clinic_visit_heidi_session_path(patient, clinic_visit), headers: {
        "ACCEPT" => "application/json"
      }

      expect(response).to be_successful
      expect(response.parsed_body).to eq("present" => false)
    end

    it "returns not found when Heidi is disabled" do
      Renalware.config.heidi_enabled = false

      get patient_clinic_visit_heidi_session_path(patient, clinic_visit), headers: {
        "ACCEPT" => "application/json"
      }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET show" do
    before do
      clinic_visit = create(:clinic_visit, patient:, by: user)
      get patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
    end

    it "responds successfully" do
      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    let(:clinic_visit) { create(:clinic_visit, patient:, by: user) }

    context "with a manual Heidi replacement" do
      let!(:heidi_session) { create(:heidi_session, patient:, clinic_visit:, user:) }
      let!(:other_session) { create(:heidi_session) }
      let(:replacement_params) do
        valid_clinic_visit_params.merge(
          notes: "<p>Replacement document</p>",
          superseded_heidi_session_ids: "#{heidi_session.id},#{other_session.id}"
        )
      end

      it "persists the override only for sessions belonging to the visit" do
        put patient_clinic_visit_path(patient, clinic_visit),
            params: { clinic_visit: replacement_params }

        expect(response).to be_redirect
        expect(clinic_visit.reload.notes).to eq("<p>Replacement document</p>")
        expect(heidi_session.reload.notes_superseded_at).to be_present
        expect(other_session.reload.notes_superseded_at).to be_nil

        client = instance_double(Renalware::Heidi::SessionsClient)
        result = Renalware::Heidi::BaseClient::Result.new(
          success: true,
          body: { "session" => { "consult_note" => { "result" => "Late automatic note" } } }
        )
        allow(client).to receive(:get).and_return(result)
        Renalware::Heidi::SyncSession.new(session: heidi_session, client:).call

        expect(clinic_visit.reload.notes).to eq("<p>Replacement document</p>")
        expect(heidi_session.reload.consult_note).to eq("<p>Late automatic note</p>")
      end

      it "does not persist an override when validation fails and preserves it for retry" do
        put patient_clinic_visit_path(patient, clinic_visit),
            params: { clinic_visit: replacement_params.merge(date: "") }

        expect(heidi_session.reload.notes_superseded_at).to be_nil
        expect(response.body).to include('name="clinic_visit[superseded_heidi_session_ids]"')
        expect(response.body).to include("#{heidi_session.id},#{other_session.id}")
      end

      it "does not mark an override when Notes are not submitted" do
        put patient_clinic_visit_path(patient, clinic_visit),
            params: { clinic_visit: replacement_params.except(:notes) }

        expect(heidi_session.reload.notes_superseded_at).to be_nil
      end

      it "does not preserve an automatic import superseded by the replacement" do
        heidi_session.update!(status: :synced, consult_note: "<p>Automatic note</p>",
                              consult_note_inserted_at: Time.current)
        put patient_clinic_visit_path(patient, clinic_visit), params: {
          clinic_visit: replacement_params.merge(heidi_notes_loaded_at: 5.minutes.ago.iso8601)
        }

        expect(clinic_visit.reload.notes).to eq("<p>Replacement document</p>")
      end
    end

    it "redirects to the clinic_visits index" do
      put patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param),
          params: {
            clinic_visit: {
              date: Time.zone.today,
              time: Time.zone.now,
              did_not_attend: false,
              height: 1.75, weight: 89.2, bp: "110/70",
              urine_blood: "neg",
              urine_protein: "neg",
              urine_glucose: "high",
              notes: "Nothing unusual"
            }
          }

      expect(response).to redirect_to(patient_clinic_visits_path(patient))
    end

    it "preserves Heidi notes inserted after the edit form was loaded " \
       "but not seen by the browser" do
      loaded_at = 5.minutes.ago
      create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        status: :synced,
        consult_note: "<p>Heidi note</p>",
        consult_note_inserted_at: 1.minute.ago
      )

      put patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param),
          params: {
            clinic_visit: valid_clinic_visit_params.merge(
              notes: "<p>Clinician edit</p>",
              heidi_notes_loaded_at: loaded_at.iso8601,
              seen_heidi_session_ids: ""
            )
          }

      expect(clinic_visit.reload.notes).to eq("<p>Clinician edit</p><br><p>Heidi note</p>")
    end

    it "trusts the submitted notes when the browser saw the synced Heidi note" do
      loaded_at = 5.minutes.ago
      heidi_session = create(
        :heidi_session,
        patient:,
        clinic_visit:,
        user:,
        status: :synced,
        consult_note: "<p>Original Heidi note</p>",
        consult_note_inserted_at: 1.minute.ago
      )

      put patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param),
          params: {
            clinic_visit: valid_clinic_visit_params.merge(
              notes: "<p>Clinician edited Heidi note</p>",
              heidi_notes_loaded_at: loaded_at.iso8601,
              seen_heidi_session_ids: heidi_session.id.to_s
            )
          }

      expect(clinic_visit.reload.notes).to eq("<p>Clinician edited Heidi note</p>")
    end
  end

  describe "DELETE destroy" do
    it "deletes a clinic_visit" do
      clinic_visit = create(:clinic_visit, patient:, by: user)
      expect {
        delete patient_clinic_visit_path(patient_id: patient.to_param, id: clinic_visit.to_param)
      }.to change(patient.clinic_visits, :count).by(-1)
    end
  end
end
