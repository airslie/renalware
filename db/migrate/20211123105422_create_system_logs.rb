class CreateSystemLogs < ActiveRecord::Migration[5.2]
  def change
    create_enum :system_log_severity, %w(info warning error)
    create_enum :system_log_group, %w(users admin superadmin developer)
    create_table :system_logs do |t|
      t.enum :severity, enum_type: :system_log_severity, null: false, default: :info, inudex: true
      t.enum :group, enum_type: :system_log_group, null: false, default: :users, index: true
      t.references(
        :owner,
        foreign_key: { to_table: :users },
        index: true,
        comment: "Optional - if targetted at a specific user"
      )
      t.text :message
      t.timestamps null: false
    end
  end
end
