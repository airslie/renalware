# Note this plural resource is for managing primary_care_physicians.
# The singular resource in the same folder is for updating the patient.primary_care_physician.
module Renalware
  module Patients
    class PrimaryCarePhysiciansController < BaseController
      include Pagy::Backend

      before_action :find_primary_care_physician, only: %i(edit update)

      def index
        pagy, primary_care_physicians = pagy(
          PrimaryCarePhysician
          .order(:name)
          .includes(:address)
          .eager_load(practices: :address)
        )
        authorize primary_care_physicians
        render locals: { primary_care_physicians: primary_care_physicians, pagy: pagy }
      end

      def new
        @primary_care_physician = PrimaryCarePhysician.new
        @alternative_address = alternative_address
        authorize @primary_care_physician
      end

      def edit
        render_form(@primary_care_physician, :edit)
      end

      def create
        @primary_care_physician = PrimaryCarePhysician.new(primary_care_physician_params)
        authorize @primary_care_physician

        if @primary_care_physician.save
          redirect_to patients_primary_care_physicians_path,
                      notice: success_msg_for("primary_care_physician")
        else
          @alternative_address = alternative_address
          flash.now[:error] = failed_msg_for("primary_care_physician")
          render :new
        end
      end

      def update
        if @primary_care_physician.update(primary_care_physician_params)
          update_primary_care_physician_successful(@primary_care_physician)
        else
          update_primary_care_physician_failed(@primary_care_physician)
        end
      end

      def destroy
        authorize PrimaryCarePhysician.destroy(params[:id])

        redirect_to patients_primary_care_physicians_path,
                    notice: success_msg_for("primary_care_physician")
      end

      private

      def find_primary_care_physician
        @primary_care_physician = PrimaryCarePhysician.find_or_initialize_by(id: params[:id])
        authorize @primary_care_physician
      end

      def update_primary_care_physician_successful(_primary_care_physician)
        redirect_to_primary_care_physicians_list
      end

      def update_primary_care_physician_failed(primary_care_physician)
        flash.now[:error] = failed_msg_for("primary_care_physician")
        render_form(primary_care_physician, :edit)
      end

      def redirect_to_primary_care_physicians_list
        redirect_to patients_primary_care_physicians_path,
                    notice: success_msg_for("primary_care_physician")
      end

      def render_form(primary_care_physician, action)
        @primary_care_physician = primary_care_physician
        @alternative_address = alternative_address
        render action
      end

      def primary_care_physician_params
        params.require(:patients_primary_care_physician).permit(
          :name, :practitioner_type, :code, :telephone,
          practice_ids: [],
          address_attributes: %i(
            id name organisation_name street_1 street_2 street_3 town county
            postcode country_id telephone
          )
        )
      end

      def alternative_address
        @primary_care_physician.address || @primary_care_physician.build_address
      end
    end
  end
end
