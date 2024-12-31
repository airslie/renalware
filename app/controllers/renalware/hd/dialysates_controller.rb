module Renalware
  module HD
    class DialysatesController < BaseController
      def index
        dialysates = Dialysate.all
        authorize dialysates
        render locals: { dialysates: dialysates }
      end

      def new
        dialysate = Dialysate.new
        authorize dialysate
        render_new(dialysate)
      end

      def edit
        render_edit(find_and_authorize_dialysate)
      end

      def create
        dialysate = Dialysate.new(dialysate_params)
        authorize dialysate

        if dialysate.save
          redirect_to hd_dialysates_path, notice: success_msg_for("dialysate")
        else
          flash.now[:error] = failed_msg_for("dialysate")
          render_new(dialysate)
        end
      end

      def update
        dialysate = find_and_authorize_dialysate
        if dialysate.update(dialysate_params)
          redirect_to hd_dialysates_path, notice: success_msg_for("dialysate")
        else
          flash.now[:error] = failed_msg_for("dialysate")
          render_edit(dialysate)
        end
      end

      def destroy
        find_and_authorize_dialysate.destroy!
        redirect_to hd_dialysates_path, notice: success_msg_for("dialysate")
      end

      private

      def render_new(dialysate)
        render :new, locals: { dialysate: dialysate }
      end

      def render_edit(dialysate)
        render :edit, locals: { dialysate: dialysate }
      end

      def find_and_authorize_dialysate
        Dialysate.find(params[:id]).tap { |dialysate| authorize(dialysate) }
      end

      def dialysate_params
        params
          .require(:dialysate)
          .permit(
            :name, :description,
            :sodium_content, :sodium_content_uom,
            :bicarbonate_content, :bicarbonate_content_uom,
            :calcium_content, :calcium_content_uom,
            :potassium_content, :potassium_content_uom
          )
      end
    end
  end
end
