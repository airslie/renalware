module Renalware
  module EPR
    class SaveLetterJob < Letters::SavePdfLetterToFileJob
      def perform(args)
        super
        path = Pathname(args[:file_path])
        xml = MetadataXml.for_letter(
          args[:letter], Renalware.config.epr_site_code, filename: path.basename.to_s
        ).to_xml
        File.write(path.sub_ext(".xml"), xml)
      end
    end
  end
end
