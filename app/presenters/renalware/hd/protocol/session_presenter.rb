# Override SessionPresenter methods where necessary in order
# to tailor output for the Protocol PDF.
module Renalware
  module HD
    module Protocol
      class SessionPresenter < HD::SessionPresenter
        def started_at
          ::I18n.l(session.started_at)
        end
      end
    end
  end
end
