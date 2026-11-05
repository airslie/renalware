module Renalware
  module Letters
    module Rendering
      class RTFParagraph
        def self.attributes(content, node)
          ancestors = node.ancestors.to_a + [node]
          indent = (ancestors.count { |item| item.name == "li" } * 360) +
                   (ancestors.count { |item| item.name == "blockquote" } * 720)
          spacing = node.name.match?(/\A(?:p|h[1-6]|pre)\z/) ? 180 : 0
          { content:, spacing:, indent: }
        end

        def self.decorate(items, node)
          return items if items.empty?

          if node.name.match?(/\Ah[1-6]\z/)
            style = heading_style(node)
            items.each { |item| item[:content] = "#{style} #{item[:content]}" }
          elsif node.name == "li"
            RTFList.decorate(items.first, node)
          elsif %w(ul ol).include?(node.name)
            # Pandoc separates lists from the following section with 9pt of space.
            items.last[:spacing] = 180
          end
          items
        end

        def self.heading_style(node)
          level = node.name.delete_prefix("h").to_i
          "\\outlinelevel#{level - 1} \\b \\fs#{36 - (level * 2)}"
        end

        def self.call(item, in_table: false, alignment: "ql")
          return item[:rtf] if item.key?(:rtf)

          table = in_table ? '\intbl' : ""
          "{\\pard#{table} \\#{alignment} \\f0 \\fs24 \\sa#{item[:spacing]} " \
            "\\li#{item[:indent]} \\fi#{item.fetch(:hanging, 0)}" \
            "#{item.fetch(:list_controls, '')} #{item[:content]}\\par}\n"
        end
      end
    end
  end
end
