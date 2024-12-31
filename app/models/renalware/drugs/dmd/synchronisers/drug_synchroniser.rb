module Renalware
  module Drugs::DMD
    module Synchronisers
      # Data in the Drugs table corresponds to Virtual Therapeutic Moieties (VTMs)
      # in the DM+D dataset. We synchronise Drugs data with DM+D VTMs in a two step
      # process. First, populate the {Drugs::DMD::VirtualTherapeuticMoiety} table.
      # Then, sync it with the Drugs table as per below.

      # We do this two step process both for more control, and because the VTM data
      # is anyhow needed for other purposes.
      #
      class DrugSynchroniser
        def initialize(vtm_repository: VirtualTherapeuticMoiety::ExportSyncQuery.new)
          @vtm_repository = vtm_repository
        end
        attr_reader :vtm_repository

        def call
          now = Time.current

          upserts = vtm_repository.call.map do |moiety|
            {
              name: moiety.name,
              code: moiety.code,
              inactive: moiety.inactive || false, # disallow nulls
              updated_at: now
            }
          end

          return if upserts.empty?

          Drugs::Drug.upsert_all(upserts, unique_by: :code)
        end
      end
    end
  end
end
