describe "Managing alerts" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }

  describe "POST create" do
    context "with valid attributes and no urgency" do
      it "creates a new alert" do
        params = {
          patients_alert: {
            notes: "An alert"
          }
        }

        post(patient_alerts_path(patient, format: :js), params: params)
        expect(response).to be_successful

        alert = Renalware::Patients::Alert.find_by(patient_id: patient.id)

        expect(alert).not_to be_nil
        expect(alert.urgent).to be(false)
        expect(alert.covid_19).to be(false)
        expect(alert.notes).to eq("An alert")
      end
    end

    context "when an urgency of 'Urgent' is selected" do
      it "creates a new alert marked as urgent = true" do
        headers = {
          "HTTP_REFERER" => "/",
          "ACCEPT" => "application/javascript"
        }
        params = {
          patients_alert: {
            urgency: "urgent",
            notes: "An alert"
          }
        }

        post(patient_alerts_path(patient), params: params, headers: headers)
        expect(response).to be_successful

        alert = Renalware::Patients::Alert.find_by(patient_id: patient.id)

        expect(alert.covid_19).to be(false)
        expect(alert.urgent).to be(true)
      end
    end

    context "when an urgency of COVID-19 is selected" do
      it "creates a new alert marked as covid_19 = true" do
        headers = {
          "HTTP_REFERER" => "/",
          "ACCEPT" => "application/javascript"
        }
        params = {
          patients_alert: {
            urgency: "covid_19",
            notes: "An alert"
          }
        }

        post(patient_alerts_path(patient), params: params, headers: headers)
        expect(response).to be_successful

        alert = Renalware::Patients::Alert.find_by(patient_id: patient.id)

        expect(alert.covid_19).to be(true)
        expect(alert.urgent).to be(false)
      end
    end

    context "with invalid attributes" do
      it "returns 44 validation error and does not create a new alert" do
        params = {
          patients_alert: {
            urgent: true,
            notes: ""
          }
        }

        post(patient_alerts_path(patient, format: :js), params: params)

        expect(response).to have_http_status(:unprocessable_content)
        alert = Renalware::Patients::Alert.find_by(patient_id: patient.id)
        expect(alert).to be_nil
      end
    end
  end

  describe "DELETE destroy" do
    let(:alert) do
      create(:patient_alert,
             patient: patient,
             by: Renalware::Patients.cast_user(user))
    end

    it "soft deletes the alert" do
      delete patient_alert_path(patient, alert, format: :js)

      expect(response).to be_successful
      expect(Renalware::Patients::Alert).not_to exist(id: alert.id)
    end

    it "does not baulk if the alert has already been deleted" do
      alert.destroy!
      expect(Renalware::Patients::Alert).not_to exist(id: alert.id)

      delete patient_alert_path(patient, alert, format: :js)

      expect(response).to be_successful
      expect(Renalware::Patients::Alert).not_to exist(id: alert.id)

      # Check the alert is still available in the #undeleted scope
      expect(Renalware::Patients::Alert.count).to eq(0)
      expect(Renalware::Patients::Alert.with_deleted.count).to eq(1)
    end
  end
end
