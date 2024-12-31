module Renalware
  module Letters
    # Responsible for defining the set of observation descriptions that
    # are relevant to clinical letters
    class RelevantObservationDescription
      def self.all
        Pathology::ObservationDescription.for(codes)
      end

      def self.codes
        %w(
          HGB PLT WBC URE CRE EGFR POT NA BIC CCA PHOS
          ALB BIL AST GGT ALP CHOL FER HBA BGLU PTHI
        )
      end
    end
  end
end
