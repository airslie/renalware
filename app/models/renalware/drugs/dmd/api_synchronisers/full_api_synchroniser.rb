module Renalware
  module Drugs::DMD
    module APISynchronisers
      # Take DM+D (Directory of Medicine & Devices) data from the
      # NHS Digital Terminology Service (https://ontology.nhs.uk/) and sync
      # it with a local copy of it.
      #
      # Safe to run multiple times.
      #
      # @see Synchronisers::FullSynchroniser for the complete process
      class FullAPISynchroniser
        def call
          FormSynchroniser.new.call
          RouteSynchroniser.new.call
          UnitOfMeasureSynchroniser.new.call
          VirtualTherapeuticMoietySynchroniser.new.call
          VirtualMedicalProductSynchroniser.new.call
          AtcCodeSynchroniser.new.call
          ActualMedicalProductSynchroniser.new.call
          TradeFamilySynchroniser.new.call
          AmpTradeFamilySynchroniser.new.call
        end
      end
    end
  end
end
