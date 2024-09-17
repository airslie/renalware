class AddBackfillUuidInUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def up
    safety_assured do
      Renalware::User.unscoped.in_batches do |relation|
        relation.where(uuid: nil).update_all("uuid = uuid_generate_v4()")
        sleep(0.01)
      end
      change_column_null :users, :uuid, false
    end
  end
end
