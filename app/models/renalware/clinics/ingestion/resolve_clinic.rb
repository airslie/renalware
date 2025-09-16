module Renalware::Clinics
  module Ingestion
    class ResolveClinic
      include Renalware::Callable

      pattr_initialize [:name_in_feed, :code_in_feed]

      # The strategy for resolving the outpatient clinic referenced in an HL7 message
      # can be configured via the Rails config.
      # Options are
      # :by_code
      #   we look for a clinic with a matching code, return nil if none found.
      #   this is useful we have a firehose of clinic appointments that have not been
      #   pre-filtered by Renal specialty.
      # :by_name_mapping
      #   look up a row in Renalware::Clinics::Mapping with a
      #   name_in_feed matching the HL7 PV1-3 and return the mapped clinic_id, the default clinic
      #   is ine is configured, or nil. Used when the feed is pre-filtered by Renal specialty.
      #
      # :by_name_with_jit_creation
      #   Used when the feed is pre-filtered by Renal specialty.
      #   Try to find a clinic by the name in the feed; if not found create it.
      #
      # Other strategies could be implemented in the future.
      #
      # @param name_in_feed [String] The HL7 PV1-3 clinic name
      # @param code_in_feed [String] The HL7 PV1-3 clinic code
      # @return [Renalware::Clinics::Clinic, nil]
      #
      def call
        case strategy
        when :by_code then Clinic.find_by(code: code_in_feed)
        when :by_name_mapping then Mapping.clinic_for(name_in_feed)
        when :by_name_with_jit_creation
          raise ArgumentError, "clinic name is required" if name_in_feed.blank?

          Clinic.find_or_create_by(name: name_in_feed)
        else raise "Unknown strategy #{strategy} for resolving the outpatient clinic"
        end
      end

      private

      def strategy = Renalware.config.feeds_outpatient_clinic_resolution_strategy&.to_sym
    end
  end
end
