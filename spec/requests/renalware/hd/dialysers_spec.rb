# frozen_string_literal: true

describe "Managing Dialysers" do
  let(:dialyser) { create(:hd_dialyser) }

  describe "GET new" do
    it "responds with a form" do
      get new_hd_dialyser_path

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:hd_dialyser)
        post hd_dialysers_path, params: { hd_dialyser: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::HD::Dialyser).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }
        post hd_dialysers_path, params: { hd_dialyser: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_hd_dialyser_path(dialyser)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { name: "Something" }
        patch hd_dialyser_path(dialyser), params: { hd_dialyser: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::HD::Dialyser).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }
        patch hd_dialyser_path(dialyser), params: { hd_dialyser: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete hd_dialyser_path(dialyser)
      expect(response).to have_http_status(:redirect)

      expect(Renalware::HD::Dialyser).not_to exist(id: dialyser.id)

      follow_redirect!
      expect(response).to be_successful
    end
  end
end
