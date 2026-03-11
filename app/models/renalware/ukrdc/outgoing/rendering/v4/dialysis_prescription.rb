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

            def entered_on_element = create_node("EnteredOn", hd_profile.created_at.iso8601)

            def from_time_element
              return if hd_profile.prescribed_on.blank?

              create_node("FromTime", hd_profile.prescribed_on.to_datetime.iso8601)
            end

            def to_time_element
              return if hd_profile.deactivated_at.blank?

              create_node("ToTime", hd_profile.deactivated_at.iso8601)
            end

            def session_type_element = create_node("SessionType", "HD")

            def time_dialysed_element
              return if hd_profile.prescribed_time.blank?

              create_node("TimeDialysed", hd_profile.prescribed_time)
            end

            def sessions_per_week = hd_profile.schedule_definition&.days_per_week

            def sessions_per_week_element
              return unless sessions_per_week

              create_node("SessionsPerWeek", sessions_per_week)
            end

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
