# rubocop:disable Rails/ContentTag
# See https://github.com/kylefox/trix/blob/master/lib/trix/simple_form/trix_editor_input.rb
class TrixEditorInput < SimpleForm::Inputs::Base
  def input(_wrapper_options)
    trix_options = options.slice(:spellcheck, :toolbar, :tabindex, :input, :class, :data)
    editor_options = { input: input_class, class: "trix-content" }.merge(trix_options)

    editor_tag = template.content_tag("trix-editor", "", editor_options)
    hidden_field = @builder.hidden_field(attribute_name, input_html_options)

    template.content_tag("div", hidden_field + editor_tag, class: "trix-editor-wrapper")
  end
end
# rubocop:enable Rails/ContentTag
