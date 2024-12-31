module Renalware
  module HD
    class CannulationTypesController < BaseController
      def index
        cannulation_types = CannulationType.all
        authorize cannulation_types
        render locals: { cannulation_types: cannulation_types }
      end

      def new
        cannulation_type = CannulationType.new
        authorize cannulation_type
        render_new(cannulation_type)
      end

      def edit
        cannulation_type = find_and_authorize_cannulation_type
        render_edit(cannulation_type)
      end

      def create
        cannulation_type = CannulationType.new(cannulation_type_params)
        authorize cannulation_type

        if cannulation_type.save
          redirect_to hd_cannulation_types_path,
                      notice: success_msg_for("cannulation type")
        else
          flash.now[:error] = failed_msg_for("cannulation type")
          render_new(cannulation_type)
        end
      end

      def update
        cannulation_type = find_and_authorize_cannulation_type
        if cannulation_type.update(cannulation_type_params)
          redirect_to hd_cannulation_types_path,
                      notice: success_msg_for("cannulation type")
        else
          flash.now[:error] = failed_msg_for("cannulation type")
          render_edit(cannulation_type)
        end
      end

      def destroy
        authorize CannulationType.destroy(params[:id])
        redirect_to hd_cannulation_types_path,
                    notice: success_msg_for("cannulation type")
      end

      private

      def render_new(cannulation_type)
        render :new, locals: { cannulation_type: cannulation_type }
      end

      def render_edit(cannulation_type)
        render :edit, locals: { cannulation_type: cannulation_type }
      end

      def cannulation_type_params
        params.require(:hd_cannulation_type).permit(:name)
      end

      def find_and_authorize_cannulation_type
        CannulationType.find(params[:id]).tap do |cannulation_type|
          authorize cannulation_type
        end
      end
    end
  end
end
