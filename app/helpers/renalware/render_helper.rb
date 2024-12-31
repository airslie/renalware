module Renalware
  module RenderHelper
    def render_if_exists(path_to_partial, args = {})
      render(path_to_partial, args)
    rescue ActionView::MissingTemplate
      nil
    end
  end
end
