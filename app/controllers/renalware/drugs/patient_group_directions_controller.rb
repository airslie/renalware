module Renalware
  module Drugs
    class PatientGroupDirectionsController < BaseController
      include Pagy::Backend

      def index
        pagy, directions = pagy(PatientGroupDirection.ordered)
        authorize directions
        render locals: { directions: directions, pagy: pagy }
      end

      def new
        pgd = PatientGroupDirection.new
        authorize pgd
        render_new(pgd)
      end

      def create
        pgd = PatientGroupDirection.new(pgd_params)
        authorize pgd
        if pgd.save
          redirect_to drugs_patient_group_directions_path
        else
          flash.now[:error] = failed_msg_for("body composition")
          render_new(pgd)
        end
      end

      def edit
        render_edit(find_and_auth_pgd)
      end

      def update
        pgd = find_and_auth_pgd
        if pgd.update(pgd_params)
          redirect_to drugs_patient_group_directions_path
        else
          flash.now[:error] = failed_msg_for("body composition")
          render_edit(pgd)
        end
      end

      def destroy
        find_and_auth_pgd.destroy
        redirect_to drugs_patient_group_directions_path
      end

      private

      def render_new(pgd) = render :new, locals: { pgd: pgd }
      def render_edit(pgd) = render :edit, locals: { pgd: pgd }
      def find_and_auth_pgd = PatientGroupDirection.find(params[:id]).tap { |pgd| authorize pgd }

      def pgd_params
        params
          .require(:pgd)
          .permit(:name, :code, :starts_on, :ends_on)
      end
    end
  end
end
