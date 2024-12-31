# Example pathology listener.
#
# This listener had been wired to receive broadcast events in the
# broadcast_subscription_map. See config/initializers/renalware.rb
#
class PathologyListener
  # The observation_request is about to saved.
  def before_observation_request_persisted(obr_attributes)
    # ...
  end

  # The observation_request has just been saved.
  def after_observation_request_persisted(observation_request)
    # ...
  end
end
