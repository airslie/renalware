# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::TransferOfCare::DocumentBundle do
        subject(:bundle) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:patient) { build_stubbed(:patient) }
        let(:resource) { bundle[:resource] }
        let(:letters_patient) { patient.becomes(Letters::Patient) }
        let(:clinics_patient) { patient.becomes(Clinics::Patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            uuid: "LET1",
            patient: letters_patient,
            updated_at: Time.zone.parse("2022-01-01 01:01:01"),
            event: build_stubbed(
              :clinic_visit,
              uuid: "222",
              date: "2022-01-01",
              time: "11:01:01",
              patient: clinics_patient
            ),
            event_id: 99,
            author: author
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        before do
          # A lot of work to get all the data in place!
          allow(patient).to receive(:secure_id_dashed).and_return("PAT1")
          allow(letter)
            .to receive(:archive)
            .and_return(build_stubbed(:letter_archive, letter: letter))
        end

        it do
          expect(resource.id).to eq(transmission.uuid)
          expected_updated_at = letter.updated_at.to_datetime.to_s
          expect(resource.meta.lastUpdated).to eq(expected_updated_at)
          expect(resource.type).to eq("document")
        end

        describe "fullUrl" do
          pending ".."
        end

        describe "#entry" do
          subject(:entry) { resource.entry }

          it do
            entries = resource.entry.map { |en| en.resource.class.name }
            expect(entries).to include(
              # "Formats::FHIR::STU3::AllergyIntolerance",
              # "Formats::FHIR::STU3::MedicationStatement",
              "FHIR::STU3::Patient",
              "FHIR::STU3::Composition",
              "FHIR::STU3::Encounter"
            )
            # TODO: Check Lists are included
          end
        end
      end
    end
  end
end
