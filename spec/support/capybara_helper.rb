module CapybaraHelper
  def select_nth_option_from(selector, number = 1)
    all("#{selector} option")[number - 1].select_option
  end

  def select_first_option_from(selector)
    select_nth_option_from(selector)
  end

  def within_article(title, &)
    within(:css, "article", text: title, &)
  end
end
