module Renalware
  module Renal
    class ProfilesController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def show
        render locals: {
          patient: renal_patient,
          profile: find_and_authorize_profile
        }
      end

      def edit
        render_edit(find_and_authorize_profile)
      end

      def update
        profile = find_and_authorize_profile

        if profile.update(profile_params)
          redirect_to patient_renal_profile_path(renal_patient),
                      notice: success_msg_for("profile")
        else
          render_edit(profile)
        end
      end

      private

      def render_edit(profile)
        render :edit, locals: { patient: renal_patient, profile: profile }
      end

      def profile_params
        params
          .require(:renal_profile)
          .permit(
            :esrf_on, :first_seen_on, :prd_description_id, :weight_at_esrf,
            :modality_at_esrf, :comorbidities_updated_on,
            address_at_diagnosis_attributes: address_params, document: {}
          )
      end

      def address_params
        [
          :id, :name, :organisation_name, :street_1, :street_2, :street_3, :county, :country_id,
          :town, :postcode, :telephone, :email
        ]
      end

      def find_and_authorize_profile
        (renal_patient.profile || renal_patient.build_profile).tap { |profile| authorize profile }
      end
    end
  end
end
