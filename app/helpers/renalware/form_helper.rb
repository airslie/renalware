# frozen_string_literal: true

module Renalware
  module FormHelper
    def errors_css_class(model, attr)
      " field_with_errors" if model.errors.key?(attr)
    end

    def render_input(builder, attribute, html_options: {})
      renderable = builder.object.public_send(attribute)
      return unless renderable

      render input_partial_path_for(renderable),
             attribute: attribute,
             f: builder,
             html_options: html_options
    end

    def input_partial_path_for(renderable)
      partial_type = partial_type_for(renderable)
      "renalware/shared/documents/#{partial_type}_input"
    end

    def partial_type_for(renderable)
      if renderable.respond_to?(:to_partial_path)
        renderable.to_partial_path.split("/").last
      else
        renderable.class.name.demodulize.underscore
      end
    end

    # Given a string value of eg "ASDF" and w width of 5, return a span containing a left
    # padded string with nbsp for padding eg "<span class='monospaced'>&nbsp;ASDF"</span>"
    def monospace(value, width = 5)
      tag.span(class: "monospaced") do
        concat(("%#{width}s" % value).gsub(" ", "&nbsp;").html_safe)
      end
    end

    def save_or_cancel(
      form:,
      back_path:,
      submit_title: nil,
      cancel_title: I18n.t("btn.cancel"),
      **args # e.g. remote: true
    )
      tag.div(class: "form-actions") do
        concat(
          link_to(cancel_title, back_path, class: "btn btn-secondary mr-3", **args)
        )
        concat(form.submit(submit_title, class: "btn btn-primary"))
      end
    end

    def filter_or_reset(
      form:,
      reset_path:,
      filter_title: I18n.t("btn.filter"),
      reset_title: I18n.t("btn.reset")&.downcase,
      show_filter_button: true
    )
      tag.div(class: "filter-actions") do
        if show_filter_button
          concat(form.submit(filter_title, class: "btn btn-sm btn-secondary"))
          concat(tag.span { " #{I18n.t('btn.or')} " })
        end
        concat(link_to(reset_title, reset_path))
      end
    end

    def help_panel
      tag.div(class: "rounded-md bg-blue-100 px-3 py-2 flex items-start shadow mb-5") do
        concat(
          tag.span do
            inline_icon(:info_circle, size: :md, class: "mt-px mr-2 text-blue-500")
          end
        )
        concat(tag.span { yield if block_given? })
      end
    end
  end
end
