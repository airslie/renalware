class CreateFnUKRDCUpdateSendToRenalreg < ActiveRecord::Migration[7.1]
  def up
    load_function("ukrdc_update_send_to_renalreg_v01.sql")
  end

  def down
    connection.execute("DROP FUNCTION IF EXISTS renalware_demo.ukrdc_update_send_to_renalreg;")
  end
end
