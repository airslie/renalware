# frozen_string_literal: true

module ElementHelpers
  def within_article(title, &block)
    within(:css, "article", text: title, &block)
  end
end

World(ElementHelpers)
