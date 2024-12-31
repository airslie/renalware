module Renalware
  module HD
    class SessionFactory
      attr_reader :patient, :user, :type

      # The optional :type argument has been passed into the controller as a query string parameter.
      # The only valid values are nil or "dna". If "dna", it is signifies we should build a
      # Session::DNA object. Otherwise we always build a Session::Open.
      def initialize(patient:, user:, type: nil)
        @patient = patient
        @user = user
        @type = type
      end

      def build
        session = build_session
        apply_profile(session)
        set_default_access(session)
        build_prescription_administrations(session)
        session
      end

      private

      def session_klass
        dna_session? ? Session::DNA : Session::Open
      end

      def dna_session?
        type == "dna"
      end

      def build_session
        session_klass.new(signed_on_by: user).tap do |ses|
          ses.duration_form = build_duration_form_object
        end
      end

      def build_duration_form_object
        Sessions::DurationForm.new(
          start_date: Time.zone.today,
          start_time: current_time_rounded_to_5_minutes
        )
      end

      def apply_profile(session) # rubocop:disable Metrics/AbcSize
        if (profile = Profile.for_patient(patient).first)
          session.hospital_unit = profile.hospital_unit
          unless dna_session?
            session.document.info.hd_type = profile.document.dialysis.hd_type
            session.dialysate_id = profile.dialysate_id
            session.document.info.needle_size = profile.document.dialysis.needle_size
            session.document.info.cannulation_type = profile.document.dialysis.cannulation_type
          end
        end
      end

      def set_default_access(session) # rubocop:disable Naming/AccessorMethodName
        return if dna_session?

        accesses_patient = Renalware::Accesses.cast_patient(patient)
        if (profile = accesses_patient.current_profile)
          session.document.info.access_type = profile.type.name
          session.document.info.access_side = profile.side
        end
      end

      def build_prescription_administrations(session)
        return unless session.new_record?

        patient.prescriptions.to_be_administered_on_hd.map do |prescription|
          session.prescription_administrations.build(
            prescription: prescription,
            administered_by: user
          )
        end
      end

      def current_time_rounded_to_5_minutes
        Time.zone.now.change(min: (Time.zone.now.min / 5) * 5)
      end
    end
  end
end
