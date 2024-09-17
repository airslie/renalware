# frozen_string_literal: true

describe "Admission Request (TCI) management" do
  let(:reason) { create(:admissions_request_reason, description: "XYZ") }
  let(:user) { @current_user }
  let(:time) { Time.zone.now }
  let(:patient) { create(:patient, by: user) }

  def create_request
    create(:admissions_request,
           reason: reason,
           priority: :urgent,
           by: user,
           patient: patient,
           created_at: time,
           updated_at: time)
  end

  # monitor_database_record_creation: true
  describe "GET index" do
    it "lists patients with an admission request" do
      create_request

      get admissions_requests_path

      expect(response).to be_successful
      expect(response.body).to include("XYZ")
      expect(response.body).to include(l(time))
      expect(response.body).to include(patient.to_s)
      expect(response.body).to include("Urgent")
    end
  end

  describe "GET html new" do
    it "renders a form" do
      get new_admissions_request_path(patient_id: patient.id)

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST js create" do
    context "with valid data" do
      it "creates a new Admissions::Request" do
        params = {
          admissions_request: {
            reason_id: reason.id,
            patient_id: patient.id,
            priority: "urgent"
          }
        }

        expect {
          post(admissions_requests_path(format: :js), params: params)
        }.to change(Renalware::Admissions::Request, :count).by(1)

        expect(response).to be_successful
      end
    end

    context "with invalid data ie reason not selected" do
      it "fails to create a request and re-renders the new template with errors" do
        params = {
          admissions_request: {
            patient_id: patient.id
          }
        }

        expect {
          post(admissions_requests_path, params: params)
        }.not_to change(Renalware::Admissions::Request, :count)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET html edit" do
    it "renders the edit modal" do
      request = create_request

      get edit_admissions_request_path(request, format: :html)

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH js update" do
    context "when valid inputs" do
      it "renders the edit modal" do
        request = create_request
        params = {
          admissions_request: {
            reason_id: reason.id,
            patient_id: patient.id,
            notes: "Updated notes"
          }
        }

        patch admissions_request_path(request, format: :js, params: params)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:update)
        expect(request.reload.notes).to eq("Updated notes")
      end
    end

    context "when invalid inputs" do
      it "renders the edit modal" do
        request = create_request
        params = {
          admissions_request: {
            reason_id: nil
          }
        }

        patch admissions_request_path(request, format: :js, params: params)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE js destroy" do
    it "soft delete the request" do
      request = create_request

      expect {
        delete admissions_request_path(request, format: :js)
      }.to change(Renalware::Admissions::Request, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:destroy)
    end
  end
end
