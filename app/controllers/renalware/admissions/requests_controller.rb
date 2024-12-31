module Renalware
  module Admissions
    class RequestsController < BaseController
      include Pagy::Backend

      def index
        requests = Request
          .ordered
          .includes(:patient, :reason, :created_by, :updated_by, :hospital_unit)
          .all
        pagy, requests = pagy(requests)
        authorize requests
        render locals: { requests: requests, pagy: pagy }
      end

      def new
        request = Request.new(patient: patient)
        authorize request
        render_new(request)
      end

      def edit
        request = find_request
        authorize request
        render_edit(request)
      end

      def create
        request = Request.new(request_params)
        authorize request
        unless request.save_by(current_user)
          return render_new(request)
        end

        flash.now[:notice] = success_msg_for("admission request")
      end

      def update
        request = find_request
        authorize request
        request.by = current_user

        if request.update(request_params)
          flash.now[:notice] = success_msg_for("admission request")
          render locals: { request: request }
        else
          render_edit(request)
        end
      end

      def destroy
        request = find_request
        authorize request
        request.destroy!
        flash.now[:notice] = success_msg_for("admission request")
        render locals: { request_id: request_id }
      end

      def sort
        authorize Request, :sort?
        ids = params["admissions_request"]
        Request.sort(ids)
        render json: ids
      end

      private

      def patient
        Patient.find(params[:patient_id])
      end

      def render_new(request)
        render :new, locals: {
          request: request,
          reasons: RequestReason.ordered.pluck(:description, :id),
          hospital_units: Hospitals::Unit.ordered.pluck(:name, :id)
        }, layout: false
      end

      def render_edit(request)
        render :edit, locals: {
          request: request,
          reasons: RequestReason.ordered.pluck(:description, :id),
          hospital_units: Hospitals::Unit.ordered.pluck(:name, :id)
        }, layout: false
      end

      def find_request
        Request.find(request_id)
      end

      def request_id
        params[:id]
      end

      def request_params
        params
          .require(:admissions_request)
          .permit(:patient_id, :reason_id, :notes, :hospital_unit_id, :priority)
      end
    end
  end
end
