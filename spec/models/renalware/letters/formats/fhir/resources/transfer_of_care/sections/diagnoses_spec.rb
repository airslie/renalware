# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      module Resources::TransferOfCare
        describe Sections::Diagnoses do
          subject(:section) { described_class.new(arguments) }

          let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
          let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
          let(:patient) {
            instance_double(Renalware::Patient, secure_id_dashed: "123", problems: [])
          }
          let(:letter) { instance_double(Letter, patient: patient) }

          it { expect(section.snomed_code).to eq("887161000000102") }
          it { expect(section.title).to eq("Diagnoses") }
          it { expect(section.render?).to be(true) }
          it { expect(section.call).not_to be_nil }
        end
      end
    end
  end
end
