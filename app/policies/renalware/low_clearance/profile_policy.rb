# frozen_string_literal: true

require_dependency "renalware/messaging"

module Renalware
  module LowClearance
    class ProfilePolicy < BasePolicy
      def edit?
        record.present? &&
          record.patient.ever_been_on_low_clearance? &&
          update?
      end
    end
  end
end
