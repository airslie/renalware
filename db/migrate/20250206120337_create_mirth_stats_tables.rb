class CreateMirthStatsTables < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :monitoring_mirth_channel_groups do |t|
        t.uuid :uuid, null: false, index: { unique: true }
        t.text :name, null: false
        t.timestamps null: false
      end

      create_table :monitoring_mirth_channels do |t|
        t.uuid :uuid, null: false, index: { unique: true }
        t.references(
          :channel_group,
          foreign_key: { to_table: :monitoring_mirth_channel_groups },
          index: true
        )
        t.text :name, null: false
        t.timestamps null: false
      end

      create_table :monitoring_mirth_channel_stats do |t|
        t.references(
          :channel,
          foreign_key: { to_table: :monitoring_mirth_channels },
          null: false,
          index: true
        )
        t.integer :received, default: 0, null: false
        t.integer :sent, default: 0, null: false
        t.integer :error, default: 0, null: false
        t.integer :queued, default: 0, null: false
        t.integer :filtered, default: 0, null: false
        t.timestamps null: false
      end
      # index created_at on stats to make chart generation faster
      add_index :monitoring_mirth_channel_stats, :created_at
    end
  end
end
