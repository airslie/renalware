class AddUniqueIndexToLetterSectionSnapshots < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index(
      :letter_section_snapshots,
      [:letter_id, :section_identifier],
      unique: true,
      algorithm: :concurrently,
      name: "index_unique_on_letter_id_and_section_identifier"
    )
  end
end
