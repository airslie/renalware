module Renalware
  module XHRHelper
    def refresh(el, partial:, locals:)
      <<-JS.squish.html_safe
        $("#{el}").html("#{escape_javascript(render(partial, locals))}");
      JS
    end

    def replace(el, partial:, locals:)
      <<-JS.squish.html_safe
        $("#{el}").replaceWith("#{escape_javascript(render(partial, locals))}");
        $("#{el}").addClass("post-action-highlight");
      JS
    end
  end
end
