module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class PrimaryLanguage < Rendering::Base
          pattr_initialize [:patient!]

          def xml
            return unless render_primary_language?

            primary_language_element
          end

          private

          # Omit 'Other' language as it is not part of the ISO set, but we have it for some reason
          def render_primary_language?
            patient.language.present? && patient.language.code != "ot"
          end

          # NB NHS_DATA_DICTIONARY_LANGUAGE_CODE is ISO 639-1 plus braille and sign
          def primary_language_element
            create_node("PrimaryLanguage") do |lang|
              lang << create_node("CodingStandard", "NHS_DATA_DICTIONARY_LANGUAGE_CODE")
              lang << create_node("Code", patient.language&.code)
              lang << create_node("Description", patient.language)
            end
          end
        end
      end
    end
  end
end
