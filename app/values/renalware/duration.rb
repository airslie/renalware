module Renalware
  class Duration
    attr_reader :seconds

    class Minute
      def self.to_seconds(value)
        value.to_i * 60
      end
    end

    class Hour
      def self.to_seconds(value)
        value.to_i * Minute.to_seconds(60)
      end
    end

    def self.from_string(value)
      Duration.new(to_seconds(value))
    end

    def self.from_minutes(minutes)
      minutes = 0 if minutes.nil? || minutes.blank?
      seconds = minutes.to_i * 60
      Duration.new(seconds)
    end

    def self.to_seconds(string)
      return nil if string.blank?

      case string
      when /(?<hours>\d+):(?<minutes>\d{2})/ # "hh:mm"
        match = $LAST_MATCH_INFO
        Hour.to_seconds(match[:hours]) + Minute.to_seconds(match[:minutes])
      else
        Minute.to_seconds(string)
      end
    end

    def initialize(seconds)
      @seconds = seconds
    end

    # Returns the duration in hours and minutes format: "hh:mm"
    def to_s
      return "" if @seconds.nil?

      hours, seconds = @seconds.divmod(Hour.to_seconds(1))
      minutes = seconds / Minute.to_seconds(1)
      sprintf("%d:%02d", hours, minutes)
    end

    private_class_method :to_seconds
  end
end
