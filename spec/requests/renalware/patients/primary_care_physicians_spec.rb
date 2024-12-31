module Renalware
  describe "Configuring Primary Care Physicians" do
    let(:primary_care_physician) { create(:primary_care_physician) }

    describe "GET new" do
      it "responds with a form" do
        get new_patients_primary_care_physician_path

        expect(response).to be_successful
      end
    end

    describe "POST create" do
      context "with valid attributes" do
        it "creates a new record" do
          address_attributes = attributes_for(:address)
          primary_care_physician_attributes = attributes_for(:primary_care_physician)
          primary_care_physician_address_attributes =
            primary_care_physician_attributes.merge(address_attributes: address_attributes)

          post patients_primary_care_physicians_path,
               params: {
                 patients_primary_care_physician: primary_care_physician_address_attributes
               }
          expect(response).to have_http_status(:redirect)
          expect(Patients::PrimaryCarePhysician).to(
            exist(primary_care_physician_attributes)
          )
          expect(Address).to exist(address_attributes)

          follow_redirect!

          expect(response).to be_successful
        end
      end

      context "with invalid attributes" do
        it "responds with form" do
          attributes = { name: "" }

          post patients_primary_care_physicians_path,
               params: { patients_primary_care_physician: attributes }

          expect(response).to be_successful
        end
      end
    end

    describe "GET index" do
      it "responds successfully" do
        get patients_primary_care_physicians_path

        expect(response).to be_successful
      end
    end

    describe "GET edit" do
      it "responds with a form" do
        get edit_patients_primary_care_physician_path(primary_care_physician)

        expect(response).to be_successful
      end
    end

    describe "PATCH update" do
      context "with valid attributes" do
        it "updates a record" do
          attributes = { name: "My GP" }
          patch patients_primary_care_physician_path(primary_care_physician),
                params: { patients_primary_care_physician: attributes }

          expect(response).to have_http_status(:redirect)
          expect(Patients::PrimaryCarePhysician).to exist(attributes)

          follow_redirect!

          expect(response).to be_successful
        end
      end

      context "with invalid attributes" do
        it "responds with a form" do
          attributes = { name: "" }
          patch patients_primary_care_physician_path(primary_care_physician),
                params: { patients_primary_care_physician: attributes }

          expect(response).to be_successful
        end
      end
    end

    describe "DELETE destroy" do
      it "deletes the primary_care_physician" do
        delete patients_primary_care_physician_path(primary_care_physician)

        expect(response).to have_http_status(:redirect)
        expect(Patients::PrimaryCarePhysician).not_to(
          exist(id: primary_care_physician.id)
        )

        follow_redirect!

        expect(response).to be_successful
      end
    end
  end
end
