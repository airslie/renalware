class AddStatusToLetterMailshotMailshots < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum(
        :background_job_status,
        %w(queued processing success failure)
      )
      change_table :letter_mailshot_mailshots do |t|
        t.enum :status, enum_type: :background_job_status
        t.text :last_error
      end
    end
  end
end
