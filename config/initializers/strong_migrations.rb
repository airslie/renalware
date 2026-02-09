# Mark existing migrations as safe.
StrongMigrations.start_after = 20250209000000

# Set timeouts for migrations.
# If you use PgBouncer in transaction mode, delete these lines and set timeouts on the database user.
StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.statement_timeout = 1.hour

# Analyze tables after indexes are added.
# Outdated statistics can sometimes hurt performance.
StrongMigrations.auto_analyze = true
