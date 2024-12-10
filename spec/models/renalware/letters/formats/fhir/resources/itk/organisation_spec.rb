# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources
      describe ITK::Organisation do
        subject(:organisation) { described_class.call(arguments) }

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

        let(:resource) { organisation[:resource] }
        let(:patient) { build_stubbed(:patient) }
        let(:letters_patient) { patient.becomes(Renalware::Letters::Patient) }
        let(:author) { build_stubbed(:user, uuid: "abc") }
        let(:letter) {
          build_stubbed(
            :approved_letter,
            uuid: "LET1",
            patient: letters_patient,
            updated_at: Time.zone.parse("2022-01-01 01:01:01"),
            event_id: 99,
            author: author,
            archive: build_stubbed(:letter_archive, uuid: "123", pdf_content: "123")
          ).tap do |let|
            let.build_main_recipient(person_role: :primary_care_physician)
          end
        }

        it "renders the resource" do
          expect(resource.identifier.first.value).to eq("RAJ01")
        end
      end
    end
  end
end
