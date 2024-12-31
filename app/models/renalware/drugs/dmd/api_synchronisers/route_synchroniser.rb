module Renalware
  module Drugs
    module DMD::APISynchronisers
      class RouteSynchroniser
        def initialize(route_repository: DMD::Repositories::RouteRepository.new)
          @route_repository = route_repository
        end
        attr_reader :route_repository

        def call
          entries = route_repository.call

          return if entries.empty?

          now = Time.current
          upserts = entries.map do |entry|
            {
              name: entry.name,
              code: entry.code,
              updated_at: now
            }
          end

          Medications::MedicationRoute.upsert_all(upserts, unique_by: :code)
        end
      end
    end
  end
end
