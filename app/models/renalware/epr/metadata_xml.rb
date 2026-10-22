module Renalware
  module EPR
    # Builds the XML sidecar that sits alongside an EPR PDF, describing the document so the
    # receiving document store can file it against the patient.
    class MetadataXml
      pattr_initialize [
        :filename!,
        :hospital_number!,
        :section!,
        :destination_label!,
        :document_name!,
        :document_id!,
        :document_type!,
        :document_date!,
        :renal_activity!
      ]

      def self.for_letter(letter, site)
        name = LetterFilename.new(letter, site)
        new(
          filename: name.to_s,
          hospital_number: name.hospital_number,
          section: "Correspondence",
          destination_label: "Administrative_Letter",
          document_name: "Renal Outpatient Letter",
          document_id: letter.id,
          document_type: Renalware.config.epr_letter_document_type,
          document_date: letter.approved_at.strftime("%d-%m-%Y"),
          renal_activity: Renalware.config.epr_renal_activity_code
        )
      end

      def self.for_event(event, site)
        name = MdtFilename.new(event, site)
        new(
          filename: name.to_s,
          hospital_number: name.hospital_number,
          section: "Clinical Notes & History",
          destination_label: "MDT_Meeting_Notes",
          document_name: "MDT_Meeting_Notes",
          document_id: event.id,
          document_type: Renalware.config.epr_mdt_document_type,
          document_date: event.created_at.strftime("%d-%m-%Y"),
          renal_activity: Renalware.config.epr_renal_activity_code
        )
      end

      def to_xml
        builder.to_xml(indent: 2)
      end

      private

      def builder
        Nokogiri::XML::Builder.new do |xml|
          xml.Batch { xml.Files { file_upload(xml) } }
        end
      end

      def file_upload(xml)
        xml.FileUpload(filename:) do
          file_details(xml)
          category(xml)
        end
      end

      def file_details(xml)
        xml.KWFileDetails do
          xml.DestinationPath destination_path
          xml.AddToScanQueue "false"
          xml.VersionFile "true"
        end
      end

      def category(xml)
        xml.Category(name: "Patient Records") do
          xml.Attributes(id: "Renal") do
            attributes.each { |name, value| xml.send(:"#{name}_", value) }
          end
        end
      end

      def attributes
        {
          PatientHospitalNumber: hospital_number,
          Section: section,
          DocumentType: document_type,
          DocumentName: document_name,
          SpecialtyCode: renal_activity,
          DocumentDate: document_date,
          BatchReferenceNumber: "null",
          JobName: "Renal",
          DateScanned: document_date
        }
      end

      def destination_path
        "\\Patient Records\\#{hospital_number}\\#{section}\\" \
          "#{hospital_number}_#{destination_label}_#{renal_activity}_#{document_date}_" \
          "(#{document_id}).pdf"
      end
    end
  end
end
