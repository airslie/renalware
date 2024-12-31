# To create outside of Rails, insert a row with values for the following columns
# into the `delayed_jobs` table:
#
#     handler: {see h7_message_example.yml}
#     run_at: {current_time e.g. NOW() AT TIME ZONE 'UTC'}
#
# Notes:
#
# - the key `raw_message` for the `handler` column must have line endings "\n"
# - to run delayed_jobs see in development use rake jobs:work
#
FeedJob = Struct.new(:raw_message) do
  def perform
    Renalware::Feeds.message_processor.call(raw_message)
  end

  def max_attempts = 2
  def destroy_failed_jobs? = false

  # Reschedule after an error. No point trying straight away, so try at these intervals:
  # After attempt no. Wait for hours
  # ---------------------------
  # 1                  2
  # 2                  17
  # Then give up.
  # Note e.g. attempts**4 == attempts to the power of 4
  def reschedule_at(current_time, attempts)
    current_time + ((attempts**4) + 1).hours
  end
end
