# frozen_string_literal: true

module Renalware
  module Modalities
    class ReasonsController < BaseController
      skip_after_action :verify_authorized

      def index
        @reason_hd_pd = HaemodialysisToPD.all
        @reason_pd_hd = PDToHaemodialysis.all

        modal_change_type = params[:modal_change_type]
        type = modal_change_type ? "Renalware::Modalities::#{modal_change_type.camelize}" : nil

        @modality_reason_select = Reason.where(type: type)

        respond_to do |format|
          format.html
          format.json {
            render json: @modality_reason_select.as_json(only: [:id, :rr_code, :description])
          }
        end
      end
    end
  end
end
