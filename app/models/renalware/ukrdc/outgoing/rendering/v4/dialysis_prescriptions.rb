# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        module V4
          class DialysisPrescriptions < Rendering::Base
            pattr_initialize [:patient!]

            def xml
              dialysis_sessions_element
            end

            private

            def dialysis_sessions_element
              create_node("DialysisPrescriptions") do |elem|
                elem[:start] = from.iso8601
                elem[:stop] = to.iso8601
                hd_profiles.each do |hd_profile|
                  elem << DialysisPrescription.new(hd_profile:).xml
                end
              end
            end

            def hd_profiles
              HD::Profile
                .with_deactivated
                .order(prescribed_on: :asc, deactivated_at: :desc)
                .where(patient:, prescribed_on: from..to)
            end

            def from = patient.changes_since.to_date
            def to = patient.changes_up_until.to_date
          end
        end
      end
    end
  end
end
