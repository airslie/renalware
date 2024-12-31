module Renalware
  module Letters
    module Formats
      module Pdf
        class Document
          include Prawn::View
          pattr_initialize(:letter, :document)

          def self.build_document
            doc = Prawn::Document.new(page_size: "A4", page_layout: :portrait)
            doc.font_size(9)
            doc
          end

          def document
            @document ||= self.class.build_document
          end

          def render
            PageNumbering.new(document).build
            super
          end

          def build # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
            # For now, ensure a blank document is rendered unless dev or test env
            # as prawn not ready for activation in uat/prod yet
            return self unless Rails.env.local?

            Clinic.new(document, letter).render
            Letterhead.new(document).build
            Addressee.new(document, letter).build

            c = document.cursor
            document.font_size(8) do
              Problems.new(document, letter, 0, c, 200).build
              Prescriptions.new(document, letter, 220, c, 300).build
              x = Part::RecentPathologyResults.new(letter: letter)
              Investigations.new(
                document,
                results: x.raw_results
              ).build
              Allergies.new(document).build
              ClinicalObservations.new(document).build
            end

            Body.new(document, letter).build
            Signature.new(
              document,
              signature: "X",
              position: "Pos"
            ).build

            CarbonCopies.new(document).build
            self
          end
        end
      end
    end
  end
end
