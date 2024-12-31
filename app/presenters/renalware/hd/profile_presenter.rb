module Renalware
  module HD
    class ProfilePresenter < DumbDelegator
      attr_reader :preference_set

      delegate :dialysis,
               :anticoagulant,
               :transport,
               :drugs,
               :care_level,
               to: :document

      delegate :dialyser,
               :cannulation_type,
               :bicarbonate,
               :needle_size,
               :single_needle,
               :temperature,
               :blood_flow,
               :has_sodium_profiling,
               :sodium_first_half,
               :sodium_second_half,
               :substitution_percent,
               to: :dialysis, allow_nil: true

      delegate :type,
               :loading_dose,
               :hourly_dose,
               to: :anticoagulant, allow_nil: true, prefix: true

      delegate :unit_code,
               to: :hospital_unit, prefix: true, allow_nil: true

      delegate :on_esa,
               :on_iron,
               :on_warfarin,
               to: :drugs, prefix: true, allow_nil: true

      delegate :has_transport,
               :type,
               :decided_on,
               to: :transport, prefix: true, allow_nil: true

      def initialize(profile, preference_set: nil)
        super(profile)
        @preference_set = preference_set
      end

      def document
        ProfileDocumentPresenter.new(__getobj__.document)
      end

      def hospital_unit_hint
        if preference_set.hospital_unit.present?
          "Preference: #{@preference_set.hospital_unit}"
        end
      end

      def schedule_hint
        return if preference_set.preferred_schedule.blank?

        "Preference: #{@preference_set.preferred_schedule}"
      end

      def current_schedule
        return other_schedule if other_schedule.present?

        schedule_definition
      end

      def schedule_definitions
        ScheduleDefinition
          .includes(:diurnal_period)
          .ordered
          .map { |definition| [definition.to_s, definition.id] }
      end

      def last_update
        "#{::I18n.l(updated_at)} by #{updated_by}"
      end

      def hd_type
        document.dialysis.hd_type.try(:text)
      end

      def prescribed_times
        (60..720).step(15).map { |mins| [Duration.from_minutes(mins).to_s, mins] }
      end

      def formatted_prescribed_time
        return unless prescribed_time

        ::Renalware::Duration.from_minutes(prescribed_time).to_s
      end

      def blood_flow
        "#{dialysis.blood_flow} ml/min" if dialysis.blood_flow.present?
      end

      def flow_rate
        "#{dialysis.flow_rate} ml/min" if dialysis.flow_rate.present?
      end

      def anticoagulant_stop_time
        return if anticoagulant.stop_time.blank?

        Duration.from_minutes(anticoagulant.stop_time).to_s
      end

      def transport_summary
        return if transport.blank?

        [transport.has_transport&.text, transport.type&.text].compact.join(": ")
      end

      # Although stored as a PG time data type, Rails adds a date internally when loaded from the db
      # so make sure we display just a 24 hour time eg 08:30.
      def scheduled_time
        super&.strftime("%H:%M")
      end
    end
  end
end
