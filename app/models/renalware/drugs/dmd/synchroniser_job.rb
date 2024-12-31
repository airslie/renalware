module Renalware
  module Drugs::DMD
    # Perform full DM+D synchronisation
    # Safe to run multiple times.
    #
    # @see Synchronisers::FullSynchroniser
    class SynchroniserJob < ApplicationJob
      def perform_now
        return if Renalware.config.disable_dmd_synchroniser_job

        System::APILog.with_log "Drugs::DMD::SynchroniserJob" do
          Synchronisers::FullSynchroniser.new.call
        end
      end
    end
  end
end
