#
# When subscribed to HL7 `message_arrived` messages, gets notified of incoming HL7 messages
#
module Renalware
  module Patients
    module Ingestion
      class MessageListener
        def adt_message_arrived(args)
          hl7_message = args[:hl7_message]
          return unless hl7_message.adt?

          command = Command.for(hl7_message)
          command.call
        end
      end
    end
  end
end
