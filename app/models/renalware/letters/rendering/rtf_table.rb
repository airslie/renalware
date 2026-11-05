module Renalware
  module Letters
    module Rendering
      class RTFTable
        pattr_initialize :node, :render_cell

        WIDTH = 8640 # Pandoc's default six-inch table width, in twips.
        ALIGNMENTS = { "left" => "ql", "center" => "qc", "right" => "qr" }.freeze

        def call
          rows = RTFTableGrid.new(node).call
          count = rows.map { |row| row[:cells].size }.max.to_i
          return "" if count.zero?

          boundaries = column_boundaries(count)
          rows.map { |row| render_row(row, boundaries) }.join + caption
        end

        private

        def column_boundaries(count)
          columns = node.xpath("./col|./colgroup/col")
          widths = columns.map { |col| col["style"].to_s[/\bwidth:\s*([\d.]+)%/, 1].to_f }
          widths = Array.new(count, 1.0) unless widths.size == count && widths.all?(&:positive?)
          total = widths.sum
          offset = 0.0
          widths.map { |width| ((offset += width) / total * WIDTH).round }
        end

        def render_row(row, boundaries)
          border = row[:header] ? '\clbrdrb\brdrs' : ""
          definitions = boundaries.map { |boundary| "#{border}\\cellx#{boundary}" }.join
          cells = boundaries.each_index.map { |index| cell(row[:cells][index]) }.join
          "{\n\\trowd \\trgaph120\n#{definitions}\n\\trkeep\\intbl\n{\n#{cells}}\n\\intbl\\row}\n"
        end

        def cell(node)
          content = node ? render_cell.call(node, alignment(node)) : ""
          "{#{content}\\cell}\n"
        end

        def alignment(cell)
          value = cell["align"] || cell["style"].to_s[/\btext-align:\s*(\w+)/, 1]
          ALIGNMENTS.fetch(value.to_s.downcase, "ql")
        end

        def caption
          node = self.node.at_xpath("./caption")
          content = node ? render_cell.call(node, "ql", in_table: false) : ""
          return content if content.present?

          RTFParagraph.call({ content: "", spacing: 180, indent: 0 })
        end
      end
    end
  end
end
