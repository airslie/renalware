# rubocop:disable-next Metrics/ClassLength
class RestructureSystemDashboardTables < ActiveRecord::Migration[8.0]
  def up
    within_renalware_schema do
      safety_assured do
        restructure_widgets
        create_widget_roles
        restructure_dashboards
        restructure_placements
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def restructure_widgets
    rename_table :system_components, :system_dashboard_widgets
    change_table_comment :system_dashboard_widgets, "Ruby view components registered for use on dashboards"

    remove_index :system_dashboard_widgets, :roles
    remove_column :system_dashboard_widgets, :roles
    remove_column :system_dashboard_widgets, :dashboard
    remove_index :system_dashboard_widgets, :class_name
    add_index :system_dashboard_widgets, :class_name, unique: true

    add_column(
      :system_dashboard_widgets,
      :key,
      :string,
      comment: "Stable immutable identifier e.g. user_activity"
    )
    add_column :system_dashboard_widgets, :description, :text
    execute "UPDATE system_dashboard_widgets SET key = lower(regexp_replace(name, '[^a-zA-Z0-9]+', '_', 'g'))"
    change_column_null :system_dashboard_widgets, :key, false
    add_index :system_dashboard_widgets, :key, unique: true
    change_column_comment :system_dashboard_widgets, :class_name, "Component class e.g. Renalware::.."
  end

  def create_widget_roles
    create_table(
      :system_dashboard_widget_roles,
      comment: "The roles whose users may see a dashboard widget. No rows means visible to no one"
    ) do |t|
      t.references(
        :widget,
        null: false,
        index: false,
        foreign_key: { to_table: :system_dashboard_widgets, on_delete: :cascade }
      )
      t.references(
        :role,
        null: false,
        type: :integer,
        index: true,
        foreign_key: { to_table: :roles, on_delete: :cascade }
      )
      t.timestamps null: false
    end
    add_index :system_dashboard_widget_roles, %i(widget_id role_id), unique: true
  end

  def restructure_dashboards
    remove_index :system_dashboards, :name
    remove_index :system_dashboards, :user_id
    remove_foreign_key :system_dashboards, column: :cloned_from_dashboard_id

    add_column(
      :system_dashboards,
      :key,
      :string,
      comment: "Stable immutable identifier e.g. admin"
    )
    execute <<~SQL.squish
      UPDATE system_dashboards SET key = lower(regexp_replace(coalesce(name, id::text), '[^a-zA-Z0-9]+', '_', 'g'))
    SQL
    change_column_null :system_dashboards, :key, false
    change_column_null :system_dashboards, :name, false, "Dashboard"
    change_column_comment(
      :system_dashboards,
      :cloned_from_dashboard_id,
      "If the user customised their dashboard we store the original here"
    )

    add_index :system_dashboards, :key, unique: true, where: "user_id IS NULL", name: "idx_system_dashboards_global_key"
    add_index(
      :system_dashboards,
      %i(user_id cloned_from_dashboard_id),
      unique: true,
      where: "user_id IS NOT NULL",
      name: "idx_system_dashboards_user_clone"
    )
    add_foreign_key :system_dashboards, :users, column: :user_id, on_delete: :cascade
    add_foreign_key(
      :system_dashboards,
      :system_dashboards,
      column: :cloned_from_dashboard_id,
      on_delete: :nullify
    )
  end

  def restructure_placements
    rename_table :system_dashboard_components, :system_dashboard_placements
    change_table_comment :system_dashboard_placements, "A widget placed on a dashboard"

    remove_foreign_key :system_dashboard_placements, column: :component_id
    remove_foreign_key :system_dashboard_placements, column: :dashboard_id
    rename_column :system_dashboard_placements, :component_id, :widget_id

    remove_index :system_dashboard_placements, name: "idx_dashboard_component_useage_unique"
    remove_index :system_dashboard_placements, name: "idx_dashboard_component_position"

    change_column_null :system_dashboard_placements, :dashboard_id, false
    change_column_null :system_dashboard_placements, :widget_id, false
    change_column_default :system_dashboard_placements, :position, from: 1, to: nil
    add_column :system_dashboard_placements, :settings, :jsonb, null: false, default: {}, comment: "e.g. wrapper_classes (Tailwind)"

    add_index(
      :system_dashboard_placements,
      %i(dashboard_id widget_id),
      unique: true,
      name: "idx_dashboard_placement_widget_unique",
      comment: "Allow only one instance of a widget on any dashboard"
    )
    add_index(
      :system_dashboard_placements,
      %i(dashboard_id position),
      name: "idx_dashboard_placement_position"
    )
    add_foreign_key :system_dashboard_placements, :system_dashboards, column: :dashboard_id, on_delete: :cascade
    add_foreign_key :system_dashboard_placements, :system_dashboard_widgets, column: :widget_id, on_delete: :restrict
  end
end
