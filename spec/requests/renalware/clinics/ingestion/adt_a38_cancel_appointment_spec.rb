describe "HL7 ADT^A38 cancel appointment" do
  # As used at MSE for appointment cancellation.
  # The A38 event is sent when an A05 (pre-admit a patient) event is cancelled, either because of
  # erroneous entry of the A05 event or because of a decision not to pre-admit the patient after
  # all. The fields included when this message is sent should be the fields pertinent to communicate
  # this event. When other fields change, it is recommended that the
  # A08 (update patient information) event be used in addition.
  include HL7Helpers
  include PatientsSpecHelper

  let(:nhs_number)        { "1092192328" }
  let(:local_patient_id)  { "123" }
  let(:visit_number)      { "123" }
  let(:clinic_code)       { "clinic1" }
  let(:consultant_code)   { "doc1" }
  let(:starts_at)         { "20210809130000" }

  let(:data) do
    OpenStruct.new(
      visit_number: visit_number,
      starts_at: starts_at,
      patient: OpenStruct.new(
        nhs_number: nhs_number,
        hospital_number: local_patient_id,
        family_name: "Smith",
        given_name: "John",
        sex: "M",
        born_on: "19440922",
        address: OpenStruct.new(postcode: "AA1 1AA")
      ),
      clinic: OpenStruct.new(
        code: clinic_code
      ),
      consultant: OpenStruct.new(
        code: consultant_code,
        family_name: "Jones",
        given_name: "Jill",
        title: "Mrs"
      )
    )
  end

  def create_matching_patient
    create(
      :patient,
      nhs_number: nhs_number,
      local_patient_id: local_patient_id,
      born_on: Date.parse("19440922")
    ).tap do |pat|
      pat.current_address.update!(postcode: "OLD POSTCODE")
    end
  end

  before do
    create(:user, :system)
    create(:modality_change_type, :default)
  end

  describe "ADT^A38 delete/cancel appointment" do
    it "sanity check the fixture builds using our argument" do
      msg = hl7_message_from_file("clinics/ADT_A38_cancel_appointment", data)

      expect(msg.patient_identification.nhs_number).to eq(nhs_number)
      expect(msg.patient_identification.hospital_identifiers[:KCH]).to eq(local_patient_id)
      expect(msg.pv1.visit_number).to eq(visit_number)
    end

    context "when patient is not found in Renalware" do
      it "ignores the message" do
        msg = hl7_message_from_file("clinics/ADT_A38_cancel_appointment", data)

        expect {
          Renalware::Clinics::Ingestion::Commands::DeleteAppointment.call(msg)
        }.not_to change(Renalware::Clinics::Appointment, :count)
      end
    end

    context "when patient found but does not have an appointment with a matching visitor_number" do
      it "ignores the message" do
        msg = hl7_message_from_file("clinics/ADT_A38_cancel_appointment", data)
        create_matching_patient

        expect {
          Renalware::Clinics::Ingestion::Commands::DeleteAppointment.call(msg)
        }.not_to change(Renalware::Clinics::Appointment, :count)
      end
    end

    context "when patient found having appointment with a matching visitor_number" do
      it "deletes the appointment" do
        msg = hl7_message_from_file("clinics/ADT_A38_cancel_appointment", data)
        clinic_patient = Renalware::Clinics.cast_patient(create_matching_patient)
        create(:appointment, patient: clinic_patient, visit_number: visit_number)

        expect {
          Renalware::Clinics::Ingestion::Commands::DeleteAppointment.call(msg)
        }.to change(Renalware::Clinics::Appointment, :count).by(-1)
      end
    end
  end
end
