module Renalware
  module Letters::Formats::FHIR
    module Support
      module Helpers
        extend ActiveSupport::Concern

        # Only useful where one (1..1) coding expected
        def snomed_coding(code, display)
          {
            coding: snomed_coding_content(code, display)
          }
        end

        # Useful when we need an array of codings
        def snomed_coding_content(code, display)
          {
            system: "http://snomed.info/sct",
            code: code,
            display: display
          }
        end

        def system_identifier(uuid)
          {
            system: "https://tools.ietf.org/html/rfc4122",
            value: uuid
          }
        end

        def html_fragment_from(letter, html_id:)
          fragment = Nokogiri.XML(letter.archive.content)
            .xpath("//*[@id='#{html_id}']")
            .first
            &.to_s
          raise(ArgumentError, html_id) if fragment.blank?

          fragment
        end
      end
    end
  end
end
