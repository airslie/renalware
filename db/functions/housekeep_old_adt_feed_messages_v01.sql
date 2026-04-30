create or replace function renalware.housekeep_old_adt_feed_messages()
/*
 * Deletes a small batch of old ADT feed_messages, oldest first.
 *
 * The function is intended to be called repeatedly by pg_cron. To tune batch
 * size or retention without a code release, replace this function in the DB.
 */
returns table(
  run_id bigint,
  deleted_count integer,
  cutoff_sent_at timestamp,
  oldest_deleted_sent_at timestamp,
  newest_deleted_sent_at timestamp
)
as $$
declare
  v_function_name text := 'housekeep_old_adt_feed_messages';
  v_started_at timestamp := current_timestamp;
  v_cutoff_sent_at timestamp := current_timestamp - interval '6 months';
  v_message_type renalware.hl7_message_type := 'ADT';
  v_retention_period interval := interval '6 months';
  v_batch_size integer := 5000;
  v_run_id bigint;
  v_deleted_count integer := 0;
  v_oldest_deleted_sent_at timestamp;
  v_newest_deleted_sent_at timestamp;
begin
  insert into renalware.feed_message_housekeeping_runs (
    function_name,
    started_at,
    message_type,
    retention_period,
    batch_size,
    cutoff_sent_at,
    created_at,
    updated_at
  ) values (
    v_function_name,
    v_started_at,
    v_message_type,
    v_retention_period,
    v_batch_size,
    v_cutoff_sent_at,
    current_timestamp,
    current_timestamp
  )
  returning id into v_run_id;

  begin
    create temporary table if not exists feed_message_housekeeping_candidates(
      id integer primary key,
      sent_at timestamp
    ) on commit drop;

    truncate table feed_message_housekeeping_candidates;

    insert into feed_message_housekeeping_candidates(id, sent_at)
    select feed_messages.id, feed_messages.sent_at
    from renalware.feed_messages
    where feed_messages.message_type = v_message_type
    and feed_messages.sent_at < v_cutoff_sent_at
    and not exists (
      select 1
      from renalware.patient_merge_merges
      where patient_merge_merges.feed_message_id = feed_messages.id
    )
    order by feed_messages.sent_at asc, feed_messages.id asc
    limit v_batch_size
    for update of feed_messages skip locked;

    update renalware.feed_logs
    set message_id = null,
        updated_at = current_timestamp
    where message_id in (
      select id
      from feed_message_housekeeping_candidates
    );

    update renalware.feed_message_replays
    set message_id = null,
        updated_at = current_timestamp
    where message_id in (
      select id
      from feed_message_housekeeping_candidates
    );

    with deleted as (
      delete from renalware.feed_messages
      where id in (
        select id
        from feed_message_housekeeping_candidates
      )
      returning sent_at
    )
    select
      count(*)::integer,
      min(deleted.sent_at),
      max(deleted.sent_at)
    into
      v_deleted_count,
      v_oldest_deleted_sent_at,
      v_newest_deleted_sent_at
    from deleted;
  exception
    when others then
      update renalware.feed_message_housekeeping_runs
      set finished_at = current_timestamp,
          error_message = sqlerrm,
          updated_at = current_timestamp
      where id = v_run_id;

      return query
      select
        v_run_id,
        0,
        v_cutoff_sent_at,
        null::timestamp,
        null::timestamp;
  end;

  update renalware.feed_message_housekeeping_runs
  set finished_at = current_timestamp,
      deleted_count = v_deleted_count,
      oldest_deleted_sent_at = v_oldest_deleted_sent_at,
      newest_deleted_sent_at = v_newest_deleted_sent_at,
      updated_at = current_timestamp
  where id = v_run_id;

  return query
  select
    v_run_id,
    v_deleted_count,
    v_cutoff_sent_at,
    v_oldest_deleted_sent_at,
    v_newest_deleted_sent_at;
end;
$$ language plpgsql;
