module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class Observation < Rendering::Base
          pattr_initialize [
            :observed_at!,
            :measurement!,
            :i18n_key!,
            :updated_by,
            :pre_post
          ]

          def xml
            return if measurement.blank? || measurement.to_f.zero?

            observation_element
          end

          private

          def observation_element
            create_node("Observation") do |elem|
              elem << observation_time_element
              elem << observation_code_element
              elem << observation_value_element
              elem << observation_units_element
              elem << pre_post_element
              elem << updated_by_element
            end
          end

          def observation_code_element
            create_node("ObservationCode") do |code_elem|
              code_elem << create_node("CodingStandard", "UKRR")
              code_elem << create_node("Code", I18n.t("loinc.#{i18n_key}.code"))
              code_elem << create_node("Description", I18n.t("loinc.#{i18n_key}.description"))
            end
          end

          def observation_time_element
            create_node("ObservationTime", observed_at.to_datetime)
          end

          def updated_by_element
            return if updated_by.blank?

            create_node("Clinician") do |clinician_element|
              clinician_element << create_node("Description", updated_by.to_s)
            end
          end

          def observation_units_element
            create_node("ObservationUnits", I18n.t("loinc.#{i18n_key}.units"))
          end

          def observation_value_element
            create_node("ObservationValue", measurement.to_s[0, 19].strip)
          end

          def pre_post_element
            create_node("PrePost", pre_post.upcase) if pre_post.present? # eg PRE or POST
          end
        end
      end
    end
  end
end
