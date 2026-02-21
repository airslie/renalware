# rubocop:disable Layout/LineLength
describe "HL7 SIU^S12 - Notification of New Appointment Booking" do
  # This message is sent from a filler application to notify other applications that a
  # new appointment has been booked. The information provided in the SCH segment and the other
  # detail segments as appropriate describe the appointment that has been booked by the
  # filler application.

  # NOTE if clinic code and name are not in PV3, then in Mirth we should move them in there to
  # match our expectations. For example at BLT PV3.1 is not necessarily populated so we copy:
  #  AIL3.1 => PV3.1 clinic name
  #  SCH7.1 => PV3.2 clinic name

  # Example message:
  #   MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241106150701||SIU^S12|Q166323123117|P|2.4
  #   SCH|149549015||||||Nephrology New||30|MINUTES|^^30^20241106120000^20241106123000||||||||||||||Confirmed
  #   PID|1||10769857^^^RNJ 5C4 MRN^MRN||MOLLY^RENALOP2^^^^^CURRENT||19870101|2|||21 Rush Home Road^^^ROMFORD^RG7 0JB^^HOME^^||0766655652^MOBILE~02011110111^HOME~testrenal@test.co^EMAIL|""^BUSINESS||""||13401071||||H||||||||N
  #   PD1|||THE CHRISP STREET HTH CTR^^F84062|G999^SMAILL^AM^^^^^^EXTID
  #   PV1|1|O|RNJ Renal OPD^Nephrology New^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH|""|||C3590850^Smith^John^^^Dr^NHSCONSULTANTNUMBER^PRSNL^^^NONGP|G9123^Jones^JP||361||||""||||OPREFERRAL|924301148^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON||||||
  #   RGS|1
  #   AIG|1||Baxter, Stanley
  #   AIL|1||RNJ Renal OPD^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH

  include HL7Helpers
  include PatientsSpecHelper

  let(:default_clinic) { create(:clinic, code: "DefaultClinicCode", name: "Default Clinic") }
  let(:default_clinic_mapping) {
    create(
      :clinics_mapping,
      name_in_feed: "Any Other Clinic",
      clinic: default_clinic,
      default_clinic: true
    )
  }
  let(:clinic_code) { "Clinic1Code" }
  let(:clinic_name) { "Clinic1Name" }
  let(:raw_hl7) do
    hl7 = <<-HL7
      MSH|^~\&|BLT_TIE|BLT|RENALWARE|MSE|20241106150701||SIU^S12|Q166323123117|P|2.4
      SCH|149549015||||||clinic_name_copied_into_PV3.1||30|MINUTES|^^30^20241106120000^20241106123000||||||||||||||Confirmed
      PID|1||10769857^^^Dover||MOLLY^RENALOP2^^^^^CURRENT||19870101|2|||21 Rush Home Road^^^ROMFORD^RG7 0JB^^HOME^^||0766655652^MOBILE~02011110111^HOME~testrenal@test.co^EMAIL|""^BUSINESS||""||13401071||||H||||||||N
      PD1|||THE CHRISP STREET HTH CTR^^F84062|G999^SMAILL^AM^^^^^^EXTID
      PV1|1|O|#{clinic_code}^#{clinic_name}^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH|""|||C3590850^Smith^John^^^Dr^NHSCONSULTANTNUMBER^PRSNL^^^NONGP|G9123^Jones^JP||361||||""||||OPREFERRAL|924301148^^^RNJATTNUM^VISITID|||||||||||||||||""|""||RNJ ROYALLONDON||||||
      RGS|1
      AIG|1||Baxter, Stanley
      AIL|1||clinic_code_copied_into_PV3.1^^^RNJ ROYALLONDON^^AMB^RNJ MainBld RLH
    HL7
    hl7.gsub(/^ */, "")
  end

  before do
    create(:user, :system)
    create(:modality_change_type, :default)
    allow(Renalware.config).to receive_messages(
      feeds_outpatient_clinic_resolution_strategy: :by_name_mapping
    )
  end

  def create_patient
    create(
      :patient,
      local_patient_id: "10769857",
      given_name: "MOLLY",
      family_name: "RENALOP2",
      born_on: Date.parse("19870101")
    ).tap do |pat|
      pat.current_address.update!(postcode: "RG7 0JB")
    end
  end

  def create_consultant = create(:consultant, code: "C3590850", name: "Dr John Smith")
  def create_clinic     = create(:clinic, code: clinic_code, name: clinic_name)

  context "when patient is not found" do
    context "when the clinic and consultant exists" do
      it "creates the patient and schedules the appointment" do
        msg = hl7_message_from_raw_string(raw_hl7)
        clinic = create_clinic
        consultant = create_consultant
        # Map clinic_name to clinic
        create(:clinics_mapping, name_in_feed: clinic_name, clinic:)

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.to change(Renalware::Patient, :count).by(1)
          .and change(Renalware::Clinics::Appointment, :count).by(1)

        expect(Renalware::Clinics::Consultant.last).to have_attributes(
          code: "C3590850",
          name: "Dr John Smith"
        )

        patient = Renalware::Patient.last
        expect(Renalware::Clinics::Appointment.last).to have_attributes(
          patient_id: patient.id,
          consultant_id: consultant.id,
          clinic_id: clinic.id,
          starts_at: Time.zone.parse("20241106120000"),
          ends_at: Time.zone.parse("20241106123000")
        )
      end

      context "when the consultant in PV1.7 does not exist in RW" do
        it "creates the patient and consultant and schedules the appointment" do
          msg = hl7_message_from_raw_string(raw_hl7)
          clinic = create_clinic
          create(:clinics_mapping, name_in_feed: clinic_name, clinic:)

          expect {
            Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
          }.to change(Renalware::Patient, :count).by(1)
            .and change(Renalware::Clinics::Appointment, :count).by(1)
            .and change(Renalware::Clinics::Consultant, :count).by(1)

          expect(Renalware::Clinics::Consultant.last).to have_attributes(
            code: "C3590850",
            name: "Dr John Smith"
          )

          patient = Renalware::Patient.last
          expect(Renalware::Clinics::Appointment.last).to have_attributes(
            patient_id: patient.id,
            clinic_id: clinic.id,
            starts_at: Time.zone.parse("20241106120000"),
            ends_at: Time.zone.parse("20241106123000")
          )
        end
      end

      context "when the clinic in PV1.3 does not exist in RW" do
        context "when there is no default clinic set in the mappings table" do
          it "creates the patient but does not schedule the appointment" do
            msg = hl7_message_from_raw_string(raw_hl7)

            expect {
              Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
            }.not_to change(Renalware::Clinics::Appointment, :count)

            expect(Renalware::Clinics::Mapping.count).to eq(1)
            expect(Renalware::Clinics::Mapping.last).to have_attributes(
              name_in_feed: clinic_name,
              clinic_id: nil,
              default_clinic: false
            )
          end
        end

        context "when there is a default clinic set in the mappings table" do
          it "creates the patient and schedules the appointment under the default clinic" do
            default_clinic = create(:clinic, code: "DefaultClinicCode", name: "Default Clinic")
            create(
              :clinics_mapping,
              name_in_feed: "Any Other Clinic",
              clinic: default_clinic, default_clinic: true
            )
            msg = hl7_message_from_raw_string(raw_hl7)

            # Creates a mapping for the new clinic_name to default_clinic
            # Creates the appointment under default_clinic
            expect {
              Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
            }.to change(Renalware::Clinics::Appointment, :count).by(1)
              .and change(Renalware::Clinics::Mapping, :count).by(1)

            expect(Renalware::Clinics::Mapping.last).to have_attributes(
              name_in_feed: clinic_name,
              clinic: default_clinic,
              default_clinic: false
            )
          end
        end
      end
    end

    context "when PV3.1.1 clinic code is empty" do
      let(:clinic_code) { "" }

      it "does nothing" do
        msg = hl7_message_from_raw_string(raw_hl7)

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.not_to change(Renalware::Patient, :count)
      end
    end
  end

  context "when patient already exists in RW" do
    it "schedules the appointment against the existing patient" do
      msg = hl7_message_from_raw_string(raw_hl7)
      clinic = create_clinic
      create(:clinics_mapping, name_in_feed: clinic_name, clinic:)
      consultant = create_consultant
      patient = create_patient

      expect {
        Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
      }.to change(Renalware::Clinics::Appointment, :count).by(1)

      expect(Renalware::Clinics::Appointment.last).to have_attributes(
        patient_id: patient.id,
        consultant_id: consultant.id,
        clinic_id: clinic.id
      )
    end

    context "when consultant is not found" do
      it "creates the consultant using PV1.7 Attending Consultant" do
        msg = hl7_message_from_raw_string(raw_hl7)
        clinic = create_clinic
        create(:clinics_mapping, name_in_feed: clinic_name, clinic:)
        patient = create_patient

        expect {
          Renalware::Clinics::Ingestion::Commands::CreateOrUpdateAppointment.call(msg)
        }.to change(Renalware::Clinics::Consultant, :count).by(1)
          .and change(Renalware::Clinics::Appointment, :count).by(1)

        consultant = Renalware::Clinics::Consultant.last
        expect(consultant).to have_attributes(
          code: "C3590850",
          name: "Dr John Smith"
        )

        expect(Renalware::Clinics::Appointment.last).to have_attributes(
          patient_id: patient.id,
          consultant_id: consultant.id,
          clinic_id: clinic.id
        )
      end
    end
  end
end
# rubocop:enable Layout/LineLength
