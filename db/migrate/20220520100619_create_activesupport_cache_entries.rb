class CreateActivesupportCacheEntries < ActiveRecord::Migration[6.0]
  def up
    if ActiveSupport::Cache.const_defined?(:DatabaseStore)
      within_renalware_schema do
        ActiveSupport::Cache::DatabaseStore::Migration.migrate(:up)
      end
    end
  end

  def down
    if ActiveSupport::Cache.const_defined?(:DatabaseStore)
      within_renalware_schema do
        ActiveSupport::Cache::DatabaseStore::Migration.migrate(:down)
      end
    end
  end
end
