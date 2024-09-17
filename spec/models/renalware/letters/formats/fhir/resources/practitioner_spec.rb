# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    describe Resources::Practitioner do
      subject(:practitioner) { described_class.call(arguments) }

      let(:author) do
        instance_double(
          Renalware::User,
          uuid: "999",
          family_name: "Smith",
          given_name: "John",
          professional_position: "Consultant"
        )
      end

      let(:patient) {
        instance_double(
          Renalware::Patient,
          secure_id_dashed: "111",
          nhs_number: "0123456789",
          local_patient_id: "PID1",
          local_patient_id_2: "PID2",
          local_patient_id_3: "",
          local_patient_id_4: nil,
          given_name: "John",
          family_name: "Doe",
          title: "Mr",
          sex: "M",
          born_on: Date.parse("2001-01-02"),
          current_address: nil,
          telephone1: nil,
          email: nil
        )
      }
      let(:letter) { instance_double(Letter, patient: patient, author: author) }
      let(:arguments) do
        Arguments.new(
          transmission: instance_double(Transports::Mesh::Transmission, letter: letter),
          transaction_uuid: "123"
        )
      end

      it "fullUrl" do
        expect(practitioner[:fullUrl]).to eq("urn:uuid:999")
      end

      describe "resource" do
        subject(:resource) { practitioner[:resource] }

        it { expect(resource.id).to eq("999") }
        it { expect(resource.meta.profile).to eq(["https://fhir.hl7.org.uk/STU3/StructureDefinition/CareConnect-Practitioner-1"]) }

        describe "identifier" do
          pending "Add once we can get SDS user id"
        end

        describe "name" do
          subject(:name) { resource.name[0] }

          it { expect(name.use).to eq("official") }
          it { expect(name.family).to eq("Smith") }
          it { expect(name.given).to eq(["John"]) }
          it { expect(name.prefix).to eq(["Consultant"]) }
        end

        describe "telecom" do
          subject(:telecom) { resource.telecom[0] }

          before { allow(Renalware.config).to receive(:mesh_practitioner_phone).and_return("1234") }

          it { expect(telecom.system).to eq("phone") }
          it { expect(telecom.value).to eq("1234") }
          it { expect(telecom.use).to eq("work") }
        end
      end
    end
  end
end
