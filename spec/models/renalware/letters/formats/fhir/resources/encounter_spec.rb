# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      describe Resources::Encounter do
        subject(:encounter) { described_class.call(arguments) }

        let(:arguments) do
          patient = instance_double(Renalware::Patient, secure_id_dashed: "111")
          visit = instance_double(
            Renalware::Clinics::ClinicVisit,
            uuid: "222",
            datetime: DateTime.parse("2022-01-01 11:00:00")
          )
          letter = instance_double(Letter, patient: patient, event: visit, author: author)
          Arguments.new(
            transmission: instance_double(Transports::Mesh::Transmission, letter: letter),
            transaction_uuid: "123"
          )
        end
        let(:author) { instance_double(Renalware::User, uuid: "999") }

        describe "#resource" do
          subject(:resource) { encounter[:resource] }

          it "references the patient" do
            expect(resource.subject.reference).to eq("urn:uuid:111")
          end

          it "has an id matching the clinic visit uuid" do
            expect(resource.id).to eq("222")
          end

          describe "#period" do
            subject { resource.period }

            it {
              is_expected.to have_attributes(
                start: "2022-01-01T11:00:00+00:00",
                end: "2022-01-01T11:00:00+00:00"
              )
            }
          end

          describe "#participant" do
            it "is the author's urn" do
              expect(
                resource.participant.first.individual.reference
              ).to eq("urn:uuid:#{author.uuid}")
            end
          end
        end

        describe "#fullUrl" do
          subject { encounter[:fullUrl] }

          it { is_expected.to eq("urn:uuid:222") }
        end
      end
    end
  end
end
