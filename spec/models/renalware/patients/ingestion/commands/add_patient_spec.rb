# frozen_string_literal: true

require "rails_helper"

module Renalware::Patients::Ingestion
  describe Commands::AddPatient do
    include HL7Helpers
    include PatientsSpecHelper
    subject(:service) { described_class }

    let(:system_user) { create(:user, username: Renalware::SystemUser.username) }

    before do
      Renalware.configure do |config|
        config.patient_hospital_identifiers = {
          HOSP_A: :local_patient_id,
          HOSP_B: :local_patient_id_2,
          HOSP_E: :local_patient_id_5,
          HOSP_C: :local_patient_id_3,
          HOSP_D: :local_patient_id_4
        }
        config.hl7_patient_locator_strategy = :dob_and_any_nhs_or_assigning_auth_number
      end
      system_user
    end

    describe "#call" do
      context "when the patient does not exist in Renalware" do
        it "creates them" do
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
            postcode: "postcode"
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
          expect {
            result = described_class.call(hl7_message)
          }.to change(Renalware::Patient, :count).by(1)

          expect(result).to be_a(Renalware::Patient)
          expect(Renalware::Patients::Ingestion::UpdateMasterPatientIndex).to have_received(:call)

          patient = Renalware::Patient.find_by!(nhs_number: "9999999999")

          expect(patient).to have_attributes(pattrs.to_h.slice!(:sex))
          expect(patient.sex.to_s).to eq(pattrs.to_h[:sex])
          expect(patient.current_address).to have_attributes(aattrs.to_h)
        end
      end
    end
  end
end
