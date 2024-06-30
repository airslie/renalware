# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Layout/LineLength
module Renalware
  module Feeds
    describe HL7DocumentMessageBuilder do
      include LettersSpecHelper

      before do
        allow(Renalware.config).to receive(:patient_hospital_identifiers).and_return(
          HOSP1: :local_patient_id,
          HOSP2: :local_patient_id_2,
          HOSP3: :local_patient_id_3
        )
        Hospitals::Centre.create!(code: "CODE1", abbrev: "HOSP1", name: "HOSP1")
        Hospitals::Centre.create!(code: "CODE2", abbrev: "HOSP2", name: "HOSP2")
        Hospitals::Centre.create!(code: "CODE3", abbrev: "HOSP3", name: "HOSP3")
      end

      let(:patient) do
        create(
          :letter_patient,
          nhs_number: "9999999999",
          local_patient_id: 111,
          local_patient_id_2: 222,
          local_patient_id_3: 333,
          family_name: "Jones",
          given_name: "Patricia",
          title: "Ms",
          born_on: "01-01-1970",
          sex: "F"
        )
      end

      let(:user) do
        create(:user, family_name: "Smith", given_name: "Jo", gmc_code: "MyGmcCode")
      end

      describe "MSH, PID, TXA, OBX segment" do
        context "when rendering a letter" do
          context "when PDFs rendered via WickedPdf" do
            before { Renalware.config.letters_render_pdfs_with_prawn = false }

            it do
              stub_const("Renalware::VERSION", "9.9.9")

              travel_to Time.zone.parse("20211117152417") do
                # As we are relying on JIT wicked pdf rednering, stub out renderer to return a
                # known value - normally its '%PDF..' etc but we will return 'A' because we know it
                # is 'QQ==' in base64
                renderer = Letters::Rendering::PdfRenderer.new(nil)
                allow(renderer).to receive(:call).and_return("A")
                allow(Letters::RendererFactory).to receive(:renderer_for).and_return(renderer)

                letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                  patient: patient,
                  clinical: true,
                  author: user
                )

                msg = described_class.call(renderable: letter, message_id: 123)
                expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_CL_#{letter.id}"

                expect(msg[:MSH].to_s).to eq(
                  "MSH|^~\\&|Renalware|MSE|||20211117152417||MDM^T02||RW0000000123|U|9.9.9"
                )
                expect(msg[:PID].to_s).to eq(
                  "PID||9999999999^^^NHS|111^^^CODE1~222^^^CODE2~333^^^CODE3||Jones^^Patricia^^Ms||19700101"
                )
                expect(msg[:PV1].to_s).to eq("PV1|||||||||||||||||||")

                expect(msg[:TXA].to_s).to eq(
                  "TXA||CL^Clinic Letter|ED^Electronic Document|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}|Smith^Jo^MyGmcCode|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}||||||#{letter.id}||||#{expected_filename}|AU"
                )
                expect(msg[:OBX].to_s).to eq(
                  "OBX|1|ED|||^TEXT^PDF^Base64^QQ=="
                )
              end
            end
          end

          context "when PDFs rendered using prawn (letter_archive.pdf_content populated at save)" do
            before { Renalware.config.letters_render_pdfs_with_prawn = true }

            it do
              pending "Fix with prawn changes"

              stub_const("Renalware::VERSION", "9.9.9")

              travel_to Time.zone.parse("20211117152417") do
                # As we are relying on JIT wicked pdf rednering, stub out renderer to return a
                # known value - normally its '%PDF..' etc but we will return 'A' because we know it
                # is 'QQ==' in base64
                # renderer = Letters::Rendering::PdfRenderer.new(nil)
                # allow(renderer).to receive(:call).and_return("A")
                # allow(Letters::RendererFactory).to receive(:renderer_for).and_return(renderer)

                letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                  patient: patient,
                  clinical: true,
                  author: user
                )
                expect(letter.archive.pdf_content).to be_present

                # User a known value for pdf_content - normally its '%PDF..' etc) but we will return
                # 'A' because we know it is 'QQ==' in base64
                allow(letter.archive).to receive(:pdf_content).and_return("A")

                msg = described_class.call(renderable: letter, message_id: 123)
                expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_CL_#{letter.id}"

                expect(msg[:MSH].to_s).to eq(
                  "MSH|^~\\&|Renalware|MSE|||20211117152417||MDM^T02||RW0000000123|U|9.9.9"
                )
                expect(msg[:PID].to_s).to eq(
                  "PID||9999999999^^^NHS|111^^^CODE1~222^^^CODE2~333^^^CODE3||Jones^^Patricia^^Ms||19700101"
                )
                expect(msg[:PV1].to_s).to eq("PV1|||||||||||||||||||")

                expect(msg[:TXA].to_s).to eq(
                  "TXA||CL^Clinic Letter|ED^Electronic Document|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}|Smith^Jo^MyGmcCode|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}||||||#{letter.id}||||#{expected_filename}|AU"
                )
                expect(msg[:OBX].to_s).to eq(
                  "OBX|1|ED|||^TEXT^PDF^Base64^QQ=="
                )
              end
            end
          end

          context "when the letter has an associated clinic visit" do
            it "includes a PV1 segment with clinic cod and visit number from the A05 HL7 message" do
              allow(Renalware::Letters::Rendering::PdfRenderer).to receive(:call).and_return("A") # base64='QQ=='
              clin = create(
                :clinic,
                code: "C1"
              )
              cv = create(
                :clinic_visit,
                clinic: clin,
                patient_id: patient.id,
                date: "2021-12-01",
                time: "09:01:01"
              )
              create(
                :appointment,
                clinic: clin,
                patient_id: patient.id,
                becomes_visit_id: cv.id,
                visit_number: "V1"
              )
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                patient: patient,
                clinical: true,
                author: create(:user, family_name: "Smith", given_name: "Jo")
              )
              letter.event = cv
              letter.save_by!(user)

              msg = described_class.call(renderable: letter, message_id: 123)

              expect(msg[:PV1].to_s).to eq("PV1|||C1||||||||||||||||V1")
            end
          end
        end

        context "when rendering an event" do
          it do
            travel_to Time.zone.parse("20211117152417") do
              stub_const("Renalware::VERSION", "9.9.9")
              allow(Renalware::Events::EventPdf).to receive(:call).and_return("A") # base64='QQ=='

              create(
                :swab_event_type,
                external_document_type_code: "XX",
                external_document_type_description: "YY"
              )
              event = Events::EventPdfPresenter.new(
                create(
                  :swab,
                  patient: patient,
                  by: user
                )
              )
              Renalware.config.ukrdc_site_code = "RJZ"
              create(:hospital_centre, code: "RJZ")

              msg = described_class.call(renderable: event, message_id: 123)

              expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_XX_#{event.id}"

              expect(msg[:MSH].to_s).to eq(
                "MSH|^~\\&|Renalware|MSE|||20211117152417||MDM^T02||RW0000000123|U|9.9.9"
              )
              expect(msg[:PID].to_s).to eq(
                "PID||9999999999^^^NHS|111^^^CODE1~222^^^CODE2~333^^^CODE3||Jones^^Patricia^^Ms||19700101"
              )
              expect(msg[:TXA].to_s).to eq(
                "TXA||XX^YY|ED^Electronic Document|" \
                "#{event.approved_at.strftime('%Y%m%d%H%M')}|Smith^Jo^MyGmcCode|" \
                "#{event.approved_at.strftime('%Y%m%d%H%M')}||||||#{event.id}||||#{expected_filename}|AU"
              )
              expect(msg[:OBX].to_s).to eq(
                "OBX|1|ED|||^TEXT^PDF^Base64^QQ=="
              )
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
