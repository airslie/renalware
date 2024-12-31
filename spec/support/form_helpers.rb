module FormHelpers
  # Submit forms that use the default structure eg they call save_or_cancel
  # to add a Create/Save button to the form
  def submit_form
    within ".form-actions", match: :first do
      find("input[name='commit']").click
    end
  end
end
