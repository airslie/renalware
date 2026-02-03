class AddUKRDCModalityCodeIdToModalityDescriptions < ActiveRecord::Migration[5.2]
  def change
    # add_column :modality_descriptions, :ukrdc_modality_code_id, :integer
    add_reference :modality_descriptions,
                  :ukrdc_modality_code,
                  foreign_key: true

    reversible do |direction|
      direction.up do
        # Obviously this 'data migration' will only apply if modality_descriptions are already seeded!
        connection.execute(<<~SQL.squish)
          update renalware.modality_descriptions set ukrdc_modality_code_id = (select id from renalware.ukrdc_modality_codes where qbl_code = '19') where name = 'PD';
          update renalware.modality_descriptions set ukrdc_modality_code_id = (select id from renalware.ukrdc_modality_codes where qbl_code = '1') where name = 'HD';
          update renalware.modality_descriptions set ukrdc_modality_code_id = (select id from renalware.ukrdc_modality_codes where qbl_code = '29') where name = 'Transplant';
          update renalware.modality_descriptions set ukrdc_modality_code_id = (select id from renalware.ukrdc_modality_codes where qbl_code = '900') where name = 'vCKD';
        SQL
      end
      direction.down do
        # noop
      end
    end
  end
end
