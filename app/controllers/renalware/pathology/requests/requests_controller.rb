require_dependency "renalware/pathology"

module Renalware
  module Pathology
    module Requests
      class RequestsController < Pathology::BaseController
        include Renalware::Concerns::Pageable

        before_filter :load_patients, only: [:new, :create]

        def index
          requests = Request.ordered.page(@page).per(@per_page)
          authorize requests
          render :index, locals: { requests: requests }
        end

        # NOTE: This needs to be POST since params[:patient_ids] may exceed url char limit in GET
        def new
          render :new,
            layout: false,
            locals: local_vars.merge(
              all_clinics: Renalware::Clinics::Clinic.ordered,
              all_consultants: Renalware::Pathology::Consultant.ordered
            )
        end

        def create
          requests.each { |request| request.print_form }

          render pdf: "create",
            layout: false,
            locals: local_vars,
            extra: "--no-print-media-type" # NOTE: Foundation CSS does not work well in print mode
        end

        private

        def local_vars
          {
            requests: requests,
            request_html_form_params: request_html_form_params
          }
        end

        def request_html_form_params
          OpenStruct.new(
            patient_ids: raw_request_params[:patient_ids],
            clinic_id: request_params[:clinic].id,
            consultant_id: request_params[:consultant].id,
            telephone: request_params[:telephone]
          )
        end

        def requests
          RequestPresenter.present(
            Requests::RequestsFactory.new(@patients, request_params).build
          )
        end

        def request_params
          @request_params ||= Requests::RequestParamsFactory.new(raw_request_params).build
        end

        def raw_request_params
          params
            .fetch(:request, {})
            .permit(:consultant_id, :clinic_id, :telephone, patient_ids: [])
            .merge(by: current_user)
        end

        def load_patients
          patient_ids = raw_request_params[:patient_ids]
          @patients = Pathology::OrderedPatientQuery.new(patient_ids).call
          authorize Renalware::Patient
        end
      end
    end
  end
end
