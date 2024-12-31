class CreateUserGroups < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :user_groups do |t|
        t.string(
          :name,
          index: { unique: true },
          null: false,
          comment: "e.g. 'Transplant Cordinators'"
        )
        t.string :description
        t.boolean(
          :active,
          default: true,
          null: false,
          index: true,
          comment: "If false, the group will not be displayed anywhere prospectively"
        )
        t.integer(
          :memberships_count,
          null: false,
          default: 0,
          comment: "Counter cache for the number of memberships in this group"
        )
        t.boolean(
          :letter_electronic_ccs,
          null: false,
          default: false,
          comment: "If true, the group can be chosen from the electronic CCs recipients " \
                   "dropdown in letters"
        )
        t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
        t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
        t.timestamps null: false
      end

      create_table :user_group_memberships do |t|
        t.references :user, null: false, foreign_key: true
        t.references :user_group, null: false, foreign_key: true
        t.timestamps null: false
        t.index [:user_id, :user_group_id], unique: true
      end
    end
  end
end
