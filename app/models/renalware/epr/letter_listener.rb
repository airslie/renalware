module Renalware
  module EPR
    # Subscribed to Letters::CompleteLetter when config.epr_export_enabled is true.
    # See config/initializers/renalware.rb
    class LetterListener
      def letter_completed(letter)
        letter = letter.becomes(Letters::Letter)
        return unless letter.patient.patient_at?(site)

        filename = LetterFilename.new(letter, site).to_s
        Folders.letters(site).each do |folder|
          SaveLetterJob.perform_later(letter:, file_path: folder.join(filename).to_s)
        end
      end

      private

      def site = Renalware.config.epr_site_code
    end
  end
end
