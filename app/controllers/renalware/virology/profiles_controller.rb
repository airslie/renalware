module Renalware
  module Virology
    class ProfilesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def edit
        render_edit(profile: find_profile_and_authorize_profile)
      end

      def update
        profile = find_profile_and_authorize_profile
        if update_profile(profile)
          redirect_to patient_virology_dashboard_path(virology_patient)
        else
          render_edit(profile: profile)
        end
      end

      private

      def find_profile_and_authorize_profile
        (virology_patient.profile || virology_patient.build_profile)
          .tap { |profile| authorize profile }
      end

      def render_edit(profile:)
        render :edit, locals: { patient: virology_patient, profile: profile }
      end

      def update_profile(profile)
        document = profile.document
        document.hiv = year_date_diagnosis_for(:hiv)
        document.hepatitis_b = year_date_diagnosis_for(:hepatitis_b)
        document.hepatitis_b_core_antibody = year_date_diagnosis_for(:hepatitis_b_core_antibody)
        document.hepatitis_c = year_date_diagnosis_for(:hepatitis_c)
        document.htlv = year_date_diagnosis_for(:htlv)
        profile.save_by(current_user)
      end

      def year_date_diagnosis_for(condition)
        document_params = profile_params[:document]
        YearDatedDiagnosis.new(document_params[condition])
      end

      def profile_params
        params.require(:virology_profile).permit(document: {})
      end
    end
  end
end
