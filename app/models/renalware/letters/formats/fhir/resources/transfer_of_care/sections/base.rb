module Renalware
  module Letters
    module Formats::FHIR
      module Resources::TransferOfCare
        class Sections::Base
          include Support::Helpers
          delegate :letter, to: :arguments, allow_nil: true
          delegate :render?, to: :view_component
          attr_reader :arguments, :options

          def self.call(arguments, options = {})
            new(arguments, **options).call
          end

          def initialize(arguments, options = {})
            @arguments = arguments
            @options = options
          end

          def call
            return unless render?

            {
              title: title,
              code: snomed_coding(snomed_code, title),
              text: {
                status: text_status,
                div: html_content
              },
              entry: entries
            }
          end

          # Super class can override these
          def text_status = "additional"
          def title = raise(NotImplementedError)
          def snomed_code = raise(NotImplementedError)
          def entries = []

          # Render the component to a string - regardless of whether the component
          # uses a sidecar template or a #call method.
          # Note that the fhir ruby gem will wrap the content automatically in a div
          #  <div xmlns="http://www.w3.org/1999/xhtml">[component html]</div>
          # which is handy
          def html_content
            ActionController::Base.renderer.render(view_component)
          end

          def view_component
            @view_component ||= Object.const_get("#{self.class.name}Component").new(letter)
          end
        end
      end
    end
  end
end
