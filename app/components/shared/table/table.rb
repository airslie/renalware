# frozen_string_literal: true

class Shared::Table < Shared::Base
  def view_template(&)
    table(**attrs, &)
  end

  private

  def default_attrs = { class: "plx" }
end
