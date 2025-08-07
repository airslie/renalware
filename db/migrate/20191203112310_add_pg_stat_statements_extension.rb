class AddPgStatStatementsExtension < ActiveRecord::Migration[5.2]
  def change
    # enable_extension "pg_stat_statements" # Azure flexible disallows this unless an azure admin.
    enable_extension "plpgsql"
  end
end
