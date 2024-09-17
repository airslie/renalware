# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    describe Resources::AllergyIntolerance do
      subject(:encounter) { described_class.call(arguments) }

      let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
      let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
      let(:patient) { instance_double(Renalware::Patient, secure_id_dashed: "123") }
      let(:letter) { instance_double(Letter, patient: patient) }

      describe "references" do
        it "has a reference to the patient" do
          expect(encounter[:resource].patient.reference).to eq("urn:uuid:123")
        end

        it "has handles missing snomed codes"
      end
    end
  end
end
