module Renalware
  module Letters
    module Rendering
      class RTFList
        def self.decorate(item, node)
          list = node.parent
          level = list.xpath("ancestor::ul | ancestor::ol").length
          id = list.xpath("preceding::ul | preceding::ol | ancestor::ul | ancestor::ol").length + 1
          marker = marker(node, level)
          item[:content] = "{\\listtext\\tab #{marker}\\tab} #{item[:content]}"
          item[:hanging] = -360
          item[:list_controls] = "\\ls#{id}\\ilvl#{level}\\tx360"
        end

        def self.marker(node, level)
          return level.even? ? '\bullet ' : '\endash ' unless node.parent.name == "ol"

          siblings = node.parent.element_children.select { |child| child.name == "li" }
          number = node.parent["start"].to_i
          number = 1 if number.zero?
          "#{number + siblings.index(node)}."
        end
      end
    end
  end
end
