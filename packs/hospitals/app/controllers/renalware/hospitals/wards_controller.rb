module Renalware
  module Hospitals
    class WardsController < BaseController
      def index
        authorize Ward, :index?
        wards = Ward.where(hospital_unit_id: unit.id).order(name: :asc)
        respond_to do |format|
          format.json do
            render json: wards.select(:id, :name).to_json
          end
          format.html do
            render locals: { unit: unit, wards: wards }
          end
        end
      end

      def new
        ward = unit.wards.build
        authorize ward
        render_new(ward)
      end

      def edit
        render_edit(find_an_authorise_ward)
      end

      def create
        ward = unit.wards.build(ward_params)
        authorize ward
        if ward.save
          redirect_to hospitals.unit_wards_path(unit), notice: success_msg_for(:ward)
        else
          render_new(ward)
        end
      end

      def update
        ward = find_an_authorise_ward
        if ward.update(ward_params)
          redirect_to hospitals.unit_wards_path(unit), notice: success_msg_for(:ward)
        else
          render_edit(find_an_authorise_ward)
        end
      end

      def destroy
        find_an_authorise_ward.destroy!
        redirect_to hospitals.unit_wards_path(unit), notice: success_msg_for(:ward)
      end

      private

      def render_new(ward)
        render :new, locals: { ward: ward }
      end

      def render_edit(ward)
        render :edit, locals: { ward: ward }
      end

      def unit
        @unit ||= Unit.find(params[:unit_id])
      end

      def find_an_authorise_ward
        unit.wards.find(params[:id]).tap { |ward| authorize(ward) }
      end

      def ward_params
        params.require(:ward).permit(:code, :name, :active)
      end
    end
  end
end
