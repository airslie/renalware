module Renalware
  module Pathology
    # Responsible for defining the set of observation descriptions that
    # are relevant to pathology in the renal care domain
    #
    class RelevantObservationDescription
      # Returns an AR Relation containing e.g.:
      # [
      #    #<Renalware::Pathology::ObservationDescription id: 767, code: "HGB", name: "HGB">,
      #    #<Renalware::Pathology::ObservationDescription id: 1058, code: "MCV", name: "MCV">,
      #    #<Renalware::Pathology::ObservationDescription id: 1055, code: "MCH", name: "MCH">,
      #     ...
      #  ]
      def self.all
        ObservationDescription.for(codes)
      end

      def self.codes
        %w(
          HGB MCV MCH HYPO WBC LYM NEUT PLT RETA ESR
          CRP FER FOL B12 URE CRE EGFR NA POT BIC
          CCA PHOS PTHI TP GLO ALB URAT BIL ALT AST
          ALP GGT BGLU HBA HBAI CHOL HDL LDL TRIG TSH
          CK URR CRCL UREP AL CICLOMS TACROMS SIROMS CMVD TROP
        )
      end
    end
  end
end
