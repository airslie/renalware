module Renalware
  module Feeds
    class HL7TestMessagesController < BaseController
      def new
        authorize %i(renalware admin devops), :show?
        test_messages = HL7TestMessage.all
        render locals: { form: HL7TestForm.new, test_messages: test_messages }
      end

      def create # rubocop:disable Metrics/MethodLength
        authorize %i(renalware admin devops), :create?
        body = replace_placeholders_in_hl7_message(form_params[:body])
        error = nil

        begin
          Renalware::Feeds.message_processor.call(body)
        rescue StandardError => e
          error = e.detailed_message
        end

        respond_to do |format|
          format.js do
            render locals: { result: "Processed #{Time.zone.now}", error: error }
          end
        end
      end

      private

      def form_params
        params.require(:feeds_hl7_test_form).permit(:body)
      end

      def replace_placeholders_in_hl7_message(message)
        message
          .gsub("{{message_id}}", SecureRandom.hex(12))
          .gsub("\r\n", "\r")
      end
    end
  end
end
