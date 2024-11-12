# frozen_string_literal: true

module Renalware
  module Feeds
    # Responsible for representing an HL7 message. Fields can be queried via
    # chained method calls. For example, accessing the patient identifier field
    # in the PID segment can be accessed by calling:
    #
    #   HL7Message.new(raw_message).patient_identification.internal_id
    #
    class HL7Message < SimpleDelegator
      ACTIONS = {
        "ADT^A28" => :add_person_information,
        "ADT^A31" => :update_person_information,
        "ADT^A08" => :update_admission,
        "ADT^A01" => :admit_patient,
        "ADT^A02" => :transfer_patient,
        "ADT^A03" => :discharge_patient,
        "ADT^A11" => :cancel_admission,
        "ADT^A05" => :schedule_new_appointment,
        "ADT^A38" => :cancel_appointment,
        "MFN^M02" => :add_consultant, # no
        "ADT^A34" => :merge_patient, # no
        "ADT^A13" => :cancel_discharge,
        "ORU^R01" => :add_pathology_observations
      }.freeze

      class ObservationRequest < SimpleDelegator
        def initialize(observation_request_segment) # rubocop:disable Lint/UselessMethodDefinition
          super
        end

        # Select only OBX children. OBR can have other types of child
        # segments but we want to ignore those.
        def observations
          @observations ||= children
            .select { |segment| segment.is_a? HL7::Message::Segment::OBX }
            .map { |obx_segment| Observation.new(obx_segment) }
        end

        def filler_order_number       = super.split("^").first
        def identifier                = universal_service_id.split("^").first
        def name                      = universal_service_id.split("^")[1]
        def observed_at               = observation_date.presence || requested_date
        def ordering_provider_name    = ordering_provider.last
        def placer_order_number       = super.split("^").first

        private

        def ordering_provider = super.split("^")
      end

      class Observation < SimpleDelegator
        attr_reader :cancelled

        alias_attribute :observed_at, :observation_date
        alias_attribute :value, :observation_value
        alias_attribute :result_status, :observation_result_status

        # Apply aliases logic to return the OBX code
        def identifier  = observation_id.split("^").first
        def name        = observation_id.split("^")[1]
        # TODO: Implement comment extraction
        def comment     = @comment || ""

        # Some messages may come through with result text like
        #   ##TEST CANCELLED## Insufficient specimen received
        # in which case replace with something more concise.
        # We could save the actual message somewhere.
        # If the value contains eg
        #   "12.8\.br\This result bla bla"
        # then we
        # However the best way to handle this is to use Mirth preprocessor script to
        # map \.br\ to eg '¬' and then we can handle that more easily as as / is a escape char
        # and breaks all sorts of things
        def observation_value
          if super.upcase.at("CANCELLED")
            @comment = super
            @cancelled = true
            ""
          elsif super.at("\\.br\\")
            parts = super.split("\\.br\\")
            @comment = parts[1..]&.join(" ")
            parts[0]
          elsif super.at("¬")
            parts = super.split("¬")
            @comment = parts[1..]&.join(" ")
            parts[0]
          else
            super
          end
        end

        # Because some units of measurement, such as 10^12/L for WBC, contain a caret, the caret
        # will initially have been encoded by Mirth as \S\ (a Mirth escape sequence for ^
        # or whatever the mirth component separator character is configured to be)
        # However in the 10^12/L example above, when encoded by Mirth, becomes `10\S\12/L` but
        # the `\12` within the message is interpreted as a `\n` (form feed) by
        # delayed_job when it is read into the yaml format string in the HL7 messages.
        # While it might be possible to write out yaml into delayed_job using a format
        # that will not un-escape on reading, the approach here is that the we have preprocessed
        # the message using a trigger (at the point it is inserted into delayed_jobs) by
        # replacing any instance of \S\ with \\S\\ in the message.
        # Thus the raw data for units in the database will look like `10\\S\\12/L`.
        # When ever this string is loaded by Ruby it will un-escaped and become "\S\"
        # No `\12` is not found and un-escaped to \n"
        # Note in the gsub here we double escape the \'s
        def units
          super&.gsub("\\S\\", "^")
        end
      end

      # There is a problem here is there are < 1 OBR
      # i.e. self[:OBR] could be an array
      def observation_requests
        Array(self[:OBR]).map { |obr| ObservationRequest.new(obr) }
      end

      def patient_dob
        dob = self[:PID]&.patient_dob
        Date.parse(dob) if dob.present?
      end

      def action                  = ACTIONS.fetch(type, :no_matching_command)
      def patient_identification  = Renalware::Feeds::PatientIdentification.new(self[:PID])
      def orc_order_status        = first_orc_segment.order_status
      def orc_filler_order_number = first_orc_segment.filler_order_number
      def pv1                     = Renalware::Feeds::HL7Segments::PV1.new(self[:PV1])
      def pv2                     = Renalware::Feeds::HL7Segments::PV2.new(self[:PV2])
      def time                    = self[:MSH].time
      def type                    = self[:MSH].message_type
      def header_id               = self[:MSH].message_control_id
      def message_type            = type.split("^").first
      def sending_app             = self[:MSH].sending_app
      def sending_facility        = self[:MSH].sending_facility

      # Adding this so it is part of the interface and we can mock an HL7Message in tests
      def to_hl7 # rubocop:disable Lint/UselessMethodDefinition
        super
      end

      def event_type
        parts = type.split("^")
        parts.length == 2 && parts.last
      end

      %i(ORU ADT).each do |msg_type|
        define_method(:"#{msg_type.to_s.downcase}?") do
          msg_type.to_s == message_type
        end
      end

      def practice_code
        self[:PD1].e3.split("^")[2] if self[:PD1]
      end

      def gp_code
        self[:PD1].e4.split("^")[0] if self[:PD1]
      end

      private

      def first_orc_segment
        Array(self[:ORC]).first || NullObject.instance
      end
    end
  end
end
