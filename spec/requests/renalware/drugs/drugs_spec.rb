describe "Configuring Drugs" do
  include DrugsSpecHelper

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

        refresh_prescribable_drugs_materialized_view
        expect(Renalware::Drugs::PrescribableDrug.count).to eq(0)

        post drugs_drugs_path, params: { drugs_drug: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Drugs::Drug).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful

        expect(Renalware::Drugs::PrescribableDrug.count).to eq(1)
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
    let!(:current_drug) { create(:drug, name: "Current drug") }
    let!(:deleted_drug) { create(:drug, name: "Deleted drug", deleted_at: Time.zone.now) }

    it "defaults to non-deleted drugs" do
      get drugs_drugs_path

      expect(response).to be_successful
      expect(response.body).to include(current_drug.name)
      expect(response.body).not_to include(deleted_drug.name)
      selected_option = response.parsed_body.at_css("#q_deleted_at_not_null option[selected]")
      expect(selected_option.text).to eq("Non-deleted")
    end

    it "shows both current and deleted drugs when All is selected" do
      get drugs_drugs_path, params: { q: { deleted_at_not_null: "" } }

      expect(response).to be_successful
      expect(response.body).to include(current_drug.name, deleted_drug.name, "Deleted at")
      deleted_row = response.parsed_body.at_css("tr#drugs_drug_#{deleted_drug.id}")
      expect(deleted_row["class"]).to eq("deleted")
      expect(deleted_row.css("td").last.text).to eq(I18n.l(deleted_drug.deleted_at))
      expect(deleted_row.css("a")).to be_empty
      current_row = response.parsed_body.at_css("tr#drugs_drug_#{current_drug.id}")
      expect(current_row["class"]).to be_blank
      expect(current_row.css("td").last.text).to be_empty
      expect(current_row.css("a").map(&:text)).to eq(%w(Edit Delete))
      expect(response.parsed_body.at_css("#q_deleted_at_not_null option").text).to eq("All")
    end

    it "filters to non-deleted drugs" do
      get drugs_drugs_path, params: { q: { deleted_at_not_null: "false" } }

      expect(response.body).to include(current_drug.name)
      expect(response.body).not_to include(deleted_drug.name)
    end

    it "filters to deleted drugs" do
      get drugs_drugs_path, params: { q: { deleted_at_not_null: "true" } }

      expect(response.body).to include(deleted_drug.name)
      expect(response.body).not_to include(current_drug.name)
    end

    it "shows all deletion statuses when All is selected" do
      get drugs_drugs_path, params: { q: { deleted_at_not_null: "" } }

      expect(response.body).to include(current_drug.name, deleted_drug.name)
    end

    it "combines deletion status with the existing filters" do
      create(:drug, name: "Other deleted drug", deleted_at: Time.zone.now)
      create(:drug, name: "Deleted inactive drug", deleted_at: Time.zone.now, inactive: true)

      get drugs_drugs_path, params: {
        q: {
          deleted_at_not_null: "true",
          name_or_drug_types_name_start: "Deleted",
          inactive_eq: false
        }
      }

      expect(response.body).to include(deleted_drug.name)
      expect(response.body).not_to include(current_drug.name, "Other deleted drug",
                                           "Deleted inactive drug")
    end
  end

  describe "GET index as JSON" do
    it "responds with json" do
      create(:drug, name: "::drug name::")
      create(:drug, name: "Deleted drug", deleted_at: Time.zone.now)

      get drugs_drugs_path, params: { format: :json }

      expect(response).to be_successful

      parsed_json = response.parsed_body

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

        drug
        refresh_prescribable_drugs_materialized_view
        expect(Renalware::Drugs::PrescribableDrug.count).to eq(1)

        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Drugs::Drug).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful

        expect(Renalware::Drugs::PrescribableDrug.count).to eq(1)
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }

        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(response).to be_successful
      end
    end

    context "when setting trade family" do
      let(:trade_family) { create(:drug_trade_family) }
      let(:trade_family_classification) {
        create(:drug_trade_family_classification,
               drug:,
               trade_family:,
               enabled: false)
      }

      before do
        trade_family_classification
      end

      it "updates a record from non-enabled to enabled and vice-versa" do
        attributes = { enabled_trade_family_ids: [trade_family.id] }

        refresh_prescribable_drugs_materialized_view
        expect(Renalware::Drugs::PrescribableDrug.count).to eq(1)

        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(drug.trade_families.count).to eq 1
        expect(drug.trade_family_classifications.first.enabled).to be true

        follow_redirect!
        expect(response).to be_successful

        # Has added a drug/tf combination to PrescribableDrugs
        expect(Renalware::Drugs::PrescribableDrug.count).to eq(2)

        # now try the reverse
        attributes = { enabled_trade_family_ids: [""] }
        patch drugs_drug_path(drug), params: { drugs_drug: attributes }

        expect(drug.trade_families.count).to eq 1
        expect(drug.trade_family_classifications.first.enabled).to be false

        follow_redirect!
        expect(response).to be_successful

        # Has removed the drug/tf combination from PrescribableDrugs
        expect(Renalware::Drugs::PrescribableDrug.count).to eq(1)
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the drug" do
      drug
      refresh_prescribable_drugs_materialized_view
      expect(Renalware::Drugs::PrescribableDrug.count).to eq(1)

      delete drugs_drug_path(drug)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::Drugs::Drug).not_to exist(id: drug.id)

      follow_redirect!

      expect(response).to be_successful

      expect(Renalware::Drugs::PrescribableDrug.count).to eq(0)
      expect(response.parsed_body.at_css("tr#drugs_drug_#{drug.id}")).to be_nil
      expect(Renalware::Drugs::Drug.with_deleted.find(drug.id).deleted_at).to be_present
    end
  end
end
