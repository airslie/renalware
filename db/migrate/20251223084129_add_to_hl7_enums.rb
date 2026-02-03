class AddToHL7Enums < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      safety_assured do
        execute <<~SQL.squish
          alter type renalware.enum_hl7_orc_order_status
          add value if not exists 'I' before 'IP' ;
        SQL

        execute <<~SQL.squish
          alter type renalware.enum_hl7_observation_result_status_codes
          add value if not exists 'IP' after 'P';
        SQL
      end
    end
  end

  def down
    # no-op
  end
end
