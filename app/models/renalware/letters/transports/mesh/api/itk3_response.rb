require "httparty"

module Renalware
  module Letters::Transports::Mesh::API
    # Wraps a Faraday response to give us helpers for handling the content of
    # an ITK3 XML response from API::Client.download_message
    # See
    # https://nhsconnect.github.io/ITK3-FHIR-Messaging-Distribution/explore_response_structure.html
    # for the expected FHIR XML response structure
    class ITK3Response
      HANDLEABLE_CONTENT_TYPES = %w(application/octet-stream application/xml).freeze

      pattr_initialize :response

      def handleable?
        raise ArgumentError if response.headers.blank?
        return false if response.body.nil?

        HANDLEABLE_CONTENT_TYPES.include?(response.headers["Content-Type"])
      end

      def operation_attributes
        return {} unless handleable?

        {
          itk3_response_type: infrastructure? ? :inf : :bus,
          itk3_response_code: response_code,
          itk3_operation_outcome_type: issue_code,
          itk3_operation_outcome_severity: issue_severity,
          itk3_operation_outcome_code: detail_code,
          itk3_operation_outcome_description: detail_description,
          itk3_error: response_code != "ok"
        }
      end

      def business?
        !infrastructure?
      end

      # Infrastructure reponse codes start with 1 or 2 eg 10010 or 20001 etc.
      # Business response codes start with 3 eg 30001.
      def infrastructure?
        %w(1 2).include?(detail_code.to_s[0])
      end

      def response_code
        xml.xpath("Bundle/entry/resource/MessageHeader/response/code/@value").text
      end

      def issue_code
        issue.xpath("code/@value").text
      end

      def detail_code
        issue.xpath("details/coding/code/@value").text
      end

      def detail_description
        issue.xpath("details/coding/display/@value").text
      end

      def issue_severity
        issue.xpath("severity/@value").text
      end

      def error?
        !type.casecmp("ok").zero?
      end

      def state
        error? ? :errored : :success
      end

      private

      def xml
        @xml ||= Nokogiri.XML(response.body).tap(&:remove_namespaces!)
      end

      def issue
        @issue ||= xml.xpath("Bundle/entry/resource/OperationOutcome/issue")
      end
    end
  end
end
