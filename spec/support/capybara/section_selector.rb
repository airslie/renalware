# Copied from
# https://github.com/citizensadvice/capybara_accessible_selectors/blob/b2ee27d18a0c338cf46b2cb2f1917483595fb203/lib/capybara_accessible_selectors/selectors/section.rb

Capybara.add_selector(:section) do
  sections = %i(section article aside footer header main form)
  xpath do |locator, heading_level: (1..6), section_element: sections, **|
    # the nil function is to wrap the condition in brackets
    heading = XPath.function(
      nil,
      XPath.descendant(*Array(heading_level).map { |i| :"h#{i}" })
    )[1][XPath.string.n.is(locator.to_s)]
    XPath.descendant(*Array(section_element).map(&:to_sym))[heading]
  end
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a section
    #
    # @param [String] locator The section heading
    # @param [Hash] options Finder options
    def within_section(locator, **, &)
      within(:section, locator, **, &)
    end
  end
end
