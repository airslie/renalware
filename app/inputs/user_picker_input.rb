# frozen_string_literal: true

class UserPickerInput < SimpleForm::Inputs::CollectionSelectInput
  def input_type
    :user_picker
  end

  def input_html_options
    options = super
    options[:class] ||= []
    options[:class] << :searchable_select
    options
  end
end
