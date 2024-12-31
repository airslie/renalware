module Renalware
  module TooltipHelper
    def tooltip(label:, content:)
      tag.span(title: content,
               class: "has-tip",
               "aria-haspopup" => "true",
               data: {
                 tooltip: "",
                 options: "disable_for_touch:true"
               }) do
        label
      end
    end

    def tooltip_with_block(label:)
      tag.span(title: label,
               class: "has-tip",
               "aria-haspopup" => "true",
               data: {
                 tooltip: "",
                 options: "disable_for_touch: true; hover_delay: 100;"
               }) do
        yield if block_given?
      end
    end
  end
end
