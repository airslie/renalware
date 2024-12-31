module Renalware
  module Letters::Transports::Mesh
    class Operation < ApplicationRecord
      include RansackAll
      ACCEPTABLE_CONTENT_TYPES = %w(application/octet-stream application/xml).freeze

      validates :action, presence: true
      validates :direction, presence: true
      belongs_to :parent, class_name: "Operation"
      has_many :children, class_name: "Operation", dependent: :nullify, foreign_key: "parent_id"
      belongs_to :transmission
      # validates :transmission, presence: true

      enum :action, {
        endpointlookup: "endpointlookup",
        handshake: "handshake",
        check_inbox: "check_inbox",
        download_message: "download_message",
        acknowledge_message: "acknowledge_message",
        send_message: "send_message"
      }

      scope :successful_business_responses, -> {
        where(action: "download_message")
          .where(itk3_response_type: "bus")
          .where(itk3_operation_outcome_code: "30001")
      }

      scope :successful_infrastructure_responses, -> {
        where(action: "download_message")
          .where(itk3_response_type: "inf")
          .where(itk3_operation_outcome_code: "20013")
      }

      enum :direction, { outbound: "outbound", inbound: "inbound" }

      ransacker :created_at, type: :date do
        Arel.sql("date(created_at)")
      end

      def success?
        http_success? && mesh_success? && itk3_success?
      end

      def http_success?
        (200..299).cover?(http_response_code)
      end

      def mesh_success?
        mesh_response_error_code.blank?
      end

      def itk3_success?
        itk3_response_code&.casecmp("ok")&.zero?
      end

      def itk3_infrastructure_response?
        itk3_response_type == "inf"
      end

      def itk3_business_response?
        itk3_response_type == "bus"
      end
    end
  end
end
