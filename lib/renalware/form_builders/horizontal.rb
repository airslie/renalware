# frozen_string_literal: true

module Renalware
  module FormBuilders
    class Horizontal < ActionView::Helpers::FormBuilder
      CALENDAR_ICON_PATH = [
        "M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 ",
        "2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 ",
        "0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 ",
        "0 0121 11.25v7.5"
      ].join

      CALENDAR_SVG_OPTIONS = {
        xmlns: "http://www.w3.org/2000/svg",
        fill: "none",
        viewBox: "0 0 24 24",
        "stroke-width": "1.5",
        stroke: "currentColor",
        class: "rw-date-input__icon-svg"
      }.freeze

      INPUT_SIZE_CLASSES = {
        xs: "rw-input--xs",
        sm: "rw-input--sm",
        md: "rw-input--md",
        lg: "rw-input--lg",
        full: "rw-input--full",
        date: "rw-input--date"
      }.freeze

      def error_summary(title: "Please fix the following:")
        return if object.blank? || object.errors.blank?

        @template.content_tag(:div, class: "rw-error-summary") do
          list_items = object.errors.full_messages.map { |msg| @template.content_tag(:li, msg) }
          @template.content_tag(:h2, title, class: "rw-error-summary__title") +
            @template.content_tag(
              :ul,
              @template.safe_join(list_items),
              class: "rw-error-summary__list"
            )
        end
      end

      def field_row(method, label: nil, hint: nil, row_class: nil, &)
        @template.content_tag(:div, class: class_names("rw-field-row", row_class)) do
          label_html = label_row(method, text: label)
          control_html = control_row(method, hint:, &)
          label_html + control_html
        end
      end

      def text_row(method, label: nil, hint: nil, **opts)
        field_row(method, label:, hint:) { text_field(method, input_opts(opts)) }
      end

      def date_row(method, label: nil, hint: nil, **opts)
        field_row(method, label:, hint:) do
          date_opts = input_opts(opts, default_size: :date)
          date_opts[:class] = class_names("js-flatpickr", "rw-input--with-icon", date_opts[:class])
          date_opts[:data] = (date_opts[:data] || {}).merge(controller: "flatpickr")
          date_opts[:autocomplete] ||= "off"
          date_opts[:value] ||= format_date_value(object&.public_send(method))

          input = text_field(method, date_opts)
          icon = calendar_icon
          @template.content_tag(:div, @template.safe_join([input, icon]), class: "rw-date-input")
        end
      end

      def text_area_row(method, label: nil, hint: nil, **opts)
        field_row(method, label:, hint:) { text_area(method, input_opts(opts)) }
      end

      def select_row(method, choices, **opts)
        label = opts.delete(:label)
        hint = opts.delete(:hint)
        options = opts.delete(:options) || {}
        input_html = opts.delete(:input_html) || {}
        field_row(method, label:, hint:) do
          select(method, choices, options, input_opts(input_html.merge(opts)))
        end
      end

      def file_row(method, label: nil, hint: nil, **opts)
        field_row(method, label:, hint:) { file_field(method, input_opts(opts)) }
      end

      def actions_row(&)
        @template.content_tag(:div, class: "rw-actions", &)
      end

      private

      def label_row(method, text: nil)
        @template.content_tag(:div, class: "rw-label") do
          label(method, text, class: "rw-label__text")
        end
      end

      def control_row(method, hint: nil, &)
        @template.content_tag(:div, class: "rw-control") do
          control = @template.capture(&)
          hint_html = hint.present? ? @template.content_tag(:p, hint, class: "rw-hint") : nil
          err_html = error_text_for(method)
          @template.safe_join([control, hint_html, err_html].compact)
        end
      end

      def error_text_for(method)
        return unless object&.errors&.[](method)&.any?

        @template.content_tag(:p, object.errors[method].to_sentence, class: "rw-error")
      end

      def input_opts(opts, default_size: nil)
        opts = opts.dup
        size = opts.key?(:size) ? opts.delete(:size) : default_size
        disabled = opts[:disabled] == true
        opts[:class] =
          class_names("rw-input", size_class_for(size), ("rw-input--disabled" if disabled),
                      opts[:class])
        opts
      end

      def class_names(*parts)
        parts.flatten.compact.compact_blank.join(" ")
      end

      def size_class_for(size)
        return nil if size.blank?

        INPUT_SIZE_CLASSES[size.to_sym]
      end

      # Keep date rendering resilient against bad imported strings, matching
      # existing behavior in FlatpickrInput.
      def format_date_value(value)
        return "" if value.blank?

        I18n.l(value)
      rescue I18n::ArgumentError
        value
      end

      def calendar_icon
        @template.content_tag(:span, class: "rw-date-input__icon", aria: { hidden: true }) do
          calendar_icon_svg
        end
      end

      def calendar_icon_svg
        path = @template.tag.path(
          "stroke-linecap": "round",
          "stroke-linejoin": "round",
          d: CALENDAR_ICON_PATH
        )
        @template.content_tag(:svg, path, CALENDAR_SVG_OPTIONS)
      end
    end
  end
end
