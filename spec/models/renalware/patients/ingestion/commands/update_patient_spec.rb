# frozen_string_literal: true

module Renalware::Patients::Ingestion
  describe Commands::UpdatePatient do
    include HL7Helpers
    include PatientsSpecHelper
    subject(:service) { described_class }

    let(:system_user) { create(:user, username: Renalware::SystemUser.username) }

    def create_deceased_patient_with_incomplete_death_attributes(
      by:,
      nhs_number: nil,
      born_on: "2000-01-01"
    )
      create(
        :patient,
        local_patient_id: "A123",
        born_on: born_on,
        nhs_number: nhs_number,
        died_on: nil,
        first_cause: nil
      ).tap do |patient|
        set_modality(
          patient: patient,
          modality_description: create(:modality_description, :death),
          by: by
        )
      end
    end
    describe "#call" do
      context "when the patient has the death modality but no cause of death or died_on set" do
        it "can update the patient without triggering missing cause of death validations" do
          patient = create_deceased_patient_with_incomplete_death_attributes(
            by: system_user,
            nhs_number: "9999999999"
          )
          hl7_data = OpenStruct.new(
            hospital_number: "A123",
            nhs_number: "9999999999",
            family_name: "new_family_name",
            given_name: "new_given_name",
            born_on: Date.parse("2000-01-01")
          )

          hl7_message = hl7_message_from_file("ADT_A31", hl7_data)

          expect(hl7_message.patient_identification.internal_id).to eq("A123")
          described_class.new(hl7_message).call

          expect(patient.reload.nhs_number).to eq("9999999999")
        end
      end

      describe "ethnicity" do
        [
          { possibles: %w(A B), current: "A", incoming: "B", expected: "B" },
          { possibles: %w(A), current: "A", incoming: "B", expected: "A" }
        ].each do |opts|
          context "when configured ethnicities are #{opts[:possibles].join(', ')} " \
                  "and the patient's current ethnicity is #{opts[:current]} " \
                  "and incoming ethnicity is #{opts[:incoming]}" do
            before do
              allow(Renalware.config.hl7_patient_locator_strategy)
                .to receive(:fetch)
                .with(:adt)
                .and_return(:simple)
              opts[:possibles].each { |code| create(:ethnicity, name: code, rr18_code: code) }
            end

            it "expects patient ethnicity to be #{opts[:expected]} after saving" do
              patient = create(
                :patient,
                ethnicity: Renalware::Patients::Ethnicity.find_by!(rr18_code: opts[:current]),
                local_patient_id: "HA123",
                by: system_user
              )

              msh = "MSH|^~\&|ADT||||20150122154918||ADT^A31|897847653|P|2.3"
              pid = "PID||9999999999^^^NHS|HA123^^^HOSP_A~||Jones^John^^^MS||" \
                    "20000101|M||||||||||||||" \
                    "#{opts[:incoming]}||||||||"

              hl7_message = Renalware::Feeds::HL7Message.new(::HL7::Message.new([msh, pid]))

              # Sanity check of the data we are going to try and save
              expect(hl7_message.patient_identification.ethnic_group).to eq(opts[:incoming])

              # Persist the data
              described_class.new(hl7_message).call

              expect(patient.reload.ethnicity.rr18_code).to eq(opts[:expected])
            end
          end
        end
      end

      context "when updating a patient and the strategy=nhs_or_any_assigning_auth_number" do
        it "updates the correct patient number columns" do # rubocop:disable RSpec/ExampleLength
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

          # The patient is known on the system only as local_patient_id_2 (HOSP_B) => "HB123"
          # so after the update any other numbers passed in the HL7 should be populated.
          patient = create(
            :patient,
            local_patient_id_2: "HB123",
            nhs_number: nil,
            by: system_user
          )

          msh = "MSH|^~\&|ADT||||20150122154918||ADT^A31|897847653|P|2.3"
          pid = "PID||" \
                "9999999999^^^NHS|" \
                "HA123^^^HOSP_A~" \
                "HB123^^^HOSP_B~" \
                "HC123^^^HOSP_C~" \
                "HD123^^^HOSP_D~" \
                "HE123^^^HOSP_E" \
                "||Jones^John^^^MS||20000101|M|||" \
                "address1^address2^address3^address4^postcode^other^HOME|||||||||||||||||||"

          hl7_message = Renalware::Feeds::HL7Message.new(::HL7::Message.new([msh, pid]))

          expected_hosp_numbers = {
            nhs_number: "9999999999",
            local_patient_id: "HA123",
            local_patient_id_2: "HB123",
            local_patient_id_3: "HC123",
            local_patient_id_4: "HD123",
            local_patient_id_5: "HE123"
          }

          # Sanity check of the data we are going to try and save
          expect(hl7_message.patient_identification.identifiers).to eq(expected_hosp_numbers)

          # Persist the data
          described_class.new(hl7_message).call

          # We should have saved all the numbers
          expect(patient.reload).to have_attributes(expected_hosp_numbers)
        end
      end

      context "when updating a patient found by nhs_number with the 'simple' strategy" do
        it "does not change the local_patient_id" do
          allow(Renalware.config)
            .to receive(:patient_hospital_identifiers)
            .and_return({ HOSP_A: :local_patient_id })
          allow(Renalware.config.hl7_patient_locator_strategy)
            .to receive(:fetch)
            .with(:adt)
            .and_return(:simple)

          # The patient is known on the system only as NHS number "1791963196"
          # so after the update the local_patient_id using the number in the HL7 message
          patient = create(
            :patient,
            local_patient_id: "PAS123",
            born_on: "2000-01-01",
            nhs_number: "1791963196",
            by: system_user
          )

          msh = "MSH|^~\&|ADT||||20150122154918||ADT^A31|897847653|P|2.3"
          pid = "PID||" \
                "1791963196^^^NHS|PAS123^^^HOSP_A~" \
                "||Jones^John^^^MS||20000101|M|||" \
                "address1^address2^address3^address4^postcode^other^HOME|||||||||||||||||||"

          hl7_message = Renalware::Feeds::HL7Message.new(::HL7::Message.new([msh, pid]))

          expected_hosp_numbers = { nhs_number: "1791963196", local_patient_id: "PAS123" }

          # Sanity check of the data we are going to try and save
          expect(hl7_message.patient_identification.identifiers).to eq(expected_hosp_numbers)

          # Persist the data
          described_class.new(hl7_message).call

          # We should have saved all the numbers
          expect(patient.reload).to have_attributes(expected_hosp_numbers)
        end
      end
    end
  end
end
