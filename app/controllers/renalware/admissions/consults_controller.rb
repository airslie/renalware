require "collection_presenter"

module Renalware
  module Admissions
    class ConsultsController < BaseController
      include Pagy::Backend
      include Renalware::Concerns::PdfRenderable
      helper Hospitals::HospitalsHelper

      # rubocop:disable Metrics/AbcSize
      def index
        session[:consults_results] = nil if params.key?(:reset)
        query = ConsultQuery.new(params[:q])

        respond_to do |format|
          format.pdf do
            consults = query.call
            authorize consults
            options = default_pdf_options.merge!(
              pdf: "Admission Consults #{I18n.l(Time.zone.today)}",
              locals: {
                consults: CollectionPresenter.new(consults, ConsultPresenter),
                query: query.search
              }
            )
            render_with_wicked_pdf options
          end
          format.html do
            pagy, consults = pagy(query.call)
            authorize consults
            render locals: {
              consults: CollectionPresenter.new(consults, ConsultPresenter),
              query: query.search,
              pagy: pagy
            }
          end
        end
      end
      # rubocop:enable Metrics/AbcSize

      def new
        consult = Consult.new(started_on: Time.zone.today)
        authorize consult
        render_new(consult)
      end

      def edit
        session[:consults_results] = request&.referer # for back link
        render_edit(find_and_authorize_consult)
      end

      def create
        consult = Consult.new(consult_params)
        authorize consult
        if consult.save_by(current_user)
          redirect_to admissions_consults_path, notice: success_msg_for("consult")
        else
          render_new(consult)
        end
      end

      def update
        consult = find_and_authorize_consult
        if consult.update_by(current_user, consult_params)
          url = session[:consults_results] || admissions_consults_path
          redirect_to url, notice: success_msg_for("consult")
        else
          render_edit(consult)
        end
      end

      def destroy
        find_and_authorize_consult.update!(ended_on: Time.zone.now, by: current_user)
        redirect_back(
          fallback_location: admissions_consults_path,
          notice: success_msg_for("consult")
        )
      end

      private

      def find_and_authorize_consult
        Consult.find(params[:id]).tap do |consult|
          authorize consult
        end
      end

      def render_new(consult)
        render :new, locals: { consult: consult }
      end

      def render_edit(consult)
        render :edit, locals: { consult: consult }
      end

      def consult_params
        params
          .require(:admissions_consult)
          .permit(
            :consult_site_id, :hospital_ward_id, :patient_id, :q, :other_site_or_ward,
            :decided_on, :transferred_on, :started_on, :ended_on, :decided_on,
            :aki_risk, :transfer_priority, :priority, :seen_by_id,
            :e_alert, :consult_type, :specialty_id,
            :requires_aki_nurse, :description, :contact_number, :rrt
          )
      end

      def per_page
        params[:per_page] || 30
      end
    end
  end
end
