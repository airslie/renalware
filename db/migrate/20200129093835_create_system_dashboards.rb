class CreateSystemDashboards < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :system_dashboards do |t|
        t.string(
          :name,
          index: { unique: true },
          comment: "A named dashboard e.g. default, hd_nurse"
        )
        t.text :description
        t.references(
          :user,
          index: false,
          null: true,
          comment: "If present, this dashboard belongs to a user e.g. they have customised a " \
                   "named dashboard to make it their own"
        )
        t.references(
          :cloned_from_dashboard,
          null: true,
          foreign_key: { to_table: :system_dashboards },
          comment: "Is the user customised their dashboard we store the original here"
        )
        t.timestamps null: false
      end
      add_index :system_dashboards, :user_id, unique: true

      create_table(
        :system_components,
        comment: "Available ruby display widgets for use e.g. in dashboards"
      ) do |t|
        t.string :class_name, null: false, index: true, comment: "Component class eg Renalware::.."
        t.string(
          :name,
          null: false,
          index: { unique: true },
          comment: "Friendly component name e.g. 'Letters in Progress'"
        )
        t.boolean :dashboard, default: true, null: false, comment: "If true, can use on dashboards"
        t.string :roles, index: true, comment: "Who can use or be assigned this component"
        t.timestamps null: true
      end

      create_table :system_dashboard_components, comment: "Defines dashboard content" do |t|
        t.references(
          :dashboard,
          foreign_key: { to_table: :system_dashboards }
        )
        t.references(
          :component,
          foreign_key: { to_table: :system_components }
        )
        t.integer :position, null: false, default: 1
        t.timestamps null: false
      end

      add_index(
        :system_dashboard_components,
        [:dashboard_id, :component_id],
        unique: true,
        name: "idx_dashboard_component_useage_unique",
        comment: "Allow only one instance of a component on any dashboard"
      )

      add_index(
        :system_dashboard_components,
        [:dashboard_id, :position],
        unique: true,
        name: "idx_dashboard_component_position",
        comment: "Position must be unique within a dashboard"
      )
    end
  end
end
