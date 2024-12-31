module Renalware
  module Drugs
    module DMD::Synchronisers
      # Build a many-to-many table between a Drug and From, Unit of Measure and Route
      class VMPClassificationSynchroniser
        def call # rubocop:disable Metrics/AbcSize
          drug_code_to_id_map = Drugs::DrugCodeToIdMap.new
          routes = Medications::RoutesIndexedByCodeMap.new

          DMD::VirtualMedicalProduct.find_in_batches(batch_size: 500) do |batch|
            upserts = []

            batch.each do |vmp|
              drug_id = drug_code_to_id_map[vmp.virtual_therapeutic_moiety_code]

              next if drug_id.nil?

              # unit_of_measure_id: unit_of_measure&.id,
              upserts.push(
                {
                  code: vmp.code,
                  drug_id: drug_id,
                  form_id: forms_code_to_id_map[vmp.form_code],
                  unit_dose_uom_id: uom_code_to_id_map[vmp.unit_dose_uom_code],
                  unit_dose_form_size_uom_id: uom_code_to_id_map[vmp.unit_dose_form_size_uom_code],
                  active_ingredient_strength_numerator_uom_id:
                    uom_code_to_id_map[vmp.active_ingredient_strength_numerator_uom_code],
                  route_id: routes[vmp.route_code]&.id,
                  trade_family_ids: trade_family_ids_for(vmp),
                  inactive: vmp.inactive
                }
              )
            end

            next if upserts.none?

            VMPClassification.upsert_all(
              upserts,
              unique_by: :index_drug_vmp_classifications_on_code
            )
          end
        end

        private

        # { "ABC" => 123, ..}
        def uom_code_to_id_map = @uom_code_to_id_map ||= UnitOfMeasure.pluck(:code, :id).to_h

        # { "ABC" => 123, ..}
        def forms_code_to_id_map = @forms_code_to_id_map ||= Form.pluck(:code, :id).to_h

        # { "ABC" => 123, ..}
        def trade_family_code_to_id_map
          @trade_family_code_to_id_map ||= TradeFamily.pluck(:code, :id).to_h
        end

        def trade_family_ids_for(vmp)
          trade_family_codes = vmp_code_to_trade_family_codes[vmp.code] || []
          trade_family_codes.map { |code| trade_family_code_to_id_map[code] }
        end

        # Create a mapping between vmp code and trade family codes:
        # 'VMP_CODE' => ['TRADE_FAMILY_CODE_1', 'TRADE_FAMILY_CODE_1', ..]
        def vmp_code_to_trade_family_codes
          @vmp_code_to_trade_family_codes ||= begin
            DMD::ActualMedicalProduct.where.not(trade_family_code: nil)
              .pluck(:virtual_medical_product_code, :trade_family_code)
              .each_with_object({}) do |(vmp_code, trade_family_code), acc|
              acc[vmp_code] ||= Set.new
              acc[vmp_code] << trade_family_code
            end
          end
        end
      end
    end
  end
end
