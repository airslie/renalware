class AddVNDAssessmentRiskToHDMDM < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        update_view :hd_mdm_patients, version: 7, revert_to_version: 6

        reversible do |direction|
          direction.up do
            execute <<-SQL.squish
              update renalware.system_view_metadata
              set filters = '[
                {"code": "schedule", "type": 0},
                {"code": "hospital_unit", "type": 0},
                {"code": "named_nurse", "type": 0},
                {"code": "named_consultant", "type": 0},
                {"code": "on_worryboard", "type": 0},
                {"code": "vnd_risk_level", "type": 0}
              ]' where view_name = 'hd_mdm_patients';
            SQL
          end
          direction.down do
            execute <<-SQL.squish
              update renalware.system_view_metadata
              set filters = '[
                {"code": "schedule", "type": 0},
                {"code": "hospital_unit", "type": 0},
                {"code": "named_nurse", "type": 0},
                {"code": "named_consultant", "type": 0},
                {"code": "on_worryboard", "type": 0}
              ]' where view_name = 'hd_mdm_patients';
            SQL
          end
        end
      end
    end
  end
end
