module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::GPPractice do
        include LettersSpecHelper

        subject(:section) { described_class.new(arguments) }

        let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
        let(:arguments) do
          Arguments.new(
            transmission: transmission,
            transaction_uuid: "123",
            organisation_uuid: "ORG1"
          )
        end
        let(:patient) { build_stubbed(:letter_patient, secure_id: "123") }
        let(:topic) { build(:letter_topic, snomed_document_type: build(:snomed_document_type)) }
        let(:letter) do
          build_stubbed(
            :letter,
            patient: patient,
            topic: topic,
            archive: build_stubbed(:letter_archive)
          ).tap do |lett|
            lett.build_main_recipient(person_role: :primary_care_physician)
          end
        end

        before do
          allow(Renalware.config).to receive(:mesh_organisation_uuid).and_return("xyz")
        end

        it { expect(section.snomed_code).to eq("886711000000101") }
        it { expect(section.title).to eq("GP practice") }
        it { expect(section.entries).to eq([{ reference: "urn:uuid:ORG1" }]) }
        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil }
      end
    end
  end
end
