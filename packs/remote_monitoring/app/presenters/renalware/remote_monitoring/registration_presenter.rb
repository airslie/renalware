# frozen_string_literal: true

module Renalware
  module RemoteMonitoring
    class RegistrationPresenter < ApplicationPresenter
      def referral_reasons = ReferralReason.ordered.pluck(:description)

      # Label and iso8601 duration (which will be stored on the document), e.g. [
      #  ["1 month", "P1M"],
      #  ["4 months", "P4M"],
      #  ...
      # ]
      def frequencies
        Frequency.ordered.map { |x| [x.period.inspect, x.period.iso8601] }
      end
    end
  end
end
