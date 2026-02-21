module Renalware
  module Events
    class LineChangeEventQuery
      attr_reader :patient

      def initialize(patient)
        @patient = patient
      end

      def call(limit: 1)
        return [] if event_type.nil?

        Event
          .for_patient(patient)
          .where(event_type_id: event_type.id)
          .order(date_time: :desc)
          .limit(limit)
      end

      def event_type
        @event_type ||= Renalware::Events::Type.find_by(slug: :pd_line_changes)
      end
    end
  end
end
