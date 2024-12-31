module Renalware
  module Feeds
    #
    # Responsible for coordinating the processing sequences of a raw HL7 message.
    #
    class MessageProcessor
      include Broadcasting
      attr_reader :raw_message, :hl7_message, :feed_message

      # We want to wrap message processing in a transaction because if message processing
      # fails we don't want to leave an unprocessed message in the feed_messages table.
      # If we did, and the same FeedJob retires a few minutes later, if will try to save to
      # feed_messages with the same MD5 body_hash (the message is identical to one already saved)
      # resulting in unique key violation.
      # Using a transaction here prevents any orphaned records if there is an error.
      # However we should be aware that any listeners raising an error will prevent successful
      # in all other listeners. So a listener should be careful to catch errors and not re-raise
      # them, or use the :message_processed message (lower down) which is safer.
      # rubocop:disable Metrics/MethodLength
      def call(raw_message)
        @raw_message = raw_message

        parse_raw_message_into_hl7_object
        ActiveRecord::Base.transaction do
          create_feed_message_using_raw_message_and_basic_extracted_patient_data
          allow_listeners_to_process_the_message
          feed_message.update!(processed: true)
        end

        allow_listeners_to_post_process_the_message
      rescue Feeds::DuplicateMessageError => e
        Rails.logger.warn("Rejected duplicate HL7 message: #{e.message}")
      rescue StandardError => e
        notify_exception(e)
        raise e
      end
      # rubocop:enable Metrics/MethodLength

      private

      def notify_exception(exception)
        Engine.exception_notifier.notify(exception)
      end

      def allow_listeners_to_process_the_message
        message_to_broadcast = "#{hl7_message.message_type.downcase}_message_arrived"
        broadcast(
          message_to_broadcast.to_sym,
          hl7_message: hl7_message,
          feed_message: feed_message
        )
      end

      def allow_listeners_to_post_process_the_message
        # Another event, this one letting anyone interested know that a message been successfully
        # processed. They might want to forward the message on somewhere else for instance.
        # Think Diaverum.
        # The crucial difference here is that an exception raised by a listener does not prevent the
        # main processing of the HL7 message from being rolled back.
        # They could use this for message processing but we'd rather it was used for post-processing
        # e.g. forwarding, logging etc.
        # Its is recommended here to use an async listener - see example in renalware-diaverum
        # - so that any error in the listener has its own retry mechanism and does not cause the
        # current job to retry.
        message_to_broadcast = "#{hl7_message.message_type.downcase}_message_processed"
        broadcast(
          message_to_broadcast.to_sym,
          hl7_message: hl7_message,
          feed_message: feed_message
        )
      end

      def parse_raw_message_into_hl7_object
        @hl7_message = MessageParser.parse(raw_message)
      end

      # If the incoming message has already been processed we should not be processing it again.
      # To help enforce this there is a unique MD5 hash on feed_messages which will baulk if the
      # same message payload is saved twice - in this case we exit #call early, the broadcast
      # is not issued and therefore the message is not processed. The message will go back into
      # the activejob queue and retry, failing until it finally gives up!
      def create_feed_message_using_raw_message_and_basic_extracted_patient_data
        @feed_message = PersistMessage.new.call(hl7_message)
      end
    end
  end
end
