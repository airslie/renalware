module Renalware
  # Formats exceptions into a string suitable for logging or display.
  class ExceptionFormatter
    def initialize(error) = @error = error

    def to_s
      [
        "#{error.backtrace.first}: #{error.message} (#{error.class})",
        error.backtrace.drop(1).map { |line| "\t#{line}" }
      ].join("\n")
    end
    private attr_reader :error
  end
end
