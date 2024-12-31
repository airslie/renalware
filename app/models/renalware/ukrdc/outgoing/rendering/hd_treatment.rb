module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        # Handles rendering an HD Treatment (aka modality). We defer to the base Treatment
        # class but pass in some extra arguments to the ctor.
        class HDTreatment < Rendering::Treatment
          # UKRDC3
          UNIT_TYPE_RR8_MAP = {
            hospital: "HOSP",
            satellite: "SATL",
            home: "HOME"
          }.freeze

          # UKRDC4
          # UNIT_TYPE_RR8_MAP = {
          #   hospital: "INCENTRE",
          #   satellite: "INCENTRE",
          #   home: "HOME",
          #   assisted: "ASSISTED"
          # }.freeze

          def initialize(treatment:)
            encounter_number = [
              treatment.modality_id,
              treatment.hd_profile_id
            ].compact.join("-")

            super(
              treatment: treatment,
              encounter_number: encounter_number,
              attributes: { "QBL05" => unit_type_rr8_for(treatment.hospital_unit) }
            )
          end

          private

          # Map unit_type to its equivalent Renal Registry RR8 code.
          def unit_type_rr8_for(unit)
            UNIT_TYPE_RR8_MAP[unit.unit_type.to_sym]
          end
        end
      end
    end
  end
end
