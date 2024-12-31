module Renalware
  module UKRDC
    # Formats a UKRDC patient XML filename
    class Filename
      pattr_initialize [:patient!, :batch_number!]

      def to_s
        "#{site_code}_#{batch_number}_#{sanitized_patient_identifier}.xml"
      end

      private

      def sanitized_patient_identifier
        patient_identifier.strip.upcase
      end

      def site_code
        Renalware.config.ukrdc_site_code # e.g. RJZ
      end

      # For an patient identifier to put in the filename (to make it easier to look up the patient)
      # choose the NHS Number is there is one, falling back to local_patient_id(2,3,4) then
      # ukrdc_external_id - the latter at least is guaranteed to be present.
      def patient_identifier
        return patient.nhs_number if patient.nhs_number.present?

        patient.hospital_identifier&.id || patient.ukrdc_external_id
      end
    end
  end
end
