module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::Patient do
        include XmlSpecHelper

        def render_xml(patient)
          format_xml(described_class.new(patient:).xml)
        end

        it "assigns the patient a renal_registry_id if the don't have one" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, renal_registry_id: nil)
          )

          expect(patient.renal_registry_id).to be_nil
          described_class.new(patient:).xml
          expect(patient.reload.renal_registry_id).not_to be_nil
        end

        it "the patient already has a renal_registry_id it does not change it" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, renal_registry_id: "123")
          )

          expect(patient.renal_registry_id).to be_present
          described_class.new(patient:).xml
          expect(patient.reload.renal_registry_id).to eq("123")
        end

        it "includes the correctly formatted NHS number" do
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(:patient, nhs_number: "6433678181", sent_to_ukrdc_at: 1.year.ago)
          )

          xml = render_xml(patient)

          expect(xml).to include("<PatientNumbers>")
          expect(xml).to include("<Number>6433678181</Number>")
          expect(xml).to include("<Organization>NHS</Organization>")
          expect(xml).to include("<NumberType>NI</NumberType>")
        end

        it "outputs PrimaryLanguage" do
          language = create(:language, :english)
          patient = Renalware::UKRDC::PatientPresenter.new(
            create(
              :patient,
              sent_to_ukrdc_at: 1.year.ago,
              language: language
            )
          )

          xml = render_xml(patient)

          expect(xml).to include("<PrimaryLanguage>")
          expect(xml)
            .to include("<CodingStandard>NHS_DATA_DICTIONARY_LANGUAGE_CODE</CodingStandard>")
          expect(xml).to include("<Code>en</Code>")
        end

        context "when the language is Other (ot)" do
          it "does not output it" do
            language = create(:language, :other)
            patient = Renalware::UKRDC::PatientPresenter.new(
              create(
                :patient,
                sent_to_ukrdc_at: 1.year.ago,
                language: language
              )
            )

            xml = render_xml(patient)

            expect(xml).not_to include("<PrimaryLanguage>")
          end
        end
      end
    end
  end
end
