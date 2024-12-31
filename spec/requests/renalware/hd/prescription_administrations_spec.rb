describe "HD Prescription Administrations" do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  def create_prescription_for(patient, drug_name: "Drug1")
    create(
      :prescription,
      patient: patient,
      administer_on_hd: true,
      drug: create(:drug, name: drug_name)
    )
  end

  describe "DELETE destroy" do
    it "allows a superadmin to delete a prescription administration that was created in error" do
      login_as_clinical
      patient = create(:hd_patient)
      prescription = create_prescription_for(patient)
      pa = create(
        :hd_prescription_administration,
        prescription: prescription,
        administered_by: user1,
        administered_by_password: "supersecret",
        witnessed_by: user2,
        witnessed_by_password: "supersecret"
      )

      delete hd_prescription_administration_path(prescription, pa)

      follow_redirect!
      expect(response).to be_successful
    end
  end
end
