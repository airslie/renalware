# frozen_string_literal: true

module Renalware
  module HD
    class ProtocolPresenter < DumbDelegator
      attr_accessor :patient

      # We must delegate unknown method calls to view_context in order to handle e.g.
      # .formats (required by our #with_format method) and to avoid errors if any link_to etc
      # helpers are called.
      def initialize(patient, view_context)
        @patient = patient
        @view_context = view_context
        super(view_context)
      end

      def latest_dry_weight
        @latest_dry_weight ||= begin
          Clinical::DryWeight.for_patient(patient).order(assessed_on: :desc).first
        end
      end

      # TODO: some emerging duplication with HD::DashboardPresenter and forthcoming MDMPresenter?
      #       Could have a base HD presenter or mixin required elements e.g. from concerns
      def preference_set
        @preference_set ||= PreferenceSet.for_patient(patient).first_or_initialize
      end

      def profile
        @profile ||= begin
          ProfilePresenter.new(Profile.for_patient(patient).first_or_initialize)
        end
      end

      def access
        @access ||= begin
          access_profile = Renalware::Accesses.cast_patient(patient).current_profile
          Accesses::ProfilePresenter.new(access_profile)
        end
      end

      def sessions
        @sessions ||= begin
          hd_sessions =
            Sessions::ProtocolSessionsQuery.new(patient: patient)
              .call.includes(:patient, :signed_on_by, :signed_off_by, :station)
          ::CollectionPresenter.new(hd_sessions, Protocol::SessionPresenter, view_context)
        end
      end

      def prescriptions
        days_to_lookahead = ::Renalware.config.hd_session_form_prescription_days_lookahead
        lookahead_datetime = days_to_lookahead.days.since.end_of_day
        prescriptions = patient
          .prescriptions
          .order("drugs.name asc, " \
                 "medication_prescriptions.prescribed_on asc, " \
                 "medication_prescriptions.created_at asc")
          .includes([:drug, :unit_of_measure, :trade_family])
          .to_be_administered_on_hd_and_starting_before(lookahead_datetime)
        ::CollectionPresenter.new(prescriptions, ::Renalware::Medications::PrescriptionPresenter)
      end

      def recent_pathology
        current_observation_set = Pathology.cast_patient(patient).fetch_current_observation_set
        current_observation_set ||= Pathology::NullObservationSet.new
        current_observation_set.values_for_codes(codes_to_show)
      end

      def codes_to_show
        code_group_name = "hd_session_form_recent"
        @codes_to_show ||= Pathology::CodeGroup.descriptions_for_group(code_group_name).pluck(:code)
      end

      def patient_title
        patient.to_s(:long)
      end

      # In order for pdf rendering to easily re-use html partials (despite a mime type of :pdf),
      # pass partial rendering code as a block to `with_format`.
      #
      # Example issues and usage trying to render my_partial.html.slim from my_template.pdf.slim:
      #
      #   = render 'my_partial' # cannot resolve the html partial
      #
      #   = render 'my_partial', format: :html # resolves partial but i18n requires an `html:` key
      #
      #   - with_format(:html) do
      #     = render 'my_partial' # resolves the html partial and existing i18n keys are used.
      #
      # See http://stackoverflow.com/questions/339130/how-do-i-render-a-partial-of-a-\
      # different-format-in-rails/3427634#3427634
      def with_format(format, &block)
        old_formats = formats
        begin
          self.formats = [format]
          block.call
        ensure
          self.formats = old_formats
        end
      end

      protected

      attr_accessor :view_context
    end
  end
end
