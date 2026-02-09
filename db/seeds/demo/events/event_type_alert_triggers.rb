module Renalware
  Rails.benchmark "Adding Events Type Alert Triggers" do
    Events::EventTypeAlertTrigger.find_or_create_by!(
      event_type: Events::Type.find_by!(name: "Vaccination"),
      when_event_document_contains: "covid"
    )
  end
end
