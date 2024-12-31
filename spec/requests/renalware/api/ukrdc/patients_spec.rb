describe "API request for a single UKRDC patient XML document" do
  include PatientsSpecHelper
  include LettersSpecHelper
  include PathologySpecHelper

  before { Renalware.config.ukrdc_sending_facility_name = "TEST" }

  let(:user) { @current_user }
  let(:uk) { create(:united_kingdom) }
  let(:english) { create(:language, :english) }
  let(:white_british) { create(:ethnicity, :white_british) }
  let(:patient) do
    create(
      :patient,
      ethnicity: white_british,
      country_of_birth: uk,
      language: english,
      by: user,
      sent_to_ukrdc_at: 1.year.ago,
      send_to_rpv: true,
      practice: create(:practice),
      primary_care_physician: create(:primary_care_physician)
    )
  end

  def validate(xml)
    Renalware::UKRDC::XsdSchema.new.validate(xml)
  end

  def clinic_patient(patient)
    Renalware::Clinics.cast_patient(patient)
  end

  def clinical_patient(patient)
    Renalware::Clinical.cast_patient(patient)
  end

  describe "GET #show" do
    it "renders the correct UKRDC XML" do
      create(:clinic_visit, patient: clinic_patient(patient), by: user)
      create(:allergy, patient: clinical_patient(patient), by: user)
      hd_patient = Renalware::HD.cast_patient(patient)
      sess = create(
        :hd_closed_session,
        patient: hd_patient,
        by: user
      )

      sess.updated_by = Renalware::User.first
      sess.document.info.access_type_abbreviation = "PDC UA"
      sess.save!

      # So medications elements are triggered
      create(:prescription, patient: patient, by: user)

      get renalware.api_ukrdc_patient_path(patient)

      expect(response).to be_successful

      validate(response.body) do |error|
        raise error.message
      end
    end

    context "when the patient has died" do
      it "includes first cause of death elements" do
        set_modality(
          patient: patient,
          modality_description: create(:modality_description, :death),
          by: user
        )

        patient.first_cause = create(:cause_of_death, code: 11, description: "Abc")
        patient.second_cause = create(:cause_of_death, code: 12, description: "Xyz")
        patient.died_on = Time.zone.now
        patient.save_by!(user)

        expect(patient.reload).to be_current_modality_death

        get renalware.api_ukrdc_patient_path(patient)

        expect(response).to be_successful

        matches = response.body.scan("<CauseOfDeath>")
        expect(matches.length).to eq(1)

        validate(response.body) do |error|
          raise error.message
        end
      end
    end
  end

  context "when the patient has pathology" do
    it "includes laborder/resultitems" do
      descriptions = create_descriptions(%w(HGB WBC))
      create_observations(Renalware::Pathology.cast_patient(patient), descriptions)

      get renalware.api_ukrdc_patient_path(patient)

      expect(response).to be_successful

      xml = response.body

      validate(xml).each do |error|
        raise error.message
      end

      # Lower case means here the factory has taken the code down-cased into loinc_code.
      # So it indicates we are using the loin code and so the CodingStandard should be PV.
      # Eventually we will move across to loinc codes properly but for now
      # pathology_observation_description#loinc_code stores the Patient View (PV) code mapping.
      expect(xml).to match("<Code>hgb</Code>")
      expect(xml).to match("<Code>wbc</Code>")
      expect(xml).to match("<CodingStandard>UKRR</CodingStandard>")
    end
  end

  context "when the patient has a letter" do
    it "validates Document/s element" do
      letter = create_letter(
        to: :patient,
        state: :approved,
        patient: Renalware::Letters.cast_patient(patient),
        description: "xxx"
      )
      get renalware.api_ukrdc_patient_path(patient)

      expect(response).to be_successful
      xml = response.body
      expect(xml).to match("<Document>")
      expect(xml).to match(
        "<FileName>" \
        "#{patient.family_name.upcase}-" \
        "#{patient.local_patient_id}-" \
        "#{letter.id}.pdf" \
        "</FileName>"
      )
      expect(xml).to match("<FileType>application/pdf</FileType>")
      expect(xml).to match("<Stream>")

      validate(response.body) do |error|
        raise error.message
      end
    end
  end
end
