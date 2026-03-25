class DropActivesupportCacheEntries < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      drop_table :activesupport_cache_entries, if_exists: true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
