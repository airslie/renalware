module Renalware
  module Letters
    module Formats::FHIR
      module Resources::TransferOfCare
        describe Sections::AllergiesAndAdverseReactions do
          include LettersSpecHelper

          subject(:section) { described_class.new(arguments) }

          let(:letter) { simple_stubbed_letter(patient) }
          let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
          let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
          let(:patient) { Renalware::Patient.new(secure_id: "123") }

          it { expect(section.snomed_code).to eq("886921000000105") }
          it { expect(section.title).to eq("Allergies and adverse reactions") }
          it { expect(section.render?).to be(true) }
          it { expect(section.call).not_to be_nil } # section not supported
        end
      end
    end
  end
end
