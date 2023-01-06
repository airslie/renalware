# frozen_string_literal: true

require "rails_helper"

describe "Configuring Drugs" do
  let(:drug) { create(:drug) }

  describe "GET new" do
    it "responds with a form" do
      get new_drugs_drug_path

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:drug)

        post drugs_drugs_path, params: { drugs_drug: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Drugs::Drug).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }

        post drugs_drugs_path, params: { drugs_drug: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "GET index" do
    it "responds successfully" do
      get drugs_drugs_path

      expect(response).to be_successful
    end
  end

  describe "GET index as JSON" do
    it "responds with json" do
      create(:drug, name: "::drug name::")

      get drugs_drugs_path, params: { format: :json }

      expect(response).to be_successful

      parsed_json = JSON.parse(response.body)

      expect(parsed_json.size).to eq(1)
      expect(parsed_json.first["name"]).to eq("::drug name::")
    end
  end

  describe "GET index with search" do
    it "responds with a filtered list of records matching the query" do
      create(:drug, name: "::target drug name::")
      create(:drug, name: "::another drug name::")

      get drugs_drugs_path, params: { q: { name_or_drug_types_name_start: "::target" } }

      expect(response).to be_successful
      expect(response.body).to match("::target drug name::")
      expect(response.body).not_to match("::another drug name::")
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_drugs_drug_path(drug)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { name: "::drug_name::" }

        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Drugs::Drug).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }

        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the drug" do
      delete drugs_drug_path(drug)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::Drugs::Drug).not_to exist(id: drug.id)

      follow_redirect!

      expect(response).to be_successful
    end
  end
end
