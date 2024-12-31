describe "Importing an ADT A31 'Update patient information' HL7 message" do
  before do
    allow(Renalware.config.hl7_patient_locator_strategy)
      .to receive(:fetch)
      .with(:adt)
      .and_return(:simple)
    create(:user, :system)
  end

  let(:patient_data) do
    OpenStruct.new(
      hospital_number: "A123",
      nhs_number: "9999999999",
      family_name: "new_family_name",
      given_name: "new_given_name",
      title: "new_title",
      ethnicity: create(:ethnicity, :black_caribbean),
      born_on: Time.zone.parse("2002-02-01").to_date,
      gp_code: "G123",
      practice_code: "P456"
    )
  end
  let(:raw_message) do
    msh = "MSH|^~\&|ADT|iSOFT Engine|eGate|Kings|20150122154918||ADT^A31|897847653|P|2.3"
    pid = "PID||#{patient_data.nhs_number}^^^NHS|#{patient_data.hospital_number}^^^PAS||" \
          "#{patient_data.family_name}^#{patient_data.given_name}^^^#{patient_data.title}||" \
          "#{patient_data.born_on&.strftime('%Y%m%d')}|#{patient_data.sex}|||" \
          "address1^address2^address3^address4^postcode^other^HOME|||||||||||" \
          "#{patient_data.ethnicity.rr18_code || 'A'}|||||||" \
          "#{patient_data.died_on&.strftime('%Y%m%d')}|"
    pd1 = "PD1|||DR X, X Surgery, X Road^GPPRC^" \
          "#{patient_data.practice_code}|#{patient_data.gp_code}^Deeley^DP^^^DR"
    [msh, pid, pd1].join("\n")
  end

  context "when the patient exists" do
    it do
      # Create a sample patient and check we can update them
      patient = create(
        :patient,
        nhs_number: patient_data.nhs_number,
        local_patient_id: patient_data.hospital_number,
        born_on: patient_data.born_on,
        family_name: "original_family_name",
        given_name: "original_given_name",
        ethnicity_id: nil,
        title: nil,
        died_on: nil
      )

      FeedJob.new(raw_message).perform

      expect(patient.reload).to have_attributes(
        died_on: patient_data.died_on,
        family_name: patient_data.family_name,
        given_name: patient_data.given_name,
        title: patient_data.title,
        ethnicity: patient_data.ethnicity
      )
    end

    context "when the patient does not exist" do
      it "does not create a patient" do
        expect {
          FeedJob.new(raw_message).perform
        }.not_to change(Renalware::Patient, :count)
      end
    end
  end
end
