module Renalware
  module Events
    # Query object that returns, for a patient, the most recent matching event (if any) for each
    # event_type_alert_trigger row in the database. The results are used to display
    # alerts in the UI.
    # For example given a vaccination Event::Type and an EventTypeAlertTrigger
    # which is configured to find any vaccination event with the word "covid" in
    # anywhere in the document, this query will return the most matching event.
    # It is possible to have multiple triggers rows for the same event type, so for example one
    # could display triggers for the most recent covid vaccination, and the most recent HBV
    # vaccination.
    class AlertableEventsQuery
      def self.call(patient:)
        Event
          .for_patient(patient)
          .joins(event_type: :alert_triggers)
          .select("DISTINCT ON (events.patient_id, event_type_alert_triggers.id) events.*")
          .where("(events.document::text ilike '%' || when_event_document_contains || '%') or " \
                 "(events.description ilike '%' || when_event_description_contains || '%')")
          .order("events.patient_id, event_type_alert_triggers.id, events.created_at desc")
      end
    end
  end
end
