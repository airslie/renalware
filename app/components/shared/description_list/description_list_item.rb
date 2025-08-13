# frozen_string_literal: true

class Shared::DescriptionListItem < Shared::Base
  include Phlex::Rails::Helpers::Sanitize

  def initialize(key, value, **attrs)
    @key = key
    @value = value.presence || I18n.t("unspecified")
    @title = attrs.delete(:title)
    super(**attrs)
  end

  def view_template
    dt(title: @title) { @key }
    dd { sanitize @value.to_s }
  end
end
