class PrepareSolidCacheEntries < ActiveRecord::Migration[8.0]
  def up
    within_renalware_schema do
      ensure_solid_cache_table!
      ensure_solid_cache_columns!
      ensure_solid_cache_indexes!
    end
  end

  def down
    within_renalware_schema do
      drop_table :solid_cache_entries, if_exists: true
    end
  end

  private

  def ensure_solid_cache_table!
    return if table_exists?(:solid_cache_entries)

    create_table :solid_cache_entries do |t|
      t.binary :key, null: false, limit: 1024
      t.binary :value, null: false, limit: 512.megabytes
      t.datetime :created_at, null: false
      t.bigint :key_hash, null: false
      t.integer :byte_size, null: false
    end
  end

  def ensure_solid_cache_columns!
    add_column :solid_cache_entries, :key_hash, :bigint unless column_exists?(:solid_cache_entries, :key_hash)
    add_column :solid_cache_entries, :byte_size, :integer unless column_exists?(:solid_cache_entries, :byte_size)
  end

  def ensure_solid_cache_indexes!
    add_index :solid_cache_entries, :key_hash, unique: true, if_not_exists: true
    add_index :solid_cache_entries, [:key_hash, :byte_size], if_not_exists: true
    add_index :solid_cache_entries, :byte_size, if_not_exists: true
    remove_index :solid_cache_entries, column: :key, if_exists: true
  end
end
