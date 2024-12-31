module Renalware
  module Transplants
    module LetterExtensions
      class StatusComponent < ViewComponent::Base
        # http://localhost:3000/patients/xxx/transplants/recipient/registration/edit

        pattr_initialize [:patient!]

        # TODO: Move URR into the a component in the Pathology namespace
        # rubocop:disable Layout/LineLength, Rails/OutputSafety
        def call
          output = []
          output << "<dt>URR</dt><dd>#{urr_value}</dd><dd>#{urr_date}</dd>" if urr_value
          output << "<dt>Transplant status</dt><dd>#{transplant_status&.description}</dd><dd>#{::I18n.l(transplant_status&.started_on)}</dd>" if transplant_status
          "<dl>#{output.join}</dl>".html_safe
        end
        # rubocop:enable Layout/LineLength, Rails/OutputSafety

        def render?
          true
        end

        private

        def urr_date
          ::I18n.l(current_observation_values.urr_observed_at)
        end

        def urr_value
          current_observation_values.urr_result
        end

        def transplant_status
          @transplant_status ||= Transplants.current_transplant_status_for_patient(patient)
        end

        def current_observation_values
          # alternatively define a method somewhere to do the OR condition there
          @current_observation_values ||=
            (@patient.current_observation_set || Pathology::NullObservationSet.new).values
        end
      end
    end
  end
end
