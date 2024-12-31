describe "Get formatted letter HTML content" do
  include LettersSpecHelper

  let(:primary_care_physician) { create(:letter_primary_care_physician) }
  let(:patient) { create(:letter_patient, primary_care_physician: primary_care_physician) }
  let(:letter) { create_letter(to: :patient, patient: patient) }

  context "with a draft letter" do
    describe "GET show" do
      let(:patient) {
        create(
          :letter_patient,
          primary_care_physician: primary_care_physician,
          family_name: "RABBIT",
          local_patient_id: "KCH57837"
        )
      }

      it "responds with the HTML" do
        get patient_letters_letter_formatted_path(patient_id: letter.patient, letter_id: letter)
        expect(response).to be_successful
        expect(response.body).to include(letter.patient.full_name)
      end

      it "responds with a PDF download" do
        get patient_letters_letter_formatted_path(
          patient_id: letter.patient, letter_id: letter, format: "pdf"
        )

        expect(response).to be_successful
        expect(response["Content-Type"]).to eq("application/pdf")
        filename = "RABBIT-KCH57837-#{letter.id}-DRAFT".upcase
        expect(response["Content-Disposition"]).to include("attachment")
        expect(response["Content-Disposition"]).to include(filename)
      end

      it "responds with an inlined PDF" do
        get patient_letters_letter_formatted_path(
          patient_id: letter.patient, letter_id: letter, disposition: "inline", format: "pdf"
        )

        expect(response).to be_successful
        expect(response["Content-Type"]).to eq("application/pdf")
        expect(response["Content-Disposition"]).to include("inline")
      end

      it "responds with an RTF download" do
        get patient_letters_letter_formatted_path(
          patient_id: letter.patient, letter_id: letter, format: "rtf"
        )

        expect(response).to be_successful
        expect(response["Content-Type"]).to eq("text/richtext")
        filename = "RABBIT-KCH57837-#{letter.id}-DRAFT".upcase
        expect(response["Content-Disposition"]).to include("attachment")
        expect(response["Content-Disposition"]).to include(filename)
        expect(response.body).to match(/\{\\rtf/)
      end
    end
  end

  context "with an archived letter" do
    before do
      create(:letter_archive, letter: letter, by: letter.created_by)
    end

    describe "GET show" do
      it "responds with the archived HTML" do
        get patient_letters_letter_formatted_path(patient_id: letter.patient, letter_id: letter)
        expect(response).to be_successful
        expect(response.body).to include(letter.archive.content)
      end
    end
  end

  context "when the letter has been successfully emailed to a GP main recipient" do
    let(:patient) {
      create(
        :letter_patient,
        primary_care_physician: primary_care_physician,
        practice: create(:practice, email: "test@example.com"),
        family_name: "RABBIT",
        local_patient_id: "KCH57837"
      )
    }

    it "indicates the letter has been sent via email to the GP" do
      get patient_letters_letter_formatted_path(patient_id: letter.patient, letter_id: letter)
      expect(response).to be_successful
      expect(response.body).to include("VIA EMAIL to test@example.com")
    end
  end
end
