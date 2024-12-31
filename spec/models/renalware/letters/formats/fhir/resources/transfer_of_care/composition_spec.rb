module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::TransferOfCare::Composition do
        subject(:composition) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:arguments) do
          Arguments.new(
            transmission: transmission,
            transaction_uuid: "123",
            organisation_uuid: "ORG1",
            itk_organisation_uuid: "ITKORG1"
          )
        end
        let(:resource) { composition[:resource] }
        let(:patient) { build_stubbed(:patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:clinic_visit) { build_stubbed(:clinic_visit, patient: Clinics.cast_patient(patient)) }
        let(:letter_patient) { patient.becomes(Letters::Patient) }
        let(:topic) { build(:letter_topic, snomed_document_type: build(:snomed_document_type)) }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            archive: build_stubbed(:letter_archive),
            patient: letter_patient,
            updated_at: Time.zone.parse("2022-01-01 01:01:01"),
            event: clinic_visit,
            event_id: 99,
            author: author,
            topic: topic
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        before do
          allow(author).to receive(:uuid).and_return("abc")
          allow(letter).to receive_messages(uuid: "LET1", event: clinic_visit)
          allow(letter_patient).to receive(:secure_id_dashed).and_return("PAT1")
          allow(clinic_visit).to receive(:uuid).and_return("CV_ENCOUNTER_1")
        end

        describe "fullUrl" do
          subject { composition[:fullUrl] }

          it "is the urn of the letter" do
            is_expected.to eq("urn:uuid:LET1")
          end
        end

        describe "resource" do
          subject(:resource) { composition[:resource] }

          it "id is the message id (a UUID in the database)" do
            expect(resource.id).to eq(letter.uuid)
          end

          it "references the patient" do
            expect(resource.subject.reference).to eq("urn:uuid:PAT1")
          end

          # it "references the clinic visit" do
          #   expect(resource.encounter.reference).to eq("urn:uuid:CV_ENCOUNTER_1")
          # end

          it "includes the letter updated_at" do
            expect(resource.date).to eq("2022-01-01T01:01:01+00:00")
          end

          it "references the letter author" do
            expect(resource.author.first.reference).to eq("urn:uuid:abc")
          end

          it "has the correct snomed code" do
            expect(resource.type.coding.first.code).to eq("823681000000100")
            expect(resource.type.coding.first.display).to eq("Outpatient letter")
          end

          it "references MSE as the custodian" do
            expect(resource.custodian.reference).to eq("urn:uuid:ORG1")
          end

          it "uses the correct 'Correspondence Care Setting Type'" do
            pending "FIXME"

            expect(
              resource.extension.last.valueCodeableConcept.coding.first.code
            ).to eq("snomed code for setting")
          end
        end
      end
    end
  end
end
