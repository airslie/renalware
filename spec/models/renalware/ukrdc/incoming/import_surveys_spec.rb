module Renalware
  module UKRDC
    describe Incoming::ImportSurveys do
      include UKRDCSpecHelper

      subject(:service) { described_class.new(logger: logger) }

      let(:paths) { Incoming::Paths.new }
      let(:logger) do
        Class.new do
          define_method :info, ->(mgs) {}
        end.new
      end

      # For testing, we will keep the files in the rails tmp folder ./demo/tmp/ukrdc
      before do
        allow(Renalware.config)
          .to receive(:ukrdc_working_path)
          .and_return(Rails.root.join("tmp/ukrdc"))
      end

      def create_pos_s_survey_with_questions
        create(:pos_s_survey).tap do |survey|
          %w(
            YSQ1 YSQ2 YSQ3 YSQ4 YSQ5 YSQ6 YSQ7 YSQ8 YSQ9 YSQ10 YSQ11 YSQ12
            YSQ13 YSQ14 YSQ15 YSQ16 YSQ17 YSQ18 YSQ19 YSQ20 YSQ21 YSQ22
          ).each do |code|
            create(:survey_question, survey: survey, code: code)
          end
        end
      end

      def create_eq5d_survey_with_questions
        create(:eq5d_survey).tap do |survey|
          %w(YOHQ1 YOHQ2 YOHQ3 YOHQ4 YOHQ5 YOHQ6).each do |code|
            create(:survey_question, survey: survey, code: code)
          end
        end
      end

      describe "#call" do
        context "when there are no errors - the happy path" do
          it "imports an xml file containing 2 surveys and checks all responses are persisted" do
            patient = create(:patient, nhs_number: "9999999999")
            # Create the two surveys and their questions
            create_pos_s_survey_with_questions
            create_eq5d_survey_with_questions

            copy_test_files_into_incoming_folder(paths: paths)

            expect {
              service.call
            }.to change(Surveys::Response, :count).by(28) # 6 EQ5D questions + 22 POS-S

            # expect the test file to have been archived
            expect(paths.incoming.glob("*.xml").length).to eq(0)
            expect(paths.archive.glob("*.xml").length).to eq(1)

            # Expected to have logged info
            expect(UKRDC::TransmissionLog.count).to eq(1)
            log = UKRDC::TransmissionLog.first
            expect(log).to have_attributes(
              status: "imported",
              patient_id: patient.id,
              file_path: paths.incoming.join("survey_0.xml").to_s,
              direction: "in"
            )
            expect(log.payload).not_to be_nil
          end
        end

        context "when an erorr occurs" do
          context "when the patient is not found" do
            it "logs the error to the transmission logs" do
              copy_test_files_into_incoming_folder(paths: paths)

              expect {
                service.call
              }.not_to change(Surveys::Response, :count)

              expect(paths.incoming.glob("*.xml").length).to eq(0)
              expect(paths.archive.glob("*.xml").length).to eq(1)

              # Expected to have logged info
              expect(UKRDC::TransmissionLog.count).to eq(1)
              log = UKRDC::TransmissionLog.first
              expect(log).to have_attributes(
                status: "error",
                patient_id: nil,
                file_path: paths.incoming.join("survey_0.xml").to_s,
                direction: "in"
              )
              expect(log.error.first).to match("Couldn't find Renalware::Patient")
            end
          end

          context "when the survey is not found" do
            it "logs the error to the transmission logs" do
              patient = create(:patient, nhs_number: "9999999999")
              copy_test_files_into_incoming_folder(paths: paths)

              expect {
                service.call
              }.not_to change(Surveys::Response, :count)

              expect(paths.incoming.glob("*.xml").length).to eq(0)
              expect(paths.archive.glob("*.xml").length).to eq(1)

              # Expected to have logged info
              expect(UKRDC::TransmissionLog.count).to eq(1)
              log = UKRDC::TransmissionLog.first
              expect(log).to have_attributes(
                status: "error",
                patient_id: patient.id,
                file_path: paths.incoming.join("survey_0.xml").to_s,
                direction: "in"
              )
              expect(log.error.first).to match("Survey with name PROM not found")
            end
          end

          context "when a question is not found" do
            it "logs the error to the transmission logs" do
              patient = create(:patient, nhs_number: "9999999999")
              copy_test_files_into_incoming_folder(paths: paths)
              create(:pos_s_survey) # no questions
              create(:eq5d_survey) # no questions

              expect {
                service.call
              }.not_to change(Surveys::Response, :count)

              expect(paths.incoming.glob("*.xml").length).to eq(0)
              expect(paths.archive.glob("*.xml").length).to eq(1)

              # Expected to have logged info
              expect(UKRDC::TransmissionLog.count).to eq(1)
              log = UKRDC::TransmissionLog.first
              expect(log).to have_attributes(
                status: "error",
                patient_id: patient.id,
                file_path: paths.incoming.join("survey_0.xml").to_s,
                direction: "in"
              )
              expect(log.error.first).to match("Question with code YSQ1 not found in survey PROM")
            end
          end
        end
      end
    end
  end
end
