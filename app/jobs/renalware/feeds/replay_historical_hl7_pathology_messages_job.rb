# 'patient_added' event...
#   -> Renalware::Feeds::PatientListener receives the event
#     -> ReplayHistoricalHL7PathologyMessagesJob.perform_later(patient) # async
#       -> ReplayHistoricalHL7PathologyMessages.call(patient: patient) # does the heavy lifting
#         -> for each replayable path message fetched via ReplayableHL7PathologyMessagesQuery
#           -> broadcast oru_message_arrived event
#             -> Renalware::Pathology::Ingestion::MessageListener
#             -> ... extensible list
module Renalware
  module Feeds
    class ReplayHistoricalHL7PathologyMessagesJob < ApplicationJob
      def perform(patient, reason)
        ReplayHistoricalHL7PathologyMessages.call(patient: patient, reason: reason)
      end
    end
  end
end
