class DropConstraintUKRDCTxLogSentAt < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      change_column_null :ukrdc_transmission_logs, :sent_at, true
    end
  end
end
