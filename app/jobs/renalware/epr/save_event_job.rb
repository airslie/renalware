module Renalware
  module EPR
    class SaveEventJob < Events::SavePdfEventToFileJob
      def perform(args)
        super
        xml = MetadataXml.for_event(args[:event], Renalware.config.epr_site_code).to_xml
        File.write(Pathname(args[:file_path]).sub_ext(".xml"), xml)
      end
    end
  end
end
