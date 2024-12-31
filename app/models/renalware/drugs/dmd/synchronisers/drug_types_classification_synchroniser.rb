module Renalware
  module Drugs
    module DMD::Synchronisers
      # Build a many-to-many table between a Drug Type and a Drug.
      # This tells us which Drug Types are available for each Drug.
      #
      class DrugTypesClassificationSynchroniser
        def call
          drug_type_atc_codes_to_id_mapping = Drugs::Type.pluck(:atc_codes, :id).to_h
          drug_vtm_code_to_id_mapping = Drugs::Drug.pluck(:code, :id).to_h

          DMD::VirtualMedicalProduct.find_in_batches(batch_size: 500) do |batch|
            upserts = []

            batch.each do |vmp|
              drug_id = drug_vtm_code_to_id_mapping[vmp.virtual_therapeutic_moiety_code]

              next if drug_id.nil?
              next if vmp.atc_code.nil?

              drug_type_atc_codes_to_id_mapping.each do |atc_codes, drug_type_id|
                next if atc_codes.nil?

                atc_codes.each do |drug_type_atc_code|
                  next unless vmp.atc_code.starts_with?(drug_type_atc_code)

                  upserts.push(
                    {
                      drug_id: drug_id,
                      drug_type_id: drug_type_id
                    }
                  )
                end
              end
            end

            next if upserts.none?

            DrugTypeClassification.upsert_all(
              upserts,
              unique_by: %i(drug_id drug_type_id)
            )
          end
        end
      end
    end
  end
end
