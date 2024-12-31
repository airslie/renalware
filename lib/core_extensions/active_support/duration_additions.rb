module CoreExtensions
  module ActiveSupport
    module DurationAdditions
      FORMATTING_ELEMENTS = [:years, :months, :weeks, :days, :hours, :minutes, :seconds].freeze

      # Add a custom method on ActiveSupportDuration.
      # This is a variation on Duration#inspect that excludes empty parts.
      # Given an iso8601 duration of 1 week:
      #   duration = Duration.parse("P1W")
      #   duration.inspect        #=> "1 week, 0 days, and 0 hours"
      #   duration.to_formatted_s #=> "1 week"
      #
      # rubocop:disable Style/Semicolon, Style/EachWithObject
      def to_formatted_s
        parts
          .reduce(::Hash.new(0)) { |h, (l, r)| h[l] += r; h }
          .reject { |_, val| val < 1 }
          .sort_by { |unit, _| FORMATTING_ELEMENTS.index(unit) }
          .map { |unit, val| "#{val} #{val == 1 ? unit.to_s.chop : unit.to_s}" }
          .to_sentence(locale: ::I18n.default_locale)
      end
      # rubocop:enable Style/Semicolon, Style/EachWithObject
    end
  end
end

ActiveSupport::Duration.include(CoreExtensions::ActiveSupport::DurationAdditions)
