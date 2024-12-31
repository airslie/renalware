module Renalware
  module Drugs::DMD
    module APISynchronisers
      class ActualMedicalProductSynchroniser
        COUNT = 100

        def initialize(
          actual_medical_product_repository: Repositories::ActualMedicalProductRepository.new
        )
          @actual_medical_product_repository = actual_medical_product_repository
        end
        attr_reader :actual_medical_product_repository

        def call
          offset = 0

          loop do
            entries = actual_medical_product_repository.call(offset: offset, count: COUNT)

            Rails.logger.info(
              "[ActualMedicalProductSynchroniser] offset: #{offset}; records: #{entries.size}"
            )

            break if entries.empty?

            now = Time.current
            upserts = entries.select { _1.virtual_medical_product_code.present? }.map do |entry|
              {
                code: entry.code,
                name: entry.name,
                virtual_medical_product_code: entry.virtual_medical_product_code,
                updated_at: now
              }
            end

            next if upserts.none?

            ActualMedicalProduct.upsert_all(upserts, unique_by: :code)

            offset += COUNT
          end
        end
      end
    end
  end
end
