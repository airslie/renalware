# Characterisation ("golden file") spec for the GP Connect Send Document payload.
#
# The XML produced here is what NHS England assured and what is in production at HOSPA, so any
# refactoring of the delivery code (e.g. extracting it so it can be shared with Relay) must
# leave it byte-for-byte unchanged. All inputs are fixed and the two sources of nondeterminism
# (the MessageHeader timestamp and random identifiers) are pinned.
#
# If a change to the payload is intentional (and re-assured), regenerate the fixture with:
#   UPDATE_GOLDEN=1 bin/rspec \
#     spec/models/renalware/letters/formats/fhir/build_payload_call_golden_file_spec.rb
module Renalware::Letters
  module Formats::FHIR
    describe BuildPayload, ".call (golden file)" do
      let(:fixture_path) do
        Rails.root.join("spec/fixtures/letters/fhir/gp_connect_send_document.xml")
      end

      let(:patient) do
        build_stubbed(
          :patient,
          secure_id: "11111111111111111111111111111111",
          nhs_number: "9999999999",
          born_on: Date.new(1970, 1, 2),
          given_name: "Patricia",
          family_name: "Jones",
          title: "Ms",
          local_patient_id: "KCH12345",
          local_patient_id_2: nil,
          local_patient_id_3: nil,
          local_patient_id_4: nil,
          telephone1: "01234 567890",
          email: "patricia@example.com"
        ).becomes(Renalware::Letters::Patient)
      end
      let(:clinics_patient) { patient.becomes(Renalware::Clinics::Patient) }
      let(:author) do
        build_stubbed(
          :user,
          uuid: "22222222-2222-2222-2222-222222222222",
          given_name: "Jane",
          family_name: "Doctor",
          professional_position: "Consultant Nephrologist"
        )
      end
      let(:topic) do
        build(
          :letter_topic,
          snomed_document_type: build(
            :snomed_document_type,
            code: "371531000",
            title: "Report of clinical encounter"
          )
        )
      end
      let(:letter) do
        build_stubbed(
          :approved_letter,
          uuid: "33333333-3333-3333-3333-333333333333",
          patient:,
          topic:,
          author:,
          approved_at: Time.zone.parse("2022-01-01 01:01:01"),
          event: build_stubbed(
            :clinic_visit,
            uuid: "44444444-4444-4444-4444-444444444444",
            date: "2022-01-01",
            time: "11:01:01",
            patient: clinics_patient
          ),
          event_id: 99,
          archive: build_stubbed(
            :letter_archive,
            uuid: "55555555-5555-5555-5555-555555555555",
            content: "<html><body>Golden letter</body></html>",
            pdf_content: "%PDF-1.4 golden"
          )
        ).tap do |let|
          let.build_main_recipient(person_role: :primary_care_physician)
        end
      end
      let(:transmission) do
        instance_double(
          Transports::Mesh::Transmission,
          letter:,
          uuid: "66666666-6666-6666-6666-666666666666"
        )
      end
      let(:arguments) do
        Arguments.new(
          transmission:,
          transaction_uuid: "77777777-7777-7777-7777-777777777777"
        )
      end

      before do
        allow(Renalware.config).to receive_messages(
          letters_mesh_workflow: :gp_connect,
          mesh_organisation_uuid: "88888888-8888-8888-8888-888888888888",
          mesh_itk_organisation_uuid: "99999999-9999-9999-9999-999999999999",
          mesh_organisation_ods_code: "RAJ01",
          mesh_organisation_name: "Test Hospital",
          mesh_organisation_phone: "01111 111111",
          mesh_organisation_email: "org@example.com",
          mesh_practitioner_phone: "02222 222222",
          mesh_care_setting_snomed_code: "788003006",
          mesh_care_setting_description: "Nephrology service",
          mesh_use_endpoint_lookup: false
        )
        allow(SecureRandom).to receive(:uuid).and_return("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
      end

      it "routes using MESH auto-routing demographics in Mex-To" do
        expect(arguments.mex_to).to eq("GPPROVIDER_9999999999_19700102_Jones")
      end

      it "uses the document title as the Mex-Subject" do
        expect(arguments.mex_subject).to eq(
          "Consultation report for JONES, Patricia (Ms), NHS Number: 9999999999, " \
          "seen at Test Hospital, RAJ01, Version: 1"
        )
      end

      it "produces the assured GP Connect XML, unchanged" do
        xml = travel_to(Time.utc(2022, 1, 2, 3, 4, 5)) { described_class.call(arguments) }

        if ENV["UPDATE_GOLDEN"]
          FileUtils.mkdir_p(fixture_path.dirname)
          File.write(fixture_path, xml)
        end

        expect(xml).to eq(File.read(fixture_path))
      end
    end
  end
end
