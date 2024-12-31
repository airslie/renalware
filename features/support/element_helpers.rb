module ElementHelpers
  def within_article(title, &)
    within(:css, "article", text: title, &)
  end

  def submit_form
    within ".form-actions", match: :first do
      find("input[name='commit']").click
    end
  end
end

World(ElementHelpers)
