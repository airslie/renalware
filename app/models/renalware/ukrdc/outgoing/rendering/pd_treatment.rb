module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        # Handles rendering a PD Treatment (aka modality). We defer to the base Treatment
        # class but pass in some extra arguments to the ctor.
        class PDTreatment < Rendering::Treatment
          def initialize(treatment:)
            encounter_number = [
              treatment.modality_id,
              treatment.pd_regime_id
            ].compact.join("-")

            super(
              treatment: treatment,
              encounter_number: encounter_number
            )
          end
        end
      end
    end
  end
end
