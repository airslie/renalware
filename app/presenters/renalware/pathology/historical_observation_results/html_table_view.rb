require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for rendering a HTML table to format historical observation results.
    #
    class HistoricalObservationResults::HTMLTableView < SimpleDelegator
      def render(view_model)
        header, *body = view_model

        content_tag(:table, id: "observations") do
          concat(format_header(header))
          concat(format_body(body))
        end
      end

      private

      def format_header(cells)
        content_tag(:thead) do
          content_tag(:tr) do
            cells.each do |cell|
              concat(format_header_cell(cell))
            end
          end
        end
      end

      def format_body(rows)
        content_tag(:tbody) do
          rows.each do |row|
            concat(content_tag(:tr) do
              row.each do |cell|
                concat(format_body_cell(cell))
              end
            end)
          end
        end
      end

      def format_header_cell(cell)
        content_tag(:th, cell, class: cell.html_class, title: cell.title)
      end

      def format_body_cell(cell)
        if cell.respond_to?(:cancelled?)
          if cell.cancelled?
            # content = cell.cancelled ? "CANCL" : cell.to_s
            content_tag(:td, class: cell.html_class, style: "text-align: center") do
              tooltip_with_block(label: cell.comment) do
                content_tag(:i, "", class: "fa fa-warning centre")
              end
            end
          else
            content_tag(:td, cell, class: cell.html_class)
          end
        else
          # A date?
          content_tag(:td, cell, class: cell.html_class)
        end
      end
    end
  end
end
