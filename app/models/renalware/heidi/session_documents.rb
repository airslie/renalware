module Renalware
  module Heidi
    # Fetches a preview without changing the imported note or the clinic visit.
    class SessionDocuments
      class FetchError < StandardError; end

      def initialize(session:, client: SessionsClient.new)
        @session = session
        @client = client
      end

      def call
        details = client.get(session.user, session.heidi_session_id)
        documents = client.documents(session.user, session.heidi_session_id)
        raise FetchError if details.failed? || documents.failed?

        [main_note(details.body)] + additional_documents(documents.body)
      end

      private

      attr_reader :session, :client

      def main_note(body)
        note = body.dig("session", "consult_note") || {}
        output(note, "consult_note", note["heading"] || "Main note", note["result"])
      end

      def additional_documents(body)
        Array(body["documents"]).map do |document|
          output(document, document["id"], document["name"], document["content"])
        end
      end

      def output(document, id, name, content)
        ready = document["status"].blank? || %w(CREATED COMPLETED).include?(document["status"])
        html = ready ? formatted_content(document, content) : nil
        { id:, name: name.presence || "Untitled document", content: html }
      end

      def formatted_content(document, content)
        return if content.blank?

        if document["content_type"] == "HTML"
          ::Rails::Html::SafeListSanitizer.new.sanitize(
            content, tags: Clinics::ClinicVisitPresenter::NOTE_TAGS, attributes: []
          ).presence
        else
          MarkdownToHtml.new(content).call.presence
        end
      end
    end
  end
end
