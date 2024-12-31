module Renalware
  module Drugs::DMD
    module APISynchronisers
      class AmpTradeFamilySynchroniser
        COUNT = 100

        def initialize(
          snomed_amps_repository: Repositories::SnomedAmpsWithTradeFamilyRepository.new
        )
          @snomed_amps_repository = snomed_amps_repository
        end
        attr_reader :snomed_amps_repository

        def call
          offset = 0

          trade_family_codes = Drugs::TradeFamily.all.index_by(&:code)

          loop do
            entries = snomed_amps_repository.call(offset: offset, count: COUNT)

            Rails.logger.info(
              "[AmpTradeFamilySynchroniser] offset: #{offset}; records: #{entries.size}"
            )

            break if entries.empty?

            now = Time.current
            entries.each do |entry|
              trade_family_code = entry.parent_codes.find { |parent_code|
                trade_family_codes[parent_code]
              }

              next if trade_family_code.nil?

              ActualMedicalProduct.where(code: entry.code)
                .update_all(trade_family_code: trade_family_code, updated_at: now)
            end

            # Once upgraded to Rails 7, use `on_duplicate: Arel.sql("")`
            # ActualMedicalProduct.upsert_all(upserts, unique_by: :code, on_duplicate: Arel.sql(""))

            offset += COUNT
          end
        end
      end
    end
  end
end
