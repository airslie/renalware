module Renalware
  class Configuration
    module Feeds
      def self.included(base)
        register_outpatient_clinic_config(base)
        register_outgoing_document_config(base)
        register_raw_hl7_config(base)
        register_patient_config(base)
      end

      def self.register_outpatient_clinic_config(base)
        # See ResolveClinic for details of the strategies.
        base.config_accessor(:feeds_outpatient_clinic_resolution_strategy) do
          ENV.fetch("FEEDS_OUTPATIENT_CLINIC_RESOLUTION_STRATEGY", "by_code").to_sym
        end
      end

      def self.register_outgoing_document_config(base)
        base.config_accessor(:feeds_outgoing_documents_enabled) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("FEEDS_OUTGOING_DOCUMENTS_ENABLED", "true")
          )
        end

        base.config_accessor(:feeds_outgoing_documents_hospital_service) do
          ENV.fetch("FEEDS_OUTGOING_DOCUMENTS_HOSPITAL_SERVICE", "") # eg. "361^Nephrology"
        end

        base.config_accessor(:feeds_outgoing_documents_sending_facility) do
          ENV.fetch("FEEDS_OUTGOING_DOCUMENTS_SENDING_FACILITY", "MSE")
        end

        # Opt in only after the TIE mapping supports standard MSH field placement.
        base.config_accessor(:feeds_outgoing_documents_correct_msh_header) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("FEEDS_OUTGOING_DOCUMENTS_CORRECT_MSH_HEADER", "false")
          )
        end

        base.config_accessor(:feeds_outgoing_documents_use_guids) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("FEEDS_OUTGOING_DOCUMENTS_USE_GUIDS", "false")
          )
        end

        base.config_accessor(:feeds_outgoing_documents_letter_format) do
          fmt = ENV.fetch("FEEDS_OUTGOING_DOCUMENTS_LETTER_FORMAT", "pdf").to_sym
          [:pdf, :rtf].find { |x| x == fmt } || :pdf
        end
      end

      def self.register_raw_hl7_config(base)
        base.config_accessor(:bypass_raw_hl7_processing_advisory_lock) do
          ENV.fetch("BYPASS_RAW_HL7_PROCESSING_ADVISORY_LOCK", 0).to_i == 1
        end
      end

      def self.register_patient_config(base)
        base.config_accessor(
          :feeds_always_create_patient_on_a31_a28_as_tie_is_filtering_by_renal
        ) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch(
              "FEEDS_ALWAYS_CREATE_PATIENT_ON_A31_A28_AS_TIE_IS_FILTERING_BY_RENAL",
              "false"
            )
          )
        end
      end
    end
  end
end
