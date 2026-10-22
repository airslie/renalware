module Renalware
  module EPR
    # Where EPR files are dropped. Each document goes to a tmp folder, from where another process
    # collects it, and to an archive folder.
    class Folders
      def self.letters(site) = new.letters(site)
      def self.events = new.events

      def letters(site)
        [root.join("tmp", site.to_s.downcase), root.join("archive", site.to_s.downcase)]
      end

      def events
        [events_root.join("tmp"), events_root.join("archive")]
      end

      private

      def root
        Pathname(Renalware.config.epr_letters_folder.presence || Rails.root.join("tmp/epr"))
      end

      def events_root
        Pathname(Renalware.config.epr_events_folder.presence || Rails.root.join("tmp/epr/events"))
      end
    end
  end
end
