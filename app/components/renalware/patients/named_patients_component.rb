module Renalware
  module Patients
    class NamedPatientsComponent < ApplicationComponent
      include ApplicationHelper
      include Pagy::Backend
      include Pagy::Frontend

      delegate :default_patient_link, to: :helpers
      pattr_initialize [:current_user!]

      def render?
        Renalware.config.user_dashboard_display_named_patients && patients.count > 0
      end

      def pagination
        load_patients unless @pagination
        @pagination
      end

      def patients
        load_patients unless @patients
        @patients
      end

      def formatted_title(title)
        if pagination.limit < pagination.count
          "#{title} (#{pagination.limit} of #{pagination.count})"
        else
          "#{title} (#{pagination.count})"
        end
      end

      class RowPresenter < SimpleDelegator
        pattr_initialize :patient
        delegate :hgb_result, :cre_result, to: :current_observations
        delegate :access_profile_started_on, :access_profile_type, to: :access_patient
        delegate :dialysing_at_unit, to: :hd_patient
        delegate_missing_to :patient
        delegate :to_s, :to_param, to: :patient

        def access_patient
          Renalware::Accesses::PatientPresenter.new(patient)
        end

        def hd_patient
          Renalware::HD::PatientPresenter.new(patient)
        end

        def current_observations
          Renalware::Pathology::ObservationSetPresenter.new(patient.current_observation_set)
        end

        def most_recent_clinic_visit
          Renalware::Clinics.cast_patient(patient).most_recent_clinic_visit
        end
      end

      def each_row
        patients.each { |patient| yield RowPresenter.new(patient) }
      end

      private

      def load_patients
        @pagination, @patients = pagy(scope, items: 10, anchor_string: "data-remote='true'")
      end

      def scope
        Patient
          .merge(Accesses::Patient.with_current_plan)
          .merge(Accesses::Patient.with_profile)
          .merge(HD::Patient.with_profile)
          .include(PatientPathologyScopes)
          .with_current_pathology
          .includes(current_modality: :description)
          .where(named_nurse: current_user)
          .order(updated_at: :desc)
      end
    end
  end
end
