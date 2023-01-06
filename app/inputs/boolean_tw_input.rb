# frozen_string_literal: true

class BooleanTwInput < SimpleForm::Inputs::BooleanInput
  def input_html_options
    options = super
    options[:class] ||= []
    options[:class] << " mr-2 "
    options
  end
end
