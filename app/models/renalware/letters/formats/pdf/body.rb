module Renalware
  module Letters
    module Formats
      module Pdf
        class Body
          include Prawn::View
          pattr_initialize :document, :letter
          UL_BULLET = "• ".freeze

          # 1. Pre-process string
          #    - replace &nbsp; with " "
          # 2. Then loop through nokogiri-parsed elements
          #    - handle ul and ol correctly if poss
          def build
            return if letter&.body.blank?

            body = letter
              .body
              .gsub("&nbsp;", " ")

            fragment = Nokogiri::HTML.fragment(body)
            pad_top(10) do
              formatted_text(parse_html_fragment_into_text_array(fragment))
            end
          end

          # Experimental recursive fn to try and handle eg ol>li+li and ul>li+li
          # Does not work correctly atm - ol bullet does not increment.
          # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
          def parse_html_fragment_into_text_array(elem, styles = [], li_type = nil, bullet = nil)
            texts = []
            case elem.name
            when "text" then texts << { text: elem.text, styles: styles }
            when "br" then texts << { text: "\n" }
            when "em" then styles = [:italic]
            when "b", "strong" then styles = [:bold]
            when "ul" then li_type = :ul
            when "ol"
              li_type = :ol
              bullet ||= 0
            when "li"
              bull = li_type == :ol ? "#{bullet += 1}. " : UL_BULLET
              texts << { text: "\n#{bull} " }
            end
            elem.children.each do |child|
              texts.concat(parse_html_fragment_into_text_array(child, styles, li_type, bullet))
            end
            texts
          end
          # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity
        end
      end
    end
  end
end
