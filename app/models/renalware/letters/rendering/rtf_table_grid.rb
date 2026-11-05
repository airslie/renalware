module Renalware
  module Letters
    module Rendering
      # Pandoc's RTF writer expands spans into a rectangular grid, rather than merged cells.
      class RTFTableGrid
        pattr_initialize :table

        MAX_CELLS = 10_000
        class TableTooLargeError < StandardError; end

        def call
          check_size!(1)
          occupied = Array.new(rows.length) { [] }
          rows.each_with_index.map do |row, row_index|
            cells = row.xpath("./th|./td")
            fill_row(occupied, cells, row_index)
            { cells: occupied[row_index].map { |cell| cell == :span ? nil : cell },
              header: header?(row, row_index, cells) }
          end
        end

        private

        def fill_row(occupied, cells, row_index)
          column = 0
          cells.each do |cell|
            column += 1 while occupied[row_index][column]
            occupy(occupied, cell, row_index, column)
            column += span(cell, "colspan")
          end
        end

        def header?(row, index, cells)
          row.parent.name == "thead" || (index.zero? && cells.all? { |cell| cell.name == "th" })
        end

        def rows
          @rows ||= table.xpath("./tr|./thead/tr|./tbody/tr|./tfoot/tr")
        end

        def span(cell, attribute)
          # Limit each span; check_size! separately bounds the entire expanded rectangle.
          cell[attribute].to_i.clamp(1, 100)
        end

        def occupy(occupied, cell, row, column)
          width = span(cell, "colspan")
          check_size!(column + width)
          height = [span(cell, "rowspan"), rows.length - row].min
          height.times do |offset|
            occupied[row + offset].fill(:span, column, width)
          end
          occupied[row][column] = cell
        end

        def check_size!(width)
          return if rows.length * width <= MAX_CELLS

          raise TableTooLargeError, "RTF table exceeds the limit of #{MAX_CELLS} expanded cells"
        end
      end
    end
  end
end
