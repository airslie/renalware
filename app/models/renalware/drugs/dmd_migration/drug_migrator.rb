module Renalware
  module Drugs
    module DMDMigration
      class DrugMigrator
        def call
          drug_ids_by_name = Drugs::Drug
            .where(inactive: false)
            .where.not(code: nil)
            .pluck(:name, :id).to_h
          dmd_matches = DMDMatch.where(approved_vtm_match: true).where.not(vtm_name: nil)

          dmd_matches.each do |dmd_match|
            new_drug_id = drug_ids_by_name[dmd_match.vtm_name]
            next if new_drug_id.nil?

            Medications::Prescription
              .where(drug_id: dmd_match.drug_id)
              .update_all(
                drug_id: new_drug_id,
                legacy_drug_id: dmd_match.drug_id
              )
          end
        end
      end
    end
  end
end
