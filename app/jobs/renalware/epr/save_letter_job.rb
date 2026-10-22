module Renalware
  module EPR
    class SaveLetterJob < Letters::SavePdfLetterToFileJob
      def perform(args)
        super
        xml = MetadataXml.for_letter(args[:letter], Renalware.config.epr_site_code).to_xml
        File.write(Pathname(args[:file_path]).sub_ext(".xml"), xml)
      end
    end
  end
end
