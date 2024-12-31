module Renalware
  module Drugs
    module DMDMigration
      class FormMigrator
        def call
          form_ids_by_name = Drugs::Form.pluck(:name, :id).to_h
          dmd_matches = DMDMatch.where.not(form_name: nil)

          dmd_matches.each do |dmd_match|
            Medications::Prescription.where(form_id: nil)
              .where(drug_id: dmd_match.drug_id)
              .update_all(form_id: form_ids_by_name[dmd_match.form_name])
          end
        end
      end
    end
  end
end
