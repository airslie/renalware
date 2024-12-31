module Renalware
  module Modalities
    class DescriptionsController < BaseController
      def index
        modality_descriptions = Description.order(code: :asc)
        authorize modality_descriptions
        render locals: { modality_descriptions: modality_descriptions }
      end

      def new
        modality_description = Description.new
        authorize modality_description
        render_new(modality_description)
      end

      def edit
        render_edit(find_and_authorize_modality_description)
      end

      def create
        modality_description = Description.new(modality_description_params)
        authorize modality_description

        if modality_description.save
          redirect_to modalities_descriptions_path,
                      notice: success_msg_for("modality description")
        else
          flash.now[:error] = failed_msg_for("modality description")
          render_new(modality_description)
        end
      end

      def update
        modality_description = find_and_authorize_modality_description
        if modality_description.update(modality_description_params)
          redirect_to modalities_descriptions_path,
                      notice: success_msg_for("modality description")
        else
          flash.now[:error] = failed_msg_for("modality description")
          render_edit(modality_description)
        end
      end

      def destroy
        authorize Description.destroy(params[:id])
        redirect_to modalities_descriptions_path,
                    notice: success_msg_for("modality description")
      end

      private

      def render_new(modality_description)
        render :new, locals: { modality_description: modality_description }
      end

      def render_edit(modality_description)
        render :edit, locals: { modality_description: modality_description }
      end

      def modality_description_params
        params
          .require(:modalities_description)
          .permit(
            :name,
            :code,
            :site,
            :hidden,
            :ignore_for_aki_alerts,
            :ignore_for_kfre
          )
      end

      def find_and_authorize_modality_description
        Description.find(params[:id]).tap do |description|
          authorize description
        end
      end
    end
  end
end
