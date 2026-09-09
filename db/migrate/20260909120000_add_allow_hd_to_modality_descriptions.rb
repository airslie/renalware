class AddAllowHDToModalityDescriptions < ActiveRecord::Migration[7.1]
  def up
    within_renalware_schema do
      add_column :modality_descriptions, :allow_hd, :boolean, default: false, null: false

      # This is a small reference table, so backfill it in the migration transaction.
      safety_assured do
        execute <<~SQL.squish
          UPDATE modality_descriptions
          SET allow_hd = TRUE
          WHERE name <> 'Home HD'
            AND (name LIKE '%HD%' OR type IN (
              'Renalware::HD::ModalityDescription',
              'Renalware::Transplants::RecipientModalityDescription',
              'Renalware::PD::ModalityDescription'
            ))
        SQL
      end
    end
  end

  def down
    within_renalware_schema do
      remove_column :modality_descriptions, :allow_hd
    end
  end
end
