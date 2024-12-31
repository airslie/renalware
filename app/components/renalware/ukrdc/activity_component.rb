module Renalware
  module UKRDC
    class ActivityComponent < ApplicationComponent
      rattr_initialize [:current_user!]

      def summaries
        DailySummary.order(date: :desc).limit(7)
      end
    end
  end
end
