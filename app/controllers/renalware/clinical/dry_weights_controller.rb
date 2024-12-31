require "collection_presenter"

module Renalware
  module Clinical
    class DryWeightsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include Pagy::Backend

      def index
        authorize DryWeight, :index?
        query = PatientDryWeightsQuery.new(patient: clinical_patient, search_params: params[:q])
        pagy, dry_weights = pagy(query.call)

        render locals: {
          search: query.search,
          dry_weights: CollectionPresenter.new(dry_weights, DryWeightPresenter),
          patient: clinical_patient,
          pagy: pagy
        }
      end

      def show
        dry_weight = DryWeight.for_patient(clinical_patient).find(params[:id])
        authorize dry_weight
        @dry_weight = DryWeightPresenter.new(dry_weight)
      end

      def new
        save_path_to_return_to
        dry_weight = DryWeight.new(
          patient: clinical_patient,
          assessor: current_user,
          assessed_on: Time.zone.today
        )
        authorize dry_weight
        render_new(dry_weight)
      end

      def create
        dry_weight = DryWeight.new(patient: clinical_patient)
        dry_weight.attributes = dry_weight_params
        authorize dry_weight

        if dry_weight.save
          redirect_to return_url, notice: success_msg_for("dry weight")
          session.delete(:return_to)
        else
          flash.now[:error] = failed_msg_for("dry weight")
          render_new(dry_weight)
        end
      end

      protected

      def save_path_to_return_to
        return unless request.format == :html

        session[:return_to] ||= request.referer
      end

      def return_url
        @return_url ||= begin
          path = session[:return_to]
          path = nil if path == new_patient_clinical_dry_weight_path(clinical_patient)
          path || patient_clinical_profile_path(clinical_patient)
        end
      end
      helper_method :return_url

      def render_new(dry_weight)
        render :new, locals: {
          dry_weight: dry_weight,
          patient: clinical_patient
        }
      end

      def dry_weight_params
        params
          .require(:clinical_dry_weight)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        %i(assessed_on weight minimum_weight maximum_weight assessor_id)
      end
    end
  end
end
