class InlineRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def self.default_options
    {
      item_wrapper_class: %w(flex items-center),
      collection_wrapper_tag: "div",
      collection_wrapper_class: "flex flex-col sm:flex-row sm:items-center gap-x-8 gap-y-2",
      input_html: {
        class: "h-4 w-4 border-gray-400 text-sky-600 focus:ring-sky-500 cursor-pointer"
      },
      item_label_class: "ml-3 block font-medium text-gray-700 cursor-pointer"
    }
  end

  def input_type = "radio_buttons"
end
