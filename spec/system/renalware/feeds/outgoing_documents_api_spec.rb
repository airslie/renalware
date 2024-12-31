describe "Outgoing Documents API" do
  let(:api_user) do
    create(
      :user,
      username: "xyz",
      authentication_token: "wWsSmmHywhYMWPM6e9ib"
    )
  end

  describe "authorisation" do
    context "when no credentials supplied" do
      it "redirects to the login page" do
        get feeds_queued_outgoing_documents_path

        expect(response).to be_unauthorized
      end
    end

    context "when invalid credentials supplied" do
      it "redirects to login page when provided username does not exist" do
        get feeds_queued_outgoing_documents_path(
          username: "nothing",
          token: "doing"
        )

        expect(response).to be_unauthorized
      end

      it "returns unathorised when provided token in valid does not exist" do
        get feeds_queued_outgoing_documents_path(
          username: api_user.username,
          token: "bla"
        )

        expect(response).to be_unauthorized
      end
    end

    context "when valid credentials supplied" do
      it do
        get feeds_queued_outgoing_documents_path(
          username: api_user.username,
          token: api_user.authentication_token
        )

        expect(response).to be_successful
      end
    end
  end

  describe "index.json" do
    it "responds successfully with a paginated list of queued documents" do
      user = create(:user)
      event = create(:swab, by: user)
      queued_ev1 = Renalware::Feeds::OutgoingDocument.create!(
        renderable: event,
        by: user,
        created_at: 1.day.ago
      )
      queued_ev2 = Renalware::Feeds::OutgoingDocument.create!(
        renderable: event,
        by: user,
        created_at: 10.days.ago
      )

      get feeds_queued_outgoing_documents_path(
        username: api_user.username,
        token: api_user.authentication_token
      )

      expect(response.media_type).to eq("application/json")
      docs = JSON.parse(response.body).with_indifferent_access
      expect(docs).to eq(
        {
          documents: [
            {
              id: queued_ev2.id,
              state: queued_ev2.state,
              url: feeds_queued_outgoing_document_url(
                queued_ev2,
                protocol: :http,
                host: "www.example.com"
              )
            },
            {
              id: queued_ev1.id,
              state: queued_ev1.state,
              url: feeds_queued_outgoing_document_url(
                queued_ev1,
                protocol: :http,
                host: "www.example.com"
              )
            }
          ]
        }.with_indifferent_access
      )
    end

    describe "show.json" do
      it "responds successfully with json containing an HL7 doc" do
        user = create(:user)
        event = create(:swab, by: user)
        Renalware.config.ukrdc_site_code = "RJZ"
        create(:hospital_centre, code: "RJZ")

        queued_doc = Renalware::Feeds::OutgoingDocument.create!(
          renderable: event,
          by: user,
          created_at: 1.day.ago,
          state: :queued
        )

        get feeds_queued_outgoing_document_path(
          id: queued_doc.id,
          username: api_user.username,
          token: api_user.authentication_token
        )

        expect(response.media_type).to eq("application/json")
        doc = JSON.parse(response.body).with_indifferent_access

        expect(doc[:id]).to eq(queued_doc.id)
        expect(doc[:state]).to eq("queued")
        # expect(doc[:body]).to eq("SOME HL7")
      end
    end

    describe "update.json" do
      it "updates the status to processed" do
        user = create(:user)
        event = create(:swab, by: user)
        Renalware.config.ukrdc_site_code = "RJZ"
        create(:hospital_centre, code: "RJZ")

        queued_doc = Renalware::Feeds::OutgoingDocument.create!(
          renderable: event,
          by: user,
          created_at: 1.day.ago,
          state: :queued
        )

        patch feeds_queued_outgoing_document_path(
          id: queued_doc.id,
          username: api_user.username,
          token: api_user.authentication_token
        )

        expect(response.media_type).to eq("application/json")
        JSON.parse(response.body).with_indifferent_access

        expect(queued_doc.reload.state).to eq("processed")
      end
    end
  end
end
