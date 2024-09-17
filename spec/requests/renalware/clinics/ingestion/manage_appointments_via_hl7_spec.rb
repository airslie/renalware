# frozen_string_literal: true

describe "manage appointments via HL7 ADT messages" do
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

  describe "ADT^A05 create or update appointment" do
    it "sanity check the fixture builds using our arguments" do
      msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)

      expect(msg.patient_identification.nhs_number).to eq(nhs_number)
      expect(msg.patient_identification.hospital_identifiers[:KCH]).to eq(local_patient_id)
      expect(msg.pv1.visit_number).to eq(visit_number)
      expect(msg.pv1.clinic.code).to eq(clinic_code)
      expect(msg.pv1.consulting_doctor.code).to eq(consultant_code)
    end

    context "when patient is not found" do
      it "ignores the message" do
        msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.not_to change(Renalware::Clinics::Appointment, :count)
      end
    end

    context "when patient is found but there is no matching clinic" do
      it "ignores the message" do
        msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)
        create_matching_patient

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.not_to change(Renalware::Clinics::Appointment, :count)
      end
    end

    context "when the clinic is found but no matching patient or consultant" do
      it "creates the patient, consultant and appointment" do
        msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)
        clinic = create(:clinic, code: clinic_code)

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.to change(Renalware::Clinics::Appointment, :count).by(1)
          .and change(Renalware::Patient, :count).by(1)
          .and change(Renalware::Clinics::Consultant, :count).by(1)

        appointment = Renalware::Clinics::Appointment.last
        expect(appointment).to have_attributes(clinic: clinic, visit_number: visit_number)
        expect(appointment.consultant).to have_attributes(code: consultant_code)
        patient = appointment.patient
        expect(patient).to have_attributes(nhs_number: nhs_number)
        expect(patient.reload.current_modality).to be_nil
      end

      context "when the default_modality_description is set on the clinic" do
        it "assigns this to new patients" do
          msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)
          nephrology = create(:modality_description, :nephrology)
          create(:clinic, code: clinic_code, default_modality_description: nephrology)

          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)

          appointment = Renalware::Clinics::Appointment.last
          expect(appointment.patient.current_modality.description_id).to eq(nephrology.id)
        end
      end
    end

    context "when patient and clinic are found but there is no matching consultant" do
      it "creates the consultant and the appointment" do
        msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)
        patient = create_matching_patient
        clinic = create(:clinic, code: clinic_code)

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.to change(Renalware::Clinics::Appointment, :count).by(1)
          .and change(Renalware::Clinics::Consultant, :count).by(1)

        appointment = Renalware::Clinics::Appointment.last

        expect(appointment).to have_attributes(
          patient_id: patient.id,
          clinic_id: clinic.id,
          starts_at: Time.zone.parse(starts_at),
          visit_number: visit_number
        )

        expect(appointment.consultant).to have_attributes(
          name: "Mrs Jill Jones",
          code: "doc1"
        )
      end
    end

    context "when patient, clinic and consultant are matched" do
      it "creates an appointment" do
        msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)
        patient = create_matching_patient
        clinic = create(:clinic, code: clinic_code)
        consultant = create(:consultant, code: consultant_code)

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.to change(Renalware::Clinics::Appointment, :count).by(1)

        appointment = Renalware::Clinics::Appointment.last

        expect(appointment).to have_attributes(
          consultant_id: consultant.id,
          patient_id: patient.id,
          clinic_id: clinic.id,
          starts_at: Time.zone.parse(starts_at),
          visit_number: visit_number
        )
      end

      # rubocop:disable RSpec/ChangeByZero
      context "when patient has a modality and the default modality description is set on clinic" do
        it "does not change the patient's modality" do
          msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)
          nephrology = create(:modality_description, :nephrology)
          create(:clinic, code: clinic_code, default_modality_description: nephrology)
          create(:consultant, code: consultant_code)
          patient = create_matching_patient
          set_modality(
            patient: patient,
            modality_description: create(:modality_description, :hd),
            by: patient.created_by
          )

          expect {
            Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
          }.to change(Renalware::Clinics::Appointment, :count).by(1)
            .and change(Renalware::Modalities::Modality, :count).by(0)
        end
      end
      # rubocop:enable RSpec/ChangeByZero
    end

    it "updates patient demographics (eg postcode) if patient found" do
      patient = create_matching_patient
      patient.current_address.update!(postcode: "OLD_POSTCODE")
      create(:clinic, code: clinic_code)

      data.patient.address.postcode = "NEW_POSTCODE"
      msg = hl7_message_from_file("clinics/ADT_A05_create_appointment", data)

      expect {
        Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
      }.to change(Renalware::Clinics::Appointment, :count).by(1)

      expect(patient.current_address.reload.postcode).to eq("NEW_POSTCODE")
    end
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
