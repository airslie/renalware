describe "Configuring Modality Descriptions" do
  let(:modality_description) { create(:modality_description) }

  describe "GET new" do
    it "responds with a form" do
      get new_modalities_description_path

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:modality_description, allow_hd: true)

        post modalities_descriptions_path, params: { modalities_description: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Modalities::Description).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }

        post modalities_descriptions_path, params: { modalities_description: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "GET index" do
    it "responds successfully" do
      get modalities_descriptions_path

      expect(response).to be_successful
      expect(response.body).to include("Allow HD")
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_modalities_description_path(modality_description)

      expect(response).to be_successful
      expect(Capybara.string(response.body)).to have_field("Allow HD", type: "checkbox")
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = {
          name: "My Edited Modality Description",
          hidden: true,
          allow_hd: true
        }

        patch modalities_description_path(modality_description),
              params: { modalities_description: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Modalities::Description).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    it "allows HD to be disabled" do
      modality_description.update!(allow_hd: true)

      patch modalities_description_path(modality_description),
            params: { modalities_description: { allow_hd: "0" } }

      expect(response).to have_http_status(:redirect)
      expect(modality_description.reload.allow_hd).to be(false)
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }

        patch modalities_description_path(modality_description),
              params: { modalities_description: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    it "soft deletes the modality description" do
      delete modalities_description_path(modality_description)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::Modalities::Description).not_to exist(id: modality_description.id)

      follow_redirect!

      expect(response).to be_successful
    end
  end
end
