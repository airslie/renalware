class AddDeletedAtToPatientBookmarks < ActiveRecord::Migration[4.2]
  def up
    add_column :patient_bookmarks, :deleted_at, :datetime
    remove_index(:patient_bookmarks, [:patient_id, :user_id])
    add_index :patient_bookmarks, :patient_id

    # We'd like to have a unique index on [patient, user, deleted_at]
    # so that there can only ever be one un-deleted (deleted_at == NULL)
    # patient+user combination - ie you can't bookmark a patient twice.
    # However we also want to allow historical duplicates - there can be
    # many of the same patient+user combination as long as they have a different
    # deleted_at datetime. Because NULLs don't help in the index for our un-deleted
    # scenario (deleted_at == NULL) we have to coalesce those NULLs into the same
    # valid date. This lets us have a unique index when deleted_at is NULL.
    connection.execute(
      "CREATE UNIQUE INDEX patient_bookmarks_uniqueness
      ON patient_bookmarks
      (patient_id, user_id, COALESCE(deleted_at, '1970-01-01'));"
    )
  end

  def down
    remove_index(:patient_bookmarks, name: :patient_bookmarks_uniqueness)
    remove_column :patient_bookmarks, :deleted_at, :datetime
    add_index(:patient_bookmarks, [:patient_id, :user_id], unique: true)
    remove_index :patient_bookmarks, :patient_id
  end
end
