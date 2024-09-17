# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::DistributionList do
        subject(:section) { described_class.new(arguments) }

        let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:patient) { build_stubbed(:letter_patient, secure_id: "123") }
        let(:letter) do
          build_stubbed(
            :letter,
            patient: patient,
            archive: build_stubbed(:letter_archive)
          ).tap do |lett|
            lett.build_main_recipient(person_role: :primary_care_physician)
          end
        end

        it { expect(section.snomed_code).to eq("887261000000109") }
        it { expect(section.title).to eq("Distribution list") }
        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil }

        describe "references" do
          it "has a reference to the patient" do
            allow(patient).to receive(:secure_id_dashed).and_return("123")

            hash = section.call

            expect(hash[:entry].any? { |entry| entry[:reference] == "urn:uuid:123" }).to be(true)
          end

          it "reference the author practitioner"
          it "references any eCCs practitioners ??"
        end
      end
    end
  end
end
