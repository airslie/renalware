# Don't rely on auto-loading in an initializer
require_relative "../../app/models/concerns/renalware/broadcasting"

# New subscription registry - previous implementation does not work across threads.
# Each key in the map (hash) is the name of a class that broadcasts/publishes messages.
# Entries in the array (value) for that key are classes which subscribe to events in the
# publishing class. If you want a subscriber to listen asynchronously for events via ActiveJob,
# use an Subscriber instance like so
# "Renalware::Modalities::ChangePatientModality" => [
#   Renalware::Broadcasting::Subscriber.new("Renalware::Patients::DemoListener", async: true),
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
# application with confusing outcomes.
Renalware.configure do |config|
  config.broadcast_subscription_map = {
    "Renalware::Patients::BroadcastPatientAddedEvent" => [
      "Renalware::Feeds::PatientListener"
    ],
    "Renalware::Modalities::ChangePatientModality" => [
      "Renalware::Medications::PatientListener",
      "Renalware::Letters::PatientListener",
      "Renalware::HD::PatientListener",
      "Renalware::Patients::PatientListener"
    ],
    "Renalware::Letters::ApproveLetter" => [
      Renalware::Broadcasting::Subscriber.new(
        "Renalware::Letters::CalculatePageCountJob", async: true
      )
    ],
    "Renalware::Letters::ResolveDefaultElectronicCCs" => [
      "Renalware::HD::PatientListener"
    ],
    "Renalware::Pathology::CreateObservationRequests" => [],
    "Renalware::Events::CreateEvent" => [],
    "Renalware::Events::UpdateEvent" => [],
    "Renalware::Feeds::ReplayHistoricalHL7PathologyMessages" => [
      "Renalware::Pathology::Ingestion::MessageListener"
    ],
    "Renalware::Feeds::MessageProcessor" => [
      "Renalware::Patients::Ingestion::MessageListener",
      "Renalware::Pathology::Ingestion::AKIListener",
      "Renalware::Pathology::Ingestion::MessageListener",
      "Renalware::Clinics::Ingestion::MessageListener",
      "Renalware::Pathology::KFRE::Listener"
    ]
  }

  unless config.letters_render_pdfs_with_prawn
    # If using WickedPDF (wkhtmltopdf) then after letter is signed-off, run a job to
    # calculate and store the number of pages in the file - useful to batch printing.
    # If using prawn, we can quickly create the PDF and get the page count a the point of
    # approval, because, unlike wkhtmltopdf, the PDF generation is very fast.
    job = Renalware::Broadcasting::Subscriber.new(
      "Renalware::Letters::CalculatePageCountJob",
      async: true
    )
    config.broadcast_subscription_map["Renalware::Letters::ApproveLetter"] << job
  end
end
