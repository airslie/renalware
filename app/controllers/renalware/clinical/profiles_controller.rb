module Renalware
  module Clinical
    # Note that there is no concrete Clinical::Profile, most data here is persisted in the patient
    class ProfilesController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def show
        authorize clinical_patient
        render locals: {
          patient: clinical_patient,
          profile: Clinical::ProfilePresenter.new(patient: clinical_patient, params: params)
        }
      end

      def edit
        authorize clinical_patient
        render locals: { patient: clinical_patient }
      end

      def update
        authorize clinical_patient
        if update_patient
          redirect_to patient_clinical_profile_path(clinical_patient),
                      notice: success_msg_for("clinical history")
        else
          render :edit, locals: { patient: clinical_patient }
        end
      end

      private

      def update_patient
        clinical_patient.assign_attributes(profile_params.without(:document))

        document = clinical_patient.document
        %i(diabetes history).each do |document_attribute|
          document.send(
            :"#{document_attribute}=",
            profile_params[:document][document_attribute].symbolize_keys
          )
        end
        clinical_patient.by = current_user
        clinical_patient.save!(validate: false)
      end

      def profile_params
        params
          .require(:clinical_profile)
          .permit(
            :named_consultant_id,
            :named_nurse_id,
            :hospital_centre_id,
            :preferred_death_location_id,
            :preferred_death_location_notes,
            document: {
              diabetes: %i(diagnosis diagnosed_on),
              history: %i(alcohol smoking)
            }
          ).to_h
      end
    end
  end
end
