# To create outside of Rails, insert a row with values for the following columns
# into the `delayed_jobs` table:
#
#     handler: {see example.yml}
#     run_at: {current_time}
#
# Notes:
#
# - the key `raw_message` for the `handler` column must have line endings "\n"
# - to run delayed_jobs see in development use rake jobs:work
#
PathologyFeedJob = Struct.new(:raw_message) do
  def perform
    Renalware::Feeds::MessageProcessor.new.call(raw_message)
  end
end
