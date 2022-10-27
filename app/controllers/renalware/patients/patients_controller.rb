# frozen_string_literal: true

module Renalware
  module Patients
    class PatientsController < Renalware::BaseController
      include PresenterHelper
      include Renalware::Concerns::Pageable
      include Renalware::Concerns::PatientVisibility

      def index
        sort = params.dig(:q, :s)
        patient_search.sorts = sort if sort
        patients = patient_search.result.page(page).per(per_page)
        authorize patients
        render locals: {
          search: patient_search,
          patients: present(patients, PatientPresenter)
        }
      end

      def search
        skip_authorization
        query = Patients::SearchQuery.new(term: params[:term], scope: patient_scope)
        patients = query.call.page(page).per(per_page)
        render json: simplify(patients).to_json
      end

      def new
        patient = patient_scope.new.tap(&:build_current_address)

        patient.hospital_centre = Renalware::Hospitals::Centre.host_site.default.ordered.first

        authorize patient
        render locals: { patient: patient }
      end

      def create
        patient = patient_scope.new(patient_params)
        authorize patient

        if patient.save_by(current_user)
          # Reload in order to let pg generate the secure id
          redirect_to_patient_demographics(patient.reload)
        else
          flash.now[:error] = failed_msg_for("patient")
          render :new, locals: { patient: patient }
        end
      end

      def edit
        authorize patient
        render locals: { patient: patient }
      end

      def update
        authorize patient
        if patient.update_by(current_user, patient_params)
          redirect_to_patient_demographics(patient)
        else
          flash.now[:error] = failed_msg_for("patient")
          render :edit, locals: { patient: patient }
        end
      end

      def show
        authorize patient
        render locals: { patient: patient }
      end

      # This differs from the base controller implementation becuase we are looking
      # up by id not patient_id
      def patient
        @patient ||= begin
          patient_scope.find_by(secure_id: params[:id]).tap do |patient_|
            raise PatientNotFoundError unless patient_
          end
        end
      end

      private

      def simplify(patients)
        patients.map do |patient|
          {
            id: patient.id,
            text: patient.to_s(:long)
          }
        end
      end

      def patient_params
        params.require(:patient).permit(patient_attributes)
      end

      def patient_attributes
        [
          :nhs_number, :family_name, :given_name, :sex, :country_of_birth_id,
          :ethnicity_id, :born_on, :paediatric_patient_indicator, :cc_on_all_letters,
          :title, :suffix, :marital_status, :telephone1, :telephone2, :email, :religion_id,
          :language_id, :cc_decision_on, :next_of_kin,
          :local_patient_id, :local_patient_id_2, :local_patient_id_3,
          :local_patient_id_4, :local_patient_id_5, :external_patient_id,
          :send_to_renalreg, :send_to_rpv, :renalreg_decision_on, :rpv_decision_on,
          :renalreg_recorded_by, :rpv_recorded_by, :hospital_centre_id,
          current_address_attributes: address_params,
          document: {}
        ]
      end

      def address_params
        [
          :id, :name, :organisation_name, :street_1, :street_2, :street_3, :county, :country_id,
          :town, :postcode, :telephone, :email
        ]
      end

      def redirect_to_patient_demographics(patient)
        redirect_to patient, notice: success_msg_for("patient")
      end
    end
  end
end
