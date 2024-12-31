namespace :system do
  desc "Execute a specific SQL function eg rake system:execute_sql_fn sql_fn=test_fn(123)"
  task execute_sql_fn: :environment do
    sql_fn = ENV.fetch("sql_fn")
    Renalware::System::SqlFunctionJob.perform_now(sql_fn)
  end
end
