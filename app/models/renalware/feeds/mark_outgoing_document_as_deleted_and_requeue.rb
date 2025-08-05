module Renalware
  module Feeds
    # When a renderable (letter/event etc) is (soft-)deleted, if has already been
    # sent to Mirth (and then on to the TIE), then it will have a row in the outgoing_documents
    # table. We need to mark that document in this row as deleted
    # and set the status to 'queued' so Mirth will resend it (it polls this table) and this time it
    # will include document completion status of eg "CA" (cancelled) to indicate to the TIE that it
    # should be flagged as deleted in downstream document repositories.
    #
    # Example usage in a letter_listener.rb class that has been configured to listen
    # to the letter_* events:
    #
    #   def letter_deleted(letter)
    #     Renalware::Feeds::MarkOutgoingDocumentAsDeletedAndRequeue.call(
    #       renderable: letter,
    #       by: letter.deleted_by
    #     )
    #   end
    class MarkOutgoingDocumentAsDeletedAndRequeue
      include Callable

      pattr_initialize [:renderable!, :by!]

      def call
        doc = Renalware::Feeds::OutgoingDocument.find_by(renderable: renderable)
        return if doc.blank? || renderable.deleted_at.blank?

        doc.update!(
          by: by, # the user who deleted the document
          state: :queued, # Requeue, so Mirth will pick it up again
          comments: "Requeued as document was deleted"
        )
      end
    end
  end
end
