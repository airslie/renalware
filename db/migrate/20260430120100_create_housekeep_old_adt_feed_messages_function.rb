class CreateHousekeepOldAdtFeedMessagesFunction < ActiveRecord::Migration[7.1]
  def up
    within_renalware_schema do
      return if function_exists?

      load_function("housekeep_old_adt_feed_messages_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("drop function if exists renalware.housekeep_old_adt_feed_messages")
    end
  end

  private

  def function_exists?
    connection.select_value(<<~SQL.squish)
      select exists (
        select 1
        from pg_proc
        join pg_namespace on pg_namespace.oid = pg_proc.pronamespace
        where pg_namespace.nspname = 'renalware'
        and pg_proc.proname = 'housekeep_old_adt_feed_messages'
      )
    SQL
  end
end
