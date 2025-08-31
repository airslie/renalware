class BackfillAddUuidToEvents < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    # Backfill existing records in batches to avoid long locks
    Renalware::Events::Event.unscoped.in_batches(of: 10000) do |relation|
      relation.where(uuid: nil).update_all("uuid = gen_random_uuid()")
      sleep(0.01)
    end
  end

  def down
    # no-op
  end
end
