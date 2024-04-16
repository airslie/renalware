create or replace function renalware.feed_sausages_upsert_from_mirth(
  _sent_at timestamp,
  _message_type renalware.hl7_message_type,
  _event_type renalware.hl7_event_type,
  _orc_filler_order_number varchar,
  _orc_order_status renalware.enum_hl7_orc_order_status,
  _header_id varchar,
  _body text,
  _nhs_number varchar,
  _dob date,
  _local_patient_id varchar,
  _local_patient_id_2 varchar,
  _local_patient_id_3 varchar,
  _local_patient_id_4 varchar,
  _local_patient_id_5 varchar
)
/*
 * Fn called by mirth to upsert a row into the feed_sausages table.
 */
RETURNS TABLE(sausage_id bigint, sausage_queue_id bigint)
  AS $$
  declare id_of_upserted_feed_sausage bigint;
  declare id_of_inserted_feed_sausage_queue bigint;
  BEGIN

    if _message_type = 'ORU' and (_orc_filler_order_number = '' or _orc_filler_order_number is null) then
      RAISE EXCEPTION 'orc_filler_order_number cannot be blank';
    end if;

    -- The ON CONFLICT after this insert means that where orc_filler_order_number is not null or ''
    -- (ie its an ORU path message, since ADTs do not have an orc_filler_order_number)
    -- then only one unique value is allowed in the table (see index in a migration),
    -- and if you try to insert a row with an
    -- orc_filler_order_number that already exist, the DO UPDATE will execute to replace the
    -- the row's content with the new content (body, nhs_number etc) but only if the messages was
    -- sent from the lab _more recently_ than the stored one.
    -- TODO: what happens if > 1 lab send the same value? Not a problem at MSE say where
    -- a SHO- prefix is used on the orc_filler_order_number
    insert into renalware.feed_sausages (
      sent_at,
      message_type,
      event_type,
      orc_filler_order_number,
      orc_order_status,
      header_id,
      body,
      nhs_number,
      local_patient_id,
      local_patient_id_2,
      local_patient_id_3,
      local_patient_id_4,
      local_patient_id_5,
      dob,
      created_at,
      updated_at
    ) values (
      _sent_at,
      _message_type,
      _event_type,
      _orc_filler_order_number,
      _orc_order_status,
      _header_id,
      _body,
      _nhs_number,
      _local_patient_id,
      _local_patient_id_2,
      _local_patient_id_3,
      _local_patient_id_4,
      _local_patient_id_5,
      _dob,
      current_timestamp,
      current_timestamp
    )
    on conflict (orc_filler_order_number) where (orc_filler_order_number is not null and orc_filler_order_number != '')
    do update
    set
      sent_at             = EXCLUDED.sent_at,
      version             = feed_sausages.version + 1,
      message_type        = EXCLUDED.message_type,
      event_type          = EXCLUDED.event_type,
      orc_order_status    = EXCLUDED.orc_order_status,
      header_id           = EXCLUDED.header_id,
      body                = EXCLUDED.body,
      nhs_number          = EXCLUDED.nhs_number,
      local_patient_id    = EXCLUDED.local_patient_id,
      local_patient_id_2  = EXCLUDED.local_patient_id_2,
      local_patient_id_3  = EXCLUDED.local_patient_id_3,
      local_patient_id_4  = EXCLUDED.local_patient_id_4,
      local_patient_id_5  = EXCLUDED.local_patient_id_5,
      dob                 = EXCLUDED.dob,
      updated_at          = current_timestamp
      where EXCLUDED.sent_at > feed_sausages.sent_at
      and EXCLUDED.header_id::integer > feed_sausages.header_id::integer
      RETURNING feed_sausages.id into id_of_upserted_feed_sausage;
    --
    if id_of_upserted_feed_sausage > 0 then
      -- might be interesting here to know if its an insert or an update? ir as an extra col?
      -- there is also some scope somewhere for storing the count of messages received or one
      -- one orc_filler_order_number, but probably not that useful
      insert into renalware.feed_sausage_queue (feed_sausage_id, created_at, updated_at)
      values (id_of_upserted_feed_sausage, current_timestamp, current_timestamp)
      returning feed_sausage_queue.id into id_of_inserted_feed_sausage_queue;
    end if;

    return query(select id_of_upserted_feed_sausage, id_of_inserted_feed_sausage_queue);
  END;
$$ LANGUAGE plpgsql;
