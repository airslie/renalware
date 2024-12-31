describe "Configuring PD Bag Types" do
  let(:bag_type) { create(:bag_type) }

  describe "GET new" do
    it "responds with a form" do
      get new_pd_bag_type_path

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:bag_type)
        post pd_bag_types_path, params: { pd_bag_type: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::PD::BagType.count).to eq(1)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        attributes = { manufacturer: "" }
        post pd_bag_types_path, params: { pd_bag_type: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "GET index" do
    it "responds successfully" do
      get pd_bag_types_path

      expect(response).to be_successful
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_pd_bag_type_path(bag_type)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { manufacturer: "My Edited Bag Type" }

        patch pd_bag_type_path(bag_type), params: { pd_bag_type: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::PD::BagType).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { manufacturer: "" }

        patch pd_bag_type_path(bag_type), params: { pd_bag_type: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the bag type" do
      delete pd_bag_type_path(bag_type)

      expect(response).to have_http_status(:redirect)
      expect(Renalware::PD::BagType).not_to exist(id: bag_type.id)

      follow_redirect!

      expect(response).to be_successful
    end
  end
end
