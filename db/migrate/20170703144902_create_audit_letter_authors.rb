class CreateAuditLetterAuthors < ActiveRecord::Migration[5.0]
  def change
    create_view :reporting_main_authors_audit, materialized: true
    add_index :reporting_main_authors_audit,
              [:year, :month, :user_id],
              unique: true,
              name: "main_authors_audit_year_month_user_id"
  end
end
