# frozen_string_literal: true

module Renalware
  module Feeds
    # When a new patient is added to Renalware, its possible and likely we will have received
    # HL7 messages for them at some point in the past given that we store all ADT (demographics)
    # and ORU (pathology) messages for all patients in the hospital, routed via our Mirth server.
    # So it would be nice to replay a patient's historical messages, but this time, instead of
    # ignoring their content because the patient is not in Renalware, they will be imported and
    # associated with the patient.
    #
    # This query object finds feed_messages that
    # - relate to the supplied patient
    # - have not been imported yet
    # and replays them.
    # We can in theory replay ADT or ORU messages but currently do only ORU (pathology) because it
    # it is deemed that once the patient is added to Renalware, subsequent ADT HL7 messages which
    # will soon arrive will being the demographic data up to date - so no point replaying ADT
    # messages really (although appointment info could be useful?), and might in fact lead to
    # confusion.
    #
    # We also take into account previous replays and and do not import a messages if has a row in a
    # 'replayed messages' table where success was indicated.
    class ReplayableHL7PathologyMessagesQuery
      include Callable
      pattr_initialize [:patient!, search_before_patient_creation_only: true]

      class MissingNHSNumberError < StandardError; end
      class MissingDOBNumberError < StandardError; end
      class PatientNotPersistedError < StandardError; end

      def call
        raise PatientNotPersistedError unless patient.persisted?
        raise MissingNHSNumberError if patient.nhs_number.blank?
        raise MissingDOBNumberError if patient.born_on.blank?

        ids = feed_message_ids(
          patient: patient,
          before: datetime_to_search_back_from
        )
        Renalware::Feeds::Message.where(id: ids).order(sent_at: :asc)
      end

      private

      def datetime_to_search_back_from
        if search_before_patient_creation_only && patient.created_at
          patient.created_at
        else
          100.years.from_now
        end
      end

      # Get a distinct feed message for each orc_filler_order_number, talking the most recently
      # sent one. Return an array of matching ids.
      # rubocop:disable Metrics/MethodLength
      def feed_message_ids(patient:, before:)
        sql = <<-SQL.squish
          WITH history as (
            select distinct fmr.urn
            from renalware.feed_message_replays fmr
            inner join renalware.feed_replay_requests rr on rr.id = fmr.replay_request_id
            where rr.patient_id = ? and fmr.success = true
          )
          SELECT distinct on (orc_filler_order_number) fm.id
            FROM renalware.feed_messages fm
            WHERE
              fm.message_type = 'ORU'
              AND fm.event_type = 'R01'
              AND fm.orc_order_status = 'CM'
              AND fm.nhs_number = ?
              AND fm.dob = ?
              AND fm.sent_at IS NOT NULL
              AND fm.created_at <= ?
              AND fm.orc_filler_order_number not in (select h.urn from history h where fm.orc_filler_order_number = h.urn)
            ORDER BY
              orc_filler_order_number, sent_at desc, id desc
        SQL

        sql = ActiveRecord::Base.sanitize_sql_array(
          [
            sql,
            patient.id,
            patient.nhs_number,
            patient.born_on,
            before
          ]
        )
        ActiveRecord::Base.connection.execute(sql)&.values&.flatten
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
