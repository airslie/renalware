describe "Configuring Event Types" do
  let(:event_type) { create(:access_clinic_event_type) }

  describe "GET new" do
    it "responds with a form" do
      get new_events_type_path

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new record" do
        category = create(:event_category)
        attributes = attributes_for(:access_clinic_event_type).merge(category_id: category.id)
        post events_types_path, params: { events_type: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Events::Type).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }
        post events_types_path, params: { events_type: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_events_type_path(event_type)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { name: "My Edited Event" }
        patch events_type_path(event_type), params: { events_type: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Events::Type).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }
        patch events_type_path(event_type), params: { events_type: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete events_type_path(event_type)
      expect(response).to have_http_status(:redirect)

      expect(Renalware::Events::Type).not_to exist(id: event_type.id)

      follow_redirect!
      expect(response).to be_successful
    end
  end
end
