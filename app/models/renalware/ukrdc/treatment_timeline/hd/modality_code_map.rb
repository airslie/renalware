module Renalware
  module UKRDC
    module TreatmentTimeline
      module HD
        class ModalityCodeMap
          def code_for_profile(profile)
            hd_type = profile&.hd_type
            return default_code if hd_type.blank?

            ukrr_name = case hd_type.to_s.downcase
                        when "hd" then "Haemodialysis"
                        when "hdf_pre", "hdf_post" then "Haemodiafiltration"
                        end

            ModalityCode.find_by!(description: ukrr_name)
          end

          def default_code
            ModalityCode.find_by!(description: "Haemodialysis")
          end
        end
      end
    end
  end
end
