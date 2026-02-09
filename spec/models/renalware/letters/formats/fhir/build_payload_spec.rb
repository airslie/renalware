module Renalware::Letters
  module Formats::FHIR
    describe BuildPayload do
      include LettersSpecHelper

      let(:user) { create(:user, :minimal) }
      let(:practice) { create(:practice) }

      def create_patient(given_name: "John")
        create(
          :letter_patient,
          given_name:, # trigger value
          practice:,
          primary_care_physician: create(:letter_primary_care_physician, practices: [practice]),
          by: user
        )
      end

      def create_mesh_letter(patient, user, to: :primary_care_physician)
        create_letter(
          state: :approved,
          to:,
          patient:,
          author: user,
          topic: create(:letter_topic, snomed_document_type: create(:snomed_document_type)),
          by: user,
          approved_at: Time.zone.now
        ).reload.tap do |letter|
          letter.archive = create(:letter_archive, letter:, by: user)
        end
      end

      before do
        allow(Renalware.config).to receive_messages(
          mesh_organisation_uuid: SecureRandom.uuid,
          mesh_itk_organisation_uuid: SecureRandom.uuid,
          mesh_organisation_ods_code: "ABC"
        )
      end

      it "#call" do
        patient = create_patient
        letter = create_mesh_letter(patient, user)
        transmission = Transports::Mesh::Transmission.create!(letter:)
        args = Arguments.new(transmission:, transaction_uuid: "123")

        xml_string = described_class.call(args)

        expect(xml_string).to be_a(String)
        Nokogiri::XML(xml_string)
      end
    end
  end
end
