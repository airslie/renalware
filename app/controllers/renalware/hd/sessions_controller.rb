# frozen_string_literal: true

require "collection_presenter"

# rubocop:disable Metrics/ClassLength
module Renalware
  module HD
    class SessionsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::Pageable
      include PresenterHelper

      def index
        query = sessions_query
        sessions = query
          .call
          .eager_load(:hospital_unit, :patient, :signed_on_by, :signed_off_by)
          .page(page)
          .per(per_page || 15)
        authorize sessions
        presenter = CollectionPresenter.new(sessions, SessionPresenter, view_context)
        @q = query.search
        render :index, locals: { patient: hd_patient, sessions: presenter }
      end

      def show
        session = find_session
        authorize session
        presenter = SessionPresenter.new(session, view_context)
        render :show, locals: { session: presenter, patient: hd_patient }
      end

      def new
        session = SessionFactory.new(
          patient: hd_patient,
          user: current_user,
          type: params[:type]
        ).build

        authorize session
        render :new, locals: locals(session)
      end

      def create
        save_session
      end

      def edit
        session = find_session
        authorize session
        session.duration_form = Sessions::DurationForm.duration_form_for(session)
        authorize session
        render :edit, locals: locals(session)
      rescue Pundit::NotAuthorizedError
        flash[:warning] = t(".session_is_immutable")
        redirect_to patient_hd_session_path(session, patient_id: hd_patient)
      end

      def update
        save_session
      end

      def destroy
        session = find_session
        authorize session
        session.destroy!
        regenerate_rolling_hd_statistics
        message = success_msg_for("HD session")
        redirect_to patient_hd_dashboard_path(hd_patient), notice: message
      end

      def save_session
        authorize HD::Session::Closed, :"#{action_name}?"
        command = Sessions::SaveSession.new(patient: hd_patient, current_user: current_user)
        command.subscribe(self)
        command.call(params: session_params,
                     id: params[:id],
                     signing_off: params[:signoff].present?)
      end

      def save_success(_session)
        url = patient_hd_dashboard_path(hd_patient)
        message = success_msg_for("HD session")
        redirect_to url, notice: message
      end

      def save_failure(session)
        flash.now[:error] = failed_msg_for("HD session")
        action = action_name.to_sym == :create ? :new : :edit
        render action, locals: locals(session)
      end

      protected

      def find_session
        Session.for_patient(hd_patient).find(params[:id])
      end

      def locals(session)
        {
          session: session,
          patient: hd_patient
        }
      end

      def sessions_query
        Sessions::PatientQuery.new(patient: hd_patient, q: params[:q])
      end

      def session_params
        @session_params ||= begin
          params.require(:hd_session).require(:type)
          params.require(:hd_session)
                        .permit(attributes)
                        .merge(document: document_attributes, by: current_user)
        end
      end

      def attributes
        [
          :hospital_unit_id, :notes, :dialysate_id,
          :signed_on_by_id, :signed_off_by_id, :type, :hd_station_id,
          duration_form: [:start_date, :start_time, :end_time, :overnight_dialysis],
          document: []
        ]
      end

      def document_attributes
        params
          .require(:hd_session)
          .fetch(:document, nil)
          .try(:permit!)
      end

      def regenerate_rolling_hd_statistics
        Delayed::Job.enqueue UpdateRollingPatientStatisticsDjJob.new(hd_patient.id)
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
