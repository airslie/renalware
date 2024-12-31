module Renalware
  module Drugs::DMD
    module Synchronisers
      # Perform full DM+D drug synchronisation
      # Safe to run multiple times.
      #
      # @see APISynchronisers::FullAPISynchroniser for more details
      # @see SynchroniserJob for a job that runs it in the background.
      class FullSynchroniser
        def call
          # Take external data, and store it locally
          APISynchronisers::FullAPISynchroniser.new.call

          # Build local data relationships
          ClassificationAndDrugsSynchroniser.new.call
        end
      end
    end
  end
end
