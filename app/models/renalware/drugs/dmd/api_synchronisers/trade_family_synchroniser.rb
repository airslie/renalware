module Renalware
  module Drugs
    module DMD::APISynchronisers
      class TradeFamilySynchroniser
        def initialize(trade_family_repository: DMD::Repositories::TradeFamilyRepository.new)
          @trade_family_repository = trade_family_repository
        end
        attr_reader :trade_family_repository

        def call
          entries = trade_family_repository.call

          return if entries.empty?

          now = Time.current
          upserts = entries.map do |entry|
            {
              code: entry.code,
              name: entry.name,
              updated_at: now
            }
          end

          TradeFamily.upsert_all(upserts, unique_by: :code)
        end
      end
    end
  end
end
