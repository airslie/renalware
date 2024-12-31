module Renalware
  module UKRDC
    class XmlRenderer
      DEFAULT_TEMPLATE = "/renalware/api/ukrdc/patients/show".freeze
      attr_reader :template, :errors, :locals, :schema

      class Success < ::Success
        alias xml object
      end

      class Failure < ::Failure
        alias validation_errors object
      end

      # Schema is an instance of Nokogiri::XML::Schema passed in for optimisation reasons.
      # If it is not passed in we create it.
      def initialize(schema:, template: nil, locals: {})
        @template = template || DEFAULT_TEMPLATE
        @schema = schema
        @locals = locals
      end

      # If we successfully generate the UKRDC XML for a patient, return a Success object where
      # success#xml is the valid XML
      # If there are XSD validation messages, we return a Failure object where
      # failure#validation_messages is an array of XSD validation messages.
      def call
        return XmlRenderer::Failure.new(validation_errors) if validation_errors.any?

        XmlRenderer::Success.new(xml)
      end

      def xml
        @xml ||= begin
          Ox.default_options = { no_empty: false, encoding: "UTF-8" }
          doc = Ox::Document.new
          doc << instruct_element
          doc << UKRDC::Outgoing::Rendering::Patient.new(locals).xml
          Ox.dump(doc)
        end
      end

      # Returns an array of SchemaValidation errors
      def validation_errors
        @validation_errors ||= schema.validate(xml)
      end

      private

      def instruct_element
        Ox::Instruct.new(:xml).tap do |instruct|
          instruct[:version] = "1.0"
          instruct[:encoding] = "UTF-8"
        end
      end
    end
  end
end

# rubocop:disable Layout/LineLength
# For reference this is the code used to compare old and new methods of exporting the XML
# in the #call method:
#
# modified_old_xml = xml_old.gsub("<FamilyDoctor>\n    </FamilyDoctor>", "<FamilyDoctor/>")
# modified_old_xml = modified_old_xml.gsub("<Diagnoses>\n  </Diagnoses>", "<Diagnoses/>")
# modified_old_xml = modified_old_xml.gsub("<Encounters>\n  </Encounters>", "<Encounters/>")
# modified_old_xml = modified_old_xml.gsub("<Medications>\n  </Medications>", "<Medications/>")
# modified_old_xml = modified_old_xml.gsub("<Procedures>\n  </Procedures>", "<Procedures/>")
# modified_old_xml = modified_old_xml.gsub("<Attributes>\n      </Attributes>", "<Attributes/>")
# modified_old_xml = modified_old_xml.gsub("<ResultValue></ResultValue>", "<ResultValue/>")
# modified_old_xml = modified_old_xml.gsub("<LabOrders start=\"2017-01-01\" stop=\"2019-12-29\">\n  </LabOrders>", "<LabOrders/>")
# modified_old_xml = modified_old_xml.gsub("<Observations start=\"2017-01-01\" stop=\"2019-12-29\">\n  </Observations>", "<Observations start=\"2017-01-01\" stop=\"2019-12-29\"/>")
# modified_old_xml = modified_old_xml.gsub("<LabOrders/>", "<LabOrders start=\"2017-01-01\" stop=\"2019-12-29\"/>")

# if modified_old_xml != xml
#   File.open(Rails.root.join("tmp", "#{locals[:patient].id}_old.txt"), "wb") { |f| f.write modified_old_xml }
#   File.open(Rails.root.join("tmp", "#{locals[:patient].id}_new.txt"), "wb") { |f| f.write xml }
# end
#
# def xml_old
#   @xml_old ||= begin
#     API::UKRDC::PatientsController.new.render_to_string(
#       template: template,
#       format: :xml,
#       locals: locals,
#       encoding: "UTF-8"
#     )
#   end
# end
# rubocop:enable Layout/LineLength
