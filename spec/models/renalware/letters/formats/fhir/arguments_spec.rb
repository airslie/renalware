# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    describe Arguments do
      subject(:arguments) do
        described_class.new(
          transmission: transmission,
          transaction_uuid: transaction_uuid,
          organisation_uuid: "ORG1"
        )
      end

      let(:transmission) {
        build_stubbed(
          :letter_mesh_transmission,
          letter: letter
        )
      }
      let(:transaction_uuid) { SecureRandom.uuid }
      let(:patient_uuid) { "aaaabe8f-8694-47e3-8740-ccf306f6cf02" }
      let(:letter_uuid) { "aaaa54bb-adfb-452e-a829-c50a42709080" }
      let(:author_uuid) { "aaaa4316-1daa-4c41-91c9-a8d0ea6ceb5e" }
      let(:letter_archive_uuid) { "aaaa0000-1111-2222-2222-333333333333" }
      let(:clinic_visit_uuid) { "aaaaf1a9-0c1c-4151-b947-7d9e7fce0a75" }
      let(:patient) {
        build_stubbed(
          :letter_patient,
          secure_id: patient_uuid,
          family_name: "Jones",
          given_name: "Jenny",
          born_on: "1970-01-31",
          nhs_number: "0123456789"
        )
      }
      let(:clinics_patient) { Renalware::Clinics.cast_patient(patient) }
      let(:letter) {
        build_stubbed(
          :letter,
          uuid: letter_uuid,
          patient: patient,
          author: build_stubbed(:user, uuid: author_uuid),
          archive: build_stubbed(:letter_archive, uuid: letter_archive_uuid),
          description: "Clinic Letter",
          event: build_stubbed(
            :clinic_visit,
            uuid: clinic_visit_uuid,
            patient: clinics_patient
          )
        )
      }

      describe "patient_urn" do
        it do
          expect(arguments.patient_urn).to eq("urn:uuid:#{patient_uuid}")
        end
      end

      describe "letter_urn" do
        it do
          expect(arguments.letter_urn).to eq("urn:uuid:#{letter.uuid}")
        end
      end

      describe "author_urn" do
        it do
          expect(arguments.author_urn).to eq("urn:uuid:#{author_uuid}")
        end
      end

      describe "binary_uuid" do
        it do
          expect(arguments.binary_urn).to eq("urn:uuid:#{letter_archive_uuid}")
        end
      end

      describe "gp_connect?" do
        it do
          expect(arguments.gp_connect?).to be(true)
        end
      end

      # describe "encounter_urn" do
      #   it "is nil when there is no clinic visit for this letter" do
      #     allow(letter).to receive(:event).and_return(nil)

      #     expect(arguments.encounter_urn).to be_nil
      #   end

      #   it "returns the clinic_visit.uuid if this the letter is associated with a clinic" do
      #     expect(arguments.encounter_urn).to eq("urn:uuid:#{clinic_visit_uuid}")
      #   end
      # end

      describe "organisation_uuid" do
        it "is read from config" do
          expect(arguments.organisation_uuid).to eq("ORG1")
        end
      end

      describe "organisation_urn" do
        it "is derived from config" do
          expect(arguments.organisation_urn).to eq("urn:uuid:ORG1")
        end
      end

      describe "organisation_ods_code" do
        it "is read from config" do
          allow(Renalware.config).to receive(:mesh_organisation_ods_code).and_return("ABC")

          expect(arguments.organisation_ods_code).to eq("ABC")
        end
      end

      describe "mex_to" do
        it "concatenates nhs dob surname join with _" do
          expect(arguments.mex_to).to eq("GPPROVIDER_0123456789_19700131_Jones")
        end
      end

      describe "mex_subject" do
        it "concatenates document title, patient and organisation etc" do
          allow(Renalware.config).to receive_messages(
            mesh_organisation_ods_code: "ODS1",
            mesh_organisation_name: "Some Hospital"
          )

          expect(arguments.mex_subject).to eq(
            "Report of clinical encounter for JONES, Jenny, NHS Number: 0123456789, " \
            "seen at Some Hospital, ODS1, Version: 1"
          )
        end
      end

      describe "document_title" do
        it "is an alias for letter.description" do
          expect(arguments.document_title).to eq("Report of clinical encounter")
        end
      end
    end
  end
end
