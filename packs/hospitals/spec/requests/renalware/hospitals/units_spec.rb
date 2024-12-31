describe "Managing Hospital Units" do
  let(:hospital_centre) { create(:hospital_centre) }
  let(:hospital_unit) { create(:hospital_unit) }

  describe "GET new" do
    it "responds with a form" do
      get hospitals.new_unit_path

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(:hd_hospital_unit)
          .merge(hospital_centre_id: hospital_centre.id)
        post hospitals.units_path, params: { unit: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Hospitals::Unit).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        attributes = { name: "" }
        post hospitals.units_path, params: { unit: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get hospitals.edit_unit_path(hospital_unit)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { name: "My Edited Event" }
        patch hospitals.unit_path(hospital_unit), params: { unit: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Hospitals::Unit).to exist(attributes)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { name: "" }
        patch hospitals.unit_path(hospital_unit), params: { unit: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the event type" do
      delete hospitals.unit_path(hospital_unit)
      expect(response).to have_http_status(:redirect)

      expect(Renalware::Hospitals::Unit).not_to exist(id: hospital_unit.id)

      follow_redirect!
      expect(response).to be_successful
    end
  end
end
