module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::GPConnect::Composition do
        subject(:composition) { described_class.call(arguments) }

        let(:transmission) do
          instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
        end
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
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
            topic: topic,
            event_id: 99,
            author: author
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        before do
          allow(letter).to receive_messages(uuid: "LET1", event: clinic_visit)
          allow(author).to receive_messages(uuid: "abc")
          allow(letter_patient).to receive(:secure_id_dashed).and_return("PAT1")
          allow(clinic_visit).to receive(:uuid).and_return("CV_ENCOUNTER_1")
          allow(Renalware.config).to receive(:mesh_organisation_uuid).and_return("ORG1")
        end

        describe "fullUrl" do
          subject { composition[:fullUrl] }

          it "is the urn of the letter" do
            is_expected.to eq("urn:uuid:LET1")
          end
        end

        describe "resource" do
          subject(:resource) { composition[:resource] }

          # GPCM-SD-104
          describe "meta profile" do
            subject { resource.meta.profile.first }

            it "has the correct profile" do
              is_expected
                .to eq("https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Composition-1")
            end
          end

          it "id is the message id (a UUID in the database)" do
            expect(resource.id).to eq(letter.uuid)
          end

          it "subject references the patient urn" do
            expect(resource.subject.reference).to eq("urn:uuid:PAT1")
          end

          it "includes the letter updated_at" do
            expect(resource.date).to eq("2022-01-01")
          end

          it "author element references the sending organisation" do
            expect(resource.author.first.reference).to eq("urn:uuid:abc")
          end

          it "custodian element references the sending organisation" do
            expect(resource.custodian.reference).to eq("urn:uuid:ORG1")
          end

          it "has the correct snomed code" do
            expect(resource.type.coding[0].code).to eq("823691000000103")
            expect(resource.type.coding[0].display).to eq("Clinical letter (record artifact)")
          end

          it "has correct sections" do
            section = resource.section[0]
            expect(section.entry[0].reference).to eq arguments.organisation_urn
            expect(section.entry[1].reference).to eq arguments.author_urn
            expect(section.entry[2].reference).to eq arguments.patient_urn
            expect(section.entry[3].reference).to eq arguments.binary_urn
          end
        end
      end
    end
  end
end
