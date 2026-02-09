# In development the number of SELECT queries usually takes a lot of space
# of the total request output. Unless you're specifically optimising those,
# it's much cleaner to remove them from standard output.

return if ENV["SILENCE_ACTION_VIEW_SELECT_LOG"].nil?

Rails.application.config.action_view.logger = nil

module LoggerWithoutSelect
  def sql(event)
    super unless event.payload[:sql].present? && event.payload[:sql].include?("SELECT")
  end
end

ActiveRecord::LogSubscriber.prepend LoggerWithoutSelect
