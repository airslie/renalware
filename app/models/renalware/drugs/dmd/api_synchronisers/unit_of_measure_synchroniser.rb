module Renalware::Drugs
  module DMD
    module APISynchronisers
      class UnitOfMeasureSynchroniser
        def initialize(unit_of_measure_repository: Repositories::UnitOfMeasureRepository.new)
          @unit_of_measure_repository = unit_of_measure_repository
        end
        attr_reader :unit_of_measure_repository

        def call
          entries = unit_of_measure_repository.call

          return if entries.empty?

          now = Time.current
          upserts = entries.map do |entry|
            {
              code: entry.code,
              name: entry.name,
              updated_at: now
            }
          end

          UnitOfMeasure.upsert_all(upserts, unique_by: :code)
        end
      end
    end
  end
end
