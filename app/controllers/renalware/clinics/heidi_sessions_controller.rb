module Renalware
  module Clinics
    class HeidiSessionsController < BaseController
      include Renalware::Concerns::HeidiFeatureGate
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        clinic_visit = find_and_authorize_visit
        session = latest_heidi_session(clinic_visit)

        render json: session_payload(session)
      end

      def documents
        clinic_visit = find_and_authorize_visit
        session = clinic_visit.heidi_sessions.find(params[:session_id])
        return head :unprocessable_content if session.heidi_session_id.blank?

        response.headers["Cache-Control"] = "no-store"
        documents = Heidi::SessionDocuments.new(session:).call
        render json: { documents: }
      rescue Heidi::SessionDocuments::FetchError
        render json: { error: t("renalware.heidi.refresh_failed") },
               status: :bad_gateway
      end

      private

      def find_and_authorize_visit
        clinics_patient.clinic_visits.find(params[:clinic_visit_id]).tap do |clinic_visit|
          authorize clinic_visit, :edit?
        end
      end

      def latest_heidi_session(clinic_visit)
        clinic_visit.heidi_sessions.order(created_at: :desc).first
      end

      def session_payload(session)
        return { present: false } if session.blank?

        {
          present: true,
          id: session.id,
          status: session.status,
          status_label: session.status.humanize,
          consult_note_status: session.consult_note_status.presence || "Not ready",
          consult_note: session.consult_note,
          last_synced_at: last_synced_at(session),
          synced: session.synced?
        }
      end

      def last_synced_at(session)
        session.last_synced_at.present? ? helpers.l(session.last_synced_at) : "Pending"
      end
    end
  end
end
