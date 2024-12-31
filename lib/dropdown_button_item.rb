require "virtus"

class DropdownButtonItem < ActionView::Base
  include Renalware::IconHelper
  include ActionView::Helpers::TagHelper
  include Virtus.model(mass_assignment: false)

  attribute :title, String
  attribute :url, String
  attribute :icon, String
  attribute :url_options, Hash
  attribute :enabled, Boolean

  def initialize(options = {})
    @title = options.delete(:title)
    @url = options.delete(:url)
    @icon = options.delete(:icon)
    @url_options = options
    @enabled = options.delete(:enabled) { true }
  end

  def to_html
    enabled? ? enabled_html : disabled_html
  end

  private

  def enabled_html
    content_tag(:li) do
      capture do
        link_to(url, url_options, class: "flex") { icon_and_title_html }
      end
    end
  end

  def disabled_html
    content_tag(:li, class: "disabled") { icon_and_title_html }
  end

  def icon_and_title_html
    tag.div(class: "flex items-center") do
      concat(icon_html)
      concat(title_html)
    end
  end

  def icon_html
    inline_icon(icon) if icon.present?
  end

  def title_html
    tag.span(class: "ml-2") { title } if title.present?
  end
end
