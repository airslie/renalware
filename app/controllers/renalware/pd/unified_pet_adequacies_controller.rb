module Renalware
  module PD
    # PET and Adequacy are two distinct, discrete PD tests.
    # The function of this unified PET + Adequacy controller is to provide the functionality for
    # a user to add the data for both at the same time.
    # This is because
    # a) users tend to regard the tests as 'lumped-together' (even though they aren't), and
    # b) both tests are often done at the same time, so a unified form saves some time and effort.
    #
    # Note that we never edit a unified PET + Adequacy; as they create separate rows in the db
    # and are separate models, once created they are treated distinctly. This is mainly because
    # the processing of the tests is quite different.
    # See pet.rb and adequacy.rb for more detail.
    class UnifiedPETAdequaciesController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility
      include PresenterHelper

      # We use an active model form to present a unified model api for the view
      # to display and submit in the #new template.
      def new
        form = UnifiedPETAdequacyForm.new(
          patient: pd_patient,
          pet: PETResult.new(patient: pd_patient, performed_on: Date.current),
          adequacy: AdequacyResult.new(patient: pd_patient, performed_on: Date.current)
        )
        authorize Patient, :index?
        render locals: { form: form }
      end

      def create
        authorize Patient, :new?
        pet = PETResult.new(pet_params)
        adequacy = AdequacyResult.new(adequacy_params)
        form = build_form_object(pet, adequacy)

        if form.valid?
          form.save_by!(current_user)
          redirect_to patient_pd_dashboard_path(pd_patient)
        else
          render :new, locals: { form: form }
        end
      end

      def build_form_object(pet, adequacy)
        UnifiedPETAdequacyForm.new(
          patient: pd_patient,
          pet: pet,
          adequacy: adequacy,
          **unified_params.to_h.symbolize_keys
        )
      end

      def pet_params
        params
          .require(:patient_pd_unified_pet_adequacy)
          .require(:pet)
          .permit(
            :patient_id,
            :performed_on,
            :test_type,
            :volume_in,
            :volume_out,
            :dextrose_concentration_id,
            :infusion_time,
            :drain_time,
            :overnight_volume_in,
            :overnight_volume_out,
            :overnight_dextrose_concentration_id,
            :overnight_dwell_time
          )
      end

      def adequacy_params
        params
          .require(:patient_pd_unified_pet_adequacy)
          .require(:adequacy)
          .permit(
            :patient_id,
            :performed_on,
            :height,
            :weight,
            :dial_24_vol_in,
            :dial_24_vol_out,
            :dial_24_missing,
            :urine_24_vol,
            :urine_24_missing
          )
      end

      def unified_params
        params
          .require(:patient_pd_unified_pet_adequacy)
          .permit(:adequacy_missing, :pet_missing)
      end
    end
  end
end
