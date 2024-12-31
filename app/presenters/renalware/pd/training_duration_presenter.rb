module Renalware
  module PD
    class TrainingDurationPresenter
      # An array of delivery interval options derived from the PD configuration, and using an
      # iso8601 representation of the duration (eg "P4W" for 4 weeks), e.g.
      # [
      #  [
      #    "1 week", "P1W",
      #    "1 year", "P1Y",
      #    ...
      #  ]
      # ]
      # Note use Duration#to_formatted_s when rendering out a duration anywhere in the app.
      def self.dropdown_options
        PD.config.training_durations.map do |duration|
          [duration.to_fs, duration.iso8601]
        end
      end

      def initialize(duration)
        @interval = duration.present? ? parse_iso8601_duration(duration) : NullObject.instance
      end

      def to_s
        interval.to_fs
      end

      private

      attr_reader :interval

      def parse_iso8601_duration(duration)
        ActiveSupport::Duration.parse(duration)
      end
    end
  end
end
