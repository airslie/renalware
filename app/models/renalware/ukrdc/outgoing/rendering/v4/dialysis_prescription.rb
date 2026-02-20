# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class DialysisPrescription < Rendering::Base
            pattr_initialize [:hd_profile!]
            delegate :formatted_prescribed_time, to: :hd_profile_presenter

            def xml
              dialysis_prescription_element
            end

            private

            def dialysis_prescription_element
              create_node("DialysisPrescription") do |elem|
                elem << entered_on_element
                elem << from_time_element
                elem << to_time_element
                elem << session_type_element
                elem << sessions_per_week_element
                elem << time_dialysed_element
                elem << vascular_access_element
              end
            end

            def entered_on_element = create_node("EnteredOn", hd_profile.created_at.to_date.iso8601)
            def from_time_element = create_node("FromTime", hd_profile.prescribed_on.iso8601)
            def to_time_element = create_node("ToTime", hd_profile.deactivated_at&.to_date&.iso8601)
            def session_type_element = create_node("SessionType", "HD")
            def sessions_per_week_element = create_node("SessionsPerWeek", sessions_per_week)
            def time_dialysed_element = create_node("TimeDialysed", formatted_prescribed_time)
            def sessions_per_week = hd_profile.schedule_definition&.days_per_week

            def vascular_access_element
              create_node("VascularAccess", access_profile&.type&.rr02_code)
            end

            def hd_profile_presenter
              @hd_profile_presenter ||= HD::ProfilePresenter.new(hd_profile)
            end

            def access_profile
              @access_profile ||= begin
                Accesses::ProfileAtTimeQuery.call(
                  patient: hd_profile.patient,
                  at: hd_profile.prescribed_on
                )
              end
            end
          end
        end
      end
    end
  end
end
