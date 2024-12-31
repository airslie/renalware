module Renalware
  module HD
    class DialysersController < BaseController
      def index
        dialysers = Dialyser.all
        authorize dialysers
        render locals: { dialysers: dialysers }
      end

      def new
        dialyser = Dialyser.new
        authorize dialyser
        render locals: { dialyser: dialyser }
      end

      def edit
        dialyser = load_and_authorize_dialyser
        render locals: { dialyser: dialyser }
      end

      def create
        dialyser = Dialyser.new(dialyser_params)
        authorize dialyser

        if dialyser.save
          redirect_to hd_dialysers_path, notice: success_msg_for("dialyser")
        else
          flash.now[:error] = failed_msg_for("dialyser")
          render :new, locals: { dialyser: dialyser }
        end
      end

      def update
        dialyser = load_and_authorize_dialyser
        if dialyser.update(dialyser_params)
          redirect_to hd_dialysers_path, notice: success_msg_for("dialyser")
        else
          flash.now[:error] = failed_msg_for("dialyser")
          render :edit, locals: { dialyser: dialyser }
        end
      end

      def destroy
        dialyser = load_and_authorize_dialyser
        dialyser.destroy
        redirect_to hd_dialysers_path, notice: success_msg_for("dialyser")
      end

      private

      def dialyser_params
        params
          .require(:hd_dialyser)
          .permit(:group, :name, :membrane_surface_area, :membrane_surface_area_coefficient_k0a)
      end

      def load_and_authorize_dialyser
        dialyser = Dialyser.find(params[:id])
        authorize dialyser
        dialyser
      end
    end
  end
end
