module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::Binary do
        subject(:binary) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:binary_uuid) { SecureRandom.uuid }
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:patient) { build_stubbed(:patient) }
        let(:letters_patient) { patient.becomes(Letters::Patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:topic) { build(:letter_topic, snomed_document_type: build(:snomed_document_type)) }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            uuid: "LET1",
            patient: letters_patient,
            updated_at: Time.zone.parse("2022-01-01 01:01:01"),
            event_id: 99,
            topic: topic,
            author: author,
            archive: build_stubbed(:letter_archive, uuid: binary_uuid, pdf_content: "123")
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        describe "#fullUrl" do
          subject { binary[:fullUrl] }

          it { is_expected.to eq("urn:uuid:#{binary_uuid}") }
        end

        describe "resource" do
          subject(:resource) { binary[:resource] }

          it do
            expect(resource.id).to eq(binary_uuid)
            expect(resource.contentType).to eq("application/pdf")
            expect(resource.content).to eq(Base64.encode64("123"))
          end

          it "profile" do
            expect(resource.meta.profile)
              .to eq(["https://fhir.nhs.uk/STU3/StructureDefinition/ITK-Attachment-Binary-1"])
          end
        end
      end
    end
  end
end
