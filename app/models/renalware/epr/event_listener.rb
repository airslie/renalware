module Renalware
  module EPR
    # Subscribed to Events::CreateEvent when config.epr_export_enabled is true.
    # See config/initializers/renalware.rb
    class EventListener
      def event_created(event)
        return unless event.event_type&.save_pdf_to_electronic_public_register?
        return unless event.patient.patient_at?(site)

        filename = MdtFilename.new(event, site).to_s
        Folders.events.each do |folder|
          SaveEventJob.perform_later(event:, file_path: folder.join(filename).to_s)
        end
      end

      private

      def site = Renalware.config.epr_site_code
    end
  end
end
