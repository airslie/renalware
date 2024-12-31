module Renalware
  module HD
    module Sessions
      # A generic service object which saves a (new or existing) HD::Session of any (STI) type.
      class SaveSession
        include Wisper::Publisher
        attr_reader :patient, :params, :current_user, :session_type

        def initialize(patient:, current_user:)
          @patient = patient
          @current_user = current_user
        end

        # Note that in the event of a #save failure due to a validation error,
        # we must revert the session's :type to the original
        # in case they want to save the session as another type i.e. they tried to save as
        # Closed (sign-off) but next time they want to save as Open (not signed off)
        # - so we need make sure the hidden :type form value is not rendered as :closed
        # This is getting a bit confusing and might need some refactoring, for example by
        # driving the :type to save using the button name on the form
        def call(params:, id: nil, signing_off: false)
          @params = parse_params(params)
          session = find_or_build_session(id)
          # session.duration_form = Sessions::DurationForm.duration_form_for(session)

          session = update_session_attributes(session, signing_off)
          duration_form = Sessions::DurationForm.new(params[:duration_form])
          duration_form.require_all_fields = signing_off
          session.duration_form = duration_form
          session.started_at = session.duration_form.started_at
          session.stopped_at = session.duration_form.stopped_at

          if session.save
            # Might be cleaner if something listened for this event and created this job there?
            # UpdateRollingPatientStatisticsJob.perform_later(patient) unless session.open?
            unless session.open?
              UpdateRollingPatientStatisticsJob.perform_later(patient)
            end

            broadcast(:save_success, session)
          else
            session.type = session_type # See method comment
            broadcast(:save_failure, session)
          end
        end

        private

        def parse_params(params)
          @session_type = params.delete(:type)
          raise(ArgumentError, "Missing type in session params") if session_type.blank?

          params
        end

        def update_session_attributes(session, signing_off)
          session = signed_off(session) if signing_off
          session.attributes = params
          session.by = current_user
          lookup_access_type_abbreviation(session)
          session
        end

        def find_or_build_session(id)
          if id.present?
            Session.for_patient(patient).find(id)
          else
            session_klass.new(patient: @patient)
          end
        end

        # NB Will return a different session object
        def signed_off(session)
          session = session.becomes!(Session::Closed)
          session.profile = patient.hd_profile
          session.signed_off_at = Time.zone.now
          session.dry_weight = most_recent_dry_weight
          session
        end

        def session_klass
          session_type.constantize
        end

        def most_recent_dry_weight
          Renalware::Clinical::DryWeight
            .for_patient(patient)
            .order(assessed_on: :desc)
            .first
        end

        def lookup_access_type_abbreviation(session)
          return unless session.document.respond_to?(:info)

          access_type = Accesses::Type.find_by(name: session.document.info.access_type)
          return unless access_type

          session.document.info.access_type_abbreviation = access_type.abbreviation
        end
      end
    end
  end
end
