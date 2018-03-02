# frozen_string_literal: true

require_dependency "renalware/reporting"
require "cronex"

module Renalware
  module Reporting
    class AuditPresenter < SimpleDelegator
      def refresh_schedule
        return if super.blank?
        Cronex::ExpressionDescriptor.new(super).description
      end
    end
  end
end
