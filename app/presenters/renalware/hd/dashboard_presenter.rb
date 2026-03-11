module Renalware
  module HD
    class DashboardPresenter
      attr_accessor :patient

      delegate :has_ever_been_on_hd?, to: :patient

      def initialize(patient, view_context, current_user)
        @patient = patient
        @view_context = view_context
        @current_user = current_user
      end

      def preference_set
        @preference_set ||= PreferenceSet.for_patient(patient).first_or_initialize
      end

      def profile
        @profile ||= begin
          ProfilePresenter.new(Profile.for_patient(patient).first_or_initialize)
        end
      end

      def historical_profiles
        @historical_profiles ||= begin
          Profile
            .deleted
            .ordered
            .limit(3)
            .for_patient(patient).map { |prof| ProfilePresenter.new(prof) }
        end
      end

      def historical_profile_count
        @historical_profile_count ||= Profile.deleted.for_patient(patient).count
      end

      def access
        @access ||= begin
          access_profile = Renalware::Accesses.cast_patient(patient).current_profile
          Accesses::ProfilePresenter.new(access_profile)
        end
      end

      # rubocop:disable Metrics/MethodLength
      def sessions
        @sessions ||= begin
          hd_sessions = Session
            .eager_load(
              :hospital_unit,
              :patient,
              :station,
              :signed_on_by,
              :signed_off_by
            )
            .for_patient(patient)
            .limit(10).ordered
          CollectionPresenter.new(hd_sessions, SessionPresenter, view_context)
        end
      end
      # rubocop:enable Metrics/MethodLength

      def sessions_total_count
        @sessions_total_count ||= Session.for_patient(patient).count
      end

      def sessions_summary
        recent_activity_summary(displayed: sessions.size, total: sessions_total_count)
      end

      def prescription_administrations
        @prescription_administrations ||= begin
          prescription_administrations_scope.limit(10)
        end
      end

      def prescription_administrations_total_count
        @prescription_administrations_total_count ||= prescription_administrations_scope.count
      end

      def prescription_administrations_summary
        recent_activity_summary(
          displayed: prescription_administrations.size,
          total: prescription_administrations_total_count
        )
      end

      def pgds
        @pgds ||= begin
          pgds_scope.limit(10)
        end
      end

      def pgds_total_count
        @pgds_total_count ||= pgds_scope.count
      end

      def pgds_summary
        recent_activity_summary(displayed: pgds.size, total: pgds_total_count)
      end

      def can_add_hd_profile?
        profile.new_record? && policy_for(profile).edit? && has_ever_been_on_hd?
      end

      def can_add_preference_set?
        preference_set.new_record? && policy_for(preference_set).new? && has_ever_been_on_hd?
      end

      # Its possible to add an Access Profile even if the patient does not have the HD modality.
      def can_add_access_profile?
        access.nil? && policy_for(Renalware::Accesses::Profile).new?
      end

      def can_add_session?
        policy_for(Renalware::HD::Session::Open).new? && has_ever_been_on_hd?
      end

      def can_add_dna_session?
        policy_for(Renalware::HD::Session::DNA).new? && has_ever_been_on_hd?
      end

      private

      def policy_for(thing)
        Pundit.policy!(current_user, thing)
      end

      def pgds_scope
        @pgds_scope ||= SessionPatientGroupDirectionsQuery.new(patient:).call
      end

      def prescription_administrations_scope
        @prescription_administrations_scope ||= patient
          .prescription_administrations
          .includes(
            [
              :administered_by,
              :witnessed_by,
              :reason,
              prescription: [:medication_route, :drug]
            ]
          )
          .ordered
      end

      def recent_activity_summary(displayed:, total:)
        I18n.t("renalware.hd.dashboards.recent_activity.summary", displayed:, total:)
      end

      attr_accessor :view_context, :current_user
    end
  end
end
