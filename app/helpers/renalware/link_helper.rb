module Renalware
  module LinkHelper
    # A wrapper around link_to_if that will output greyed-out text to indicate the option is
    # not permitted if condition is falsey.
    def link_to_if_allowed(condition, name, options = {}, html_options = {})
      link_to_if(condition, name, options, html_options) do
        tag.span(class: "no-permission") { name }
      end
    end

    # Used for displaying a question mark icon as a hint in forms
    # eg HD Session
    def help_link(opts = {})
      link_to("#", **opts) do
        inline_icon :question_mark, size: :xl
      end
    end

    def external_link_to(body, url, gap: 2, **html_options)
      html_options.reverse_merge!(target: "_blank")
      link_to(url, html_options) do
        tag.div(class: "flex items-center gap-#{gap}") do
          capture do
            concat inline_icon(:external, size: :sm)
            concat body
          end
        end
      end
    end

    def svg_btn(title, svg_name, url, gap: 2, size: :md, **html_options)
      html_options[:class] ||= ""
      html_options[:class] += " btn"
      link_to(url, html_options) do
        tag.div(class: "flex items-center gap-#{gap}") do
          capture do
            concat inline_icon(svg_name, size: size)
            concat title
          end
        end
      end
    end
  end
end
