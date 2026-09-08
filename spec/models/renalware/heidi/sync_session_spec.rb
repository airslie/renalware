describe Renalware::Heidi::SyncSession do
  subject(:sync) { described_class.new(session:, client:) }

  let(:session) { create(:heidi_session) }
  let(:client) { instance_double(Renalware::Heidi::SessionsClient) }

  it "stores a completed consult note" do
    stub_heidi_response("**Generated** renal clinic note")

    sync.call

    expect(session.reload).to be_synced
    expect(session.consult_note_status).to eq("COMPLETED")
    expect(session.consult_note).to eq("<p><strong>Generated</strong> renal clinic note</p>")
    expect(session.last_synced_at).to be_present
    expect(session.sync_error).to be_nil
  end

  it "appends the completed consult note to the associated clinic visit notes" do
    clinic_visit = create(:clinic_visit, notes: "Existing notes")
    session.update!(clinic_visit:)
    stub_heidi_response(<<~MARKDOWN)
      ## Assessment

      - Stable CKD
      - Continue current treatment
    MARKDOWN

    sync.call

    notes = clinic_visit.reload.notes
    expect(notes).to include("Existing notes")
    expect(notes).to include("<p><strong>Assessment</strong></p>")
    expect(notes).to include("<li>Stable CKD</li>")
    expect(notes).to include("<li>Continue current treatment</li>")
    expect(session.reload.consult_note_inserted_at).to be_present
  end

  it "separates the appended consult note from existing notes that aren't block-wrapped" do
    clinic_visit = create(:clinic_visit, notes: "Existing notes")
    session.update!(clinic_visit:)
    stub_heidi_response("Generated note")

    sync.call

    expect(clinic_visit.reload.notes).to eq("Existing notes<br><p>Generated note</p>")
  end

  it "respects an override saved while the API request was in flight" do
    clinic_visit = create(:clinic_visit, notes: "Replacement document")
    session.update!(clinic_visit:)
    allow(client).to receive(:get) do
      Renalware::Heidi::Session.find(session.id).update!(notes_superseded_at: Time.current)
      completed_heidi_response("Default note")
    end

    sync.call

    expect(clinic_visit.reload.notes).to eq("Replacement document")
    expect(session.reload).to be_synced
    expect(session.consult_note).to eq("<p>Default note</p>")
    expect(session.consult_note_inserted_at).to be_nil
  end

  it "allows a new session to import after an earlier session was superseded" do
    clinic_visit = create(:clinic_visit, notes: "Replacement document")
    create(:heidi_session, clinic_visit:, notes_superseded_at: Time.current)
    session.update!(clinic_visit:)
    stub_heidi_response("New session note")

    sync.call

    expect(clinic_visit.reload.notes).to eq("Replacement document<br><p>New session note</p>")
    expect(session.reload.consult_note_inserted_at).to be_present
  end

  it "does not append the consult note twice from stale sync instances" do
    clinic_visit = create(:clinic_visit, notes: "Existing notes")
    session.update!(clinic_visit:)
    stale_session = Renalware::Heidi::Session.find(session.id)
    other_stale_session = Renalware::Heidi::Session.find(session.id)
    stale_client = instance_double(Renalware::Heidi::SessionsClient)
    other_stale_client = instance_double(Renalware::Heidi::SessionsClient)
    response = completed_heidi_response("Completed note")
    allow(stale_client).to receive(:get).and_return(response)
    allow(other_stale_client).to receive(:get).and_return(response)

    described_class.new(session: stale_session, client: stale_client).call
    described_class.new(session: other_stale_session, client: other_stale_client).call

    expect(clinic_visit.reload.notes.scan("<p>Completed note</p>").size).to eq(1)
    expect(session.reload.consult_note_inserted_at).to be_present
  end

  it "does not append the consult note again when the Heidi note was already stored" do
    clinic_visit = create(:clinic_visit, notes: "Existing notes")
    session.update!(clinic_visit:, consult_note: "Previously synced note")
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: {
          "session" => {
            "consult_note" => {
              "status" => "COMPLETED",
              "result" => "Previously synced note"
            }
          }
        }
      )
    )

    sync.call

    expect(clinic_visit.reload.notes).to eq("Existing notes")
  end

  it "does not append the consult note again when it has already been inserted" do
    clinic_visit = create(:clinic_visit, notes: "Existing notes")
    session.update!(
      clinic_visit:,
      consult_note_inserted_at: Time.zone.now
    )
    stub_heidi_response("Previously inserted note")

    sync.call

    expect(clinic_visit.reload.notes).to eq("Existing notes")
    expect(session.reload.consult_note).to eq("<p>Previously inserted note</p>")
  end

  it "leaves the session launched when the consult note is not ready" do
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: true,
        status: 200,
        body: { "session" => { "consult_note" => { "status" => "CREATED" } } }
      )
    )

    sync.call

    expect(session.reload).to be_launched
    expect(session.consult_note_status).to eq("CREATED")
    expect(session.consult_note).to be_nil
    expect(session.consult_note_inserted_at).to be_nil
    expect(session.last_synced_at).to be_present
  end

  it "records poll errors without marking the session as failed" do
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: false,
        status: 403,
        body: {},
        error: "not linked"
      )
    )

    sync.call

    expect(session.reload).to be_launched
    expect(session.sync_error).to eq("not linked")
    expect(session.last_synced_at).to be_present
  end

  it "does not downgrade an already synced session after a later poll error" do
    synced_at = 1.hour.ago
    session.update!(
      status: :synced,
      consult_note: "<p>Completed note</p>",
      last_synced_at: synced_at
    )
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      Renalware::Heidi::Client::Result.new(
        success: false,
        status: 503,
        body: {},
        error: "Heidi unavailable"
      )
    )

    sync.call

    expect(session.reload).to be_synced
    expect(session.consult_note).to eq("<p>Completed note</p>")
    expect(session.last_synced_at).to be_within(1.second).of(synced_at)
    expect(session.sync_error).to be_nil
  end

  def stub_heidi_response(markdown)
    allow(client).to receive(:get).with(session.user, session.heidi_session_id).and_return(
      completed_heidi_response(markdown)
    )
  end

  def completed_heidi_response(markdown)
    Renalware::Heidi::Client::Result.new(
      success: true,
      status: 200,
      body: {
        "session" => {
          "consult_note" => {
            "status" => "COMPLETED",
            "result" => markdown
          }
        }
      }
    )
  end
end
