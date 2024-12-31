#
# This listener had been wired to receive Event created/updated events in the
# engine's broadcast_subscription_map. See config/initializers/renalware.rb
#
class EventListener
  #
  # A broadcasted event that we are listening for
  #
  def event_created(event)
    return unless event_processable?(event)

    Renalware::Feeds::OutgoingDocument.create!(renderable: event, by: event.created_by)
  end

  private

  def event_processable?(event)
    event.event_type&.save_pdf_to_electronic_public_register?
  end
end
