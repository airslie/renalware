module Renalware
  module Transplants
    class RecipientWorkupBuilder
      def initialize(workup:, default_consenter_name:)
        @workup = workup
        @default_consenter_name = default_consenter_name
      end

      def build
        if workup.new_record?
          assign_default_consenter
        end
        workup
      end

      private

      attr_reader :workup, :default_consenter_name

      delegate :document, to: :workup

      def assign_default_consenter
        document.consent.full_name ||= default_consenter_name
        document.marginal_consent.full_name ||= default_consenter_name
        document.nhb_consent.full_name ||= default_consenter_name
      end
    end
  end
end
