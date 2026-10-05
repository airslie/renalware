module Renalware
  module Clinics
    class MappingsController < BaseController
      def index
        authorize Mapping
        mappings = paginate(Mapping.includes(:clinic).order(:name_in_feed, :id))
        render locals: { mappings: }
      end

      def new
        mapping = Mapping.new
        authorize mapping
        render locals: { mapping: }
      end

      def edit
        render locals: { mapping: find_and_authorise_mapping }
      end

      def create
        mapping = Mapping.new(mapping_params)
        authorize mapping
        if mapping.save
          redirect_to clinic_mappings_path
        else
          render :new, locals: { mapping: }, status: :unprocessable_content
        end
      end

      def update
        mapping = find_and_authorise_mapping
        if mapping.update(mapping_params)
          redirect_to clinic_mappings_path
        else
          render :edit, locals: { mapping: }, status: :unprocessable_content
        end
      end

      def destroy
        find_and_authorise_mapping.destroy!
        redirect_to clinic_mappings_path, notice: success_msg_for("clinic mapping")
      end

      private

      def mapping_params
        params.require(:mapping).permit(:name_in_feed, :clinic_id, :default_clinic)
      end

      def find_and_authorise_mapping
        Mapping.find(params[:id]).tap { |mapping| authorize mapping }
      end
    end
  end
end
