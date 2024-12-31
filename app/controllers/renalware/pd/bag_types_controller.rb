module Renalware
  module PD
    class BagTypesController < BaseController
      def index
        bag_types = BagType.ordered
        authorize bag_types
        render locals: { bag_types: bag_types }
      end

      def new
        bag_type = BagType.new
        authorize bag_type
        render locals: { bag_type: bag_type }
      end

      def edit
        render locals: { bag_type: load_and_authorize_bag_type }
      end

      def create
        bag_type = BagType.new(bag_type_params)
        authorize bag_type

        if bag_type.save
          redirect_to pd_bag_types_path,
                      notice: success_msg_for("bag type")
        else
          flash.now[:error] = failed_msg_for("bag type")
          render :new, locals: { bag_type: bag_type }
        end
      end

      def update
        bag_type = load_and_authorize_bag_type
        if bag_type.update(bag_type_params)
          redirect_to pd_bag_types_path,
                      notice: success_msg_for("bag type")
        else
          flash.now[:error] = failed_msg_for("bag type")
          render :edit, locals: { bag_type: bag_type }
        end
      end

      def destroy
        bag_type = load_and_authorize_bag_type
        bag_type.destroy!
        redirect_to pd_bag_types_path, notice: success_msg_for("bag type")
      end

      private

      def bag_type_params
        params
          .require(:pd_bag_type)
          .permit(
            :manufacturer, :description, :glucose_content, :glucose_strength, :amino_acid,
            :icodextrin, :low_glucose_degradation, :low_sodium, :sodium_content,
            :lactate_content, :bicarbonate_content, :calcium_content, :magnesium_content
          )
      end

      def load_and_authorize_bag_type
        bag_type = BagType.find(params[:id])
        authorize bag_type
        bag_type
      end
    end
  end
end
