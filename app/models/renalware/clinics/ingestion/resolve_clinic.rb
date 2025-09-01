module Renalware::Clinics
  module Ingestion
    class ResolveClinic
      include Renalware::Callable

      pattr_initialize [:name_in_feed, :code_in_feed]

      # The strategy for resolving the outpatient clinic referenced in an HL7 message
      # can be configured via the Rails config. The default is :by_code which looks for a
      # Renalware::Clinics::Clinic with a code matching the HL7 PV1-3. If the strategy is
      # :by_name_mapping then we look for a Renalware::Clinics::Mapping with a
      # name_in_feed matching the HL7 PV1-3 and return the mapped clinic_id (or nil if no
      # mapping exists and no default clinic has been set up).
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
        else raise "Unknown strategy #{strategy} for resolving the outpatient clinic"
        end
      end

      private

      def strategy = Renalware.config.feeds_outpatient_clinic_resolution_strategy&.to_sym
    end
  end
end
