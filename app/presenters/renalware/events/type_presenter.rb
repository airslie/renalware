module Renalware
  module Events
    class TypePresenter < SimpleDelegator
      def admin_change_window_hours
        window_text_for(super)
      end

      def author_change_window_hours
        window_text_for(super)
      end

      private

      def window_text_for(window)
        case window
        when -1 then "Forever"
        when 0 then "Never"
        when 168 then "1 wk"
        when 720 then "1 mon"
        when 4380 then "6 mon"
        when 8760 then "1 yr"
        else "#{window} hr"
        end
      end
    end
  end
end
