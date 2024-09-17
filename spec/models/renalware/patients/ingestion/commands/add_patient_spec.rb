# frozen_string_literal: true

module Renalware::Patients::Ingestion
  describe Commands::AddPatient do
    include HL7Helpers
    include PatientsSpecHelper

    subject(:service) { described_class }

    let(:system_user) { create(:user, username: Renalware::SystemUser.username) }

    before do
      allow(Renalware.config).to receive_messages(
        patient_hospital_identifiers: {
          HOSP_A: :local_patient_id,
          HOSP_B: :local_patient_id_2,
          HOSP_E: :local_patient_id_5,
          HOSP_C: :local_patient_id_3,
          HOSP_D: :local_patient_id_4
        }
      )
      allow(Renalware.config.hl7_patient_locator_strategy)
        .to receive(:fetch)
        .with(:adt)
        .and_return(:nhs_or_any_assigning_auth_number)

      system_user
    end

    describe "#call" do
      context "when the patient does not exist in Renalware" do
        it "creates them" do # rubocop:disable RSpec/ExampleLength
          pattrs = OpenStruct.new(
            local_patient_id: "HA123",
            local_patient_id_2: "HB123",
            local_patient_id_3: "HC123",
            local_patient_id_4: "HD123",
            local_patient_id_5: "HE123",
            given_name: "Johnny",
            family_name: "Jones",
            sex: "M"
          )
          aattrs = OpenStruct.new(
            street_1: "address1",
            street_2: "address2",
            town: "town",
            county: "county",
            postcode: "POSTCODE"
          )

          msh = "MSH|^~\&|ADT||||20150122154918||ADT^A31|897847653|P|2.3"
          pid = "PID||" \
                "9999999999^^^NHS|" \
                "#{pattrs.local_patient_id}^^^HOSP_A~" \
                "#{pattrs.local_patient_id_2}^^^HOSP_B~" \
                "#{pattrs.local_patient_id_3}^^^HOSP_C~" \
                "#{pattrs.local_patient_id_4}^^^HOSP_D~" \
                "#{pattrs.local_patient_id_5}^^^HOSP_E" \
                "||#{pattrs.family_name}^#{pattrs.given_name}^^^MS||20000101|#{pattrs.sex}|||" \
                "#{aattrs.street_1}^#{aattrs.street_2}^#{aattrs.town}^#{aattrs.county}^" \
                "#{aattrs.postcode}^other^HOME|||||||||||||||||||"

          hl7_message = Renalware::Feeds::HL7Message.new(::HL7::Message.new([msh, pid]))

          allow(Renalware::Patients::Ingestion::UpdateMasterPatientIndex).to receive(:call)

          result = nil
          reason = "123"
          expect {
            result = described_class.call(hl7_message, reason)
          }.to change(Renalware::Patient, :count).by(1)

          expect(result).to be_a(Renalware::Patient)
          expect(Renalware::Patients::Ingestion::UpdateMasterPatientIndex).to have_received(:call)

          patient = Renalware::Patient.find_by!(nhs_number: "9999999999")

          expect(patient).to have_attributes(pattrs.to_h.slice!(:sex))
          expect(patient.sex.to_s).to eq(pattrs.to_h[:sex])
          expect(patient.current_address).to have_attributes(aattrs.to_h)
        end
      end

      describe "broadcasting" do
        context "when the patient is not found" do
          it "broadcasts a :patient_added event when the patient is added" do
            # Mock up a an HL7 message
            hl7_message = Renalware::Feeds::HL7Message.new(HL7::Message.new)
            # Stub the PatientLocator to not find the patient
            allow(Renalware::Feeds::PatientLocator).to receive(:call).and_return(nil)
            # Stub UpdateMasterPatientIndex so it does not get in the way
            allow(Renalware::Patients::Ingestion::UpdateMasterPatientIndex).to receive(:call)
            # Mock a patient..
            patient = build(:patient, id: 123)
            allow(patient).to receive(:save!).and_return(true)
            # ..that is returned by a mock MessageMappers::Patient builder
            mapper_class = Renalware::Patients::Ingestion::MessageMappers::Patient
            allow(mapper_class)
              .to receive(:new)
              .and_return(instance_double(mapper_class, fetch: patient))

            # As the patient is not found by the Locator, the mapper will return our mock patient
            # and we will 'save' it and broadcast an event, passing the new patient as an arg
            reason = "123"
            expect {
              described_class.call(hl7_message, reason)
            }.to broadcast(:patient_added, patient, reason)

            # Sanity check that we did try and save the patient
            expect(patient).to have_received(:save!)
          end
        end

        context "when the patient was found" do
          it "does not broadcast an event" do
            # Mock up a an HL7 message
            hl7_message = Renalware::Feeds::HL7Message.new(HL7::Message.new)
            # Mock a patient..
            patient = instance_double(Renalware::Patient, "by=": nil, new_record?: true)
            # Stub the PatientLocator to find the patient
            allow(Renalware::Feeds::PatientLocator).to receive(:call).and_return(patient)
            # Stub UpdateMasterPatientIndex so it does not get in the way
            allow(Renalware::Patients::Ingestion::UpdateMasterPatientIndex).to receive(:call)

            expect {
              described_class.call(hl7_message)
            }.not_to broadcast(:patient_added, patient)
          end
        end
      end
    end
  end
end
