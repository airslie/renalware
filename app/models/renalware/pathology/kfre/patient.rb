module Renalware
  module Pathology
    module KFRE
      class Patient < Pathology::Patient
        def current_modality_supports_kfre?
          current_modality_code = current_modality&.description&.code
          Modalities::Description
            .ignorable_for_kfre
            .pluck(:code)
            .compact
            .exclude?(current_modality_code)
        end

        def latest_egfr
          fetch_current_observation_set.values.egfr_result
        end
      end
    end
  end
end
