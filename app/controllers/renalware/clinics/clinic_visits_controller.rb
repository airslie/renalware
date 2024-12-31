module Renalware
  module Clinics
    class ClinicVisitsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include Pagy::Backend

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

      def create
        authorize ClinicVisit, :create?
        result = CreateClinicVisit.call(clinics_patient, visit_params)
        visit = result.object.clinic_visit
        appointment = result.object.appointment_to_build_from

        if result.success?
          RememberedClinicVisitPreferences.new(session).persist(visit)
          notice = success_msg_for("clinic visit")
          redirect_to patient_clinic_visits_path(clinics_patient), notice: notice
        else
          flash.now[:error] = failed_msg_for("clinic visit")
          render_new(visit, appointment)
        end
      end

      def update
        clinic_visit = find_and_authorize_visit
        if clinic_visit.update(visit_params)
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

      def render_template(template, visit, appointment = nil)
        render template, locals: {
          patient: clinics_patient,
          clinic_visit: visit,
          built_from_appointment: appointment,
          clinic_options: clinic_options_for(template)
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

      def query_params
        params.fetch(:q, {})
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
