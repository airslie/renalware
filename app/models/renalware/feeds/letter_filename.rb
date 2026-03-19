module Renalware
  module Feeds
    class LetterFilename
      pattr_initialize :renderable

      delegate :patient,
               :external_document_type_code,
               to: :renderable

      def to_s
        [
          patient.hospital_identifiers.all.map { |k, v| "#{k}_#{v}" }.join("_"),
          patient.family_name&.upcase,
          patient.born_on&.strftime("%Y%m%d"),
          external_document_type_code,
          renderable.id
        ].compact.join("_")
      end
    end
  end
end

# Another example
# module Renalware
#   module Feeds
#     # Formats a filename for use as the RTF copy of the letter copied to the CRS/EPR folder.
#     #
#     # RTF letter filename format: A_B_C_D_E_F.rtf
#     #   A = MRN (Hosp No) or UNKNOWN
#     #   B = DOB as YYYYMMDD or UNKNOWN
#     #   C = POSTCODE as XXX-XXX or UNKNOWN
#     #   D = NHS No or UNKNOWN
#     #   E = Letter Topic (should be "GP LETTER" if GP = recip or CC"? check with Stan)
#     #   F = Letter timestamp YYYYMMDDHHMM
#     class LetterFilename
#       pattr_initialize :letter

#       MISSING_PLACEHOLDER = "UNKNOWN"

#       def to_s
#         filename
#       end

#       private

#       def filename
#         patient_parts = PatientFilenameParts.new(letter.patient)
#         letter_parts = LetterFilenameParts.new(letter)

#         [
#           patient_parts.hospital_number,
#           patient_parts.dob,
#           patient_parts.postcode,
#           patient_parts.nhs_number,
#           letter_parts.topic,
#           letter_parts.issued_on
#         ].join("_") + ".rtf"
#       end

#       class LetterFilenameParts
#         INVALID_CHARS_REMOVE = "%$`@#\"?*<>:|"
#         INVALID_CHARS_MAP_TO_SPACE = %w(/ \\).join

#         pattr_initialize :letter

#         def issued_on
#           skip_seconds = ENV.fetch("RTF_LETTER_FILENAME_TS_SKIP_SECONDS", 0).to_i == 1
#           format = skip_seconds ? "%Y%m%d%H%M" : "%Y%m%d%H%M%S"
#           letter.approved_at.strftime(format)
#         end

#         def topic
#           letter
#             .topic
#             .text
#             .tr(INVALID_CHARS_REMOVE, "")
#             .tr(INVALID_CHARS_MAP_TO_SPACE, " ")
#             .strip
#         end
#       end

#       class PatientFilenameParts
#         pattr_initialize :patient

#         def hospital_number
#           patient.local_patient_id.presence || MISSING_PLACEHOLDER
#         end

#         def dob
#           patient.born_on&.strftime("%Y%m%d").presence || MISSING_PLACEHOLDER
#         end

#         def postcode
#           patient.current_address&.postcode&.gsub(" ", "-").presence || MISSING_PLACEHOLDER
#         end

#         def nhs_number
#           patient.nhs_number.presence || MISSING_PLACEHOLDER
#         end
#       end
#     end
#   end
# end
