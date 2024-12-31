class ChangeProcedurePerformedBy < ActiveRecord::Migration[4.2]
  def up
    # Note have taken the decision not to move Users referenced by perform_by_id
    # into the new performed_by string column as it is unlikely there will be anyone affected
    # at this stage in development.
    begin
      remove_foreign_key :access_procedures, :performed_by
      remove_reference :access_procedures, :performed_by, index: true
    rescue
    end
    add_column :access_procedures, :performed_by, :string, null: true, index: true
  end

  def down
    remove_column :access_procedures, :performed_by, index: true
    add_reference :access_procedures, :performed_by, references: :users, index: true, null: true
    add_foreign_key :access_procedures, :users, column: :performed_by_id
  end
end
