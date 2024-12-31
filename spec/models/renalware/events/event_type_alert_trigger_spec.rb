module Renalware::Events
  describe EventTypeAlertTrigger do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:event_type)
    end
  end
end
