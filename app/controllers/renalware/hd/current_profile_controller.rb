module Renalware
  module HD
    class CurrentProfileController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting
      before_action :load_profile

      def show
        render :show, locals: locals
      end

      def edit
        render :edit, locals: locals
      end

      def update
        if update_profile
          redirect_to patient_hd_dashboard_path(hd_patient),
                      notice: success_msg_for("HD profile")
        else
          flash.now[:error] = failed_msg_for("HD profile")
          render :edit, locals: locals
        end
      end

      private

      attr_reader :profile

      def locals
        { profile: profile_presenter, patient: hd_patient }
      end

      def update_profile
        update_named_nurse_on_patient

        if profile.persisted?
          ReviseHDProfile.new(profile).call(profile_params)
        else
          profile.update(profile_params.merge(active: true))
        end
      end

      # If for any reason the patient is invalid (perhaps they have an NHS Number that is
      # already in use so we get an NHS already taken error) we would not be able to save
      # the named nurse to the patient here, so we skip validation.
      def update_named_nurse_on_patient
        hd_patient.named_nurse_id = profile_params[:named_nurse_id]
        hd_patient.by = current_user
        hd_patient.save(validate: false)
      end

      def preference_set
        PreferenceSet.for_patient(hd_patient).first_or_initialize
      end

      def profile_presenter
        ProfilePresenter.new(profile, preference_set: preference_set)
      end

      def load_profile
        @profile = Profile
          .for_patient(hd_patient)
          .first_or_initialize
          .tap { |profile| profile.named_nurse_id = hd_patient.named_nurse_id }
          .tap { |profile| authorize(profile) }
      end

      def profile_params
        params
          .require(:hd_profile)
          .permit(attributes)
          .to_h.merge(by: current_user)
      end

      # Note that named_nurse_id is a virtual attribute allowing us to update
      # patient.named_nurse using the hd profile form.
      def attributes
        [
          :schedule_definition_id, :other_schedule, :hospital_unit_id, :dialysate_id,
          :scheduled_time, :prescribed_time, :prescribed_on, :prescriber_id,
          :named_nurse_id, :transport_decider_id, :home_machine_identifier,
          document: {}
        ]
      end
    end
  end
end
