module Renalware
  module NavigationHelper
    # Path here must be already resolved to a string using url_for
    # e.g. Engine.routes.url_for({controller: .., action: .., only_path: true})
    def sub_nav_item(label, path)
      current_page = current_page?(path)
      tag.dd(class: ("active" if current_page)) do
        link_to label, path
      end
    end
  end
end
