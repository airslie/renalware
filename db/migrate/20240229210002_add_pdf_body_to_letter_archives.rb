class AddPdfBodyToLetterArchives < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column(
        :letter_archives,
        :pdf_content,
        :binary,
        comment: "Binary PDF letter data created by e.g. prawn. Definitive record of what was sent"
      )
    end
  end
end
