module Renalware
  module Hospitals
    class UnitsController < BaseController
      def index
        hospital_units = Unit.includes(:hospital_centre).all
        authorize hospital_units
        render locals: { hospital_units: hospital_units }
      end

      def new
        hospital_unit = Unit.new
        authorize hospital_unit
        render_new(hospital_unit)
      end

      def edit
        render_edit(find_and_authorize_hospital_unit)
      end

      def create
        hospital_unit = Unit.new(hospital_unit_params)
        authorize hospital_unit

        if hospital_unit.save
          redirect_to hospitals.units_path, notice: success_msg_for("hospital unit")
        else
          flash.now[:error] = failed_msg_for("hospital unit")
          render_new(hospital_unit)
        end
      end

      def update
        hospital_unit = find_and_authorize_hospital_unit
        if hospital_unit.update(hospital_unit_params)
          redirect_to hospitals.units_path, notice: success_msg_for("hospital unit")
        else
          flash.now[:error] = failed_msg_for("hospital unit")
          render_edit(hospital_unit)
        end
      end

      def destroy
        hospital_unit = find_and_authorize_hospital_unit
        hospital_unit.destroy!
        redirect_to hospitals.units_path, notice: success_msg_for("hospital unit")
      end

      private

      def render_new(hospital_unit)
        render :new, locals: { hospital_unit: hospital_unit }
      end

      def render_edit(hospital_unit)
        render :edit, locals: { hospital_unit: hospital_unit }
      end

      def find_and_authorize_hospital_unit
        hospital_unit = Unit.find(params[:id])
        authorize hospital_unit
        hospital_unit
      end

      def hospital_unit_params
        params.require(:unit).permit(
          :name, :unit_code, :renal_registry_code, :unit_type, :hospital_centre_id, :is_hd_site
        )
      end
    end
  end
end
