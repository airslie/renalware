require "active_support/concern"

module Renalware
  module Concerns
    # Included in controllers that list or show patients, so that, if configured to do so,
    # we can use the PatientPolicy to control patient visibility ie a user a Hospital A cannot
    # see patients at the same hospital (A) but not those at Hospital B. Used at BLT.
    module PatientVisibility
      extend ActiveSupport::Concern
      include Pundit::Authorization

      class_methods do
        # Add a skip_verify_policy_scoped macro to allow excluding an action from
        # verify_policy_scoped. Only delegate to skip_after_action if
        # patient_visibility_restrictions are configured, otherwise will raise an
        # exception as the verify_policy_scoped is not defined
        # Example usage:
        #   skip_verify_policy_scoped only: :search
        #
        def skip_verify_policy_scoped(**)
          return if Renalware.config.patient_visibility_restrictions == :none

          skip_after_action(:verify_policy_scoped, **)
        end
      end

      if Renalware.config.patient_visibility_restrictions != :none
        included do
          # Adding this after_action callback is just a helper to ensure that a developer
          # has called policy_scope from the #index action on the controller. Its has no
          # function other than a check. We could disable in non-dev environments with e.g.
          # if: Rails.env.development? || Rails.env.test?
          after_action :verify_policy_scoped, if: -> { Rails.env.local? }

          # Override policy_scope from BaseController
          def patient_scope(default_scope = Renalware::Patient.all)
            policy_scope(default_scope)
          end
        end
      end
    end
  end
end
