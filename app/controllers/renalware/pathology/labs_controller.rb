module Renalware
  module Pathology
    class LabsController < BaseController
      def index
        labs = Lab.order(:name)
        authorize labs, :index?
        render locals: { labs: labs }
      end

      def new
        lab = Lab.new
        authorize lab
        render locals: { lab: lab }
      end

      def edit
        render locals: { lab: find_authorize_lab }
      end

      def create
        lab = Lab.new(lab_params)
        authorize lab
        if lab.save
          redirect_to pathology_labs_path
        else
          render "new", locals: { lab: lab }
        end
      end

      def update
        lab = find_authorize_lab
        if lab.update(lab_params)
          redirect_to pathology_labs_path, notice: "Lab saved"
        else
          render :edit, locals: { lab: lab }
        end
      end

      private

      def find_authorize_lab
        Lab.find(params[:id]).tap { |lab| authorize lab }
      end

      def lab_params
        params
          .require(:lab)
          .permit(:name)
      end
    end
  end
end
