describe "HL7 ADT~A31 message handling: 'Update person information'" do
  let(:local_patient_id) { "P123" }
  let(:family_name) { "SMITH" }
  let(:given_name) { "John" }
  let(:middle_name) { "Middling" }
  let(:title) { "Sir" }
  let(:dob) { "19720822000000" }
  let(:died_on) { "" }
  let(:sex) { "F" }
  let(:nhs_number) { "9999999999" }
  let(:gp_code) { "G1234567" }
  let(:practice_code) { "P123456" }
  let(:practice) { create(:practice, code: practice_code) }
  let(:primary_care_physician) { create(:primary_care_physician, code: gp_code) }
  let(:system_user) { create(:user, username: Renalware::SystemUser.username) }
  let(:message) do
    hl7 = <<-HL7
      MSH|^~\&|ADT|iSOFT Engine|eGate|Kings|20150122154918||ADT^A31|897847653|P|2.3
      EVN|A31|20150122154918
      PID|1|#{nhs_number}^^^NHS|#{local_patient_id}^^^KCH||#{family_name}^#{given_name}^#{middle_name}^^#{title}||#{dob}|#{sex}||Not Specified|34 Florence Road^SOUTH CROYDON^Surrey^^CR2 0PP^ZZ993CZ^HOME^QAD||9999999999|5554443333|NSP||NSP|||||Not Specified|.|DNU||8||NSP|#{died_on}|Y
      PD1|||DR WHM SUMISU PRACTICE, Nowhere Surgery, 22 Raccoon Road, Erewhon, Erewhonshire^GPPRC^#{practice_code}|#{gp_code}^Deeley^DP^^^DR
      PV1|1|I|FISK^1^^LD^^^^^Fiske Ward|22||||#{gp_code}^Deeley^DP^^^DR|#{practice_code}^Hoskin^P^^^P^370|370||||19|||C2458519^Hoskin^P^^^P^370|01|877511|||||||||||||||||||||NORMC||||20110412095300
    HL7
    hl7.gsub(/^ */, "")
  end

  def create_dependencies
    primary_care_physician
    practice
  end

  before do
    system_user
    create(:modality_change_type, :default)
  end

  context "when the patient exists in Renalware" do
    it "updates their information" do
      create_dependencies
      patient = create(
        :patient,
        local_patient_id: local_patient_id,
        born_on: Date.parse(dob)
      )

      FeedJob.new(message).perform

      verify_patient_properties(patient.reload)
    end

    context "when the patient has died" do
      let(:died_on) { "202101012359" }

      def create_living_patient
        create(
          :patient,
          local_patient_id: local_patient_id,
          born_on: Date.parse(dob),
          died_on: nil
        )
      end

      def wire_up_listeners
        allow(Renalware.config)
          .to receive(:broadcast_subscription_map)
          .and_return(
            {
              "Renalware::Feeds::MessageProcessor" => [
                "Renalware::Patients::Ingestion::MessageListener"
              ],
              "Renalware::Modalities::ChangePatientModality" => [
                "Renalware::Medications::PatientListener"
              ]
            }
          )
      end

      it "sets the patient's modality to death (if needed)" do
        death_md = create(:death_modality_description)
        patient = create_living_patient

        FeedJob.new(message).perform

        patient.reload
        expect(patient.died_on).to eq(Date.parse(died_on))
        expect(patient.current_modality).to be_present
        expect(patient.current_modality.description).to eq(death_md)
        expect(patient.current_modality.started_on).to eq(Time.zone.today)
      end

      it "setting death modality broadcasts a msg to trigger e.g. termination of prescriptions" do
        wire_up_listeners
        create(:death_modality_description)
        patient = create_living_patient

        allow(Renalware::Medications::TerminateAllPatientPrescriptions).to receive(:call)

        FeedJob.new(message).perform

        expect(Renalware::Medications::TerminateAllPatientPrescriptions).to have_received(:call)
        expect(patient.reload.died_on).to eq(Date.parse(died_on)) # sanity check
      end
    end

    context "when the incoming practice does not exist yet in Renalware" do
      context "when the patient has no current practice" do
        it "leaves practice as nil" do
          patient = create(
            :patient,
            local_patient_id: local_patient_id,
            born_on: Date.parse(dob)
          )

          FeedJob.new(message).perform

          expect(patient.reload).to have_attributes(
            family_name: family_name,
            practice: nil
          )
        end
      end

      context "when the patient already has a practice" do
        it "leaves practice unchanged" do
          original_practice = create(:practice, code: "ABC")
          patient = create(
            :patient,
            local_patient_id: local_patient_id,
            practice_id: original_practice.id,
            born_on: Date.parse(dob)
          )

          FeedJob.new(message).perform

          expect(patient.reload).to have_attributes(
            family_name: family_name,
            practice_id: original_practice.id
          )
        end
      end
    end

    context "when the incoming gp does not exist yet in Renalware" do
      context "when the patient has no current gp" do
        it "leaves gp as nil" do
          patient = create(
            :patient,
            local_patient_id: local_patient_id,
            born_on: Date.parse(dob)
          )

          FeedJob.new(message).perform

          expect(patient.reload).to have_attributes(
            family_name: family_name,
            primary_care_physician: nil
          )
        end
      end

      context "when the patient already has a practice" do
        it "leaves practice unchanged" do
          original_gp = create(:primary_care_physician, code: "MYGP")
          patient = create(
            :patient,
            nhs_number: nhs_number,
            local_patient_id: local_patient_id,
            primary_care_physician: original_gp,
            born_on: Date.parse(dob)
          )

          FeedJob.new(message).perform

          expect(patient.reload).to have_attributes(
            family_name: family_name,
            primary_care_physician: original_gp
          )
        end
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def verify_patient_properties(patient)
    expect(patient).to have_attributes(
      family_name: family_name,
      given_name: given_name,
      title: title,
      born_on: Time.zone.parse(dob).to_date,
      died_on: died_on.presence && Time.zone.parse(died_on).to_date,
      nhs_number: nhs_number,
      primary_care_physician: primary_care_physician,
      practice: practice
    )
    expect(patient.sex.code).to eq(sex)
  end
  # rubocop:enable Metrics/AbcSize
end
