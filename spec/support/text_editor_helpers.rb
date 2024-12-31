module TextEditorHelpers
  # Basecamp trix uses hidden input to populate its editor
  def fill_in_trix_editor(id, value)
    find(:xpath, "//*[@id='#{id}']", visible: false).set(value)
  end

  # A simplified version of the helper, requires JavaScript, and will end up
  # having <div>value</div> in the trix-saved content, but that is normal
  def fill_trix_editor(with:)
    find("trix-editor").click.set(with)
  end
end
