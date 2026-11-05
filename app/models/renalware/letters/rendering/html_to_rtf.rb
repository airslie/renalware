module Renalware
  module Letters
    module Rendering
      # Deliberately limited to semantic HTML. Does not interpret CSS or fetch resources.
      # Unknown containers retain their text; nested tables are flattened within their cell.
      class HtmlToRTF
        pattr_initialize :html

        STYLES = {
          "b" => "b", "strong" => "b", "i" => "i", "em" => "i", "u" => "ul",
          "s" => "strike", "del" => "strike", "sub" => "sub", "sup" => "super",
          "code" => "f1"
        }.freeze
        BLOCKS = %w(p div section article header footer address blockquote
                    h1 h2 h3 h4 h5 h6 ul ol li dl dt dd table thead tbody tfoot tr pre).freeze
        OMITTED = %w(head style script img svg iframe object embed template).freeze

        def call
          document = Nokogiri::HTML.fragment(html)
          body = flow(document).map { |item| RTFParagraph.call(item) }.join
          header = '{\rtf1\ansi\deff0\uc1{\fonttbl{\f0\fswiss Helvetica;}{\f1 Courier;}}' \
                   '\widowctrl\hyphauto\margl697\margr697\margt697\margb697\fs20 '
          "#{header}\n#{body}\n}".gsub(/\r\n|\r|\n/, "\r\n")
        end

        private

        def children(node)
          node.children.map { |child| render(child) }.join
        end

        def render(node)
          return RTFText.new(node).call if node.text?
          return "" unless node.element?
          return "" if OMITTED.include?(node.name)

          render_element(node)
        end

        def render_element(node)
          case node.name
          when "br" then "\\line "
          when "td", "th" then "#{children(node)}\\tab "
          when "a" then link(node)
          else styled_content(node)
          end
        end

        def styled_content(node)
          content = children(node)
          style = STYLES[node.name]
          style ? "{\\#{style} #{content}}" : content
        end

        # Group inline runs into paragraphs. Containers never create paragraphs themselves.
        # This avoids multiplying paragraph breaks around nested divs, sections and lists.
        def flow(node)
          items = []
          inline = +""
          node.children.each do |child|
            if child.element? && BLOCKS.include?(child.name)
              append_paragraph(items, inline, node)
              inline = +""
              items.concat(block(child))
            else
              inline << render(child)
            end
          end
          append_paragraph(items, inline, node)
        end

        def append_paragraph(items, content, node)
          content = content.strip unless node.name == "pre"
          return items if content.empty?

          items << RTFParagraph.attributes(content, node)
        end

        def block(node)
          if node.name == "table" && node.ancestors.none? { |ancestor| ancestor.name == "table" }
            return [{ rtf: RTFTable.new(node, method(:cell_content)).call }]
          end

          RTFParagraph.decorate(flow(node), node)
        end

        def cell_content(node, alignment, in_table: true)
          flow(node).map do |item|
            item[:spacing] = 180 unless in_table
            RTFParagraph.call(item, in_table:, alignment:)
          end.join
        end

        # Render URLs as ordinary text, never RTF fields or embedded resources.
        def link(node)
          content = children(node)
          href = node["href"].to_s
          return content unless href.match?(%r{\A(?:https?://|mailto:)}i)
          return content if href == node.text

          "#{content} (#{RTFText.escape(href)})"
        end
      end
    end
  end
end
