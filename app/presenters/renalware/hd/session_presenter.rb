# frozen_string_literal: true

module Renalware
  module HD
    class SessionPresenter < SimpleDelegator
      RR40_ACCESS_SIDE_MAP = {
        "left" => "L",
        "right" => "R",
        "unknown" => "U"
      }.freeze

      attr_reader :preference_set
      delegate :info,
               :observations_before,
               :observations_after,
               :dialysis,
               :complications,
               to: :document, allow_nil: true
      delegate :access_type,
               :access_type_abbreviation, # a concatenation of rr02 and rr41
               :access_side,
               :machine_no,
               to: :info, allow_nil: true
      delegate :arterial_pressure,
               :venous_pressure,
               :blood_flow,
               :fluid_removed,
               :litres_processed,
               :machine_urr,
               :machine_ktv,
               to: :dialysis, allow_nil: true
      delegate :unit_code,
               :name,
               :renal_registry_code,
               to: :hospital_unit,
               prefix: true, allow_nil: true
      delegate :username, :to_s, to: :updated_by, prefix: true, allow_nil: true
      delegate :sodium_content, to: :dialysate, allow_nil: true
      delegate :had_intradialytic_hypotension,
               to: :complications,
               allow_nil: true
      delegate :class, to: :__getobj__

      def initialize(session, view_context = nil)
        @view_context = view_context
        @session = session
        super(session)
      end

      def had_intradialytic_hypotension?
        had_intradialytic_hypotension&.yes? ? "Y" : "N"
      end

      def state
        self.class.to_s.demodulize.downcase
      end

      def performed_on
        url = view_context.patient_hd_session_path(session.patient, session)
        text = ::I18n.l(super)
        view_context.link_to(text, url)
      end

      def performed_on_date
        __getobj__.performed_on
      end

      def start_time
        ::I18n.l(super, format: :time)
      end

      def end_time
        ::I18n.l(super, format: :time)
      end

      # Returns duration as e.g. "02:01"
      def duration
        super && ::Renalware::Duration.from_minutes(super)
      end

      # Returns duration as e.g. 121 (minutes)
      def duration_in_minutes
        __getobj__.duration
      end

      def before_measurement_for(measurement)
        observations_before.try(measurement.to_sym)
      end

      def after_measurement_for(measurement)
        observations_after.try!(measurement.to_sym)
      end

      def change_in(measurement)
        pre = before_measurement_for(measurement)
        post = after_measurement_for(measurement)
        return if pre.blank? || post.blank?

        case pre
        when ::Float then (post - pre).round(1)
        when ::Integer then (post - pre)
        end
      rescue StandardError => e
        nil
      end

      def summarised_access_used
        Renalware::HD::SessionAccessPresenter.new(self).to_html
      end

      def access_used
        Renalware::HD::SessionAccessPresenter.new(self).to_s
      end

      def truncated_notes
        return if notes.blank?

        notes.truncate(100, omission: "&hellip;").html_safe
      end

      def edit_or_view_url
        i18n_scope = "renalware.hd.sessions.#{session.state}"
        if immutable?
          view_context.link_to(I18n.t(".view", scope: i18n_scope),
                               view_context.patient_hd_session_path(patient, self),
                               class: "nowrap")
        else
          view_context.link_to(I18n.t(".edit", scope: i18n_scope),
                               view_context.edit_patient_hd_session_path(patient, self),
                               class: "nowrap")
        end
      end

      def access_side_rr40_code
        RR40_ACCESS_SIDE_MAP[access_side] || RR40_ACCESS_SIDE_MAP["unknown"]
      end

      protected

      attr_reader :session, :view_context
    end
  end
end
