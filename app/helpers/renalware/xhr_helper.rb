# frozen_string_literal: true

module Renalware
  module XHRHelper
    def refresh(el, partial:, locals:)
      <<-EOS.squish.html_safe
        $("#{el}").html("#{escape_javascript(render(partial, locals))}");
      EOS
    end

    def replace(el, partial:, locals:)
      <<-EOS.squish.html_safe
        $("#{el}").replaceWith("#{escape_javascript(render(partial, locals))}");
        $("#{el}").addClass("post-action-highlight");
      EOS
    end
  end
end
