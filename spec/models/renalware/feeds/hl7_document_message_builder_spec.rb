# rubocop:disable Layout/LineLength
module Renalware
  module Feeds
    describe HL7DocumentMessageBuilder do
      include LettersSpecHelper

      before do
        allow(Renalware.config).to receive_messages(
          feeds_outgoing_documents_letter_format: :pdf,
          patient_hospital_identifiers: {
            HOSP1: :local_patient_id,
            HOSP2: :local_patient_id_2,
            HOSP3: :local_patient_id_3
          },
          feeds_outgoing_documents_hospital_service: "361^Nephrology"
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
      let(:by) { user }

      def stub_rendering(format, content)
        if format == :pdf
          renderer = Letters::Rendering::PdfRenderer.new(nil)
          allow(renderer).to receive(:call).and_return("A")
          allow(Letters::RendererFactory).to receive(:renderer_for).and_return(renderer)
        elsif format == :rtf
          allow(PandocRuby)
            .to receive(:html)
            .and_return(instance_double(PandocRuby, to_rtf: content))
        end
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
                stub_rendering(:pdf, "A")

                letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                  patient:,
                  clinical: true,
                  author: user
                )

                document = OutgoingDocument.create!(renderable: letter, by:)
                msg = described_class.call(renderable: letter, document:)
                expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_CL_#{letter.id}"
                msh_identifier = ["RW", document.id.to_s.rjust(10, "0")].join

                expect(msg[:MSH].to_s).to eq(
                  "MSH|^~\\&|Renalware|MSE|||20211117152417||MDM^T02|#{msh_identifier}|#{msh_identifier}|U|9.9.9"
                )
                expect(msg[:PID].to_s).to eq(
                  "PID||9999999999^^^NHS|111^^^CODE1~222^^^CODE2~333^^^CODE3||Jones^^Patricia^^Ms||19700101"
                )
                expect(msg[:PV1].to_s).to eq("PV1||O||||||||361^Nephrology|||||||||")

                expect(msg[:TXA].to_s).to eq(
                  "TXA||CL^Clinic Letter|ED^Electronic Document|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}|MyGmcCode^Smith^Jo|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}||||||#{letter.id}||||#{expected_filename}|AU"
                )
                expect(msg[:OBX].to_s).to eq(
                  "OBX|1|ED|||^TEXT^PDF^Base64^QQ=="
                )
              end
            end

            context "when the using uuids for document and renderable references" do
              before do
                allow(Renalware.config).to receive_messages(
                  feeds_outgoing_documents_use_guids: true
                )
              end

              it "uses the uuid for MSH.10/11 and TXA.11" do
                stub_const("Renalware::VERSION", "9.9.9")

                stub_rendering(:pdf, "A")

                letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                  patient:,
                  clinical: true,
                  author: user
                )
                document = OutgoingDocument.create!(renderable: letter, by:)

                msg = described_class.call(renderable: letter, document:)

                expect(document.external_uuid).to be_present
                expect(letter.uuid).to be_present
                expect(msg[:MSH][9]).to eq(document.external_uuid)
                expect(msg[:MSH][10]).to eq(document.external_uuid)
                expect(msg[:TXA][12]).to eq(letter.uuid)
              end
            end
          end

          context "when letter format is RTF" do
            before do
              allow(Renalware.config).to receive_messages(
                feeds_outgoing_documents_letter_format: :rtf
              )
            end

            it "rendered letters as RTF" do
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                patient:,
                clinical: true,
                author: user
              )

              rtf_content = "ABC"
              stub_rendering(:rtf, rtf_content)
              base64_encoded_rtf = Base64.strict_encode64(rtf_content)
              document = OutgoingDocument.create!(renderable: letter, by:)

              msg = described_class.call(renderable: letter, document:)
              expect(msg[:OBX].to_s).to include("^TEXT^RTF^Base64^#{base64_encoded_rtf}")
            end
          end

          context "when a custom LetterFilename class is defined" do
            it "supports a custom filename" do
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                patient:,
                clinical: true,
                author: user
              )
              document = OutgoingDocument.create!(renderable: letter, by:)

              stub_const(
                "::Renalware::Feeds::LetterFilename",
                Class.new do
                  def initialize(*); end
                  def to_s = "some_custom_filename"
                end
              )

              msg = described_class.call(renderable: letter, document:)

              expect(msg[:TXA].to_s).to include("some_custom_filename")
            end
          end

          context "when PDFs rendered using prawn (letter_archive.pdf_content populated at save)" do
            before do
              allow(Renalware.config).to receive_messages(
                feeds_outgoing_documents_use_guids: true,
                letters_render_pdfs_with_prawn: true
              )
            end

            it do
              stub_const("Renalware::VERSION", "9.9.9")

              travel_to Time.zone.parse("20211117152417") do
                # As we are relying on JIT wicked pdf rendering, stub out renderer to return a
                # known value - normally its '%PDF..' etc but we will return 'A' because we know it
                # is 'QQ==' in base64
                # renderer = Letters::Rendering::PdfRenderer.new(nil)
                # allow(renderer).to receive(:call).and_return("A")
                # allow(Letters::RendererFactory).to receive(:renderer_for).and_return(renderer)

                letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                  patient:,
                  clinical: true,
                  author: user
                )
                expect(letter.archive.pdf_content).to be_present
                document = OutgoingDocument.create!(renderable: letter, by:)

                # User a known value for pdf_content - normally its '%PDF..' etc) but we will return
                # 'A' because we know it is 'QQ==' in base64
                allow(letter.archive).to receive(:pdf_content).and_return("A")

                msg = described_class.call(renderable: letter, document:)
                expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_CL_#{letter.id}"

                expect(msg[:MSH].to_s).to eq(
                  "MSH|^~\\&|Renalware|MSE|||20211117152417||MDM^T02|#{document.external_uuid}|#{document.external_uuid}|U|9.9.9"
                )
                expect(msg[:EVN].to_s).to eq(
                  "EVN|T02|20211117152417"
                )
                expect(msg[:PID].to_s).to eq(
                  "PID||9999999999^^^NHS|111^^^CODE1~222^^^CODE2~333^^^CODE3||Jones^^Patricia^^Ms||19700101"
                )
                expect(msg[:PV1].to_s).to eq("PV1||O||||||||361^Nephrology|||||||||")

                expect(msg[:TXA].to_s).to eq(
                  "TXA||CL^Clinic Letter|ED^Electronic Document|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}|MyGmcCode^Smith^Jo|" \
                  "#{letter.approved_at.strftime('%Y%m%d%H%M')}||||||#{letter.uuid}||||#{expected_filename}|AU"
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
              clinic = create(
                :clinic,
                code: "C1"
              )
              cv = create(
                :clinic_visit,
                clinic:,
                patient_id: patient.id,
                date: "2021-12-01",
                time: "09:01:01"
              )
              create(
                :appointment,
                clinic:,
                patient_id: patient.id,
                becomes_visit_id: cv.id,
                visit_number: "V1"
              )
              letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                patient:,
                clinical: true,
                author: create(:user, family_name: "Smith", given_name: "Jo")
              )
              letter.event = cv
              letter.save_by!(user)
              document = Feeds::OutgoingDocument.create!(renderable: letter, by:)

              msg = described_class.call(renderable: letter, document:)

              expect(msg[:PV1].to_s).to eq("PV1||O|C1|||||||361^Nephrology|||||||||V1")
            end
          end
        end

        context "when rendering an event" do
          before do
            allow(Renalware.config).to receive_messages(
              feeds_outgoing_documents_use_guids: true,
              ukrdc_site_code: "RJZ"
            )
          end

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
                  patient:,
                  by:
                )
              )

              document = Feeds::OutgoingDocument.create!(renderable: event.__getobj__, by:)
              create(:hospital_centre, code: "RJZ")
              msg = described_class.call(renderable: event, document:)

              expected_filename = "HOSP1_111_HOSP2_222_HOSP3_333_JONES_19700101_XX_#{event.id}"

              expect(msg[:MSH].to_s).to eq(
                "MSH|^~\\&|Renalware|MSE|||20211117152417||MDM^T02|#{document.external_uuid}|#{document.external_uuid}|U|9.9.9"
              )
              expect(msg[:PID].to_s).to eq(
                "PID||9999999999^^^NHS|111^^^CODE1~222^^^CODE2~333^^^CODE3||Jones^^Patricia^^Ms||19700101"
              )
              expect(msg[:TXA].to_s).to eq(
                "TXA||XX^YY|ED^Electronic Document|" \
                "#{event.approved_at.strftime('%Y%m%d%H%M')}|MyGmcCode^Smith^Jo|" \
                "#{event.approved_at.strftime('%Y%m%d%H%M')}||||||#{event.uuid}||||#{expected_filename}|AU"
              )
              expect(msg[:OBX].to_s).to eq(
                "OBX|1|ED|||^TEXT^PDF^Base64^QQ=="
              )
            end
          end
        end

        context "when the outgoing_document is marked as deleted" do
          %i(pdf rtf).each do |format|
            context "when the letter format is #{format.upcase}" do
              before do
                allow(Renalware.config)
                  .to receive(:feeds_outgoing_documents_letter_format)
                  .and_return(format)
              end

              it "Sets TXA.19 = 'CA' (deleted) and adds a blank #{format.upcase} document" do
                stub_rendering(format, "A") # stub letter rendering as its expensive
                letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(
                  patient:,
                  clinical: true,
                  author: user
                )
                # Simulate letter deletion
                letter.update_column(:deleted_at, Time.zone.now)
                letter.reload
                document = Feeds::OutgoingDocument.create!(renderable: letter, by:)

                msg = described_class.call(renderable: letter, document:)

                txa = msg[:TXA]
                expect(txa.document_completion_status).to eq("CA") # deleted
                expect(txa.unique_document_number).to eq(letter.id.to_s)

                # This tests to see if the base64-encoded binary content of the
                # app/assets/pdf/deleted_document.(pdf|rtf) file has been added to the message
                file_path = Renalware::Engine.root
                  .join("app/assets/#{format}/deleted_document.#{format}")
                content = Base64.strict_encode64(::File.binread(file_path))

                expect(msg[:OBX].to_s).to eq("OBX|1|ED|||^TEXT^#{format.upcase}^Base64^#{content}")
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
