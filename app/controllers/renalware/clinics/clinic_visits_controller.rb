module Renalware
  module Clinics
    class ClinicVisitsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def index
        query = VisitQuery.new(query_params, scope: clinics_patient.clinic_visits)
        pagy, visits = pagy(query.call.where(patient_id: clinics_patient.id))
        authorize visits
        render locals: {
          patient: clinics_patient,
          clinic_visits: CollectionPresenter.new(visits, ClinicVisitPresenter),
          query: query.search,
          pagy: pagy
        }
      end

      def new
        clinic_visit = build_new_clinic_visit
        authorize clinic_visit
        RememberedClinicVisitPreferences.new(session).apply_to(clinic_visit)
        render_new(clinic_visit, appointment_to_build_from)
      end

      def edit
        render_edit(find_and_authorize_visit)
      end

      def show
        render_show(find_and_authorize_visit)
      end

      def create
        authorize ClinicVisit, :create?
        result = CreateClinicVisit.call(clinics_patient, visit_params)
        visit = result.object.clinic_visit
        appointment = result.object.appointment_to_build_from

        if result.success?
          create_success(visit)
        else
          create_failure(visit, appointment)
        end
      end

      def update
        clinic_visit = find_and_authorize_visit
        if update_clinic_visit(clinic_visit)
          redirect_to patient_clinic_visits_path(clinics_patient),
                      notice: success_msg_for("clinic visit")
        else
          flash.now[:error] = failed_msg_for("clinic visit")
          render_edit(clinic_visit)
        end
      end

      def destroy
        find_and_authorize_visit.destroy
        redirect_to patient_clinic_visits_path(clinics_patient),
                    notice: success_msg_for("clinic visit")
      end

      private

      def render_new(visit, appointment)
        render_template(:new, visit, appointment)
      end

      def render_edit(visit)
        render_template(:edit, visit)
      end

      def render_show(visit)
        render :show, locals: {
          patient: clinics_patient,
          clinic_visit: visit
        }
      end

      def render_heidi_launch(visit, heidi_session)
        render :launch_heidi, locals: {
          patient: clinics_patient,
          clinic_visit: visit,
          heidi_launch_url: Renalware::Heidi::Client.launch_url_for(
            heidi_session.heidi_session_id
          ),
          edit_clinic_visit_url: edit_patient_clinic_visit_path(clinics_patient, visit)
        }
      end

      def render_heidi_launch_failure(visit, result)
        render :launch_heidi_failed, locals: {
          patient: clinics_patient,
          clinic_visit: visit,
          error: result.error,
          link_account_url: result.link_account_url,
          edit_clinic_visit_url: edit_patient_clinic_visit_path(clinics_patient, visit)
        }
      end

      def render_template(template, visit, appointment = nil)
        render template, locals: {
          patient: clinics_patient,
          clinic_visit: visit,
          built_from_appointment: appointment,
          clinic_options: clinic_options_for(template)
        }.merge(heidi_preparation_tab_locals)
      end

      def heidi_preparation_tab_locals
        {
          close_heidi_preparation_tab: launch_heidi? && request.post?
        }
      end

      def build_new_clinic_visit
        attrs = { height: last_height_measurement }
        if appointment_to_build_from.present?
          BuildVisitFromAppointment.new(appointment_to_build_from).call(attrs)
        else
          new_clinic_visit(attrs)
        end
      end

      def new_clinic_visit(initial_attrs)
        visit = clinic_visit_class.new(initial_attrs)
        visit.patient = clinics_patient
        visit.clinic = clinic
        authorize visit
        visit
      end

      def clinic
        return Clinic.find(clinic_id) if clinic_id.present?

        Clinic.new
      end

      # Passed in as an arg when refreshing inputs after clinic dropdown changed
      def clinic_id
        return visit_params[:clinic_id] if params[:clinic_visit]

        @clinic_id ||= begin
          temp_clinic_visit = ClinicVisit.new
          RememberedClinicVisitPreferences.new(session).apply_to(temp_clinic_visit)
          params[:clinic_id] || temp_clinic_visit.clinic_id
        end
      end

      def clinic_visit_class
        return ClinicVisit if clinic.visit_class_name.blank?

        clinic.visit_class_name.constantize
      end

      def last_height_measurement
        last_visit = clinics_patient.clinic_visits.order(created_at: :desc).first
        last_visit&.height
      end

      def appointment_to_build_from
        @appointment_to_build_from ||= begin
          appointment_id = params[:appointment_id]
          clinics_patient.appointments.find(appointment_id) if appointment_id.present?
        end
      end

      def visit_params
        @visit_params ||= begin
          params.require(:clinic_visit).permit(
            :date, :time, :clinic_id, :location_id, :height, :weight, :pulse, :temperature,
            :bp, :standing_bp, :urine_blood, :urine_protein, :urine_glucose, :notes,
            :admin_notes, :did_not_attend, :built_from_appointment_id, document: {}
          ).to_h.merge(by: current_user)
        end
      end

      def update_clinic_visit(clinic_visit)
        clinic_visit.with_lock do
          attrs = visit_params_with_preserved_heidi_notes(clinic_visit)
          next false unless clinic_visit.update(attrs)

          if visit_params.key?("notes")
            clinic_visit.heidi_sessions
              .where(id: superseded_heidi_session_ids, notes_superseded_at: nil)
              .update_all(notes_superseded_at: Time.current)
          end
          true
        end
      end

      def visit_params_with_preserved_heidi_notes(clinic_visit)
        attrs = visit_params.dup
        return attrs unless attrs.key?("notes")

        attrs["notes"] = notes_with_unseen_heidi_consult_notes(
          clinic_visit:,
          submitted_notes: attrs["notes"]
        )
        attrs
      end

      def notes_with_unseen_heidi_consult_notes(clinic_visit:, submitted_notes:)
        notes = submitted_notes.to_s
        unseen_heidi_consult_notes(clinic_visit).each do |consult_note|
          unless notes.include?(consult_note)
            notes = [notes.presence, consult_note].compact.join("<br>")
          end
        end
        notes
      end

      def unseen_heidi_consult_notes(clinic_visit)
        return Renalware::Heidi::Session.none unless heidi_notes_loaded_at

        clinic_visit
          .heidi_sessions
          .synced
          .where.not(id: seen_heidi_session_ids + superseded_heidi_session_ids)
          .where.not(consult_note_inserted_at: nil)
          .where(consult_note_inserted_at: heidi_notes_loaded_at..)
          .where.not(consult_note: [nil, ""])
          .order(:consult_note_inserted_at)
          .pluck(:consult_note)
      end

      def heidi_notes_loaded_at
        return @heidi_notes_loaded_at if defined?(@heidi_notes_loaded_at)

        @heidi_notes_loaded_at = Time.zone.parse(
          params.dig(:clinic_visit, :heidi_notes_loaded_at).to_s
        )
      rescue ArgumentError
        @heidi_notes_loaded_at = nil
      end

      def seen_heidi_session_ids
        params
          .dig(:clinic_visit, :seen_heidi_session_ids)
          .to_s
          .split(",")
          .filter_map { |id| Integer(id, exception: false) }
      end

      def superseded_heidi_session_ids
        params
          .dig(:clinic_visit, :superseded_heidi_session_ids)
          .to_s
          .split(",")
          .filter_map { |id| Integer(id, exception: false) }
      end

      def query_params
        params.fetch(:q, {})
      end

      def launch_heidi?
        Renalware.config.heidi_enabled && params[:launch_heidi].present?
      end

      def create_success(visit)
        RememberedClinicVisitPreferences.new(session).persist(visit)
        return launch_heidi_for(visit) if launch_heidi?

        redirect_to patient_clinic_visits_path(clinics_patient),
                    notice: success_msg_for("clinic visit")
      end

      def create_failure(visit, appointment)
        flash.now[:error] = clinic_visit_create_error
        render_new(visit, appointment)
      end

      def launch_heidi_for(visit)
        result = Renalware::Heidi::LaunchClinicVisitSession.new(
          clinic_visit: visit,
          user: current_user
        ).call
        if result.success?
          render_heidi_launch(visit, result.session)
        else
          flash.now[:alert] = t(".heidi_launch_failed", error: result.error)
          render_heidi_launch_failure(visit, result)
        end
      end

      def clinic_visit_create_error
        return failed_msg_for("clinic visit") unless launch_heidi?

        "#{failed_msg_for('clinic visit')}. Address the validation errors before launching Heidi."
      end

      def clinic_options_for(template)
        Renalware::Clinics::Clinic.order(:name).map do |clinic|
          [
            clinic.description,
            clinic.id,
            {
              data: {
                frame_url: new_or_edit_url_for_visit(template, clinic)
              }
            }
          ]
        end
      end

      def new_or_edit_url_for_visit(template, clinic)
        case template
        when :new then new_patient_clinic_visit_path(clinics_patient, clinic_id: clinic.id)
        when :edit then edit_patient_clinic_visit_path(clinics_patient, clinic_id: clinic.id)
        else raise ArgumentError("Unrecognised template #{template}")
        end
      end

      def find_and_authorize_visit
        clinics_patient.clinic_visits.find(params[:id]).tap do |visit|
          authorize visit
        end
      end
    end
  end
end
