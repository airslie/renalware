require "collection_presenter"

module Renalware
  module HD
    class SessionClipboardsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include PresenterHelper

      def show
        session = find_session
        authorize session
        presenter = SessionPresenter.new(session, view_context)
        render :show,
               locals: { session: presenter, patient: hd_patient },
               layout: false, content_type: "text/plain", formats: [:text]
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

      # def sessions_query
      #   Sessions::PatientQuery.new(patient: hd_patient, q: params[:q])
      # end

      # def session_params
      #   @session_params ||= begin
      #     params.require(:hd_session).require(:type)
      #     params
      #       .require(:hd_session)
      #       .permit(attributes)
      #       .merge(document: document_attributes, by: current_user)
      #   end
      # end

      # def attributes
      #   [
      #     :hospital_unit_id, :notes, :dialysate_id,
      #     :signed_on_by_id, :signed_off_by_id, :type, :hd_station_id,
      #     duration_form: [:start_date, :start_time, :end_time, :overnight_dialysis],
      #     patient_group_direction_ids: [], document: []
      #   ]
      # end

      # def document_attributes
      #   params
      #     .require(:hd_session)
      #     .fetch(:document, nil)
      #     .try(:permit!)
      # end

      # def regenerate_rolling_hd_statistics
      #   UpdateRollingPatientStatisticsJob.perform_later(hd_patient)
      # end
    end
  end
end
