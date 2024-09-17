# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    describe BuildPayload do
      include LettersSpecHelper
      let(:user) { create(:user) }
      let(:practice) { create(:practice) }

      def create_patient(given_name: "John")
        create(
          :letter_patient,
          given_name: given_name, # trigger value
          practice: practice,
          primary_care_physician: create(:letter_primary_care_physician, practices: [practice]),
          by: user
        )
      end

      def create_mesh_letter(patient, user, to: :primary_care_physician)
        create_letter(
          state: :approved,
          to: to,
          patient: patient,
          author: user,
          by: user
        ).reload.tap do |letter|
          letter.archive = create(:letter_archive, letter: letter, by: user)
        end
      end

      it "#call" do
        patient = create_patient
        letter = create_mesh_letter(patient, user)
        transmission = Transports::Mesh::Transmission.create!(letter: letter)
        args = Arguments.new(transmission: transmission, transaction_uuid: "123")

        xml_string = described_class.call(args)

        expect(xml_string).to be_a(String)
        Nokogiri::XML(xml_string)
      end
    end
  end
end
