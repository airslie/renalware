# frozen_string_literal: true

describe "Exit Site Infections" do
  describe "GET show as pdf" do
    it "responds successfully with a pdf form for the nurse to print out and use to gather " \
       "information about the infection" do
      patient = create(:pd_patient, family_name: "Rabbit", local_patient_id: "KCH12345")
      esi = create(:exit_site_infection, patient: patient)
      create(:esi_printable_form_template)

      get patient_pd_exit_site_infection_path(patient, esi, format: :pdf)

      expect(response).to be_successful
      expect(response["Content-Type"]).to eq("application/pdf")
      filename = "RABBIT-KCH12345-ESI-#{esi.id}".upcase
      expect(response["Content-Disposition"]).to include("inline")
      expect(response["Content-Disposition"]).to include(filename)
    end
  end
end
