module Renalware
  module Letters::Transports::Mesh
    module API::Errors
      # HTTP-level errors
      # Alow certain classes of http error to be retried. See handle_http_error
      class HttpError < StandardError; def retriable? = false; end
      class RetriableHttpError < HttpError; def retriable? = true; end
      class AuthorizationError < RetriableHttpError; end
      class BadRequestError < HttpError; end
      class InvalidRecipientOrWorkflowRestrictedError < HttpError; end
      class MessageAlreadyDownloadedAndAcknowledgedError < HttpError; end
      class MessageDoesNotExistError < HttpError; end
      class UnrecognisedHttpResponseCodeError < RetriableHttpError; end

      # MESH mailbox and NHS number resolution (EPL) errors
      # https://digital.nhs.uk/services/message-exchange-for-social-care-
      #  and-health-mesh/mesh-guidance-hub/endpoint-lookup-service-
      #  and-workflowids#error-handling
      class MeshMailboxOrNHSNumberException < HttpError; def retriable? = true; end
    end
  end
end
