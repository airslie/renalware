module Renalware
  module Clinics
    class AppointmentQuery
      def initialize(q: {}, relation: nil)
        @relation = relation || Appointment.all
        @q = q
        @q[:s] = "starts_at ASC" if @q[:s].blank?
      end

      def call
        search.result.includes(
          :clinic,
          :consultant,
          patient: [current_modality: [:description]]
        )
      end

      def search
        @search ||= @relation.extending(QueryableAppointment).ransack(@q)
      end

      # Note there is a known ransacker issue where if there was an appointment at 00:00 in 5-Apr
      # created in BST then it will be stored in UTC as 23:00 4-Apr and this ransacker
      # does not apply the timezone so will not find this appointment if starts_at is 5-Apr.
      module QueryableAppointment
        def self.extended(base)
          base.ransacker :starts_on, type: :date do
            Arel.sql("DATE(starts_at)")
          end
        end
      end
    end
  end
end
