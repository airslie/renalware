module Renalware
  module HD
    module LetterExtensions
      # rubocop:disable Rails/OutputSafety
      class ScheduleComponent < ViewComponent::Base
        include ActionView::Helpers
        pattr_initialize [:patient!]

        def call
          output = []
          if presented_hd_profile.hospital_unit_unit_code.present?
            output << "<dt>HD Unit</dt><dd>#{presented_hd_profile.hospital_unit_unit_code}</dd>"
          end

          if presented_hd_profile.current_schedule
            output << "<dt>Schedule</dt><dd>#{presented_hd_profile.current_schedule}</dd>"
          end

          if presented_hd_profile.formatted_prescribed_time.present?
            output << "<dt>Time</dt><dd>#{presented_hd_profile.formatted_prescribed_time}</dd>"
          end

          "<dl>#{output.join}</dl>".html_safe
        end

        def render?
          hd_profile.present?
        end

        private

        def hd_profile
          @hd_profile ||= hd_patient.hd_profile
        end

        def presented_hd_profile
          @presented_hd_profile ||= HD::ProfilePresenter.new(hd_profile)
        end

        def hd_patient = HD.cast_patient(patient)
      end
    end
    # rubocop:enable Rails/OutputSafety
  end
end
