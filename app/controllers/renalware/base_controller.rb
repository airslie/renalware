require "nhs_client"

module Renalware
  class BaseController < ApplicationController
    include Concerns::DeviseControllerMethods
    include Pundit::Authorization
    include Concerns::ReturnTo

    before_action :set_paper_trail_whodunnit
    after_action :verify_authorized

    # A layout helper macro that will ensure correct layout for turboframe requests
    def self.use_layout(name)
      layout(-> { turbo_frame_request? ? "turbo_rails/frame" : "renalware/layouts/#{name}" })
    end

    # A note on ahoy tracking:
    # check_session_expired is defined on SessionTimeoutController
    # using this in the that controller
    #   skip_before_action :track_ahoy_visit, only: check_session_expired
    # does not seem to work hence this global denylist

    # rubocop:disable Rails/LexicallyScopedActionFilter
    after_action :track_action, except: :status
    # rubocop:enable Rails/LexicallyScopedActionFilter

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    class PatientNotFoundError < StandardError; end
    rescue_from PatientNotFoundError, with: :patient_not_found

    # Expose a few attributes for use in the patient layout and its partials.
    # As a rule, we should be passing variables explicitly to all view using `locals`;
    # however, while not a fan of `helper_method`, exposing e.g. current_patient this (akin to
    # Devise's current_user) allows a layout to access e.g. the current patient easily,
    # and is more encapsulated and less bug-prone than accessing @patient directly
    helper_method :current_patient, :nhs_client
    alias_attribute :current_patient, :patient

    def patient
      @patient ||= patient_scope.find_by(secure_id: params[:patient_id]).tap do |patient_|
        raise PatientNotFoundError unless patient_
      end
    end

    def nhs_client
      @nhs_client ||= ::NHSClient.new
    end

    protected

    def patient_search
      @patient_search ||= Patients::PatientSearch.call(params, patient_scope)
    end

    # Will be overridden if a controller includes PatientVisibility
    def patient_scope(default_scope = Renalware::Patient.all)
      default_scope
    end

    def success_msg_for(model_name)
      t("#{action_name}.success", model_name: model_name&.to_s&.humanize)
    end

    def failed_msg_for(model_name)
      t("#{action_name}.failed", model_name: model_name&.humanize)
    end

    def paginate(collection, default_per_page: 25)
      collection.page(params[:page]).per(params[:per_page] || default_per_page)
    end

    def track_action
      ahoy.track "action", request.path_parameters
    end

    private

    # TODO: remove load_patient before_action once refactored out of other controllers.
    # Individual patient-level controllers can authorise using the PolicyPatient if they like,
    # but I believe it will be more extensible and intention revealing if authorisation is done
    # on the entity being actioned e.g. a Prescription. That way provides more authorisation
    # granularity if required, for example if it transpires deleting a Prescriptions is actually
    # possible if you have a certain role.
    def load_patient
      authorize patient
      patient
    end

    def patient
      @patient ||= patient_scope.find_by(secure_id: params[:patient_id]).tap do |pat|
        raise PatientNotFoundError unless pat
      end
    end

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to dashboard_path
    end

    def patient_not_found
      flash[:error] = "Patient not found"
      redirect_to dashboard_path
    end
  end
end
