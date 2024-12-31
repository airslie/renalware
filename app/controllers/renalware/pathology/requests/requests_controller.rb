module Renalware
  module Pathology
    module Requests
      class RequestsController < BaseController
        include Renalware::Concerns::Pageable

        before_action :load_patients, only: %i(new create)

        def index
          requests_query = RequestQuery.new(query_params)
          requests = requests_query.call.page(page).per(per_page)
          authorize requests

          render :index, locals: { requests: requests, query: requests_query.search }
        end

        # Displays an historical PDF
        def show
          request = RequestPresenter.new(
            Request.find(params[:id])
          )
          authorize request
          render_with_wicked_pdf(
            pdf: "show",
            page_size: "A4",
            layout: "renalware/layouts/pdf",
            locals: { request: request },
            show_as_html: params.key?(:debug),
            extra: "--no-print-media-type" # NOTE: Foundation CSS does not work well in print mode
          )
        end

        # HTML POST
        # NOTE: This needs to be POST since params[:patient_ids] may exceed url char limit in GET
        def new
          render(
            :new,
            locals: local_vars.merge(
              all_clinics: Renalware::Pathology::Clinic.for_algorithm,
              all_consultants: Renalware::Clinics::Consultant.ordered,
              all_templates: Renalware::Pathology::Requests::Request::TEMPLATES
            )
          )
        end

        # PDF POST
        # Displays multiple PDFs
        def create
          requests.each(&:print_form)

          render_with_wicked_pdf(
            pdf: "create",
            page_size: "A4",
            layout: "renalware/layouts/pdf",
            locals: local_vars,
            extra: "--no-print-media-type" # NOTE: Foundation CSS does not work well in print mode
          )
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
            clinic_id: request_params[:clinic]&.id,
            consultant_id: request_params[:consultant]&.id,
            telephone: request_params[:telephone],
            template: request_params[:template]
          )
        end

        def requests
          @requests ||= RequestPresenter.present(
            Requests::RequestsFactory.new(@patients, request_params).build
          )
        end

        def request_params
          @request_params ||= Requests::RequestParamsFactory.new(raw_request_params).build
        end

        def raw_request_params
          params
            .fetch(:request, {})
            .permit(:consultant_id, :clinic_id, :telephone, :template, patient_ids: [])
            .merge(by: current_user)
        end

        def load_patients
          patient_ids = raw_request_params[:patient_ids]

          @patients =
            Pathology::OrderedPatientQuery
              .new(patient_ids)
              .call
              .includes(:current_observation_set, :rules)
          authorize Renalware::Patient
        end

        def query_params
          params.fetch(:q, {})
        end
      end
    end
  end
end
