# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          # Handles rendering an HD Treatment (aka modality). We defer to the base Treatment
          # class but pass in some extra arguments to the ctor.
          class HDTreatment < Treatment
            def initialize(treatment:)
              encounter_number = [
                treatment.modality_id,
                treatment.hd_profile_id
              ].compact.join("-")

              super(
                treatment:,
                encounter_number:,
                attributes: { "QBL05" => treatment.hospital_unit&.unit_type_rr8 }
              )
            end
          end
        end
      end
    end
  end
end
