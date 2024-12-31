class DurationCalculator
  def self.in_minutes(start_time, end_time)
    return nil if start_time.nil? || end_time.nil?

    (end_time - start_time).to_i / 60
  end
end
