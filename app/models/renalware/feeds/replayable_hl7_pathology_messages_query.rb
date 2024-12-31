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

      class MissingNHSNumberOrLocalIdError < StandardError; end
      class MissingDOBNumberError < StandardError; end
      class PatientNotPersistedError < StandardError; end

      IDENTIFIERS = %i(
        nhs_number
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).freeze

      def initialize(patient:, from: nil, to: nil, orc_filler_order_numbers: [])
        @patient = patient
        @from = from || Time.zone.at(0) # 1970-01-01 00:00:00
        @to = to || patient&.created_at
        @orc_filler_order_numbers = orc_filler_order_numbers
      end

      def call
        validate_patient

        Renalware::Feeds::Message
          .where(id: feed_message_ids)
          .order(sent_at: :asc)
      end

      private

      def validate_patient
        raise PatientNotPersistedError unless patient.persisted?
        raise MissingDOBNumberError if patient.born_on.blank?
        raise MissingNHSNumberOrLocalIdError if identifiers.blank?
      end

      attr_reader :patient, :from, :to, :orc_filler_order_numbers

      def orc_filler_order_numbers_already_successfully_imported(patient)
        MessageReplay
          .select(:urn)
          .joins(:replay_request)
          .group(:urn)
          .where(success: true, replay_request: { patient_id: patient.id })
          .pluck(:urn)
          .compact_blank
      end

      def identifiers
        @identifiers ||= IDENTIFIERS.index_with { |meth| patient.public_send(meth) }.compact_blank
      end

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def feed_message_ids
        urns = orc_filler_order_numbers_already_successfully_imported(patient)

        query = Message.none
        identifiers.each do |column, hosp_no|
          query = query.or(Message.where(column => hosp_no))
        end
        query = query.select("distinct on (orc_filler_order_number) id")
          .where(
            message_type: "ORU",
            event_type: "R01",
            orc_order_status: "CM",
            dob: patient.born_on,
            created_at: from..to
          )
          .where.not(sent_at: nil)
          .where.not(orc_filler_order_number: nil)
          .where.not(orc_filler_order_number: "")
          .order(orc_filler_order_number: :asc, sent_at: :desc, id: :desc)

        if urns.any?
          query = query.where.not(orc_filler_order_number: urns)
        end

        if orc_filler_order_numbers.present?
          query = query.where(orc_filler_order_number: orc_filler_order_numbers)
        end

        # Don't use pluck here as it ignores the distinct on !
        query.map(&:id)
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
    end
  end
end
