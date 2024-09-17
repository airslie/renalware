# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class API::ResponseHeaders
      pattr_initialize :headers # e.g. a hash of Faraday response headers
      delegate :to_h, to: :headers

      def error_report?
        message_type == "REPORT"
      end

      # Reify Mex-* HTTP headers in the response into methods for convenience so that we can call
      # e.g. #status_description to return headers["Mex-StatusDescription"]
      [
        "StatusEvent",        # Step in the MESH server side process when the error occurred
        "LinkedMsgID",        # The message identifier of the undelivered message
        "WorkflowID",         # The workflow identifier of the undelivered message
        "StatusTimestamp",    # Time the error occurred
        "LocalID",            # Sender assigned local identifier of the unacknowledged message
        "StatusCode",         # Indicate the status of the message, non-00 indicates error
        "MessageID",          # The msg identifier of the error report (not the undelivered message)
        "StatusSuccess",      # SUCCESS or ERROR (is always ERROR in an error report)
        "StatusDescription",  # Indicate the status the message, non-00 indicates error
        "To",                 # Intended receiver of the undelivered message
        "MessageType",        # REPORT (error report) or DATA (normal message)
        "Subject"             # The subject of the undelivered message
      ].each do |header_suffix|
        define_method(header_suffix.underscore.to_sym, -> { headers["Mex-#{header_suffix}"] })
      end
    end
  end
end
