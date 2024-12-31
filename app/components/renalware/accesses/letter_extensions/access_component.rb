module Renalware
  module Accesses
    module LetterExtensions
      class AccessComponent < ViewComponent::Base
        pattr_initialize [:patient!]

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Rails/OutputSafety
        def call
          output1 = []
          output1 << "<dt>HD Access</dt>"
          sub_output1 = []
          sub_output1 << presented_access_profile.type&.to_s if presented_access_profile.type
          sub_output1 << presented_access_profile.side&.to_s if presented_access_profile.side
          output1 << "<dd>#{sub_output1.join(' ')}</dd>" if sub_output1.present?

          output2 = []
          sub_output2 = []
          if presented_access_profile.plan_type.present?
            sub_output2 << presented_access_profile.plan_type.to_s
          end
          if presented_access_profile.plan_date.present?
            sub_output2 << ::I18n.l(presented_access_profile.plan_date&.to_date)
          end
          output2 << "<dd>#{sub_output2.join(' ')}</dd>" if sub_output2.present?

          "<dl>#{[output1.join(' '), output2.join(' ')].compact.join}</dl>".html_safe
        end
        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Rails/OutputSafety

        def render?
          access_profile.present?
        end

        private

        def access_profile
          @access_profile ||= Accesses.cast_patient(patient).current_profile
        end

        def presented_access_profile
          @presented_access_profile ||= Accesses::ProfilePresenter.new(access_profile)
        end
      end
    end
  end
end
