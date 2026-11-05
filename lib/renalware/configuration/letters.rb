module Renalware
  class Configuration
    module Letters
      def self.included(base)
        register_letter_settings(base)
        register_mesh_timing_settings(base)
        register_mesh_api_settings(base)
        register_mesh_certificate_settings(base)
        register_mesh_organisation_settings(base)
        register_mesh_care_setting_settings(base)
      end

      def self.register_letter_settings(base)
        # Experimental: retain Pandoc as the default until receiving systems validate the output.
        base.config_accessor(:letters_render_rtf_with_ruby) do
          ActiveModel::Type::Boolean.new.cast(ENV.fetch("LETTERS_RENDER_RTF_WITH_RUBY", "false"))
        end

        base.config_accessor(:letters_render_pdfs_with_prawn) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("LETTERS_RENDER_PDFS_WITH_PRAWN", "false")
          )
        end

        base.config_accessor(:letters_external_document_type_code) do
          ENV["LETTERS_EXTERNAL_DOCUMENT_TYPE_CODE"].presence
        end

        base.config_accessor(:letters_external_document_type_description) do
          ENV["LETTERS_EXTERNAL_DOCUMENT_TYPE_DESCRIPTION"].presence
        end

        base.config_accessor(:letters_mesh_workflow) { :gp_connect } # or :transfer_of_care
      end

      def self.register_mesh_timing_settings(base)
        base.config_accessor(:mesh_timeout_transmissions_with_no_response_after) do
          # Duration#parse uses the ISO8601 duration format.
          ActiveSupport::Duration.parse(
            ENV.fetch("MESH_TIMEOUT_TRANSMISSIONS_WITH_NO_RESPONSE_AFTER", "P20D")
          )
        end

        base.config_accessor(:mesh_delay_seconds_between_letter_approval_and_mesh_send) do
          ActiveModel::Type::Integer.new.cast(
            ENV.fetch("MESH_DELAY_SECONDS_BETWEEN_LETTER_APPROVAL_AND_MESH_SEND", "5")
          ).seconds
        end
      end

      def self.register_mesh_api_settings(base)
        base.config_accessor(:mesh_mailbox_id) { ENV.fetch("MESH_MAILBOX_ID", "?") }
        base.config_accessor(:mesh_mailbox_password) { ENV.fetch("MESH_MAILBOX_PASSWORD", "?") }

        base.config_accessor(:mesh_api_base_url) do
          # This default is the Integration environment.
          ENV.fetch("MESH_API_BASE_URL", "https://msg.intspineservices.nhs.uk/messageexchange")
        end

        base.config_accessor(:mesh_api_secret) { ENV.fetch("MESH_API_SECRET", "?") }

        base.config_accessor(:mesh_use_endpoint_lookup) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("MESH_USE_ENDPOINT_LOOKUP", "false")
          )
        end

        base.config_accessor(:mesh_recipient_mailbox_id) do
          ENV.fetch("MESH_RECIPIENT_MAILBOX", "X26OT112") # X26OT112 is in the NHS INT env
        end

        base.config_accessor(:mesh_workflow_id) do
          ENV.fetch("MESH_WORKFLOW_ID", "GPCONNECT_SEND_DOCUMENT")
          # transfer_of_care: "TOC_FHIR_OP_ATTEN"
        end
      end

      def self.register_mesh_certificate_settings(base)
        base.config_accessor(:mesh_path_to_nhs_ca_file) do
          ENV.fetch("MESH_PATH_TO_NHS_CA_FILE", "MESH_NHS_CA_FILE")
        end

        base.config_accessor(:mesh_nhs_ca_cert) do
          ENV.fetch("MESH_NHS_CA_CERT", "MESH_NHS_CA_CERT")
        end

        base.config_accessor(:mesh_path_to_client_cert) do
          ENV.fetch("MESH_PATH_TO_CLIENT_CERT", "MESH_CLIENT_CERT")
        end

        base.config_accessor(:mesh_client_cert) { ENV.fetch("MESH_CLIENT_CERT", "") }

        base.config_accessor(:mesh_path_to_client_key) do
          ENV.fetch("MESH_PATH_TO_CLIENT_KEY", "MESH_CLIENT_KEY")
        end

        base.config_accessor(:mesh_client_key) { ENV.fetch("MESH_CLIENT_KEY", "") }
      end

      def self.register_mesh_organisation_settings(base)
        base.config_accessor(:mesh_organisation_uuid) { ENV.fetch("MESH_ORGANISATION_UUID", "??") }
        base.config_accessor(:mesh_itk_organisation_uuid) do
          ENV.fetch("MESH_ORGANISATION_UUID", "??")
        end

        base.config_accessor(:mesh_organisation_ods_code) do
          ENV.fetch("MESH_ORGANISATION_ODS_CODE", "??")
        end

        base.config_accessor(:mesh_practitioner_phone) do
          ENV.fetch("MESH_PRACTITIONER_PHONE", "??")
        end

        base.config_accessor(:mesh_organisation_phone) do
          ENV.fetch("MESH_ORGANISATION_PHONE", "??")
        end

        base.config_accessor(:mesh_organisation_email) do
          ENV.fetch("MESH_ORGANISATION_EMAIL", "??")
        end
        base.config_accessor(:mesh_organisation_name) { ENV.fetch("MESH_ORGANISATION_NAME", "??") }
      end

      def self.register_mesh_care_setting_settings(base)
        base.config_accessor(:mesh_care_setting_snomed_code) do
          ENV.fetch("MESH_CARE_SETTING_SNOMED_CODE", "788003006")
        end

        base.config_accessor(:mesh_care_setting_description) do
          ENV.fetch("MESH_CARE_SETTING_DESCRIPTION", "Nephrology service")
        end
      end
    end
  end
end
