module Renalware
  module Letters
    module Formats::FHIR
      # The send_message operation needs an xml payload and building this xml is the
      # function of this class.
      #
      # We build and validate a FHIR STU3 XML document return it.
      # This XML is a representation of the letter, and will be sent over MESHAPI
      # to the patient's GP.
      class BuildPayload
        include Callable
        include Support::Helpers

        pattr_initialize :arguments

        def call
          build_fhir_bundle_xml
        end

        private

        # Bundle here refers to the top level 'message' <Bundle> FHIR resource in the XML message.
        # See https://www.hl7.org/fhir/resourcelist.html and the wiki entry:
        # https://github.com/airslie/renalwarev2/wiki/Transfer-Of-Care
        def build_fhir_bundle_xml
          bundle = Resources::Bundle.call(arguments)
          validate_fhir_bundle(bundle)
          Nokogiri.XML(bundle.to_xml).root.to_xml # Removes the ?xml instruction
        end

        def validate_fhir_bundle(bundle)
          bundle.validate.tap { |errors|
            raise errors.to_a.join(",") if errors.any?
          }
        end
      end
    end
  end
end
