class UserPickerInput < SimpleForm::Inputs::CollectionSelectInput
  def input_type
    :user_picker
  end

  def input_html_options
    options = super
    options[:data] ||= {}
    options[:data][:controller] ||= {}
    options[:data][:controller] = :slimselect
    options
  end
end
