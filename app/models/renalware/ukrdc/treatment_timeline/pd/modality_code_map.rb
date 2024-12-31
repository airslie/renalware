module Renalware
  module UKRDC
    module TreatmentTimeline
      module PD
        class ModalityCodeMap
          def code_for_pd_regime(regime)
            return default_code if regime.blank?

            ukrr_name = if regime.treatment =~ /assisted/i
                          case regime.pd_type
                          when :apd then "Assisted APD"
                          when :capd then "Assisted CAPD"
                          end
                        else
                          case regime.pd_type
                          when :apd then "APD"
                          when :capd then "CAPD"
                          end
                        end

            ModalityCode.find_by!(description: ukrr_name)
          end

          def default_code
            ModalityCode.find_by!(txt_code: 19)
          end
        end
      end
    end
  end
end
