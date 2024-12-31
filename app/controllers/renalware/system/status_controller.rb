module Renalware
  module System
    # To avoid a dependency on as many aspects of Renalware as possible, in case one of those
    # is not functioning, inherit from ActionController::Base (not ApplicationController)
    # and do not use a layout. No database writes should occur while rendering, to catch the
    # scenario where database write privileges are incorrect or the database is out of space.
    class StatusController < ActionController::Base # rubocop:disable Rails/ApplicationController
      layout false

      def show
        render locals: { status: StatusPresenter.new }
      end
    end
  end
end
