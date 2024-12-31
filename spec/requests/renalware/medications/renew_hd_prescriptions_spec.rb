describe "Renew HD prescription" do
  let(:patient) { create(:hd_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }

  def create_prescription(patient, drug_name, hd:)
    create(
      :prescription,
      drug: create(:drug, name: drug_name),
      patient: patient,
      administer_on_hd: hd
    )
  end

  describe "GET new" do
    it "returns a list" do
      create_prescription(patient, "Drug1", hd: true)
      get new_patient_medications_prescription_batch_renewal_path(patient)

      expect(response).to be_successful
      expect(response).to render_template(:new)
      expect(response.body).to match(/Drug1/) # and checkbox
    end
  end

  describe "POST create" do
    it "calls RenewPrescription for each prescription_id posted" do
      prescription1 = create_prescription(patient, "Drug1", hd: true)
      prescription2 = create_prescription(patient, "Drug2", hd: true)

      params = {
        prescription_batch: {
          prescription_ids: [
            prescription1.id,
            prescription2.id
          ]
        }
      }

      allow(Renalware::Medications::RenewPrescription).to receive(:call)

      post(
        patient_medications_prescription_batch_renewals_path(patient),
        params: params
      )

      expect(Renalware::Medications::RenewPrescription).to have_received(:call).twice
    end

    it "does nothing when no prescription_ids supplied" do
      params = {
        prescription_batch: {
          prescription_ids: []
        }
      }

      allow(Renalware::Medications::RenewPrescription).to receive(:call)

      post(
        patient_medications_prescription_batch_renewals_path(patient),
        params: params
      )

      expect(Renalware::Medications::RenewPrescription).not_to have_received(:call)
    end

    it "does nothing when no prescription_ids params blank because all checkboxes unchecked" do
      params = {
        prescription_batch: {
          prescription_ids: [""]
        }
      }

      allow(Renalware::Medications::RenewPrescription).to receive(:call)

      post(
        patient_medications_prescription_batch_renewals_path(patient),
        params: params
      )

      expect(Renalware::Medications::RenewPrescription).not_to have_received(:call)
    end
  end
end
