# frozen_string_literal: true

describe "Peritonitis episodes" do
  let(:patient) { create(:pd_patient, family_name: "Rabbit", local_patient_id: "KCH12345") }

  describe "GET show as pdf" do
    it "responds successfully with a pdf form for the nurse to print out and use to " \
       "gather information about the infection" do
      patient = create(:pd_patient, family_name: "Rabbit", local_patient_id: "KCH12345")
      episode = create(:peritonitis_episode, patient: patient)
      create(:peritonitis_episode_printable_form_template)

      get patient_pd_peritonitis_episode_path(patient, episode, format: :pdf)

      expect(response).to be_successful
      expect(response["Content-Type"]).to eq("application/pdf")
      filename = "RABBIT-KCH12345-PERI-EPISODE-#{episode.id}".upcase
      expect(response["Content-Disposition"]).to include("inline")
      expect(response["Content-Disposition"]).to include(filename)
    end
  end
end
