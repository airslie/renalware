module Renalware
  module DeviseHelper
    def custom_devise_error_messages!
      return "" if resource.errors.empty?

      messages = resource.errors.full_messages.map { |msg| tag.li(msg) }.join

      html = <<-HTML
      <ul class="error-messages">#{messages}</ul>
      HTML

      html.html_safe
    end
  end
end
