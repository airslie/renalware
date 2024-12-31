module Renalware
  module Drugs::DMD
    module APISynchronisers
      class VirtualTherapeuticMoietySynchroniser
        def initialize(vtm_repository: Repositories::VirtualTherapeuticMoietyRepository.new)
          @vtm_repository = vtm_repository
        end
        attr_reader :vtm_repository

        def call
          entries = vtm_repository.call

          return if entries.empty?

          now = Time.current

          upserts = entries.map do |entry|
            {
              code: entry.code,
              name: entry.name,
              inactive: entry.inactive,
              updated_at: now
            }
          end

          VirtualTherapeuticMoiety.upsert_all(upserts, unique_by: :code)
        end
      end
    end
  end
end
