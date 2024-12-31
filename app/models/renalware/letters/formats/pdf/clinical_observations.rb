module Renalware
  module Letters
    module Formats
      module Pdf
        class ClinicalObservations
          include Prawn::View
          pattr_initialize :document

          def build
            text "TEST DATA! <b>BP:</b> 146/83 <b>Weight:</b> 73.1 kg <b>Height:</b> 1.56 m " \
                 "<b>BMI:</b> 30.0 <b>Urine Blood:</b> Trace <b>Urine Protein:</b> ++ " \
                 "<b>Urine Glucose:</b> Negative",
                 inline_format: true
          end
        end
      end
    end
  end
end
