module Renalware
  module EPR
    class SaveEventJob < Events::SavePdfEventToFileJob
      def perform(args)
        super
        path = Pathname(args[:file_path])
        xml = MetadataXml.for_event(
          args[:event], Renalware.config.epr_site_code, filename: path.basename.to_s
        ).to_xml
        File.write(path.sub_ext(".xml"), xml)
      end
    end
  end
end
