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
    class PatientListener
      def patient_added(patient, reason)
        if Renalware.config.replay_historical_pathology_when_new_patient_added
          ReplayHistoricalHL7PathologyMessagesJob.perform_later(patient, reason)
        end
      end
    end
  end
end
