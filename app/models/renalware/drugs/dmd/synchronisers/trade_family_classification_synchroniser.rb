module Renalware
  module Drugs::DMD
    module Synchronisers
      # Build a many-to-many table between a Trade Family and a Drug.
      # This tells us which Trade Families are available for each Drug.
      #
      class TradeFamilyClassificationSynchroniser
        def call
          trade_family_code_to_id_mapping = Drugs::TradeFamily.pluck(:code, :id).to_h
          vmp_code_to_vtm_code_mapping = Drugs::DMD::VirtualMedicalProduct.pluck(
            :code,
            :virtual_therapeutic_moiety_code
          ).to_h
          drug_vtm_code_to_id_mapping = Drugs::Drug.pluck(:code, :id).to_h

          ActualMedicalProduct.find_in_batches(batch_size: 500) do |batch|
            upserts = []

            batch.each do |amp|
              trade_family_id = trade_family_code_to_id_mapping[amp.trade_family_code]
              vtm_code = vmp_code_to_vtm_code_mapping[amp.virtual_medical_product_code]
              drug_id = drug_vtm_code_to_id_mapping[vtm_code]

              next if trade_family_id.nil? || drug_id.nil?

              upserts.push(
                {
                  drug_id: drug_id,
                  trade_family_id: trade_family_id
                }
              )
            end

            next if upserts.none?

            Drugs::TradeFamilyClassification.upsert_all(
              upserts,
              unique_by: [:drug_id, :trade_family_id]
            )
          end
        end
      end
    end
  end
end
