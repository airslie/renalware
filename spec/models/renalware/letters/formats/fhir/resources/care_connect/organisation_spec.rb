# frozen_string_literal: true

module Renalware
  module Letters
    module Formats::FHIR
      module Resources::CareConnect
        describe Organisation do
          let(:transmission) do
            instance_double(Transports::Mesh::Transmission, letter: letter, uuid: "TRANS1")
          end
          let(:arguments) {
            Arguments.new(transmission: transmission, transaction_uuid: "123")
          }
          let(:patient) { build_stubbed(:patient) }
          let(:letters_patient) { patient.becomes(Patient) }
          let(:clinics_patient) { patient.becomes(Clinics::Patient) }
          let(:author) { build_stubbed(:user, uuid: "abc") }
          let(:letter) {
            build_stubbed(
              :approved_letter,
              uuid: "LET1",
              patient: letters_patient,
              updated_at: Time.zone.parse("2022-01-01 01:01:01"),
              event: build_stubbed(
                :clinic_visit,
                uuid: "222",
                date: "2022-01-01",
                time: "11:01:01",
                patient: clinics_patient
              ),
              archive: build_stubbed(:letter_archive),
              event_id: 99,
              author: author
            ).tap do |let|
              let.build_main_recipient(person_role: :primary_care_physician)
            end
          }

          subject(:organisation) { described_class.call(arguments) }

          describe "resource" do
            subject(:resource) { organisation[:resource] }

            before do
              allow(Renalware.config).to receive(:mesh_organisation_phone).and_return("1234")
            end

            describe "name" do
              before do
                allow(Renalware.config).to receive(:mesh_organisation_name).and_return("Xxx")
              end

              it { expect(resource.name).to eq("Xxx") }
            end

            describe "telecom" do
              it "phone" do
                expect(resource.telecom[0]).to have_attributes(
                  system: "phone",
                  value: "1234",
                  use: "work"
                )
              end

              describe "email" do
                context "when config.mesh_organisation_email is configured" do
                  before do
                    allow(Renalware.config)
                      .to receive(:mesh_organisation_email).and_return("x@y.com")
                  end

                  it "uses it" do
                    expect(resource.telecom[1]).to have_attributes(
                      system: "email",
                      value: "x@y.com",
                      use: "work"
                    )
                  end
                end

                context "when config.mesh_organisation_email not configured" do
                  before do
                    allow(Renalware.config)
                      .to receive(:mesh_organisation_email).and_return("")
                  end

                  it "omits it" do
                    expect(resource.telecom[1]).to be_nil
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
