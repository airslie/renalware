class ClockPickerInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options)
    template.tag.div(class: "relative rounded-md w-60") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column(_wrapper_options = {})
    template.tag.div(class: "pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3") do
      template.concat(icon_clock)
    end
  end

  def input_column(_wrapper_options = {})
    html_options = input_html_options
    html_options[:step] = 300

    html_options[:class] ||= []
    html_options[:class] << "border-0 !pl-12"
    html_options[:class] << "clockpicker"

    html_options[:data] ||= {}
    html_options[:data].merge!(data_attributes)

    datestamp = @builder.object.public_send(attribute_name)
    value = datestamp.present? ? I18n.l(datestamp, format: :time) : ""

    @builder.time_field(attribute_name, html_options.merge(value: value))
  end

  def icon_clock
    '<svg xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
      class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>'.html_safe # rubocop:disable Rails/OutputSafety
  end

  def input_type
    :string
  end

  def data_attributes
    {}
  end
end
