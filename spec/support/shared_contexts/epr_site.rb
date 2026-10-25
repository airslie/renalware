RSpec.shared_context "with DVH as the EPR site" do
  before do
    allow(Renalware.config).to receive_messages(
      patient_hospital_identifiers: { KCH: :local_patient_id, DVH: :local_patient_id_3 },
      epr_site_code: "DVH"
    )
  end
end
