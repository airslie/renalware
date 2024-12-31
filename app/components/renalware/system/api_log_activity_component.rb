module Renalware
  module System
    class APILogActivityComponent < ApplicationComponent
      rattr_initialize [:current_user!]

      def logs
        APILog.order(created_at: :desc).limit(10)
      end
    end
  end
end
