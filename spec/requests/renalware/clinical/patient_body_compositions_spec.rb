module Renalware
  module Clinical
    describe "Patient's Body Compositions" do
      let(:patient) { create(:clinical_patient, by: user) }
      let(:user) { @current_user }

      describe "GET new" do
        it "responds successfully" do
          get new_patient_clinical_body_composition_path(patient_id: patient)
          expect(response).to be_successful
        end
      end

      describe "POST create" do
        it "responds successfully" do
          url = patient_clinical_body_compositions_path(patient_id: patient)
          params = {}
          params[:clinical_body_composition] = attributes_for(:body_composition)
          params[:clinical_body_composition][:assessor_id] = Renalware::User.first.id

          expect {
            post(url, params: params)
          }.to change(BodyComposition.all, :count).by(1)

          follow_redirect!
          expect(response).to be_successful
        end
      end

      describe "GET edit" do
        it "responds successfully" do
          body_comp = create(:body_composition, patient: patient, by: user)
          get edit_patient_clinical_body_composition_path(patient_id: patient, id: body_comp)
          expect(response).to be_successful
        end
      end

      describe "PATCH update" do
        it "responds successfully" do
          body_comp = create(:body_composition, patient: patient, by: user)
          url = patient_clinical_body_composition_path(patient_id: patient, id: body_comp)
          params = {
            clinical_body_composition: body_comp.attributes.merge!(notes: "Lorem")
          }

          patch(url, params: params)

          expect(response).to have_http_status(:redirect)
          follow_redirect!
          expect(response).to be_successful
        end
      end

      describe "GET index" do
        it "displays a table of body composition measurements" do
          body_comp = create(:body_composition, patient: patient, by: user, overhydration: 12.2)
          url = patient_clinical_body_compositions_path(patient_id: patient)

          get url

          expect(response).to be_successful
          expect(response.body).to include "Body Composition"
          expect(response.body).to include body_comp.overhydration.to_s
        end
      end
    end
  end
end
