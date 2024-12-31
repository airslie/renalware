class FlatpickrInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options)
    template.tag.div(class: "relative rounded-md w-60") do
      template.concat prefix_column
      template.concat input_column
    end
  end

  def prefix_column(_wrapper_options = {})
    %(<div class='absolute inset-y-0 left-0 pl-3 flex items-center text-gray-600 pointer-events-none'>
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
        <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5" />
      </svg>
    </div>).html_safe # rubocop:disable Rails/OutputSafety
  end

  def input_column(_wrapper_options = {})
    html_options = input_html_options
    html_options[:class] ||= []
    html_options[:class] << "border-0 !pl-12"

    html_options[:data] ||= {}
    html_options[:data].merge!(data_attributes)
    html_options[:autocomplete] = "off"

    datestamp = @builder.object.public_send(attribute_name)
    value = format_date(datestamp)
    @builder.text_field(attribute_name, html_options.merge(value: value))
  end

  def input_type
    :string
  end

  def data_attributes
    {
      controller: "flatpickr"
    }
  end

  private

  # Note that datestamp will be some kind of Date object *unless* its an invalid date string
  # e.g. "12-00-2010" that has for example been imported from another system, and its one we
  # happen to store in Rw2 in jsonb where there is no database type checking.
  # We have seen this in LowClearance::Profile.document.
  # So if we get an error converting an invalid date string, return it as is and let the
  # user correct it in the UI. Note that without this error handling, the user will
  # not be able to view the form to correct the data.
  def format_date(datestamp)
    return "" if datestamp.blank?

    I18n.l(datestamp)
  rescue I18n::ArgumentError # e.g. its a string containing an invalid date
    datestamp
  end
end
