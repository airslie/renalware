describe "patient_rules Requests" do
  let(:patient) { create(:pathology_patient) }
  let(:lab) { create(:pathology_lab) }
  let(:patient_rule) do
    create(:pathology_requests_patient_rule, patient: patient, lab: lab)
  end
  let(:clinic) { create(:clinic) }

  describe "GET new" do
    it "responds with a form" do
      get new_patient_pathology_patient_rule_path(patient_id: patient)

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    let(:url) { patient_pathology_patient_rules_path(patient_id: patient) }
    let(:patient_rule_attributes) do
      attributes_for(:pathology_requests_patient_rule).merge(
        patient_id: patient.id,
        lab_id: lab.id
      )
    end

    context "with valid attributes" do
      let(:patient_rule_exists) do
        Renalware::Pathology::Requests::PatientRule.exists?(patient_rule_attributes)
      end

      it "creates a new record" do
        post url, params: { pathology_requests_patient_rule: patient_rule_attributes }

        expect(response).to have_http_status(:redirect)
        expect(patient_rule_exists).to be(true)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        post url,
             params: { pathology_requests_patient_rule: patient_rule_attributes.except(:lab_id) }

        expect(response).to be_successful
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_patient_pathology_patient_rule_path(patient_id: patient, id: patient_rule.id)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    let(:url) { patient_pathology_patient_rule_path(patient_id: patient, id: patient_rule.id) }

    context "with valid attributes" do
      it "updates the patient rule" do
        patch url, params: { pathology_requests_patient_rule: { test_description: "Lorem Ipsum" } }

        expect(response).to have_http_status(:redirect)

        follow_redirect!

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        patch url, params: { pathology_requests_patient_rule: { test_description: nil } }

        expect(response).to be_successful
      end
    end
  end

  describe "DELETE destroy" do
    let(:patient_rule_exists) do
      Renalware::Pathology::Requests::PatientRule.exists?(id: patient_rule.id)
    end

    it "deletes the patient rule" do
      delete patient_pathology_patient_rule_path(patient_id: patient, id: patient_rule.id)

      expect(response).to have_http_status(:redirect)
      expect(patient_rule_exists).to be_falsey

      follow_redirect!

      expect(response).to be_successful
    end
  end
end
