module Renalware
  module UKRDC
    class XsdSchema
      attr_reader :major_version

      def initialize(major_version: nil)
        # If no schema version is supplied in the ctor, default to whatever is configured
        @major_version = major_version || Renalware.config.ukrdc_schema_version[0]
      end

      def validate(xml)
        schema.validate(Nokogiri::XML(xml))
      end

      private

      def schema
        @schema ||= begin
          xsd_path = File.join(Renalware::Engine.root, schema_path)
          xsddoc = Nokogiri::XML(File.read(xsd_path), xsd_path)
          Nokogiri::XML::Schema.from_document(xsddoc)
        end
      end

      # Return the path to the UKRDC XSD schema which is active for the current project.
      # Note that we include git submodules for each UKRDC version that we might need to target
      # (see .gitmodules), checked out at paths like vendor/xsd/ukrdc3, where 3 is the UKRDC schema
      # major version. The currently active UKRDC scheme a version is determined by
      # Renalware.config.ukrdc_schema_version and is in the format eg "3.3.1" - in this example
      # 3 is the major version, so we would load vendor/xsd/ukrdc3/schema/ukrdc/UKRDC.xsd
      def schema_path
        "vendor/xsd/ukrdc#{major_version}/schema/ukrdc/UKRDC.xsd"
      end
    end
  end
end
