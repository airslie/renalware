class UpdateDieteticMDMView < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      safety_assured do
        update_view :dietetic_mdm_patients, version: 3, revert_to_version: 2

        reversible do |direction|
          direction.up do
            execute <<-SQL.squish
              update renalware.system_view_metadata
              set filters = '[
                {"code": "on_worryboard", "type": 0},
                {"code": "dietician_name", "type": 0},
                {"code": "hospital_centre", "type": 0},
                {"code": "modality_name", "type": 0},
                {"code": "visit_type", "type": 0},
                {"code": "consultant_name", "type": 0},
                {"code": "outstanding_dietetic_visit", "type": 0}
              ]' where view_name = 'dietetic_mdm_patients';
            SQL
          end
          direction.down do
            execute <<-SQL.squish
              update renalware.system_view_metadata
              set filters = '[
                {"code": "on_worryboard", "type": 0},
                {"code": "dietician_name", "type": 0},
                {"code": "hospital_centre", "type": 0},
                {"code": "modality_name", "type": 0},
                {"code": "consultant_name", "type": 0},
                {"code": "outstanding_dietetic_visit", "type": 0}
              ]' where view_name = 'dietetic_mdm_patients';
            SQL
          end
        end
      end
    end
  end
end
