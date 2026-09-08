describe "Heidi document previews" do
  let(:user) { @current_user }
  let(:patient) { create(:clinics_patient, by: user) }
  let(:clinic_visit) { create(:clinic_visit, patient:, by: user, notes: "Keep these notes") }
  let(:session) { create(:heidi_session, clinic_visit:, patient:, user:) }
  let(:fetcher) { instance_double(Renalware::Heidi::SessionDocuments) }

  around do |example|
    original = Renalware.config.heidi_enabled
    Renalware.config.heidi_enabled = true
    example.run
  ensure
    Renalware.config.heidi_enabled = original
  end

  before do
    allow(Renalware::Heidi::SessionDocuments).to receive(:new).with(session:)
      .and_return(fetcher)
    allow(fetcher).to receive(:call).and_return([{ id: "letter", content: "Updated letter" }])
  end

  it "fetches a preview without saving over notes or the imported note" do
    original_note = session.consult_note
    get_documents
    expect(response).to be_successful
    expect(response.parsed_body["documents"].first["content"]).to eq("Updated letter")
    expect(response.headers["Cache-Control"]).to include("no-store")
    expect(clinic_visit.reload.notes).to eq("Keep these notes")
    expect(session.reload.consult_note).to eq(original_note)
  end

  it "rejects a session from another visit" do
    other_session = create(:heidi_session)
    expect { get_documents(session_id: other_session.id) }
      .to raise_error(ActiveRecord::RecordNotFound)
    expect(fetcher).not_to have_received(:call)
  end

  it "respects the feature gate" do
    Renalware.config.heidi_enabled = false
    get_documents
    expect(response).to have_http_status(:not_found)
  end

  it "reports a refresh failure without changing notes" do
    allow(fetcher).to receive(:call).and_raise(Renalware::Heidi::SessionDocuments::FetchError)
    get_documents
    expect(response).to have_http_status(:bad_gateway)
    expect(clinic_visit.reload.notes).to eq("Keep these notes")
  end

  def get_documents(session_id: session.id)
    get documents_patient_clinic_visit_heidi_session_path(patient, clinic_visit),
        params: { session_id: }, headers: { "ACCEPT" => "application/json" }
  end
end
