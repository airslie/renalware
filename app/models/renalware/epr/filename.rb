module Renalware
  module EPR
    # Base for the PDF file names dropped into the EPR folders. Subclasses supply the document
    # name, timestamp and document type.
    class Filename
      pattr_initialize :document, :site
      delegate :patient, to: :document

      def hospital_number
        patient.hospital_identifiers.all.fetch(site.to_s.upcase.to_sym).to_s.rjust(7, "0")
      end

      def to_s
        "#{parts.join('_')}.pdf"
      end

      private

      def parts
        [
          document.id,
          document_name,
          timestamp.strftime("%Y%m%d%H%M%S%3N"),
          hospital_number,
          family_name_caps,
          patient_dob,
          document_type
        ]
      end

      def family_name_caps = patient.family_name.upcase.gsub(/[^A-Z]/, "").slice(0, 10)
      def patient_dob = patient.born_on.strftime("%Y%m%d")
    end
  end
end
