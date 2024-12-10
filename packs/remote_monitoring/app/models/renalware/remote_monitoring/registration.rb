# frozen_string_literal: true

module Renalware
  module RemoteMonitoring
    class Registration < Events::Event
      include Document::Base

      def self.policy_class = Renalware::BasePolicy

      class Document < Document::Embedded
        attribute :referral_reason, String
        attribute :frequency_iso8601, String # durations are stored in iso8601 eg "P4M" (4 months)
        attribute :baseline_creatinine, Float

        validates :frequency_iso8601, presence: true
        validates :baseline_creatinine, numericality: true, allow_blank: true

        def frequency = ActiveSupport::Duration.parse(frequency_iso8601)&.inspect
      end
      has_document

      def partial_for(partial_type)
        File.join("renalware/remote_monitoring/registrations", partial_type)
      end
    end
  end
end
