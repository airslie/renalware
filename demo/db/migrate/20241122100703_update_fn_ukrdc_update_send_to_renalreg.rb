class UpdateFnUKRDCUpdateSendToRenalreg < ActiveRecord::Migration[7.2]
  def up
    load_function("ukrdc_update_send_to_renalreg_v02.sql")
  end

  def down
    load_function("ukrdc_update_send_to_renalreg_v01.sql")
  end
end
