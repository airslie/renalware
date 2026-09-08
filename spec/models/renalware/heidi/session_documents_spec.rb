describe Renalware::Heidi::SessionDocuments do
  subject(:fetch) { described_class.new(session:, client:).call }

  let(:session) { build_stubbed(:heidi_session) }
  let(:client) { instance_double(Renalware::Heidi::SessionsClient) }
  let(:note) { { "status" => "COMPLETED", "result" => "**Revised note**" } }
  let(:documents) do
    [{ "id" => "letter", "name" => "Referral", "content" => "New letter" }]
  end

  before do
    allow(client).to receive(:get).with(session.user, session.heidi_session_id)
      .and_return(result("session" => { "consult_note" => note }))
    allow(client).to receive(:documents).with(session.user, session.heidi_session_id)
      .and_return(result("documents" => documents))
  end

  it "returns the latest main note and additional documents without updating the session" do
    allow(session).to receive(:update!)
    expect(fetch).to eq([
                          { id: "consult_note", name: "Main note",
                            content: "<p><strong>Revised note</strong></p>" },
                          { id: "letter", name: "Referral", content: "<p>New letter</p>" }
                        ])
    expect(session).not_to have_received(:update!)
  end

  it "also accepts content returned with CREATED status" do
    note["status"] = "CREATED"
    expect(fetch.first[:content]).to eq("<p><strong>Revised note</strong></p>")
  end

  it "returns completed additional documents" do
    documents.first["status"] = "COMPLETED"
    expect(fetch.last[:content]).to eq("<p>New letter</p>")
  end

  it "keeps completed notes without content unavailable" do
    note["result"] = ""
    expect(fetch.first[:content]).to be_nil
  end

  it "withholds old content while the main note is generating" do
    note["status"] = "GENERATING"
    expect(fetch.first[:content]).to be_nil
  end

  it "keeps empty documents available as pending choices" do
    documents.first["content"] = ""
    expect(fetch.last).to include(name: "Referral", content: nil)
  end

  it "sanitizes HTML documents" do
    documents.first.merge!("content_type" => "HTML", "content" => '<p onclick="bad()">Letter</p>')
    expect(fetch.last[:content]).to eq("<p>Letter</p>")
  end

  it "fails the refresh if the documents request fails" do
    allow(client).to receive(:documents).and_return(
      Renalware::Heidi::BaseClient::Result.new(success: false)
    )
    expect { fetch }.to raise_error(described_class::FetchError)
  end

  def result(body)
    Renalware::Heidi::BaseClient::Result.new(success: true, body:)
  end
end
