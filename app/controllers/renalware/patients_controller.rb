require_dependency "renalware/patients"

module Renalware
  class PatientsController < BaseController
    include PresenterHelper
    include Renalware::Concerns::Pageable

    def index
      patients = patient_search.result.page(page).per(per_page)
      authorize patients
      render locals: {
        patients: present(patients, PatientPresenter)
      }
    end

    def search
      skip_authorization
      query = Patients::SearchQuery.new(term: params[:term])
      render json: query.call.to_json
    end

    def new
      patient = Patient.new
      authorize patient
      render locals: { patient: patient }
    end

    def create
      patient = Patient.new(patient_params)
      authorize patient

      if patient.save
        # Reload in order to let pg generate the secure id
        redirect_to_patient_demographics(patient.reload)
      else
        flash[:error] = failed_msg_for("patient")
        render :new, locals: { patient: patient }
      end
    end

    def edit
      authorize patient
      render locals: { patient: patient }
    end

    def update
      authorize patient
      if patient.update(patient_params)
        redirect_to_patient_demographics(patient)
      else
        flash[:error] = t(".failed", model_name: "patient")
        render :edit, locals: { patient: patient }
      end
    end

    def show
      authorize patient
      render locals: { patient: patient }
    end

    def patient
      @patient ||= Renalware::Patient.find_by!(secure_id: params[:id])
    end

    private

    def patient_params
      params
        .require(:patient)
        .permit(patient_attributes)
        .merge(document: document_attributes)
        .merge(by: current_user)
    end

    # rubocop:disable Metrics/MethodLength
    def patient_attributes
      [
        :nhs_number, :family_name, :given_name, :sex,
        :ethnicity_id, :born_on, :paediatric_patient_indicator, :cc_on_all_letters,
        :title, :suffix, :marital_status, :telephone1, :telephone2, :email, :religion_id,
        :language_id, :cc_decision_on,
        :local_patient_id, :local_patient_id_2, :local_patient_id_3,
        :local_patient_id_4, :local_patient_id_5, :external_patient_id,
        :send_to_renalreg, :send_to_rpv, :renalreg_decision_on, :rpv_decision_on,
        :renalreg_recorded_by, :rpv_recorded_by,
        current_address_attributes: address_params
      ]
    end
    # rubocop:enable Metrics/MethodLength

    def address_params
      [:id, :name, :organisation_name, :street_1, :street_2, :county, :country,
        :city, :postcode, :telephone, :email]
    end

    def document_attributes
      params
        .require(:patient)
        .fetch(:document, nil)
        .try(:permit!)
    end

    def redirect_to_patient_demographics(patient)
      redirect_to patient, notice: success_msg_for("patient")
    end
  end
end
