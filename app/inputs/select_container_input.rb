class SelectContainerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    options_html = input_options.delete(:options_html)

    # since we pass our options by our self (and have to select the correct
    # option), set `selected` to `''` to prevent rails calling
    # `object.send(attribute_name)` only to set `selected` which is not used.
    input_options[:selected] = ""

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    @builder.select(attribute_name, nil, input_options, merged_input_options) do
      options_html
    end
  end
end
