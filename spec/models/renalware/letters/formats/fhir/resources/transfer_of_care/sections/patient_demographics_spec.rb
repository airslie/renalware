# frozen_string_literal: true

module Renalware::Letters
  module Formats::FHIR
    module Resources::TransferOfCare
      describe Sections::PatientDemographics do
        subject(:section) { described_class.new(arguments) }

        let(:transmission) { instance_double(Transports::Mesh::Transmission, letter: letter) }
        let(:arguments) { Arguments.new(transmission: transmission, transaction_uuid: "123") }
        let(:patient) do
          build_stubbed(
            :letter_patient,
            secure_id: "c513673c-e768-4c0b-baf0-05a6f9e154ed"
          )
        end

        let(:letter) do
          build_stubbed(
            :letter,
            patient: patient,
            archive: build_stubbed(:letter_archive)
          )
        end

        it { expect(section.snomed_code).to eq("886731000000109") }
        it { expect(section.title).to eq("Patient demographics") }

        it do
          expect(section.entries).to eq(
            [{ reference: "urn:uuid:c513673c-e768-4c0b-baf0-05a6f9e154ed" }]
          )
        end

        it { expect(section.render?).to be(true) }
        it { expect(section.call).not_to be_nil }

        # describe "references" do
        #   it "has a reference to the patient" do
        #     allow(patient).to receive(:secure_id_dashed).and_return("123")

        #     expect(section[:entry].any? { |entry| entry[:reference] == "urn:uuid:123" })
        #       .to be(true)
        #   end

        #   it "reference the author practitioner"
        #   it "references any eCCs practitioners ??"
        # end

        # it "has the the appropriate fragment of html from the letter" do
        #   expect(
        #     section.dig(:text, :div)
        #   ).to eq(<<~HTML.squish)
        #     <div id="toc-patient-demographics">
        #       <table width="100%">
        #         <tbody>
        #           <tr>
        #             <th>Patient name</th>
        #             <td>
        #               <p>Prefix: Mrs</p>
        #               <p>Given Name: Jack</p>
        #               <p>Family Name: Jones</p>
        #             </td>
        #           </tr>
        #         </tbody>
        #       </table>
        #     </div>
        #   HTML
        # end
      end
    end
  end
end
