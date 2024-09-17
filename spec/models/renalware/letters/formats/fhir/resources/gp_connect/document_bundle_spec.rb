# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::GPConnect::DocumentBundle do
        subject(:bundle) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:patient) { build_stubbed(:patient) }
        let(:resource) { bundle[:resource] }
        let(:letters_patient) { patient.becomes(Letters::Patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            uuid: "LET1",
            patient: letters_patient,
            updated_at: Time.zone.parse("2022-01-01 01:01:01"),
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
            expect(entries).to eq(
              [
                "FHIR::STU3::Composition",
                "FHIR::STU3::Practitioner",
                "FHIR::STU3::Organization",
                "FHIR::STU3::Patient",
                "FHIR::STU3::Binary"
              ]
            )
          end
        end
      end
    end
  end
end
