# frozen_string_literal: true

require_dependency "renalware"

# New subscription registry - previous implementation does not work across threads.
# Each key in the map (hash) is the name of a class that broadacasts/publishes messages.
# Entries in the array (value) for that key are classes which subscribe to events in the
# publishing class. If you want a subscriber to listen asynchronously for events via ActiveJob,
# use an Subscriber instance like so
# "Renalware::Modalities::ChangePatientModality" => [
#   Renalware::Broadcasting::Subscriber.new("Renalware::Patients::DummyListener", async: true),
#   ...
# ]
# TODO: Ideally we would like an API something like this:
#   Renalware.configure do |config|
#     config.broadcast_subscription_map.configure do |publishers|
#       publishers[Renalware::Modalities::ChangePatientModality] do |publisher|
#         publisher.add_subscriber(Renalware::X)
#         publisher.add_subscriber(Renalware::y, async: true)
#       end
#     end
#   end
# As it stands its a bit too easy for the exposed subscription map hash to be overwritten by a host
# application with confusing and undesirable outcomes.
Renalware.configure do |config|
  config.broadcast_subscription_map = {
    "Renalware::Modalities::ChangePatientModality" => [
      "Renalware::Medications::PatientListener",
      "Renalware::Letters::PatientListener",
      "Renalware::HD::PatientListener",
      "Renalware::Patients::PatientListener"
    ],
    "Renalware::Letters::ApproveLetter" => [],
    "Renalware::Pathology::CreateObservationRequests" => []
  }
end

Renalware::Patients.configure
Renalware::Pathology.configure
Renalware::PD.configure do |config|
  # ...
end
