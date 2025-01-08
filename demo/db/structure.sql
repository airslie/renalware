SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: renalware; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA renalware;


--
-- Name: renalware_demo; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA renalware_demo;


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA renalware;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: intarray; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;


--
-- Name: EXTENSION intarray; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA renalware;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA renalware;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA renalware;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: access_needling_assessment_difficulties; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.access_needling_assessment_difficulties AS ENUM (
    'easy',
    'moderate',
    'hard'
);


--
-- Name: background_job_status; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.background_job_status AS ENUM (
    'queued',
    'processing',
    'success',
    'failure'
);


--
-- Name: clinical_body_composition_pre_post_hd; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.clinical_body_composition_pre_post_hd AS ENUM (
    'pre',
    'post'
);


--
-- Name: duration; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.duration AS ENUM (
    'minute',
    'hour',
    'day',
    'week',
    'month',
    'year'
);


--
-- Name: enum_colour_name; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_colour_name AS ENUM (
    'slate',
    'gray',
    'zinc',
    'neutral',
    'stone',
    'red',
    'orange',
    'amber',
    'yellow',
    'lime',
    'green',
    'emerald',
    'teal',
    'cyan',
    'sky',
    'blue',
    'indigo',
    'violet',
    'purple',
    'fuchsia',
    'pink',
    'rose'
);


--
-- Name: enum_feed_log_reason; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_feed_log_reason AS ENUM (
    'number_hit_dob_miss'
);


--
-- Name: enum_feed_log_type; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_feed_log_type AS ENUM (
    'close_match'
);


--
-- Name: enum_hd_slot_request_urgency; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_hd_slot_request_urgency AS ENUM (
    'routine',
    'urgent',
    'highly_urgent',
    'allocated'
);


--
-- Name: enum_hl7_observation_result_status_codes; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_hl7_observation_result_status_codes AS ENUM (
    'C',
    'D',
    'F',
    'I',
    'N',
    'O',
    'P',
    'R',
    'S',
    'U',
    'W',
    'X'
);


--
-- Name: enum_hl7_orc_order_status; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_hl7_orc_order_status AS ENUM (
    'A',
    'CA',
    'CM',
    'DC',
    'ER',
    'HD',
    'IP',
    'RP',
    'SC'
);


--
-- Name: enum_letters_gp_send_status; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_letters_gp_send_status AS ENUM (
    'not_applicable',
    'pending',
    'success',
    'failure'
);


--
-- Name: enum_mesh_api_action; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_mesh_api_action AS ENUM (
    'endpointlookup',
    'handshake',
    'check_inbox',
    'download_message',
    'acknowledge_message',
    'send_message'
);


--
-- Name: enum_mesh_itk3_response_type; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_mesh_itk3_response_type AS ENUM (
    'inf',
    'bus',
    'unknown'
);


--
-- Name: enum_mesh_message_direction; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_mesh_message_direction AS ENUM (
    'outbound',
    'inbound'
);


--
-- Name: enum_mesh_transmission_status; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_mesh_transmission_status AS ENUM (
    'pending',
    'success',
    'failure',
    'cancelled'
);


--
-- Name: enum_patient_landing_page; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.enum_patient_landing_page AS ENUM (
    'accesses',
    'admissions',
    'akcc',
    'clinic_visits',
    'clinical',
    'clinical_summary',
    'demographics',
    'events',
    'hd',
    'letters',
    'low_clearance',
    'modalities',
    'pathology',
    'pd',
    'prescriptions',
    'problems',
    'renal',
    'transplants_donor',
    'transplants_recipient',
    'virology'
);


--
-- Name: feed_outgoing_document_state; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.feed_outgoing_document_state AS ENUM (
    'queued',
    'errored',
    'processed'
);


--
-- Name: hd_vnd_risk_level_itemised; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.hd_vnd_risk_level_itemised AS ENUM (
    '0_very_low',
    '0_low',
    '1_low',
    '1_medium',
    '2_medium',
    '2_high'
);


--
-- Name: hd_vnd_risk_level_overall; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.hd_vnd_risk_level_overall AS ENUM (
    'low',
    'medium',
    'high'
);


--
-- Name: hl7_event_type; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.hl7_event_type AS ENUM (
    'A01',
    'A02',
    'A03',
    'A04',
    'A05',
    'A06',
    'A07',
    'A08',
    'A09',
    'A10',
    'A11',
    'A12',
    'A13',
    'A14',
    'A15',
    'A16',
    'A17',
    'A18',
    'A19',
    'A20',
    'A21',
    'A22',
    'A23',
    'A24',
    'A25',
    'A26',
    'A27',
    'A28',
    'A29',
    'A30',
    'A31',
    'A32',
    'A33',
    'A34',
    'A35',
    'A36',
    'A37',
    'A38',
    'A39',
    'A40',
    'A41',
    'A42',
    'A43',
    'A44',
    'A45',
    'A46',
    'A47',
    'A48',
    'A49',
    'A50',
    'A51',
    'A52',
    'A53',
    'A54',
    'A55',
    'A60',
    'A61',
    'A62',
    'B01',
    'B02',
    'B03',
    'B04',
    'B05',
    'B06',
    'B07',
    'B08',
    'C01',
    'C02',
    'C03',
    'C04',
    'C05',
    'C06',
    'C07',
    'C08',
    'C09',
    'C10',
    'C11',
    'C12',
    'E01',
    'E02',
    'E03',
    'E04',
    'E10',
    'E12',
    'E13',
    'E15',
    'E20',
    'E21',
    'E22',
    'E24',
    'E30',
    'E31',
    'I01',
    'I02',
    'I03',
    'I04',
    'I05',
    'I06',
    'I07',
    'I08',
    'I09',
    'I10',
    'I11',
    'I12',
    'I13',
    'I14',
    'I15',
    'I16',
    'I17',
    'I18',
    'I19',
    'I20',
    'I21',
    'I22',
    'J01',
    'J02',
    'K11',
    'K13',
    'K15',
    'K21',
    'K22',
    'K23',
    'K24',
    'K25',
    'K31',
    'K32',
    'M01',
    'M02',
    'M03',
    'M04',
    'M05',
    'M06',
    'M07',
    'M08',
    'M09',
    'M10',
    'M11',
    'M12',
    'M13',
    'M14',
    'M15',
    'M16',
    'M17',
    'N01',
    'N02',
    'O01',
    'O02',
    'O03',
    'O04',
    'O05',
    'O06',
    'O07',
    'O08',
    'O09',
    'O10',
    'O11',
    'O12',
    'O13',
    'O14',
    'O15',
    'O16',
    'O17',
    'O18',
    'O19',
    'O20',
    'O21',
    'O22',
    'O23',
    'O24',
    'O25',
    'O26',
    'O27',
    'O28',
    'O29',
    'O30',
    'O31',
    'O32',
    'O33',
    'O34',
    'O35',
    'O36',
    'O37',
    'O38',
    'O39',
    'O40',
    'P01',
    'P02',
    'P03',
    'P04',
    'P05',
    'P06',
    'P07',
    'P08',
    'P09',
    'P10',
    'P11',
    'P12',
    'PC1',
    'PC2',
    'PC3',
    'PC4',
    'PC5',
    'PC6',
    'PC7',
    'PC8',
    'PC9',
    'PCA',
    'PCB',
    'PCC',
    'PCD',
    'PCE',
    'PCF',
    'PCG',
    'PCH',
    'PCJ',
    'PCK',
    'PCL',
    'Q01',
    'Q02',
    'Q03',
    'Q05',
    'Q06',
    'Q11',
    'Q13',
    'Q15',
    'Q16',
    'Q17',
    'Q21',
    'Q22',
    'Q23',
    'Q24',
    'Q25',
    'Q26',
    'Q27',
    'Q28',
    'Q29',
    'Q30',
    'Q31',
    'Q32',
    'R01',
    'R02',
    'R04',
    'R21',
    'R22',
    'R23',
    'R24',
    'R25',
    'R26',
    'R30',
    'R31',
    'R32',
    'R33',
    'ROR',
    'S01',
    'S02',
    'S03',
    'S04',
    'S05',
    'S06',
    'S07',
    'S08',
    'S09',
    'S10',
    'S11',
    'S12',
    'S13',
    'S14',
    'S15',
    'S16',
    'S17',
    'S18',
    'S19',
    'S20',
    'S21',
    'S22',
    'S23',
    'S24',
    'S25',
    'S26',
    'S27',
    'S28',
    'S29',
    'S30',
    'S31',
    'S32',
    'S33',
    'S34',
    'S35',
    'S36',
    'S37',
    'T01',
    'T02',
    'T03',
    'T04',
    'T05',
    'T06',
    'T07',
    'T08',
    'T09',
    'T10',
    'T11',
    'T12',
    'U01',
    'U02',
    'U03',
    'U04',
    'U05',
    'U06',
    'U07',
    'U08',
    'U09',
    'U10',
    'U11',
    'U12',
    'U13',
    'V01',
    'V02',
    'V03',
    'V04',
    'W01',
    'W02',
    'Z73',
    'Z74',
    'Z75',
    'Z76',
    'Z77',
    'Z78',
    'Z79',
    'Z80',
    'Z81',
    'Z82',
    'Z83',
    'Z84',
    'Z85',
    'Z86',
    'Z87',
    'Z88',
    'Z89',
    'Z90',
    'Z91',
    'Z92',
    'Z93',
    'Z94',
    'Z95',
    'Z96',
    'Z97',
    'Z98',
    'Z99'
);


--
-- Name: hl7_message_type; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.hl7_message_type AS ENUM (
    'ACK',
    'ADR',
    'ADT',
    'BAR',
    'BPS',
    'BRP',
    'BRT',
    'BTS',
    'CCF',
    'CCI',
    'CCM',
    'CCQ',
    'CCU',
    'CQU',
    'CRM',
    'CSU',
    'DFT',
    'DOC',
    'DSR',
    'EAC',
    'EAN',
    'EAR',
    'EHC',
    'ESR',
    'ESU',
    'INR',
    'INU',
    'LSR',
    'LSU',
    'MDM',
    'MFD',
    'MFK',
    'MFN',
    'MFQ',
    'MFR',
    'NMD',
    'NMQ',
    'NMR',
    'OMB',
    'OMD',
    'OMG',
    'OMI',
    'OML',
    'OMN',
    'OMP',
    'OMS',
    'OPL',
    'OPR',
    'OPU',
    'ORA',
    'ORB',
    'ORD',
    'ORF',
    'ORG',
    'ORI',
    'ORL',
    'ORM',
    'ORN',
    'ORP',
    'ORR',
    'ORS',
    'ORU',
    'OSM',
    'OSQ',
    'OSR',
    'OUL',
    'PEX',
    'PGL',
    'PIN',
    'PMU',
    'PPG',
    'PPP',
    'PPR',
    'PPT',
    'PPV',
    'PRR',
    'PTR',
    'QBP',
    'QCK',
    'QCN',
    'QRY',
    'QSB',
    'QSX',
    'QVR',
    'RAR',
    'RAS',
    'RCI',
    'RCL',
    'RDE',
    'RDR',
    'RDS',
    'RDY',
    'REF',
    'RER',
    'RGR',
    'RGV',
    'ROR',
    'RPA',
    'RPI',
    'RPL',
    'RPR',
    'RQA',
    'RQC',
    'RQI',
    'RQP',
    'RRA',
    'RRD',
    'RRE',
    'RRG',
    'RRI',
    'RSP',
    'RTB',
    'SCN',
    'SDN',
    'SDR',
    'SIU',
    'SLN',
    'SLR',
    'SMD',
    'SQM',
    'SQR',
    'SRM',
    'SRR',
    'SSR',
    'SSU',
    'STC',
    'STI',
    'SUR',
    'TBR',
    'TCR',
    'TCU',
    'UDM',
    'VXQ',
    'VXR',
    'VXU',
    'VXX'
);


--
-- Name: nursing_experience_level_enum; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.nursing_experience_level_enum AS ENUM (
    'very_low',
    'low',
    'medium',
    'high',
    'very_high'
);


--
-- Name: pathology_chart_axis; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.pathology_chart_axis AS ENUM (
    'y1',
    'y2'
);


--
-- Name: pd_pet_type; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.pd_pet_type AS ENUM (
    'full',
    'fast'
);


--
-- Name: problem_date_display_style_enum; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.problem_date_display_style_enum AS ENUM (
    'y',
    'my',
    'dmy'
);


--
-- Name: system_log_group; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.system_log_group AS ENUM (
    'users',
    'admin',
    'superadmin',
    'developer'
);


--
-- Name: system_log_severity; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.system_log_severity AS ENUM (
    'info',
    'warning',
    'error'
);


--
-- Name: system_nag_definition_scope; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.system_nag_definition_scope AS ENUM (
    'patient',
    'user'
);


--
-- Name: system_nag_severity; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.system_nag_severity AS ENUM (
    'none',
    'info',
    'low',
    'medium',
    'high'
);


--
-- Name: system_view_category; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.system_view_category AS ENUM (
    'mdm',
    'report'
);


--
-- Name: system_view_display_type; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.system_view_display_type AS ENUM (
    'tabular'
);


--
-- Name: tristate_type; Type: TYPE; Schema: renalware; Owner: -
--

CREATE TYPE renalware.tristate_type AS ENUM (
    'unknown',
    'no',
    'yes'
);


--
-- Name: audit_view_as_json(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.audit_view_as_json(view_name text) RETURNS json
    LANGUAGE plpgsql
    AS $$ DECLARE result json;

BEGIN EXECUTE format(
  '
  select row_to_json(t)
    from (
      select
        current_timestamp as runat,
        (select array_to_json(array_agg(row_to_json(d))
      )
    from (select * from %s) d) as data) t;
    ',
  quote_ident(view_name)
) into result;

return result;

END $$;


--
-- Name: convert_to_float(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.convert_to_float(v_input text) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE v_float_value FLOAT DEFAULT NULL;
BEGIN
    -- return the value as a float or 0 if the value cannot be coerced into a float
    BEGIN
        v_float_value := v_input::FLOAT;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Invalid float value: "%".  Returning NULL.', v_input;
        RETURN 0;
    END;
RETURN v_float_value;
END;
$$;


--
-- Name: convert_to_float(text, double precision); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.convert_to_float(v_input text, default_value_if_cannot_be_coerced double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE v_float_value float DEFAULT NULL;
BEGIN
    BEGIN
        v_float_value := v_input::float;
    EXCEPTION WHEN OTHERS THEN
        RETURN default_value_if_cannot_be_coerced;
    END;
RETURN v_float_value;
END;
$$;


--
-- Name: FUNCTION convert_to_float(v_input text, default_value_if_cannot_be_coerced double precision); Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON FUNCTION renalware.convert_to_float(v_input text, default_value_if_cannot_be_coerced double precision) IS 'Tries to coerce v_input into a float (double precision) and it it cannot,
returns default_value_if_cannot_be_coerced';


--
-- Name: count_estimate(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.count_estimate(query text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec   record;
    ROWS  INTEGER;
BEGIN
    FOR rec IN EXECUTE 'EXPLAIN ' || query LOOP
        ROWS := SUBSTRING(rec."QUERY PLAN" FROM ' rows=([[:digit:]]+)');
        EXIT WHEN ROWS IS NOT NULL;
    END LOOP;

    RETURN ROWS;
END
$$;


--
-- Name: days_between(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.days_between(t_start timestamp without time zone, t_end timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
  begin
    -- calculate the days between 2 timestamps
    return (select (EXTRACT(epoch from age(t_end, t_start)) / 86400)::integer);
  end
$$;


--
-- Name: feed_sausages_upsert_from_mirth(timestamp without time zone, renalware.hl7_message_type, renalware.hl7_event_type, character varying, renalware.enum_hl7_orc_order_status, character varying, text, character varying, date, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.feed_sausages_upsert_from_mirth(_sent_at timestamp without time zone, _message_type renalware.hl7_message_type, _event_type renalware.hl7_event_type, _orc_filler_order_number character varying, _orc_order_status renalware.enum_hl7_orc_order_status, _header_id character varying, _body text, _nhs_number character varying, _dob date, _local_patient_id character varying, _local_patient_id_2 character varying, _local_patient_id_3 character varying, _local_patient_id_4 character varying, _local_patient_id_5 character varying) RETURNS TABLE(sausage_id bigint, sausage_queue_id bigint)
    LANGUAGE plpgsql
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
      where EXCLUDED.sent_at >= feed_sausages.sent_at
      and EXCLUDED.header_id::bigint > feed_sausages.header_id::bigint
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
$$;


--
-- Name: hd_diary_archive_elapsed_master_slots(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.hd_diary_archive_elapsed_master_slots() RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN

INSERT into hd_diary_slots
(
    diary_id,
    station_id,
    day_of_week,
    diurnal_period_code_id,
    patient_id,
    created_by_id,
    updated_by_id,
    created_at,
    updated_at,
    deleted_at
)
(
    select
        weekly_diary_id,
        station_id,
        day_of_week,
        diurnal_period_code_id,
        patient_id,
        master_slot_created_by_id,
        master_slot_updated_by_id,
        master_slot_created_at,
        master_slot_updated_at,
        deleted_at
    from renalware.hd_diary_matrix -- a SQL view
    where
        weekly_slot_id is null
        and master_slot_id is not null
        and master_slot_created_at <= slot_date
        and slot_date >= now() - interval '3 months'
);

END;
$$;


--
-- Name: import_feed_gps(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.import_feed_gps() RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN

  -- Upsert GPs
  WITH
   data AS (select * from feed_gps),
   gp_changes AS (
    INSERT INTO renalware.patient_primary_care_physicians (code, name, telephone, practitioner_type, created_at, updated_at)
    SELECT code, name, telephone, 'GP', clock_timestamp(), clock_timestamp()
    FROM data
    ON CONFLICT (code) DO UPDATE
      SET
       telephone = excluded.telephone,
       name = excluded.name,
       updated_at = excluded.updated_at
      where (patient_primary_care_physicians.telephone) is distinct from (excluded.telephone)
      RETURNING code, id
     )

  -- Upsert GP addresses
  INSERT INTO renalware.addresses (
    addressable_type,
    addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    created_at,
    updated_at)
  SELECT
    'Renalware::Patients::PrimaryCarePhysician' as addressable_type,
    gps.id as addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
    FROM data join patient_primary_care_physicians gps using(code)
  ON CONFLICT (addressable_type, addressable_id) DO UPDATE
    SET
    street_1 = excluded.street_1,
    street_2 = excluded.street_2,
    street_3 = excluded.street_3,
    town = excluded.town,
    county = excluded.county,
    postcode = excluded.postcode,
    updated_at = clock_timestamp()
    where (addresses.street_1, addresses.street_2, addresses.street_3)
    is distinct from (excluded.street_1, excluded.street_2, excluded.street_3);

  --GET DIAGNOSTICS changed_count = ROW_COUNT;

  -- Update the deleted_at column of any gps which do not have an Active status_code
  UPDATE renalware.patient_primary_care_physicians AS p
  SET deleted_at = CURRENT_TIMESTAMP
  FROM feed_gps AS tp
  WHERE p.code = tp.code AND tp.status IN ('C', 'P', 'B');

  -- Un-delete any previously deleted GPs
  UPDATE renalware.patient_primary_care_physicians AS gp
  SET deleted_at = NULL
  FROM feed_gps
  WHERE gp.code = feed_gps.code AND feed_gps.status IN ('A') AND gp.code NOT IN ('A');

  --GET DIAGNOSTICS deleted_count = ROW_COUNT;
  --select changed_count, deleted_count;
  END;
 $$;


--
-- Name: import_feed_practice_gps(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.import_feed_practice_gps() RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN

  /*
    1.
    Update the temporary feed_practice_gps with the correct pcp and prac ids.
    I supopse we could do this in Rails.
  */
  UPDATE feed_practice_gps F
    SET primary_care_physician_id = P.id
    FROM patient_primary_care_physicians AS P WHERE P.code = F.gp_code;

  UPDATE feed_practice_gps F
    SET practice_id = P.id
    FROM patient_practices AS P WHERE P.code = F.practice_code;

  /*
    2.
    Add any new membership rows (ignoring errors if the row already exists)
  */
  INSERT INTO renalware.patient_practice_memberships
    (practice_id, primary_care_physician_id, joined_on, left_on, active, created_at, updated_at)
  SELECT
    practice_id,
    primary_care_physician_id,
    joined_on,
    left_on,
    case when left_on is null then true else false end, --active
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM feed_practice_gps
  where practice_id is not null and primary_care_physician_id is not null
  ON CONFLICT (practice_id, primary_care_physician_id) DO NOTHING;

  /*
    3.
    Mark as deleted any memberships not in the latest uploaded data set
    as these gps have retired or moved on.
  */
  UPDATE patient_practice_memberships M
    SET deleted_at = CURRENT_TIMESTAMP
    WHERE NOT EXISTS (
      select 1 FROM feed_practice_gps T
      where T.primary_care_physician_id = M.primary_care_physician_id
      and T.practice_id = M.practice_id
    );

END;
$$;


--
-- Name: import_gps_csv(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.import_gps_csv(file text) RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN
  -- Imports a egpcur.csv.csv file created from ODS.
  -- Returns counts of changed (insert/updated) and (soft) deleted rows.

  DROP TABLE IF EXISTS tmp_gps_copy;

  -- Create a tmp table to hold the ODS-defined standard 27 field format into which we will insert out CSV data
  CREATE TEMP TABLE tmp_gps_copy (
  code text NOT NULL,
  name text NOT NULL,
  unused3 text,
  unused4 text,
  street_1 text,
  street_2 text,
  street_3 text,
  town text,
  county text,
  postcode text,
  unused11 text,
  unused12 text,
  status text, -- A = Active B = Retired C = Closed P = Proposed
  unused14 text,
  unused15 text,
  unused16 text,
  unused17 text,
  telephone text,
  unused19 text,
  unused20 text,
  unused21 text,
  amended_record_indicator text,
  unused23 text,
  unused24 text,
  unused25 text,
  unused26 text,
  unused27 text,
  CONSTRAINT tmp_gps_pkey PRIMARY KEY (code)
  );

  -- Import the CSV file into tmp_practices - note there is no CSV header in this file
  EXECUTE format ('COPY tmp_gps_copy FROM %L DELIMITER %L CSV ', file, ',');

  DROP TABLE IF EXISTS tmp_gps;
  CREATE TEMP TABLE tmp_gps AS SELECT
    code,
    name,
    telephone,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    left(status,1) as status from tmp_gps_copy ;
  ALTER TABLE tmp_gps ADD PRIMARY KEY (code);

RAISE NOTICE 'Calling cs_create_job(%)', (select status from tmp_gps limit 1);

  -- Upsert GPs
  WITH
   data AS (select * from  tmp_gps),
   gp_changes AS (
    INSERT INTO renalware.patient_primary_care_physicians (code, name, telephone, practitioner_type, created_at, updated_at)
    SELECT code, name, telephone, 'GP', clock_timestamp(), clock_timestamp()
    FROM data
    ON CONFLICT (code) DO UPDATE
      SET
       telephone = excluded.telephone,
       name = excluded.name,
       updated_at = excluded.updated_at
      where (patient_primary_care_physicians.telephone) is distinct from (excluded.telephone)
      RETURNING code, id
     )

  -- Upsert GP addresses
  INSERT INTO renalware.addresses (
    addressable_type,
    addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    created_at,
    updated_at)
  SELECT
    'Renalware::Patients::PrimaryCarePhysician' as addressable_type,
    gps.id as addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    CURRENT_TIMESTAMP as created_at,
    CURRENT_TIMESTAMP as updated_at
    FROM data join patient_primary_care_physicians gps using(code)
  ON CONFLICT (addressable_type, addressable_id) DO UPDATE
    SET
    street_1 = excluded.street_1,
    street_2 = excluded.street_2,
    street_3 = excluded.street_3,
    town = excluded.town,
    county = excluded.county,
    postcode = excluded.postcode,
    updated_at = clock_timestamp()
    where (addresses.street_1, addresses.street_2, addresses.street_3)
    is distinct from (excluded.street_1, excluded.street_2, excluded.street_3);

  --GET DIAGNOSTICS changed_count = ROW_COUNT;

  -- Update the deleted_at column of any gps which do not have an Active status_code
  UPDATE renalware.patient_primary_care_physicians AS p
  SET deleted_at = CURRENT_TIMESTAMP
  FROM tmp_gps AS tp
  WHERE p.code = tp.code AND tp.status IN ('C', 'P', 'B');

  -- Un-delete any previously deleted GPs
  UPDATE renalware.patient_primary_care_physicians AS gp
  SET deleted_at = NULL
  FROM tmp_gps
  WHERE gp.code = tmp_gps.code AND tmp_gps.status IN ('A') AND gp.code NOT IN ('A');

  --GET DIAGNOSTICS deleted_count = ROW_COUNT;
  --select changed_count, deleted_count;
  END;
 $$;


--
-- Name: import_practice_memberships_csv(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.import_practice_memberships_csv(file text) RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN

  DROP TABLE IF EXISTS copied_memberships;
  CREATE TEMP TABLE copied_memberships (
    gp_code text NOT NULL,
    practice_code text NOT NULL,
    unused3 text,
    joined_on text,
    left_on text,
    unused7 text
  );

  -- Import the CSV file into copied_memberships - note there is no CSV header in this file
  EXECUTE format ('COPY copied_memberships FROM %L DELIMITER %L CSV ', file, ',');

  DROP TABLE IF EXISTS tmp_memberships;
  CREATE TEMP TABLE tmp_memberships AS
    SELECT
      C.gp_code,
      C.practice_code,
      case C.joined_on when '' then NULL else C.joined_on::date end,
      case C.left_on when '' then NULL else C.left_on::date end,
      patient_primary_care_physicians.id primary_care_physician_id,
      patient_practices.id as practice_id
      from copied_memberships C
      INNER JOIN patient_practices on patient_practices.code = C.practice_code
      INNER JOIN patient_primary_care_physicians on patient_primary_care_physicians.code = C.gp_code;

  -- Insert any new memberships, ignoring any conflicts where the
  -- practice_id + primary_care_physician_id already exists
  INSERT INTO renalware.patient_practice_memberships
    (practice_id, primary_care_physician_id, joined_on, left_on, active, created_at, updated_at)
  SELECT
    practice_id,
    primary_care_physician_id,
    joined_on,
    left_on,
    case when left_on is null then true else false end,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM tmp_memberships
  ON CONFLICT (practice_id, primary_care_physician_id) DO NOTHING;

  -- However we need to ensure the joined_on left_on and active columns are up to date as these
  -- were recently added
  UPDATE renalware.patient_practice_memberships AS M
  SET
    joined_on = T.joined_on,
    left_on = T.left_on,
    active = case when T.left_on is null then true else false end
  FROM tmp_memberships T
  WHERE T.practice_id = M.practice_id  AND T.primary_care_physician_id = M.primary_care_physician_id;

  -- Mark as deleted any memberships not in the latest uploaded data set - ie those gps have retired or moved on
  UPDATE patient_practice_memberships mem
    SET deleted_at = CURRENT_TIMESTAMP
    WHERE NOT EXISTS (select 1 FROM tmp_memberships tmem
    WHERE tmem.practice_id = mem.practice_id AND tmem.primary_care_physician_id = mem.primary_care_physician_id);

  DROP TABLE IF EXISTS copied_memberships;
  DROP TABLE IF EXISTS tmp_memberships;
END;
$$;


--
-- Name: insert_raw_hl7_message(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.insert_raw_hl7_message(message text) RETURNS void
    LANGUAGE plpgsql
    AS $$ BEGIN
/*
 This function supersedes `new_hl7_message`
 */
insert into
  renalware.feed_raw_hl7_messages(body)
values
  (message);

END;

$$;


--
-- Name: months_between(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.months_between(t_start timestamp without time zone, t_end timestamp without time zone) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
-- calculate the months between 2 timestamps
select ((extract('years' from $2)::int -  extract('years' from $1)::int) * 12)
    - extract('month' from $1)::int + extract('month' from $2)::int
$_$;


--
-- Name: new_hl7_message(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.new_hl7_message(message text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
/*
  This fn is called by the Mirth integration engine to add an HL7 message to Renalware.
  Mirth used to insert data directly into the delayed_jobs table but we are moving away from
  that approach as it tightly couples Mirth to our internal implementation and prevents us
  from easily moving to another background processing library eg que.

  When using delayed_jobs
  -----------------------
  1. We craft a yml string and translate line endings.
  2. The trigger function preprocess_hl7_message fires when a row is added to delayed_jobs.
     It handles escaping odd characters eg 10^12 in the message. See that function for details.
     Once we have migrated Mirth to use this function and are happy it is working we can
     move that logic from preprocess_hl7_message into here and drop that function and its trigger.

  When using que
  ------------------
  # TODO: psuedo SQL
*/
insert into renalware.delayed_jobs(handler, run_at, created_at, updated_at)
values(
  E'--- !ruby/struct:FeedJob\nraw_message: |\n  ' || REPLACE(message, E'\r', E'\n  '),
  NOW() AT TIME ZONE 'UTC',
  NOW() AT TIME ZONE 'UTC',
  NOW() AT TIME ZONE 'UTC'
);
END;
$$;


--
-- Name: pathology_chart_data(integer, text, date); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.pathology_chart_data(patient_id integer, code text, start_date date) RETURNS TABLE(observed_on date, result double precision)
    LANGUAGE sql
    AS $_$
   SELECT observed_at::date, convert_to_float(result) from pathology_observations po
   inner join pathology_observation_requests por on por.id = po.request_id
   inner join pathology_observation_descriptions pod on pod.id = po.description_id
   where pod.code = $2 and observed_at >= start_date and por.patient_id = $1
   order by po.observed_at asc, po.created_at desc;

$_$;


--
-- Name: pathology_chart_series(integer, integer, date); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.pathology_chart_series(patient_id integer, observation_description_id integer, start_date date) RETURNS TABLE(observed_on bigint, result double precision)
    LANGUAGE sql
    AS $_$
  /*
  Note that we use convert_to_float(result, NULL) here rather than nresult
  (same value, populated by a trigger). Explain-analysing the query shows that using nresult in the
  where clause is much slower (x10 times). This might be because pg has not optimised around
  for the use of nresult yet, but its safer for now to use convert_to_float in both places.
  */
  select
    extract(epoch from observed_at)::bigint * 1000,
    convert_to_float(result, NULL) from pathology_observations po
  inner join pathology_observation_requests por on por.id = po.request_id
  inner join pathology_observation_descriptions pod on pod.id = po.description_id
  where
    pod.id = observation_description_id
    and observed_at >= start_date
    and por.patient_id = $1
    and convert_to_float(result, NULL) is not null
  order by
    po.observed_at asc,
    po.created_at desc
$_$;


--
-- Name: pathology_chart_series_product_ca_phos(integer, date); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.pathology_chart_series_product_ca_phos(pat_id integer, start_date date) RETURNS TABLE(observed_on bigint, result double precision)
    LANGUAGE sql
    AS $$
    /*
     * Returns the product of calcium and phosphate for a patient where those tests appear on the same day.
     * Only take rows on or after the start_date argument.
     *  "2017-07-12" : 2.581,
     *  "2017-07-10" : 2.551,
     *  "2017-07-09" : 3.301,
     */
    with cal as (
        select distinct on (po.observed_at::date)
            po.observed_at observed_on,
            convert_to_float(po.result) as result
        from pathology_observations po
        inner join pathology_observation_requests por on por.id = po.request_id
        inner join pathology_observation_descriptions pod on pod.id = po.description_id
        where por.patient_id = pat_id and pod.code = 'CAL'
        order by po.observed_at::date desc
    ),
    phos as (
        select distinct on (po2.observed_at::date)
            po2.observed_at observed_on,
            convert_to_float(po2.result) result
        from pathology_observations po2
        inner join pathology_observation_requests por2 on por2.id = po2.request_id
        inner join pathology_observation_descriptions pod2 on pod2.id = po2.description_id
        where por2.patient_id = pat_id and pod2.code = 'PHOS'
        order by po2.observed_at::date desc
    )
    select
        extract(epoch from phos.observed_on)::bigint * 1000,
        round((phos.result * cal.result)::numeric, 3)::float
    from phos
    inner join cal on cal.observed_on = phos.observed_on
    where
        phos.result > 0
        and cal.result > 0
        and phos.observed_on >= start_date
    order by phos.observed_on asc;;
$$;


--
-- Name: pathology_missing_urrs(integer, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.pathology_missing_urrs(look_behind_hours integer DEFAULT 12, look_ahead_hours integer DEFAULT 4, post_ure_code character varying DEFAULT 'P_URE'::character varying, ure_code character varying DEFAULT 'URE'::character varying, urr_code character varying DEFAULT 'URR'::character varying) RETURNS TABLE(suggested_urr numeric, post_urea_observed_at timestamp without time zone, post_urea_result double precision, post_urea_distance_in_hours_from_pre integer, pre_urea_observed_at timestamp without time zone, pre_urea_result double precision, post_urea_request_id integer, post_urea_observation_id integer, post_urea_code character varying, pre_urea_request_id integer, pre_urea_observation_id integer, pre_urea_code character varying, patient_id integer)
    LANGUAGE plpgsql
    AS $_$
declare
start_po_id bigint;
begin

  -- only search the last 3 million (1 month?) of pathology
  select max(id) - 3000000 from renalware.pathology_observations into start_po_id;

  return query
  with obrs_with_either_one_urr_or_one_post_urea as (
      select
          por.patient_id,
          request_id, -- same for urr and p_ure so helps us find urr if exists
          count(*) as urr_p_ure_count -- number of p_ure and urr OBX in this OBR - unlikely to be anything other than 0,1,2 (2 == URR alrready generated)
      from renalware.pathology_observations po
      inner join renalware.pathology_observation_descriptions pod on pod.id = po.description_id
      inner join renalware.pathology_observation_requests por on por.id = po.request_id
      where
        po.id > start_po_id
        and pod.code in ('P_URE', 'URR')
      group by por.patient_id, request_id --observed_at::date
      having count(*) = 1 -- select only rows with either just a P_URE or just a URR. Really only the former will be found but you never know
  ),
  post_urea_with_no_urr_sibling as (
      select
          x.*,
          po.id as observation_id,
          code,
          nresult,
          observed_at
      from renalware.pathology_observations po
      inner join renalware.pathology_observation_descriptions pod on pod.id = po.description_id
      inner join obrs_with_either_one_urr_or_one_post_urea x on x.request_id = po.request_id
      where
        po.id > start_po_id
        and pod.code = 'P_URE'
        and nresult > 0
  ),
  per_and_post_urea_pairs as (
      select
          post.observed_at       as post_urea_observed_at
          ,post.nresult           as post_urea_result
          ,abs((EXTRACT(epoch from AGE(post.observed_at, pre.observed_at)) / 60 / 60 )::int) as post_urea_distance_in_hours_from_pre
          ,pre.observed_at        as pre_urea_observed_at
          ,pre.nresult            as pre_urea_result
          ,post.request_id        as post_urea_request_id
          ,post.observation_id    as post_urea_observation_id
          ,post.code              as post_urea_code
          ,pre.request_id         as pre_urea_request_id
          ,pre.id                 as pre_urea_observation_id
          ,pre.code               as pre_urea_code
          ,post.patient_id
      from post_urea_with_no_urr_sibling post
      left outer join (
          select
              po.id,
              po.nresult,
              po.observed_at,
              pod.code,
              por.patient_id,
              por.id as request_id
          from renalware.pathology_observations po
          inner join renalware.pathology_observation_descriptions pod on pod.id = po.description_id
          inner join renalware.pathology_observation_requests por on por.id = po.request_id
          where
            po.id > start_po_id
            and pod.code = 'URE'
            and nresult > 0
      ) pre on pre.patient_id = post.patient_id
      and tsrange(
          post.observed_at - '1 hour'::interval * $1,
          post.observed_at + '1 hour'::interval * $2
          ) @> pre.observed_at
  )
  select
      distinct on (x.patient_id, x.post_urea_observation_id)
      round(((x.pre_urea_result - x.post_urea_result) / x.pre_urea_result * 100)::numeric, 2) as suggested_urr,
      x.*
      from per_and_post_urea_pairs x
      order by x.patient_id, x.post_urea_observation_id, x.post_urea_distance_in_hours_from_pre asc;
end;
$_$;


--
-- Name: pathology_resolve_observation_description(character varying, character varying); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.pathology_resolve_observation_description(obx_code character varying, site character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
  begin
    RETURN (
        select distinct on (pod.id) pod.id
        from pathology_observation_descriptions pod
        left outer join pathology_obx_mappings pom on pom.observation_description_id = pod.id
        left outer join pathology_senders ps on ps.id = pom.sender_id
        where
        (
            pom.code_alias = obx_code and site similar to ps.sending_facility
        )
        OR
        (
            pod.code = obx_code
        )
        order by pod.id asc, pom.observation_description_id
        limit 1
    );
end
  $$;


--
-- Name: patient_nag_clinical_frailty_score(integer); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.patient_nag_clinical_frailty_score(p_id integer, OUT out_severity renalware.system_nag_severity, OUT out_value text, OUT out_date date) RETURNS record
    LANGUAGE plpgsql STABLE
    AS $$
declare
    event_age_in_days integer;
    modality_code text;
begin
    /* A nag function which is used in the UI to display a nag on patient ages if a CFS score is
     * missing or out of date. A CFS score is recorded in the UI by creating an event of type
     * 'Clinical Frailty Score'.
     *
     * Returns:
     * - out_severity eg 'high' - see the system_nag_severity type
     * - out_value - the CFS score, or 'Missing' if no score recorded yet
     * - out_date - the date of the most recent CFS event, if one found
     *
     * The logic is:
     * - Patient modality not in HD PD Tx : out_severity = none, out_value = last CFS score, out_date = last CFS date*
     * - No CFS : out_severity = high, out_value = 'Missing', out_date = null
     * - CSF older than 180 days : out_severity = high, out_value = last CFS score, out_date = last CFS date
     * - CSF age is >=90 <180 days : out_severity = medium, out_value = last CFS score, out_date = last CFS date
     * - CSF recorded within 90 days : out_severity = none, out_value = last CFS score, out_date = last CFS date
     */
    select into
        event_age_in_days
        ,out_date
        ,out_value
        current_date - e.date_time::date -- eg 90 days, an integer
        ,date_time
        ,document ->> 'score'
    from events e
    inner join event_types et on et.id = e.event_type_id
    where e.patient_id = p_id
      and e.deleted_at is null
      and et.slug = 'clinical_frailty_score'
    order by e.date_time desc
    limit 1;

    select into modality_code pcm.modality_code
    from patient_current_modalities pcm
    where pcm.patient_id = p_id;

    select into out_value coalesce(out_value, 'Missing');

    select into out_severity
        case
            when modality_code is NULL then 'none'
            when modality_code not in ('pd', 'hd', 'transplant') then 'none'
            when event_age_in_days is NULL then 'high' -- missing CSF event
            else
                case
                    when event_age_in_days > 180 then 'high'
                    when event_age_in_days >= 90 then 'medium'
                    else 'none'
                end
            end;
 end
$$;


--
-- Name: patient_nag_hd_dna(integer); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.patient_nag_hd_dna(p_id integer, OUT out_severity renalware.system_nag_severity, OUT out_value text, OUT out_date date) RETURNS record
    LANGUAGE plpgsql STABLE
    AS $$
begin
  /* A nag function which is used in the UI to display a nag on patient ages if a patient has had
  * an HD DNA Session (DNA = did not attend) in the last 30 days.
  *
  * Returns:
  * - out_severity - 'medium' if the patient DNA'd in the last 30 days, otherwise 'none'
  * - out_value - a message
  * - out_date - the HD DNA Session date
  */
  with dna as (
    select distinct on (patient_id)
      patient_id
      ,'medium' as severity
      ,null as value
      ,started_at
      from hd_sessions hds
      where type = 'Renalware::HD::Session::DNA'
        and days_between(hds.started_at, current_timestamp::timestamp) <= 31
      order by patient_id, hds.started_at desc
  )
  select
    into out_severity, out_value, out_date
    coalesce(dna.severity, 'none'), dna.value, dna.started_at::date
  from patients p left outer join dna on dna.patient_id = p.id
  where p.id = p_id;
 end
$$;


--
-- Name: preprocess_hl7_message(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.preprocess_hl7_message() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN
  /*
  Mirth inserts a row into delayed job when a new HL7 message needs to be processed by Renalware.
  The SQL it uses looks like this:
    insert into renalware.delayed_jobs (handler, run_at)
    values(E'--- !ruby/struct:FeedJob\nraw_message: |\n  ' || REPLACE(${message.rawData},E'\r',E'\n  '), NOW());
  This works unless there is a 10^12 value in the unit of measurement segment for an OBX (e.g.
  for WBC or HGB). Then Mirth encodes the ^ as \S\ because ^ is a significant character in Mirth
  (field separator). Unfortunately this creates the combination
  10\S\12 and S\12 is converted to \n when the handler's payload is loaded in by the delayed_job worker.
  To get around this we need to convert instances of \S\ with another escape sequence eg «
  and manually map this back to a ^ in the job handler ruby code.

  So here, if this delayed_job is destined to be picked up by a Feed job handler
  make sure we convert the Mirth escape sequence \S\ to \\S\\
  */
  IF position('Feed' in NEW.handler) > 0 THEN
    NEW.handler = replace(NEW.handler, E'\\S\\', E'\\\\S\\\\');
    NEW.created_at = now();
    NEW.updated_at = now();
  END IF;

  RETURN NEW;
END

$_$;


--
-- Name: pseudo_encrypt(integer); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.pseudo_encrypt(value integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
l1 int;
l2 int;
r1 int;
r2 int;
i int:=0;
BEGIN
 l1:= (VALUE >> 16) & 65535;
 r1:= VALUE & 65535;
 WHILE i < 3 LOOP
   l2 := r1;
   r2 := l1 # ((((1366 * r1 + 150889) % 714025) / 714025.0) * 32767)::int;
   l1 := l2;
   r1 := r2;
   i := i + 1;
 END LOOP;
 RETURN ((r1 << 16) + l1);
END;
$$;


--
-- Name: refresh_all_matierialized_views(text, boolean); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.refresh_all_matierialized_views(_schema text DEFAULT '*'::text, _concurrently boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    DECLARE
      r RECORD;
    BEGIN
      RAISE NOTICE 'Refreshing materialized view(s) in % %',
        CASE WHEN _schema = '*' THEN 'all schemas'
        ELSE 'schema "'|| _schema || '"'
        END,
        CASE WHEN _concurrently
        THEN 'concurrently'
        ELSE '' END;
      IF pg_is_in_recovery() THEN
        RETURN 0;
      ELSE
        FOR r IN SELECT schemaname,
                        matviewname FROM pg_matviews WHERE schemaname = _schema OR _schema = '*'
        LOOP
          RAISE NOTICE 'Refreshing materialized view "%"."%"', r.schemaname, r.matviewname;
          EXECUTE 'REFRESH MATERIALIZED VIEW ' || CASE WHEN _concurrently THEN 'CONCURRENTLY '
          ELSE '' END || '"' || r.schemaname || '"."' || r.matviewname || '"';
        END LOOP;
      END IF;
      RETURN 1;
    END
  $$;


--
-- Name: refresh_current_observation_set(integer); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.refresh_current_observation_set(a_patient_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
  BEGIN
  with current_patient_obs as(
      select
        DISTINCT ON (p.id, obxd.id)
  p.id as patient_id,
        obxd.code,
        json_build_object('result',(obx.result),'observed_at',obx.observed_at) as value
        from patients p
        inner join pathology_observation_requests obr on obr.patient_id = p.id
        inner join pathology_observations obx on obx.request_id = obr.id
        inner join pathology_observation_descriptions obxd on obx.description_id = obxd.id
        where p.id = a_patient_id
        order by p.id, obxd.id, obx.observed_at desc
    ),
    current_patient_obs_as_jsonb as (
      select patient_id,
        jsonb_object_agg(code, value) as values,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
        from current_patient_obs
        group by patient_id order by patient_id
    )
    insert into pathology_current_observation_sets (patient_id, values, created_at, updated_at)
      select * from current_patient_obs_as_jsonb
      ON conflict (patient_id)
      DO UPDATE
      SET values = excluded.values, updated_at = excluded.updated_at;
  RETURN a_patient_id;
END
$$;


--
-- Name: update_current_observation_set_from_trigger(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.update_current_observation_set_from_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
-- TC 14/12/2017 v02
-- This function is called by a trigger when a row is inserted or updated in
-- pathology_observations. Its purpose is to keep current_observation_sets up to date
-- with the latest observations for any patient.
-- The current_observation_sets table maintains a jsonb hash into which we insert or replace
-- the observation, keyed by OBX code.
-- e.g.  .. {"HGB": { "result": 123.1, "observed_at": '2017-12-12-01:01:01'}, ..
DECLARE
  a_patient_id bigint;
  a_code text;
  current_observed_at timestamp;
  current_result text;
  new_observed_at timestamp;
BEGIN
  -- RAISE NOTICE 'TRIGGER called on %',TG_TABLE_NAME ;

  /*
  If inserting or updating, we _could_ assume the last observation to be inserted is
  the most 'recent' one (with the latest observed_at date).
  However the order of incoming messages is not guaranteed, so we have two options:
  1. Refresh the entire current_observation_set for the patient
  2. Check the current observed_at date in the jsonb and only update if we have a more
     recent one
  We have gone for 2.
  */

  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND (NEW.result != '') THEN

    -- Note we could re-generate the entire current pathology for the patient using
    --  select refresh_current_observation_set(a_patient_id);
    -- which is safer but uses more resources, so avoiding this for now.

    -- Find and store patient_id into local variable
    select request.patient_id into a_patient_id
      from pathology_observation_requests request
      where request.id = NEW.request_id;

    -- Find and store the obx code into local variable
    select description.code into a_code
      from pathology_observation_descriptions description
      where description.id = NEW.description_id;

    -- Important! Create the observation_set if it doesn't exist yet
    -- ignore the error if the row already exists
    insert into pathology_current_observation_sets (patient_id)
    values (a_patient_id)
    ON CONFLICT DO NOTHING;

    -- We are going to compare the current and new observed_at dates
    -- so need to cast them  to a timestamp
    select cast(New.observed_at as timestamp) into new_observed_at;

    -- Get the most recent date and value for this observation
    -- and store to variables.
    select
    cast(values -> a_code ->> 'observed_at' as timestamp),
    values -> a_code ->> 'result'
    into current_observed_at, current_result from
    pathology_current_observation_sets
    where patient_id = a_patient_id;

    -- Output some info to help us debug. This can be removed later.
    -- RAISE NOTICE '  Request id % Patient id % Code %', NEW.request_id, a_patient_id, a_code;
    -- RAISE NOTICE '  Last %: % at %', a_code, current_result, current_observed_at;
    -- RAISE NOTICE '  New  %: % at %', a_code, NEW.result, new_observed_at;

    IF current_observed_at IS NULL OR new_observed_at >= current_observed_at THEN
      -- The new pathology_observation row contain a more recent result that the old one.
      -- (note there may not be an old one if the patient has neve had this obs before).

      -- RAISE NOTICE '  Updating pathology_current_observation_sets..';

      -- Update the values jsonb column with the new hash for this code, e.g.
      -- .. {"HGB": { "result": 123.1, "observed_at": '2017-12-12-01:01:01'}, ..
            -- Note the `set values` below actually reads in the jsonb, updates it,
            -- and wites the whole thing back.
      update pathology_current_observation_sets
        set updated_at = CURRENT_TIMESTAMP,
          values = jsonb_set(
          values,
          ('{'||a_code||'}')::text[], -- defined in the fn path::text[]
          jsonb_build_object('result', NEW.result, 'observed_at', new_observed_at),
          true)
        where patient_id = a_patient_id;
    END IF;
  END IF;
  RETURN NULL ;
END $$;


--
-- Name: update_hd_sessions_from_trigger(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.update_hd_sessions_from_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
begin
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') then
    NEW.performed_on = NEW.started_at::date;
  END IF;
  RETURN NEW ;
END $$;


--
-- Name: FUNCTION update_hd_sessions_from_trigger(); Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON FUNCTION renalware.update_hd_sessions_from_trigger() IS 'For backward-compatibility with any SQL written to query hd_sessions.performed_on,
when the replacement started_at column is changed, write the data part
to the legacy performed_on column';


--
-- Name: update_pathology_observations_nresult_from_trigger(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.update_pathology_observations_nresult_from_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    NEW.nresult = convert_to_float(NEW.result, NULL);
  END IF;
  RETURN NEW ;
END $$;


--
-- Name: FUNCTION update_pathology_observations_nresult_from_trigger(); Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON FUNCTION renalware.update_pathology_observations_nresult_from_trigger() IS 'Tries to coerce the result column into the nresult column as a float.
Sets nresult to NULL if result is eg text and cannot be coerced.
nresult is a performance optimisation useful for instance in graphing';


--
-- Name: update_research_study_participants_from_trigger(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION renalware.update_research_study_participants_from_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
/*
TC 05/06/2018
After a participant is added to a study, assign them an external_id, to be used when sending this
data for example to an external study application.
We use pseudo_encrypt() to generate a random id which is guaranteed to be unique as it is based
on the id. Its not the most secure however as, without a secret, the id can be reverse engineered
if our pseudo_encrypt sql function open source (which it is). If this is deemed to be a problem
(our intention at this point is rudimentary obfuscation), a hospital can override replace this
function with a more secure one.
An alternative to using a trigger is to use an after_ or before_save hook in Rails. The trigger
approach is chosen as, unlike a traditional Rails app, some direct data manipulation can be expected
in Renalware, even if that is just during migration.
*/
BEGIN
  IF (TG_OP = 'INSERT') THEN
    NEW.external_id = renalware.pseudo_encrypt(NEW.id::integer);
    RETURN NEW;
  END IF;
  RETURN NULL;
END $$;


--
-- Name: ukrdc_update_send_to_renalreg(); Type: FUNCTION; Schema: renalware_demo; Owner: -
--

CREATE FUNCTION renalware_demo.ukrdc_update_send_to_renalreg(OUT records_added integer, OUT records_updated integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare countOfUpdatedRows int = 0;
BEGIN
  with candidates as(
    select
        p.id as patient_id,
        convert_to_float(pcos.values -> 'EGFR' ->> 'result', null) as egfr,
        md.code as modality_code
    from
        renalware.patients p
        inner join renalware.patient_current_modalities pcm on pcm.patient_id = p.id
        left join renalware.pathology_current_observation_sets pcos on pcos.patient_id = p.id
        inner join modality_descriptions md on md.id = pcm.modality_description_id
    where
        p.send_to_renalreg = false
        and p.renalreg_decision_on is null
        and md.code in ('transplant', 'pd', 'hd', 'low_clearance', 'nephrology')
  ),
  updateables as (
    select patient_id, egfr, modality_code from candidates
    where
      modality_code in ('transplant', 'pd', 'hd')
      or (modality_code in ('low_clearance', 'nephrology') and egfr < 30.0)
  )
  update renalware.patients p
    set
        send_to_renalreg = true,
        renalreg_decision_on = now(),
        renalreg_recorded_by = 'Renalware System'
    from updateables
    where updateables.patient_id = p.id;

  -- Return the number of updated rows in records_updated
  GET DIAGNOSTICS countOfUpdatedRows = ROW_COUNT;
  select into records_added, records_updated 0, countOfUpdatedRows;
END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: drug_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    weighting integer DEFAULT 0 NOT NULL,
    colour renalware.enum_colour_name,
    atc_codes character varying[]
);


--
-- Name: COLUMN drug_types."position"; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_types."position" IS 'Controls display order';


--
-- Name: COLUMN drug_types.weighting; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_types.weighting IS 'More important drug types have a higher value so their colour trumps other types a drug might have.';


--
-- Name: COLUMN drug_types.colour; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_types.colour IS 'A CSS colour e.f. ''#A12A12''';


--
-- Name: drug_types_drugs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_types_drugs (
    drug_id integer NOT NULL,
    drug_type_id integer NOT NULL,
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: drugs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drugs (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    read_code character varying,
    code character varying,
    inactive boolean DEFAULT false NOT NULL
);


--
-- Name: medication_prescription_terminations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.medication_prescription_terminations (
    id integer NOT NULL,
    terminated_on date NOT NULL,
    notes text,
    prescription_id integer NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    terminated_on_set_by_user boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN medication_prescription_terminations.terminated_on_set_by_user; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.medication_prescription_terminations.terminated_on_set_by_user IS 'If true, the system will not attempt to set to prescribed_on + 6 months if prescriptions administer_on_hd=true';


--
-- Name: medication_prescriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.medication_prescriptions (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    drug_id integer NOT NULL,
    treatable_type character varying NOT NULL,
    treatable_id integer NOT NULL,
    dose_amount character varying NOT NULL,
    dose_unit character varying,
    medication_route_id integer NOT NULL,
    route_description character varying,
    frequency character varying NOT NULL,
    notes text,
    prescribed_on date NOT NULL,
    provider integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    administer_on_hd boolean DEFAULT false NOT NULL,
    last_delivery_date date,
    next_delivery_date date,
    unit_of_measure_id bigint,
    trade_family_id bigint,
    form_id bigint,
    legacy_drug_id integer,
    legacy_medication_route_id integer,
    frequency_comment character varying,
    stat boolean
);


--
-- Name: COLUMN medication_prescriptions.legacy_drug_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.medication_prescriptions.legacy_drug_id IS 'Keep the previous drug id as a reference in case of issues with DMD migration';


--
-- Name: COLUMN medication_prescriptions.legacy_medication_route_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.medication_prescriptions.legacy_medication_route_id IS 'Keep the previous route id as a reference in case of issues with DMD migration';


--
-- Name: COLUMN medication_prescriptions.stat; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.medication_prescriptions.stat IS 'Can be chosen when administer_on_hd is true. Prescriptions marked as ''stat'' will be marked as terminated automatically once given.';


--
-- Name: medication_current_prescriptions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.medication_current_prescriptions AS
 SELECT mp.id,
    mp.patient_id,
    mp.drug_id,
    mp.treatable_type,
    mp.treatable_id,
    mp.dose_amount,
    mp.dose_unit,
    mp.medication_route_id,
    mp.route_description,
    mp.frequency,
    mp.notes,
    mp.prescribed_on,
    mp.provider,
    mp.created_at,
    mp.updated_at,
    mp.created_by_id,
    mp.updated_by_id,
    mp.administer_on_hd,
    mp.last_delivery_date,
    drugs.name AS drug_name,
    drug_types.code AS drug_type_code,
    drug_types.name AS drug_type_name
   FROM ((((renalware.medication_prescriptions mp
     FULL JOIN renalware.medication_prescription_terminations mpt ON ((mpt.prescription_id = mp.id)))
     JOIN renalware.drugs ON ((drugs.id = mp.drug_id)))
     FULL JOIN renalware.drug_types_drugs ON ((drug_types_drugs.drug_id = drugs.id)))
     FULL JOIN renalware.drug_types ON (((drug_types_drugs.drug_type_id = drug_types.id) AND ((mpt.terminated_on IS NULL) OR (mpt.terminated_on > now())))));


--
-- Name: pathology_observation_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_observation_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    measurement_unit_id integer,
    loinc_code character varying,
    display_group integer,
    display_order integer,
    letter_group integer,
    letter_order integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    rr_type integer DEFAULT 0 NOT NULL,
    rr_coding_standard integer DEFAULT 0 NOT NULL,
    legacy_code character varying,
    lower_threshold double precision,
    upper_threshold double precision,
    suggested_measurement_unit_id integer,
    virtual boolean DEFAULT false NOT NULL,
    chart_colour character varying,
    chart_logarithmic boolean DEFAULT false NOT NULL,
    chart_sql_function_name character varying,
    created_by_sender_id bigint,
    observations_count integer DEFAULT 0,
    last_observed_at timestamp without time zone,
    colour renalware.enum_colour_name
);


--
-- Name: COLUMN pathology_observation_descriptions.lower_threshold; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_observation_descriptions.lower_threshold IS 'Value below which a result can be seen as abnormal';


--
-- Name: COLUMN pathology_observation_descriptions.upper_threshold; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_observation_descriptions.upper_threshold IS 'Value above which a result can be seen as abnormal';


--
-- Name: COLUMN pathology_observation_descriptions.chart_sql_function_name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_observation_descriptions.chart_sql_function_name IS 'A custom json-returning SQL function returning a calculated/derived series. Must accept an integer (patient id) and date (start date to search from)';


--
-- Name: COLUMN pathology_observation_descriptions.created_by_sender_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_observation_descriptions.created_by_sender_id IS 'The feed source that dynmically created this OBX';


--
-- Name: pathology_observation_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_observation_requests (
    id integer NOT NULL,
    requestor_order_number character varying,
    requestor_name character varying NOT NULL,
    requested_at timestamp without time zone NOT NULL,
    patient_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description_id integer NOT NULL,
    filler_order_number character varying,
    feed_message_id integer
);


--
-- Name: COLUMN pathology_observation_requests.feed_message_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_observation_requests.feed_message_id IS 'Reference to the feed_message from which this observation_request was created. There is no constraint on this relationship as feed_messages can be housekept.';


--
-- Name: pathology_observations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_observations (
    id integer NOT NULL,
    result character varying NOT NULL,
    comment text,
    observed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description_id integer NOT NULL,
    request_id integer NOT NULL,
    cancelled boolean,
    nresult double precision,
    legacy_comment text,
    result_status renalware.enum_hl7_observation_result_status_codes
);


--
-- Name: COLUMN pathology_observations.nresult; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_observations.nresult IS 'The result column cast to a float, for ease of using graphing and claculations.Will be null if the result has a text value that cannot be coreced into a number';


--
-- Name: COLUMN pathology_observations.result_status; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_observations.result_status IS 'OBX.11 - Observation Result Status
Definition:
C Record coming over is a correction and thus replaces a final result
D Deletes the OBX record
F Final results; Can only be changed with a corrected result.
I Specimen in lab; results pending
N Not asked
O Order detail description only (no result)
P Preliminary results
R Results entered -- not verified
S Partial results. Deprecated. Retained only for backward compatibility as of V2.6.
U Results status change to final without retransmitting results already sent as preliminary
W Post original as wrong, e.g., transmitted for wrong patient
X Results cannot be obtained for this observation
';


--
-- Name: pathology_current_observations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.pathology_current_observations AS
 SELECT DISTINCT ON (pathology_observation_requests.patient_id, pathology_observation_descriptions.id) pathology_observations.id,
    pathology_observations.result,
    pathology_observations.comment,
    pathology_observations.observed_at,
    pathology_observations.description_id,
    pathology_observations.request_id,
    pathology_observation_descriptions.code AS description_code,
    pathology_observation_descriptions.name AS description_name,
    pathology_observation_requests.patient_id
   FROM ((renalware.pathology_observations
     LEFT JOIN renalware.pathology_observation_requests ON ((pathology_observations.request_id = pathology_observation_requests.id)))
     LEFT JOIN renalware.pathology_observation_descriptions ON ((pathology_observations.description_id = pathology_observation_descriptions.id)))
  ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;


--
-- Name: modality_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.modality_descriptions (
    id integer NOT NULL,
    name character varying NOT NULL,
    type character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    ukrdc_modality_code_id bigint,
    code character varying,
    ignore_for_aki_alerts boolean DEFAULT false NOT NULL,
    ignore_for_kfre boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN modality_descriptions.ignore_for_aki_alerts; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.modality_descriptions.ignore_for_aki_alerts IS 'If true, HL7 AKI scores are ignored when the patient has this current modality';


--
-- Name: COLUMN modality_descriptions.ignore_for_kfre; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.modality_descriptions.ignore_for_kfre IS 'If true, we will attempt to generate a KFRE on receipt of ACR/PCR result when the patient has this current modality';


--
-- Name: modality_modalities; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.modality_modalities (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    description_id integer NOT NULL,
    reason_id integer,
    modal_change_type_deprecated character varying,
    notes text,
    started_on date NOT NULL,
    ended_on date,
    state character varying DEFAULT 'current'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    change_type_id bigint,
    source_hospital_centre_id bigint,
    destination_hospital_centre_id bigint
);


--
-- Name: COLUMN modality_modalities.source_hospital_centre_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.modality_modalities.source_hospital_centre_id IS 'Source hospital when modality is transferred in.';


--
-- Name: COLUMN modality_modalities.destination_hospital_centre_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.modality_modalities.destination_hospital_centre_id IS 'Destination hospital when modality is transferred out.';


--
-- Name: patients; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patients (
    id integer NOT NULL,
    nhs_number character varying,
    local_patient_id character varying,
    family_name character varying NOT NULL,
    given_name character varying NOT NULL,
    born_on date NOT NULL,
    paediatric_patient_indicator boolean,
    sex character varying,
    ethnicity_id integer,
    hospital_centre_code character varying,
    primary_esrf_centre character varying,
    died_on date,
    first_cause_id integer,
    second_cause_id integer,
    death_notes text,
    cc_on_all_letters boolean DEFAULT true,
    cc_decision_on date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    practice_id integer,
    primary_care_physician_id integer,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    title character varying,
    suffix character varying,
    marital_status character varying,
    telephone1 character varying,
    telephone2 character varying,
    email character varying,
    document jsonb,
    religion_id integer,
    language_id integer,
    allergy_status character varying DEFAULT 'unrecorded'::character varying NOT NULL,
    allergy_status_updated_at timestamp without time zone,
    local_patient_id_2 character varying,
    local_patient_id_3 character varying,
    local_patient_id_4 character varying,
    local_patient_id_5 character varying,
    external_patient_id character varying,
    send_to_renalreg boolean DEFAULT false NOT NULL,
    send_to_rpv boolean DEFAULT false NOT NULL,
    renalreg_decision_on date,
    rpv_decision_on date,
    renalreg_recorded_by character varying,
    rpv_recorded_by character varying,
    ukrdc_external_id text DEFAULT public.uuid_generate_v4(),
    country_of_birth_id integer,
    legacy_patient_id integer,
    secure_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    sent_to_ukrdc_at timestamp without time zone,
    checked_for_ukrdc_changes_at timestamp without time zone,
    hospital_centre_id bigint,
    named_consultant_id bigint,
    next_of_kin text,
    named_nurse_id bigint,
    preferred_death_location_id bigint,
    preferred_death_location_notes text,
    actual_death_location_id bigint,
    ukrdc_anonymise boolean DEFAULT false NOT NULL,
    ukrdc_anonymise_decision_on date,
    ukrdc_anonymise_recorded_by character varying,
    renal_registry_id character varying
);


--
-- Name: pd_regimes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_regimes (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    treatment character varying NOT NULL,
    type character varying,
    glucose_volume_low_strength integer,
    glucose_volume_medium_strength integer,
    glucose_volume_high_strength integer,
    amino_acid_volume integer,
    icodextrin_volume integer,
    add_hd boolean,
    last_fill_volume integer,
    tidal_indicator boolean,
    tidal_percentage integer,
    no_cycles_per_apd integer,
    overnight_volume integer,
    apd_machine_pac character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    therapy_time integer,
    fill_volume integer,
    delivery_interval character varying,
    system_id integer,
    additional_manual_exchange_volume integer,
    tidal_full_drain_every_three_cycles boolean DEFAULT true,
    daily_volume integer,
    assistance_type character varying,
    dwell_time integer,
    exchanges_done_by character varying,
    exchanges_done_by_if_other character varying,
    exchanges_done_by_notes text,
    created_by_id bigint,
    updated_by_id bigint
);


--
-- Name: reporting_pd_audit; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.reporting_pd_audit AS
 WITH pd_patients AS (
         SELECT patients.id
           FROM ((renalware.patients
             JOIN renalware.modality_modalities current_modality ON ((current_modality.patient_id = patients.id)))
             JOIN renalware.modality_descriptions current_modality_description ON ((current_modality_description.id = current_modality.description_id)))
          WHERE ((current_modality.ended_on IS NULL) AND (current_modality.started_on <= CURRENT_DATE) AND ((current_modality_description.name)::text = 'PD'::text))
        ), current_regimes AS (
         SELECT pd_regimes.id,
            pd_regimes.patient_id,
            pd_regimes.start_date,
            pd_regimes.end_date,
            pd_regimes.treatment,
            pd_regimes.type,
            pd_regimes.glucose_volume_low_strength,
            pd_regimes.glucose_volume_medium_strength,
            pd_regimes.glucose_volume_high_strength,
            pd_regimes.amino_acid_volume,
            pd_regimes.icodextrin_volume,
            pd_regimes.add_hd,
            pd_regimes.last_fill_volume,
            pd_regimes.tidal_indicator,
            pd_regimes.tidal_percentage,
            pd_regimes.no_cycles_per_apd,
            pd_regimes.overnight_volume,
            pd_regimes.apd_machine_pac,
            pd_regimes.created_at,
            pd_regimes.updated_at,
            pd_regimes.therapy_time,
            pd_regimes.fill_volume,
            pd_regimes.delivery_interval,
            pd_regimes.system_id,
            pd_regimes.additional_manual_exchange_volume,
            pd_regimes.tidal_full_drain_every_three_cycles,
            pd_regimes.daily_volume,
            pd_regimes.assistance_type
           FROM renalware.pd_regimes
          WHERE ((pd_regimes.start_date >= CURRENT_DATE) AND (pd_regimes.end_date IS NULL))
        ), current_apd_regimes AS (
         SELECT current_regimes.id,
            current_regimes.patient_id,
            current_regimes.start_date,
            current_regimes.end_date,
            current_regimes.treatment,
            current_regimes.type,
            current_regimes.glucose_volume_low_strength,
            current_regimes.glucose_volume_medium_strength,
            current_regimes.glucose_volume_high_strength,
            current_regimes.amino_acid_volume,
            current_regimes.icodextrin_volume,
            current_regimes.add_hd,
            current_regimes.last_fill_volume,
            current_regimes.tidal_indicator,
            current_regimes.tidal_percentage,
            current_regimes.no_cycles_per_apd,
            current_regimes.overnight_volume,
            current_regimes.apd_machine_pac,
            current_regimes.created_at,
            current_regimes.updated_at,
            current_regimes.therapy_time,
            current_regimes.fill_volume,
            current_regimes.delivery_interval,
            current_regimes.system_id,
            current_regimes.additional_manual_exchange_volume,
            current_regimes.tidal_full_drain_every_three_cycles,
            current_regimes.daily_volume,
            current_regimes.assistance_type
           FROM current_regimes
          WHERE ((current_regimes.type)::text ~~ '%::APD%'::text)
        ), current_capd_regimes AS (
         SELECT current_regimes.id,
            current_regimes.patient_id,
            current_regimes.start_date,
            current_regimes.end_date,
            current_regimes.treatment,
            current_regimes.type,
            current_regimes.glucose_volume_low_strength,
            current_regimes.glucose_volume_medium_strength,
            current_regimes.glucose_volume_high_strength,
            current_regimes.amino_acid_volume,
            current_regimes.icodextrin_volume,
            current_regimes.add_hd,
            current_regimes.last_fill_volume,
            current_regimes.tidal_indicator,
            current_regimes.tidal_percentage,
            current_regimes.no_cycles_per_apd,
            current_regimes.overnight_volume,
            current_regimes.apd_machine_pac,
            current_regimes.created_at,
            current_regimes.updated_at,
            current_regimes.therapy_time,
            current_regimes.fill_volume,
            current_regimes.delivery_interval,
            current_regimes.system_id,
            current_regimes.additional_manual_exchange_volume,
            current_regimes.tidal_full_drain_every_three_cycles,
            current_regimes.daily_volume,
            current_regimes.assistance_type
           FROM current_regimes
          WHERE ((current_regimes.type)::text ~~ '%::CAPD%'::text)
        )
 SELECT 'APD'::text AS pd_type,
    count(current_apd_regimes.patient_id) AS patient_count,
    0 AS avg_hgb,
    0 AS pct_hgb_gt_100,
    0 AS pct_on_epo,
    0 AS pct_pth_gt_500,
    0 AS pct_phosphate_gt_1_8,
    0 AS pct_strong_medium_bag_gt_1l
   FROM current_apd_regimes
UNION ALL
 SELECT 'CAPD'::text AS pd_type,
    count(current_capd_regimes.patient_id) AS patient_count,
    0 AS avg_hgb,
    0 AS pct_hgb_gt_100,
    0 AS pct_on_epo,
    0 AS pct_pth_gt_500,
    0 AS pct_phosphate_gt_1_8,
    0 AS pct_strong_medium_bag_gt_1l
   FROM current_capd_regimes
UNION ALL
 SELECT 'PD'::text AS pd_type,
    count(pd_patients.id) AS patient_count,
    0 AS avg_hgb,
    0 AS pct_hgb_gt_100,
    0 AS pct_on_epo,
    0 AS pct_pth_gt_500,
    0 AS pct_phosphate_gt_1_8,
    0 AS pct_strong_medium_bag_gt_1l
   FROM pd_patients;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: access_assessments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_assessments (
    id integer NOT NULL,
    patient_id integer,
    type_id integer NOT NULL,
    side character varying NOT NULL,
    performed_on date NOT NULL,
    procedure_on date,
    comments text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_assessments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_assessments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_assessments_id_seq OWNED BY renalware.access_assessments.id;


--
-- Name: access_catheter_insertion_techniques; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_catheter_insertion_techniques (
    id integer NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_catheter_insertion_techniques_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_catheter_insertion_techniques_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_catheter_insertion_techniques_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_catheter_insertion_techniques_id_seq OWNED BY renalware.access_catheter_insertion_techniques.id;


--
-- Name: access_needling_assessments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_needling_assessments (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    difficulty renalware.access_needling_assessment_difficulties NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: TABLE access_needling_assessments; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.access_needling_assessments IS 'Stores ''Ease of Needling Vascular Access'' aka MAGIC score - see enum';


--
-- Name: access_needling_assessments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_needling_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_needling_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_needling_assessments_id_seq OWNED BY renalware.access_needling_assessments.id;


--
-- Name: access_plan_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_plan_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


--
-- Name: access_plan_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_plan_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_plan_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_plan_types_id_seq OWNED BY renalware.access_plan_types.id;


--
-- Name: access_plans; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_plans (
    id integer NOT NULL,
    plan_type_id integer NOT NULL,
    notes text,
    patient_id integer NOT NULL,
    decided_by_id integer,
    updated_by_id integer NOT NULL,
    created_by_id integer NOT NULL,
    terminated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_plans_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_plans_id_seq OWNED BY renalware.access_plans.id;


--
-- Name: access_procedures; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_procedures (
    id integer NOT NULL,
    patient_id integer,
    type_id integer NOT NULL,
    side character varying,
    performed_on date NOT NULL,
    first_procedure boolean,
    catheter_make character varying,
    catheter_lot_no character varying,
    outcome text,
    notes text,
    first_used_on date,
    failed_on date,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    performed_by character varying,
    pd_catheter_insertion_technique_id integer
);


--
-- Name: access_procedures_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_procedures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_procedures_id_seq OWNED BY renalware.access_procedures.id;


--
-- Name: access_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_profiles (
    id integer NOT NULL,
    patient_id integer,
    formed_on date NOT NULL,
    started_on date,
    terminated_on date,
    type_id integer NOT NULL,
    side character varying NOT NULL,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    decided_by_id integer
);


--
-- Name: access_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_profiles_id_seq OWNED BY renalware.access_profiles.id;


--
-- Name: access_sites; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_sites (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_sites_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_sites_id_seq OWNED BY renalware.access_sites.id;


--
-- Name: access_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    abbreviation character varying,
    rr02_code character varying,
    rr41_code character varying,
    hd_vascular boolean DEFAULT true NOT NULL
);


--
-- Name: access_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_types_id_seq OWNED BY renalware.access_types.id;


--
-- Name: access_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.access_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: access_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.access_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.access_versions_id_seq OWNED BY renalware.access_versions.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.active_storage_attachments_id_seq OWNED BY renalware.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    service_name character varying NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.active_storage_blobs_id_seq OWNED BY renalware.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.active_storage_variant_records_id_seq OWNED BY renalware.active_storage_variant_records.id;


--
-- Name: activesupport_cache_entries; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.activesupport_cache_entries (
    key bytea NOT NULL,
    value bytea NOT NULL,
    version character varying,
    created_at timestamp without time zone NOT NULL,
    expires_at timestamp without time zone
);


--
-- Name: addresses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.addresses (
    id integer NOT NULL,
    addressable_type character varying NOT NULL,
    addressable_id integer NOT NULL,
    street_1 character varying,
    street_2 character varying,
    county character varying,
    town character varying,
    postcode character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    organisation_name character varying,
    telephone character varying,
    email character varying,
    street_3 character varying,
    country_id integer,
    region text
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.addresses_id_seq OWNED BY renalware.addresses.id;


--
-- Name: admission_admissions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.admission_admissions (
    id bigint NOT NULL,
    hospital_ward_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    admitted_on date NOT NULL,
    admission_type character varying NOT NULL,
    consultant character varying,
    modality_at_admission_id bigint,
    reason_for_admission text NOT NULL,
    notes text,
    transferred_on date,
    transferred_to character varying,
    discharged_on date,
    discharge_destination character varying,
    destination_notes character varying,
    discharge_summary text,
    summarised_on date,
    summarised_by_id bigint,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    feed_id character varying
);


--
-- Name: admission_admissions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.admission_admissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_admissions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.admission_admissions_id_seq OWNED BY renalware.admission_admissions.id;


--
-- Name: admission_consult_sites; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.admission_consult_sites (
    id bigint NOT NULL,
    name character varying
);


--
-- Name: admission_consult_sites_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.admission_consult_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_consult_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.admission_consult_sites_id_seq OWNED BY renalware.admission_consult_sites.id;


--
-- Name: admission_consults; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.admission_consults (
    id bigint NOT NULL,
    hospital_ward_id bigint,
    patient_id bigint NOT NULL,
    seen_by_id bigint,
    started_on date,
    ended_on date,
    decided_on date,
    transferred_on date,
    transfer_priority character varying,
    aki_risk character varying,
    consult_type character varying,
    contact_number character varying,
    requires_aki_nurse boolean DEFAULT false NOT NULL,
    description text,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    other_site_or_ward character varying,
    consult_site_id bigint,
    rrt boolean DEFAULT false NOT NULL,
    priority integer,
    e_alert boolean DEFAULT false NOT NULL,
    specialty_id bigint
);


--
-- Name: admission_consults_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.admission_consults_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_consults_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.admission_consults_id_seq OWNED BY renalware.admission_consults.id;


--
-- Name: admission_request_reasons; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.admission_request_reasons (
    id bigint NOT NULL,
    description character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admission_request_reasons_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.admission_request_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_request_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.admission_request_reasons_id_seq OWNED BY renalware.admission_request_reasons.id;


--
-- Name: admission_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.admission_requests (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    reason_id integer NOT NULL,
    hospital_unit_id bigint,
    notes text,
    priority character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    updated_by_id integer NOT NULL,
    created_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admission_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.admission_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.admission_requests_id_seq OWNED BY renalware.admission_requests.id;


--
-- Name: admission_specialties; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.admission_specialties (
    id bigint NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admission_specialties_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.admission_specialties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_specialties_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.admission_specialties_id_seq OWNED BY renalware.admission_specialties.id;


--
-- Name: clinic_visits; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinic_visits (
    id integer NOT NULL,
    patient_id integer,
    date date NOT NULL,
    height double precision,
    weight double precision,
    systolic_bp integer,
    diastolic_bp integer,
    urine_blood character varying,
    urine_protein character varying,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    clinic_id integer NOT NULL,
    "time" time without time zone,
    admin_notes text,
    pulse integer,
    did_not_attend boolean DEFAULT false NOT NULL,
    temperature numeric(3,1),
    standing_systolic_bp integer,
    standing_diastolic_bp integer,
    document jsonb DEFAULT '{}'::jsonb NOT NULL,
    type character varying,
    body_surface_area numeric(8,2),
    total_body_water numeric(8,2),
    bmi numeric(10,1),
    uuid uuid DEFAULT public.uuid_generate_v4(),
    location_id bigint,
    urine_glucose character varying
);


--
-- Name: COLUMN clinic_visits.bmi; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.clinic_visits.bmi IS 'Body Mass Index calculated using a before_save when the clinic visit is updated';


--
-- Name: hospital_centres; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hospital_centres (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    location character varying,
    active boolean,
    is_transplant_site boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    info text,
    trust_name character varying,
    trust_caption character varying,
    host_site boolean DEFAULT false NOT NULL,
    abbrev character varying,
    default_site boolean DEFAULT false,
    departments_count integer DEFAULT 0 NOT NULL,
    units_count integer DEFAULT 0 NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4(),
    "position" integer DEFAULT 10 NOT NULL
);


--
-- Name: COLUMN hospital_centres.departments_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hospital_centres.departments_count IS 'Counter cache for the number of departments at this centre';


--
-- Name: COLUMN hospital_centres.units_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hospital_centres.units_count IS 'Counter cache for the number of units at this centre';


--
-- Name: COLUMN hospital_centres."position"; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hospital_centres."position" IS 'Allows us to float hard-to-find options like ''Other'' and ''Non-UK'' the top of of dropdown lists';


--
-- Name: pathology_current_observation_sets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_current_observation_sets (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    "values" jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: patient_current_modalities; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.patient_current_modalities AS
 SELECT patients.id AS patient_id,
    patients.secure_id AS patient_secure_id,
    current_modality.id AS modality_id,
    modality_descriptions.id AS modality_description_id,
    modality_descriptions.name AS modality_name,
    current_modality.started_on,
    modality_descriptions.code AS modality_code
   FROM ((renalware.patients
     LEFT JOIN ( SELECT DISTINCT ON (modality_modalities.patient_id) modality_modalities.id,
            modality_modalities.patient_id,
            modality_modalities.description_id,
            modality_modalities.reason_id,
            modality_modalities.modal_change_type_deprecated AS modal_change_type,
            modality_modalities.notes,
            modality_modalities.started_on,
            modality_modalities.ended_on,
            modality_modalities.state,
            modality_modalities.created_at,
            modality_modalities.updated_at,
            modality_modalities.created_by_id,
            modality_modalities.updated_by_id
           FROM renalware.modality_modalities
          WHERE (modality_modalities.ended_on IS NULL)
          ORDER BY modality_modalities.patient_id, modality_modalities.started_on DESC, modality_modalities.created_at DESC) current_modality ON ((patients.id = current_modality.patient_id)))
     LEFT JOIN renalware.modality_descriptions ON ((modality_descriptions.id = current_modality.description_id)));


--
-- Name: patient_worries; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_worries (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text,
    worry_category_id bigint,
    deleted_at timestamp(6) without time zone
);


--
-- Name: renal_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.renal_profiles (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    esrf_on date,
    first_seen_on date,
    weight_at_esrf double precision,
    modality_at_esrf character varying,
    prd_description_id integer,
    comorbidities_updated_on date,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_registration_status_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_registration_status_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    "position" integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rr_code integer,
    rr_comment text
);


--
-- Name: transplant_registration_statuses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_registration_statuses (
    id integer NOT NULL,
    registration_id integer,
    description_id integer,
    started_on date NOT NULL,
    terminated_on date,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text
);


--
-- Name: transplant_registrations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_registrations (
    id integer NOT NULL,
    patient_id integer,
    referred_on date,
    assessed_on date,
    entered_on date,
    contact text,
    notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    username character varying NOT NULL,
    given_name character varying NOT NULL,
    family_name character varying NOT NULL,
    signature character varying,
    last_activity_at timestamp without time zone,
    expired_at timestamp without time zone,
    professional_position character varying,
    approved boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    telephone character varying,
    authentication_token character varying,
    hospital_centre_id bigint,
    asked_for_write_access boolean DEFAULT false NOT NULL,
    consultant boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    feature_flags integer DEFAULT 0 NOT NULL,
    prescriber boolean DEFAULT false NOT NULL,
    language character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    password_changed_at timestamp without time zone,
    banned boolean DEFAULT false NOT NULL,
    notes text,
    gmc_code character varying,
    nursing_experience_level renalware.nursing_experience_level_enum,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: COLUMN users.feature_flags; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.users.feature_flags IS 'OR''ed feature flag bits to enable experimental features for certain users';


--
-- Name: COLUMN users.prescriber; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.users.prescriber IS 'A user can only add or terminate a prescription if this is set to true';


--
-- Name: akcc_mdm_patients; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.akcc_mdm_patients AS
 SELECT p.id,
    p.secure_id,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
    rprof.esrf_on,
    mx.modality_name,
    aplantype.name AS access_plan,
    (aplan.created_at)::date AS access_plan_date,
        CASE
            WHEN (pw.id > 0) THEN true
            ELSE false
        END AS on_worryboard,
    ( SELECT clinic_visits.bmi
           FROM renalware.clinic_visits
          WHERE ((clinic_visits.patient_id = p.id) AND (clinic_visits.bmi > (0)::numeric))
          ORDER BY clinic_visits.date DESC
         LIMIT 1) AS bmi,
    txrsd.name AS tx_status,
    renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
    (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
    renalware.convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
    (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
    renalware.convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
    (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
    renalware.convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr,
        CASE
            WHEN ((txrsd.code)::text !~~* '%permanent'::text) THEN true
            ELSE false
        END AS tx_candidate,
        CASE
            WHEN (renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) < (100.0)::double precision) THEN '< 100'::text
            WHEN (renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) > (130.0)::double precision) THEN '> 130'::text
            ELSE NULL::text
        END AS hgb_range,
        CASE
            WHEN (renalware.convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text)) >= (30.0)::double precision) THEN '>= 30'::text
            ELSE NULL::text
        END AS urea_range,
    (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
    (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
    h.name AS hospital_centre
   FROM ((((((((((((renalware.patients p
     LEFT JOIN renalware.patient_worries pw ON ((pw.patient_id = p.id)))
     LEFT JOIN renalware.pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
     LEFT JOIN renalware.renal_profiles rprof ON ((rprof.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registrations txr ON ((txr.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL) AND (txrs.started_on <= CURRENT_DATE))))
     LEFT JOIN renalware.transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
     LEFT JOIN renalware.users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
     LEFT JOIN renalware.users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
     LEFT JOIN renalware.hospital_centres h ON ((h.id = p.hospital_centre_id)))
     LEFT JOIN renalware.access_plans aplan ON (((aplan.patient_id = p.id) AND (aplan.terminated_at IS NULL))))
     LEFT JOIN renalware.access_plan_types aplantype ON ((aplantype.id = aplan.plan_type_id)))
     JOIN renalware.patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'low_clearance'::text))));


--
-- Name: clinic_appointments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinic_appointments (
    id integer NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    patient_id integer NOT NULL,
    clinic_id integer NOT NULL,
    becomes_visit_id integer,
    outcome_notes text,
    dna_notes text,
    feed_id character varying,
    consultant_id bigint,
    clinic_description text,
    updated_by_id bigint,
    created_by_id bigint,
    visit_number text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    ends_at timestamp(6) without time zone
);


--
-- Name: clinic_appointments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinic_appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinic_appointments_id_seq OWNED BY renalware.clinic_appointments.id;


--
-- Name: clinic_clinics; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinic_clinics (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    visit_class_name character varying,
    code character varying,
    deleted_at timestamp without time zone,
    updated_by_id bigint,
    created_by_id bigint,
    appointments_count integer DEFAULT 0,
    clinic_visits_count integer DEFAULT 0,
    default_modality_description_id bigint
);


--
-- Name: clinic_clinics_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinic_clinics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_clinics_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinic_clinics_id_seq OWNED BY renalware.clinic_clinics.id;


--
-- Name: clinic_consultants; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinic_consultants (
    id bigint NOT NULL,
    code character varying,
    name character varying,
    telephone character varying,
    deleted_at timestamp without time zone,
    updated_by_id bigint,
    created_by_id bigint,
    appointments_count integer DEFAULT 0
);


--
-- Name: clinic_consultants_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinic_consultants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_consultants_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinic_consultants_id_seq OWNED BY renalware.clinic_consultants.id;


--
-- Name: clinic_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinic_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: clinic_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinic_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinic_versions_id_seq OWNED BY renalware.clinic_versions.id;


--
-- Name: clinic_visit_locations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinic_visit_locations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    default_location boolean DEFAULT false NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: clinic_visit_locations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinic_visit_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_visit_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinic_visit_locations_id_seq OWNED BY renalware.clinic_visit_locations.id;


--
-- Name: clinic_visits_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinic_visits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinic_visits_id_seq OWNED BY renalware.clinic_visits.id;


--
-- Name: clinical_allergies; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinical_allergies (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    description text NOT NULL,
    recorded_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: clinical_allergies_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinical_allergies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_allergies_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinical_allergies_id_seq OWNED BY renalware.clinical_allergies.id;


--
-- Name: clinical_body_compositions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinical_body_compositions (
    id integer NOT NULL,
    patient_id integer,
    modality_description_id integer,
    assessed_on date NOT NULL,
    overhydration numeric(3,1) NOT NULL,
    volume_of_distribution numeric(4,1) NOT NULL,
    total_body_water numeric(4,1) NOT NULL,
    extracellular_water numeric(4,1) NOT NULL,
    intracellular_water numeric(3,1) NOT NULL,
    lean_tissue_index numeric(4,1) NOT NULL,
    fat_tissue_index numeric(4,1) NOT NULL,
    lean_tissue_mass numeric(4,1) NOT NULL,
    fat_tissue_mass numeric(4,1) NOT NULL,
    adipose_tissue_mass numeric(4,1) NOT NULL,
    body_cell_mass numeric(4,1) NOT NULL,
    quality_of_reading numeric(6,3) NOT NULL,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    assessor_id integer NOT NULL,
    pre_post_hd renalware.clinical_body_composition_pre_post_hd,
    weight double precision
);


--
-- Name: clinical_body_compositions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinical_body_compositions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_body_compositions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinical_body_compositions_id_seq OWNED BY renalware.clinical_body_compositions.id;


--
-- Name: clinical_dry_weights; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinical_dry_weights (
    id integer NOT NULL,
    patient_id integer,
    weight double precision NOT NULL,
    assessed_on date NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    assessor_id integer NOT NULL,
    minimum_weight double precision,
    maximum_weight double precision
);


--
-- Name: COLUMN clinical_dry_weights.minimum_weight; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.clinical_dry_weights.minimum_weight IS 'Set by the clinicial, if the patient''s weight drops below this value then the clinican may decide change drugs etc';


--
-- Name: COLUMN clinical_dry_weights.maximum_weight; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.clinical_dry_weights.maximum_weight IS 'Set by the clinicial, if the patient''s weight rises above this value then the clinican may decide change drugs etc';


--
-- Name: clinical_dry_weights_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinical_dry_weights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_dry_weights_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinical_dry_weights_id_seq OWNED BY renalware.clinical_dry_weights.id;


--
-- Name: clinical_igan_risks; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinical_igan_risks (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    risk numeric(5,2) NOT NULL,
    workings text,
    text text,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN clinical_igan_risks.risk; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.clinical_igan_risks.risk IS 'The risk of a 50% decline in estimated GFR or progression to end-stage renal disease 4.2 years after renal biopsy. Calculated using an external website and is a %value eg 40.1%';


--
-- Name: COLUMN clinical_igan_risks.workings; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.clinical_igan_risks.workings IS 'The calculation output or summary (a block of text) which the user can copy to the clipboard manually from the from the external website, and paste into RW to be saved here. Details the parameters they input as well as the calculated risk';


--
-- Name: COLUMN clinical_igan_risks.text; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.clinical_igan_risks.text IS 'The calculation output or summary (a block of text) which the user can copy to the clipboard manually from the from the external website, and paste into RW to be saved here. Details the parameters they input as well as the calculated risk';


--
-- Name: clinical_igan_risks_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinical_igan_risks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_igan_risks_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinical_igan_risks_id_seq OWNED BY renalware.clinical_igan_risks.id;


--
-- Name: clinical_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.clinical_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: clinical_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.clinical_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.clinical_versions_id_seq OWNED BY renalware.clinical_versions.id;


--
-- Name: death_causes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.death_causes (
    id integer NOT NULL,
    code integer,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: death_causes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.death_causes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: death_causes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.death_causes_id_seq OWNED BY renalware.death_causes.id;


--
-- Name: death_locations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.death_locations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    patients_preferred_count integer DEFAULT 0 NOT NULL,
    patients_actual_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    rr_outcome_code integer,
    rr_outcome_text character varying
);


--
-- Name: COLUMN death_locations.patients_preferred_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.death_locations.patients_preferred_count IS 'Counter cache for the number of patients preferring this location';


--
-- Name: COLUMN death_locations.patients_actual_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.death_locations.patients_actual_count IS 'Counter cache for the number of patients who died at this location';


--
-- Name: death_locations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.death_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: death_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.death_locations_id_seq OWNED BY renalware.death_locations.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.delayed_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.delayed_jobs_id_seq OWNED BY renalware.delayed_jobs.id;


--
-- Name: dietetic_mdm_patients; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW renalware.dietetic_mdm_patients AS
 WITH latest_dietetic_clinic_visits AS (
         SELECT DISTINCT ON (clinic_visits.patient_id) clinic_visits.date,
            clinic_visits.patient_id,
            clinic_visits.created_by_id,
            clinic_visits.document,
            clinic_visits.weight,
            clinic_visits.bmi
           FROM renalware.clinic_visits
          WHERE ((clinic_visits.type)::text = 'Renalware::Dietetics::ClinicVisit'::text)
          ORDER BY clinic_visits.patient_id, clinic_visits.date DESC, clinic_visits.created_at DESC
        ), latest_dry_weights AS (
         SELECT DISTINCT ON (cdw.patient_id) cdw.id,
            cdw.patient_id,
            cdw.weight
           FROM renalware.clinical_dry_weights cdw
          ORDER BY cdw.patient_id, cdw.created_at DESC
        )
 SELECT p.id,
    p.secure_id,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    (((named_consultant_user.family_name)::text || ', '::text) || (named_consultant_user.given_name)::text) AS consultant_name,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    md.name AS modality_name,
    latest_dietetic_clinic_visits.bmi,
    (((clinic_visit_users.family_name)::text || ', '::text) || (clinic_visit_users.given_name)::text) AS dietician_name,
    renalware.convert_to_float(((pathology."values" -> 'POT'::text) ->> 'result'::text), NULL::double precision) AS pot,
    renalware.convert_to_float(((pathology."values" -> 'PHOS'::text) ->> 'result'::text), NULL::double precision) AS phos,
    renalware.convert_to_float(((pathology."values" -> 'PTH'::text) ->> 'result'::text), NULL::double precision) AS pth,
    renalware.convert_to_float(((pathology."values" -> 'ALB'::text) ->> 'result'::text), NULL::double precision) AS alb,
    renalware.convert_to_float(((pathology."values" -> 'URR'::text) ->> 'result'::text), NULL::double precision) AS urr,
    latest_dietetic_clinic_visits.date AS clinic_visit_date,
    ((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date AS next_review_on,
    translate(initcap((latest_dietetic_clinic_visits.document ->> 'assessment_type'::text)), '_'::text, ' '::text) AS assessment_type,
    translate(initcap((latest_dietetic_clinic_visits.document ->> 'visit_type'::text)), '_'::text, ' '::text) AS visit_type,
    ((latest_dietetic_clinic_visits.document ->> 'weight_change'::text) || '%'::text) AS weight_change,
    latest_dietetic_clinic_visits.weight AS current_weight,
    latest_dry_weights.weight AS dry_weight,
        CASE
            WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < now()) THEN 'overdue'::text
            WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < (now() + '1 mon'::interval)) THEN 'in 1 months'::text
            WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < (now() + '3 mons'::interval)) THEN 'in 3 months'::text
            WHEN (((latest_dietetic_clinic_visits.document ->> 'next_review_on'::text))::date < (now() + '6 mons'::interval)) THEN 'in 6 months'::text
            ELSE NULL::text
        END AS outstanding_dietetic_visit,
    hospital_centre.name AS hospital_centre,
        CASE
            WHEN (pw.id > 0) THEN true
            ELSE false
        END AS on_worryboard
   FROM (((((((((latest_dietetic_clinic_visits
     JOIN renalware.patients p ON ((p.id = latest_dietetic_clinic_visits.patient_id)))
     LEFT JOIN latest_dry_weights ON ((latest_dry_weights.patient_id = p.id)))
     JOIN renalware.users clinic_visit_users ON ((clinic_visit_users.id = latest_dietetic_clinic_visits.created_by_id)))
     LEFT JOIN renalware.users named_consultant_user ON ((named_consultant_user.id = p.named_consultant_id)))
     LEFT JOIN renalware.patient_worries pw ON ((pw.patient_id = p.id)))
     LEFT JOIN renalware.pathology_current_observation_sets pathology ON ((pathology.patient_id = p.id)))
     LEFT JOIN renalware.modality_modalities mm ON (((mm.patient_id = p.id) AND (mm.ended_on IS NULL))))
     LEFT JOIN renalware.modality_descriptions md ON ((md.id = mm.description_id)))
     LEFT JOIN renalware.hospital_centres hospital_centre ON ((hospital_centre.id = p.hospital_centre_id)))
  WHERE ((md.name)::text <> 'death'::text)
  ORDER BY latest_dietetic_clinic_visits.date DESC
  WITH NO DATA;


--
-- Name: directory_people; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.directory_people (
    id bigint NOT NULL,
    given_name character varying NOT NULL,
    family_name character varying NOT NULL,
    title character varying,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: directory_people_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.directory_people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directory_people_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.directory_people_id_seq OWNED BY renalware.directory_people.id;


--
-- Name: drug_dmd_actual_medical_products; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_dmd_actual_medical_products (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying,
    virtual_medical_product_code character varying,
    trade_family_code character varying,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: drug_dmd_actual_medical_products_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_dmd_actual_medical_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_dmd_actual_medical_products_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_dmd_actual_medical_products_id_seq OWNED BY renalware.drug_dmd_actual_medical_products.id;


--
-- Name: drug_dmd_matches; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_dmd_matches (
    id bigint NOT NULL,
    drug_id bigint,
    prescriptions_count integer,
    drug_name character varying,
    form_name character varying,
    vtm_name character varying,
    approved_vtm_match boolean DEFAULT false,
    trade_family_name character varying,
    approved_trade_family_match boolean DEFAULT false
);


--
-- Name: drug_dmd_matches_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_dmd_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_dmd_matches_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_dmd_matches_id_seq OWNED BY renalware.drug_dmd_matches.id;


--
-- Name: drug_dmd_virtual_medical_products; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_dmd_virtual_medical_products (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying,
    form_code character varying,
    route_code character varying,
    atc_code character varying,
    unit_of_measure_code_deprecated character varying,
    strength_numerator_value character varying,
    basis_of_strength character varying,
    virtual_therapeutic_moiety_code character varying,
    inactive boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    unit_dose_uom_code character varying,
    unit_dose_form_size_uom_code character varying,
    active_ingredient_strength_numerator_uom_code character varying
);


--
-- Name: COLUMN drug_dmd_virtual_medical_products.unit_dose_uom_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_dmd_virtual_medical_products.unit_dose_uom_code IS 'dm+d name VMP.UNIT_DOSE_UOMCD';


--
-- Name: COLUMN drug_dmd_virtual_medical_products.unit_dose_form_size_uom_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_dmd_virtual_medical_products.unit_dose_form_size_uom_code IS 'dm+d name VMP.UDFS_UOMCD';


--
-- Name: COLUMN drug_dmd_virtual_medical_products.active_ingredient_strength_numerator_uom_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_dmd_virtual_medical_products.active_ingredient_strength_numerator_uom_code IS 'dm+d name VMP.STRNT_NMRTR_UOMCD';


--
-- Name: drug_dmd_virtual_medical_products_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_dmd_virtual_medical_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_dmd_virtual_medical_products_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_dmd_virtual_medical_products_id_seq OWNED BY renalware.drug_dmd_virtual_medical_products.id;


--
-- Name: drug_dmd_virtual_therapeutic_moieties; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_dmd_virtual_therapeutic_moieties (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying,
    inactive boolean DEFAULT false,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: drug_dmd_virtual_therapeutic_moieties_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_dmd_virtual_therapeutic_moieties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_dmd_virtual_therapeutic_moieties_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_dmd_virtual_therapeutic_moieties_id_seq OWNED BY renalware.drug_dmd_virtual_therapeutic_moieties.id;


--
-- Name: drug_forms; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_forms (
    id bigint NOT NULL,
    name character varying,
    code character varying NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: drug_forms_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_forms_id_seq OWNED BY renalware.drug_forms.id;


--
-- Name: drug_frequencies; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_frequencies (
    id bigint NOT NULL,
    name character varying NOT NULL,
    title character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    doses_per_week numeric(5,2),
    "position" integer DEFAULT 1 NOT NULL
);


--
-- Name: COLUMN drug_frequencies.doses_per_week; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_frequencies.doses_per_week IS 'Examples: daily = 7, weekly = 1, twice daily = 14, monthly = 0.25';


--
-- Name: drug_frequencies_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_frequencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_frequencies_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_frequencies_id_seq OWNED BY renalware.drug_frequencies.id;


--
-- Name: drug_homecare_forms; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_homecare_forms (
    id bigint NOT NULL,
    drug_type_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    form_name character varying NOT NULL,
    form_version character varying NOT NULL,
    prescription_durations character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    prescription_duration_default integer,
    prescription_duration_unit renalware.duration NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE drug_homecare_forms; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.drug_homecare_forms IS 'X-ref table that says which drug_type is supplied by which (homecare) supplier and the data required (see form_name and form_version) to programmatically select and create the right PDF Homecare Supply form for them (using the renalware-forms gem) so this can be printed out and signed.';


--
-- Name: COLUMN drug_homecare_forms.form_name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_homecare_forms.form_name IS 'The lower-case programmatic name used for this provider, eg ''fresenius''';


--
-- Name: COLUMN drug_homecare_forms.form_version; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_homecare_forms.form_version IS 'A number e.g. ''1'' that specified what version of the homecare supply formshould be created';


--
-- Name: COLUMN drug_homecare_forms.prescription_durations; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_homecare_forms.prescription_durations IS 'An array of options where each integer is a number of units - these will be displayed as dropdown options presented to the user, and checkboxes on the homecare delivery form PDF. E.g [3,6] will be displayed as options ''3 months'' and ''6 months'' (see also prescription_duration_unit)';


--
-- Name: COLUMN drug_homecare_forms.prescription_duration_default; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_homecare_forms.prescription_duration_default IS 'The default option to pre-select when displaying prescription_duration_options';


--
-- Name: COLUMN drug_homecare_forms.prescription_duration_unit; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_homecare_forms.prescription_duration_unit IS 'E.g. ''week'' or ''month''';


--
-- Name: drug_homecare_forms_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_homecare_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_homecare_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_homecare_forms_id_seq OWNED BY renalware.drug_homecare_forms.id;


--
-- Name: drug_patient_group_directions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_patient_group_directions (
    id bigint NOT NULL,
    name character varying NOT NULL,
    code character varying,
    starts_on date,
    ends_on date,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp(6) without time zone
);


--
-- Name: TABLE drug_patient_group_directions; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.drug_patient_group_directions IS 'Patient group directions (PGDs) are written instructions to help you supply or administer medicines to patients, usually in planned circumstances https://www.gov.uk/government/publications/patient-group-directions-pgds/ patient-group-directions-who-can-use-them';


--
-- Name: COLUMN drug_patient_group_directions.name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_patient_group_directions.name IS 'E.g. Ceftriaxone INJECTION';


--
-- Name: COLUMN drug_patient_group_directions.code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_patient_group_directions.code IS 'E.g. DA/57';


--
-- Name: COLUMN drug_patient_group_directions.starts_on; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_patient_group_directions.starts_on IS 'The date the PGD is effective from e.g. Apr-24-2021';


--
-- Name: COLUMN drug_patient_group_directions.ends_on; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_patient_group_directions.ends_on IS 'The date the PGD is expires e.g. Apr-24-2024';


--
-- Name: drug_patient_group_directions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_patient_group_directions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_patient_group_directions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_patient_group_directions_id_seq OWNED BY renalware.drug_patient_group_directions.id;


--
-- Name: drug_trade_families; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_trade_families (
    id bigint NOT NULL,
    name character varying,
    code character varying NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: drug_trade_family_classifications; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_trade_family_classifications (
    id bigint NOT NULL,
    drug_id bigint NOT NULL,
    trade_family_id bigint NOT NULL,
    enabled boolean DEFAULT false,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: drug_prescribable_drugs; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW renalware.drug_prescribable_drugs AS
 SELECT drug_id,
    trade_family_id,
    compound_id,
    drug_name,
    trade_family_name,
    compound_name
   FROM ( SELECT drugs.id AS drug_id,
            NULL::bigint AS trade_family_id,
            (drugs.id)::text AS compound_id,
            drugs.name AS drug_name,
            NULL::character varying AS trade_family_name,
            drugs.name AS compound_name
           FROM renalware.drugs
          WHERE ((drugs.deleted_at IS NULL) AND (drugs.inactive = false))
        UNION
         SELECT drugs.id,
            drug_trade_families.id,
            ((((drugs.id)::character varying)::text || ':'::text) || ((drug_trade_families.id)::character varying)::text),
            drugs.name,
            drug_trade_families.name,
            ((((drugs.name)::text || ' ('::text) || (drug_trade_families.name)::text) || ')'::text)
           FROM ((renalware.drugs
             JOIN renalware.drug_trade_family_classifications ON ((drug_trade_family_classifications.drug_id = drugs.id)))
             JOIN renalware.drug_trade_families ON (((drug_trade_families.id = drug_trade_family_classifications.trade_family_id) AND (drug_trade_family_classifications.enabled = true))))
          WHERE ((drugs.deleted_at IS NULL) AND (drugs.inactive = false))) t
  ORDER BY compound_name
  WITH NO DATA;


--
-- Name: drug_suppliers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_suppliers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE drug_suppliers; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.drug_suppliers IS 'A list of suppliers who deliver drugs eg for homecare';


--
-- Name: COLUMN drug_suppliers.name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.drug_suppliers.name IS 'The providers display name e.g. ''Fresenius''';


--
-- Name: drug_suppliers_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_suppliers_id_seq OWNED BY renalware.drug_suppliers.id;


--
-- Name: drug_trade_families_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_trade_families_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_trade_families_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_trade_families_id_seq OWNED BY renalware.drug_trade_families.id;


--
-- Name: drug_trade_family_classifications_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_trade_family_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_trade_family_classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_trade_family_classifications_id_seq OWNED BY renalware.drug_trade_family_classifications.id;


--
-- Name: drug_types_drugs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_types_drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_types_drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_types_drugs_id_seq OWNED BY renalware.drug_types_drugs.id;


--
-- Name: drug_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_types_id_seq OWNED BY renalware.drug_types.id;


--
-- Name: drug_unit_of_measures; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_unit_of_measures (
    id bigint NOT NULL,
    name character varying,
    code character varying NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: drug_unit_of_measures_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_unit_of_measures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_unit_of_measures_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_unit_of_measures_id_seq OWNED BY renalware.drug_unit_of_measures.id;


--
-- Name: drug_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: drug_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_versions_id_seq OWNED BY renalware.drug_versions.id;


--
-- Name: drug_vmp_classifications; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.drug_vmp_classifications (
    id bigint NOT NULL,
    drug_id bigint NOT NULL,
    code character varying NOT NULL,
    form_id bigint,
    route_id bigint,
    unit_of_measure_id bigint,
    trade_family_ids integer[] DEFAULT '{}'::integer[],
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    inactive boolean DEFAULT false NOT NULL,
    unit_dose_uom_id bigint,
    unit_dose_form_size_uom_id bigint,
    active_ingredient_strength_numerator_uom_id bigint
);


--
-- Name: drug_vmp_classifications_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drug_vmp_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_vmp_classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drug_vmp_classifications_id_seq OWNED BY renalware.drug_vmp_classifications.id;


--
-- Name: drugs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.drugs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.drugs_id_seq OWNED BY renalware.drugs.id;


--
-- Name: duplicate_nhs_numbers; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.duplicate_nhs_numbers AS
 SELECT p.secure_id,
    p.nhs_number,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    p.created_at,
    p.updated_at
   FROM (renalware.patients p
     JOIN ( SELECT patients.nhs_number,
            count(*) AS count
           FROM renalware.patients
          WHERE ((patients.nhs_number)::text <> ''::text)
          GROUP BY patients.nhs_number
         HAVING (count(*) > 1)) t USING (nhs_number));


--
-- Name: event_categories; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.event_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 10 NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_categories_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.event_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.event_categories_id_seq OWNED BY renalware.event_categories.id;


--
-- Name: event_subtypes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.event_subtypes (
    id bigint NOT NULL,
    event_type_id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    "position" integer DEFAULT 0 NOT NULL,
    definition jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deactivated_at timestamp without time zone,
    active boolean DEFAULT true
);


--
-- Name: COLUMN event_subtypes."position"; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.event_subtypes."position" IS 'The order of the subtype within an event type, if >1 subtypes';


--
-- Name: event_subtypes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.event_subtypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_subtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.event_subtypes_id_seq OWNED BY renalware.event_subtypes.id;


--
-- Name: event_type_alert_triggers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.event_type_alert_triggers (
    id bigint NOT NULL,
    event_type_id bigint NOT NULL,
    when_event_document_contains text,
    when_event_description_contains text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE event_type_alert_triggers; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.event_type_alert_triggers IS 'Matching alerts are displayed on patient pages';


--
-- Name: event_type_alert_triggers_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.event_type_alert_triggers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_type_alert_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.event_type_alert_triggers_id_seq OWNED BY renalware.event_type_alert_triggers.id;


--
-- Name: event_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.event_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event_class_name character varying,
    slug character varying,
    category_id bigint NOT NULL,
    save_pdf_to_electronic_public_register boolean DEFAULT false NOT NULL,
    title character varying,
    hidden boolean DEFAULT false NOT NULL,
    events_count integer DEFAULT 0 NOT NULL,
    external_document_type_code character varying,
    external_document_type_description character varying,
    superadmin_can_always_change boolean DEFAULT true NOT NULL,
    author_change_window_hours integer DEFAULT 0 NOT NULL,
    admin_change_window_hours integer DEFAULT 0 NOT NULL
);


--
-- Name: COLUMN event_types.events_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.event_types.events_count IS 'Counter cache column which Rails will update and which stores the count of events created with this type';


--
-- Name: COLUMN event_types.external_document_type_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.event_types.external_document_type_code IS 'A code eg ''MDT'' used as metadata when renderimg the event to a PDF';


--
-- Name: COLUMN event_types.external_document_type_description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.event_types.external_document_type_description IS 'See comment for external_document_type_code';


--
-- Name: COLUMN event_types.author_change_window_hours; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.event_types.author_change_window_hours IS 'Period post-creation within which an event of this type can be edited by the author';


--
-- Name: COLUMN event_types.admin_change_window_hours; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.event_types.admin_change_window_hours IS 'Period post-creation within which an event of this type can be edited by an admin (or superadmin if superadmin_can_always_change is false';


--
-- Name: event_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.event_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.event_types_id_seq OWNED BY renalware.event_types.id;


--
-- Name: event_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.event_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: event_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.event_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.event_versions_id_seq OWNED BY renalware.event_versions.id;


--
-- Name: events; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.events (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    event_type_id integer,
    description character varying,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    type character varying NOT NULL,
    document jsonb,
    deleted_at timestamp without time zone,
    subtype_id bigint
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.events_id_seq OWNED BY renalware.events.id;


--
-- Name: feed_file_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_file_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    prompt text NOT NULL,
    download_url_title character varying,
    download_url character varying,
    filename_validation_pattern character varying DEFAULT '.*'::character varying NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: feed_file_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_file_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_file_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_file_types_id_seq OWNED BY renalware.feed_file_types.id;


--
-- Name: feed_files; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_files (
    id integer NOT NULL,
    file_type_id integer NOT NULL,
    location character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    result text,
    time_taken integer,
    attempts integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer
);


--
-- Name: feed_files_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_files_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_files_id_seq OWNED BY renalware.feed_files.id;


--
-- Name: feed_gps; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_gps (
    id bigint NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    telephone text,
    street_1 text,
    street_2 text,
    street_3 text,
    town text,
    county text,
    postcode text,
    status character varying
);


--
-- Name: feed_gps_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_gps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_gps_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_gps_id_seq OWNED BY renalware.feed_gps.id;


--
-- Name: feed_hl7_test_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_hl7_test_messages (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: feed_hl7_test_messages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_hl7_test_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_hl7_test_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_hl7_test_messages_id_seq OWNED BY renalware.feed_hl7_test_messages.id;


--
-- Name: feed_logs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_logs (
    id bigint NOT NULL,
    log_type renalware.enum_feed_log_type NOT NULL,
    log_reason renalware.enum_feed_log_reason NOT NULL,
    patient_id bigint,
    message_id bigint,
    message_type renalware.hl7_message_type,
    event_type renalware.hl7_event_type,
    note text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: TABLE feed_logs; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.feed_logs IS 'Stores links to a feed_message and a candidate/close-matched patient where eg a patient with the incoming nhs_number is found but their DOB differs. This allows an admin to review the log and diagnose the issue.';


--
-- Name: feed_logs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_logs_id_seq OWNED BY renalware.feed_logs.id;


--
-- Name: feed_message_replays; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_message_replays (
    id bigint NOT NULL,
    replay_request_id bigint NOT NULL,
    message_id bigint NOT NULL,
    success boolean DEFAULT false NOT NULL,
    error_message text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    urn character varying
);


--
-- Name: feed_message_replays_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_message_replays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_message_replays_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_message_replays_id_seq OWNED BY renalware.feed_message_replays.id;


--
-- Name: feed_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_messages (
    id integer NOT NULL,
    event_code_deprecated character varying,
    header_id character varying NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body_hash text,
    nhs_number character varying,
    processed boolean DEFAULT false,
    patient_identifiers jsonb DEFAULT '{}'::jsonb NOT NULL,
    message_type renalware.hl7_message_type,
    event_type renalware.hl7_event_type,
    local_patient_id character varying,
    local_patient_id_2 character varying,
    local_patient_id_3 character varying,
    local_patient_id_4 character varying,
    local_patient_id_5 character varying,
    orc_order_status renalware.enum_hl7_orc_order_status,
    dob date,
    orc_filler_order_number character varying,
    sent_at timestamp(6) without time zone
);


--
-- Name: feed_messages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_messages_id_seq OWNED BY renalware.feed_messages.id;


--
-- Name: feed_outgoing_documents; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_outgoing_documents (
    id bigint NOT NULL,
    renderable_type character varying NOT NULL,
    renderable_id bigint NOT NULL,
    state renalware.feed_outgoing_document_state DEFAULT 'queued'::renalware.feed_outgoing_document_state NOT NULL,
    printing_options json DEFAULT '{}'::json,
    external_uuid uuid,
    error text,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    error_code character varying,
    errored_at timestamp without time zone,
    retried_at timestamp without time zone
);


--
-- Name: TABLE feed_outgoing_documents; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.feed_outgoing_documents IS 'A queue of documents (letters, events) that require processing by an external system e.g. Mirth. For example when a letter is approved, a hospital''s Renalware host app may listener for that event and write a row to this table, including the (polymorphic) details of the document (in this case the class name and id of the letter). When Mirth or the external system queries the Renalware API for for waiting queued documents, it will return documents referenced here that have a state of ''queued''. The renderable relation must implement the expected methods required to render to the requested format e.g. HL7 (and in the future FHIR).';


--
-- Name: COLUMN feed_outgoing_documents.renderable_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.feed_outgoing_documents.renderable_id IS 'The letter/event/etc to be processed';


--
-- Name: COLUMN feed_outgoing_documents.external_uuid; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.feed_outgoing_documents.external_uuid IS 'E.g. the Mirth message id';


--
-- Name: feed_outgoing_documents_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_outgoing_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_outgoing_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_outgoing_documents_id_seq OWNED BY renalware.feed_outgoing_documents.id;


--
-- Name: feed_practice_gps; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_practice_gps (
    id bigint NOT NULL,
    gp_code text NOT NULL,
    practice_code text NOT NULL,
    joined_on date,
    left_on date,
    primary_care_physician_id integer,
    practice_id integer
);


--
-- Name: feed_practice_gps_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_practice_gps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_practice_gps_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_practice_gps_id_seq OWNED BY renalware.feed_practice_gps.id;


--
-- Name: feed_raw_hl7_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_raw_hl7_messages (
    id bigint NOT NULL,
    body character varying,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: feed_raw_hl7_messages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_raw_hl7_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_raw_hl7_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_raw_hl7_messages_id_seq OWNED BY renalware.feed_raw_hl7_messages.id;


--
-- Name: feed_replay_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_replay_requests (
    id bigint NOT NULL,
    criteria jsonb DEFAULT '{}'::jsonb,
    started_at timestamp(6) without time zone NOT NULL,
    finished_at timestamp(6) without time zone,
    total_messages integer DEFAULT 0 NOT NULL,
    failed_messages integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    patient_id bigint NOT NULL,
    error_message text,
    reason text
);


--
-- Name: feed_replay_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_replay_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_replay_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_replay_requests_id_seq OWNED BY renalware.feed_replay_requests.id;


--
-- Name: feed_sausage_queue; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_sausage_queue (
    id bigint NOT NULL,
    feed_sausage_id integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: feed_sausage_queue_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_sausage_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_sausage_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_sausage_queue_id_seq OWNED BY renalware.feed_sausage_queue.id;


--
-- Name: feed_sausages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.feed_sausages (
    id bigint NOT NULL,
    sent_at timestamp without time zone NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    processed_at timestamp without time zone,
    message_type renalware.hl7_message_type NOT NULL,
    event_type renalware.hl7_event_type NOT NULL,
    orc_filler_order_number character varying,
    orc_order_status renalware.enum_hl7_orc_order_status,
    header_id character varying,
    body text NOT NULL,
    nhs_number character varying,
    local_patient_id character varying,
    local_patient_id_2 character varying,
    local_patient_id_3 character varying,
    local_patient_id_4 character varying,
    local_patient_id_5 character varying,
    dob date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: feed_sausages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.feed_sausages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_sausages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.feed_sausages_id_seq OWNED BY renalware.feed_sausages.id;


--
-- Name: geography_local_authority_districts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.geography_local_authority_districts (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    imd_rank integer,
    imd_pct integer,
    imd_decile integer,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: COLUMN geography_local_authority_districts.imd_rank; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.geography_local_authority_districts.imd_rank IS 'A simple Index of Multiple Deprivation (IMD) ranking of the LA from most to least deprived.';


--
-- Name: COLUMN geography_local_authority_districts.imd_pct; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.geography_local_authority_districts.imd_pct IS 'Percentage - where the most deprived 1% of LAs are 1 and the next most deprived 1% are 2 etc.';


--
-- Name: COLUMN geography_local_authority_districts.imd_decile; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.geography_local_authority_districts.imd_decile IS 'Grouping the most deprived 10% of LA as Decile 1 and the second most deprived 10% as decile 2 etc.';


--
-- Name: geography_local_authority_districts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.geography_local_authority_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geography_local_authority_districts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.geography_local_authority_districts_id_seq OWNED BY renalware.geography_local_authority_districts.id;


--
-- Name: geography_lower_super_output_areas; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.geography_lower_super_output_areas (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    imd_rank integer,
    imd_pct integer,
    imd_decile integer,
    middle_super_output_area_id bigint NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE geography_lower_super_output_areas; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.geography_lower_super_output_areas IS 'LSOAs are a type of census geography that were created to allow for comparisons across
different parts of the country. LSOAs fall within the boundaries of Local Authority
Districts (LADs). LOSAa comprise between 400 and 1,200 households and have a usually
resident population between 1,000 and 3,000 persons. LSOAs are made up of groups of
Output Areas (OAs), usually four or five.
';


--
-- Name: COLUMN geography_lower_super_output_areas.imd_rank; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.geography_lower_super_output_areas.imd_rank IS 'A simple Index of Multiple Deprivation (IMD) ranking of the LSOA from most to least deprived.';


--
-- Name: COLUMN geography_lower_super_output_areas.imd_pct; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.geography_lower_super_output_areas.imd_pct IS 'Percentage - where the most deprived 1% of LSOAs are 1 and the next most deprived 1% are 2 etc.';


--
-- Name: COLUMN geography_lower_super_output_areas.imd_decile; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.geography_lower_super_output_areas.imd_decile IS 'Grouping the most deprived 10% of LSOAs as Decile 1 and the second most deprived 10% as decile 2 etc.';


--
-- Name: geography_lower_super_output_areas_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.geography_lower_super_output_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geography_lower_super_output_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.geography_lower_super_output_areas_id_seq OWNED BY renalware.geography_lower_super_output_areas.id;


--
-- Name: geography_middle_super_output_areas; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.geography_middle_super_output_areas (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    local_authority_district_id bigint NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE geography_middle_super_output_areas; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.geography_middle_super_output_areas IS 'MSOAs are groups of Lower Layer Super Output Areas (LSOAs) -  usually four or five - that
are used to publish statistics. They are designed to contain between 5,000 and 15,000
residents and 2,000 and 6,000 households. MSOAs are generated automatically by zone-design
software using census data. They are often used when statistics cannot be published at the
LSOA level because they could be disclosive of an individual''s data. As of 2021, there were
6,856 MSOAs in England and 408 in Wales.
';


--
-- Name: geography_middle_super_output_areas_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.geography_middle_super_output_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geography_middle_super_output_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.geography_middle_super_output_areas_id_seq OWNED BY renalware.geography_middle_super_output_areas.id;


--
-- Name: geography_output_areas; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.geography_output_areas (
    id bigint NOT NULL,
    code character varying NOT NULL,
    lower_super_output_area_id bigint NOT NULL
);


--
-- Name: TABLE geography_output_areas; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.geography_output_areas IS 'Output Areas (OAs) are the lowest level of geographical area for census statistics and
were first created following the 2001 Census
';


--
-- Name: geography_output_areas_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.geography_output_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geography_output_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.geography_output_areas_id_seq OWNED BY renalware.geography_output_areas.id;


--
-- Name: geography_postcodes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.geography_postcodes (
    id bigint NOT NULL,
    postal_code character varying NOT NULL,
    lower_super_output_area_id bigint NOT NULL
);


--
-- Name: geography_postcodes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.geography_postcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geography_postcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.geography_postcodes_id_seq OWNED BY renalware.geography_postcodes.id;


--
-- Name: good_job_batches; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.good_job_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description text,
    serialized_properties jsonb,
    on_finish text,
    on_success text,
    on_discard text,
    callback_queue_name text,
    callback_priority integer,
    enqueued_at timestamp(6) without time zone,
    discarded_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone
);


--
-- Name: good_job_executions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.good_job_executions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid NOT NULL,
    job_class text,
    queue_name text,
    serialized_params jsonb,
    scheduled_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    error text,
    error_event smallint,
    error_backtrace text[],
    process_id uuid,
    duration interval
);


--
-- Name: good_job_processes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.good_job_processes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state jsonb,
    lock_type smallint
);


--
-- Name: good_job_settings; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.good_job_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    key text,
    value jsonb
);


--
-- Name: good_jobs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.good_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    queue_name text,
    priority integer,
    serialized_params jsonb,
    scheduled_at timestamp without time zone,
    performed_at timestamp without time zone,
    finished_at timestamp without time zone,
    error text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid,
    concurrency_key text,
    cron_key text,
    retried_good_job_id uuid,
    cron_at timestamp without time zone,
    batch_id uuid,
    batch_callback_id uuid,
    is_discrete boolean,
    executions_count integer,
    job_class text,
    error_event smallint,
    labels text[],
    locked_by_id uuid,
    locked_at timestamp(6) without time zone
);


--
-- Name: hd_cannulation_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_cannulation_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    qhd33_code character varying
);


--
-- Name: COLUMN hd_cannulation_types.qhd33_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_cannulation_types.qhd33_code IS 'Needling Method (RR50)';


--
-- Name: hd_cannulation_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_cannulation_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_cannulation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_cannulation_types_id_seq OWNED BY renalware.hd_cannulation_types.id;


--
-- Name: hd_dialysates; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_dialysates (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    sodium_content integer NOT NULL,
    sodium_content_uom character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bicarbonate_content numeric(10,2),
    bicarbonate_content_uom character varying DEFAULT 'mmol/L'::character varying,
    calcium_content numeric(10,2),
    calcium_content_uom character varying DEFAULT 'mmol/L'::character varying,
    glucose_content numeric(10,2),
    glucose_content_uom character varying DEFAULT 'g/L'::character varying,
    potassium_content numeric(10,2),
    potassium_content_uom character varying DEFAULT 'mmol/L'::character varying
);


--
-- Name: hd_dialysates_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_dialysates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_dialysates_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_dialysates_id_seq OWNED BY renalware.hd_dialysates.id;


--
-- Name: hd_dialysers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_dialysers (
    id integer NOT NULL,
    "group" character varying NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    membrane_surface_area numeric(10,2),
    membrane_surface_area_coefficient_k0a numeric(10,2)
);


--
-- Name: hd_dialysers_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_dialysers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_dialysers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_dialysers_id_seq OWNED BY renalware.hd_dialysers.id;


--
-- Name: hd_diaries; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_diaries (
    id bigint NOT NULL,
    type character varying NOT NULL,
    hospital_unit_id bigint NOT NULL,
    master_diary_id integer,
    week_number integer,
    year integer,
    master boolean DEFAULT false NOT NULL,
    updated_by_id integer NOT NULL,
    created_by_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT week_number_in_valid_range CHECK (((week_number >= 1) AND (week_number <= 53))),
    CONSTRAINT year_in_valid_range CHECK (((year >= 2017) AND (year <= 2050)))
);


--
-- Name: hd_diaries_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_diaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_diaries_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_diaries_id_seq OWNED BY renalware.hd_diaries.id;


--
-- Name: hd_diary_slots; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_diary_slots (
    id bigint NOT NULL,
    diary_id integer NOT NULL,
    station_id integer NOT NULL,
    day_of_week integer NOT NULL,
    diurnal_period_code_id integer NOT NULL,
    patient_id bigint NOT NULL,
    updated_by_id integer NOT NULL,
    created_by_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    archived_at timestamp without time zone,
    arrival_time time without time zone,
    CONSTRAINT day_of_week_in_valid_range CHECK (((day_of_week >= 1) AND (day_of_week <= 7)))
);


--
-- Name: hd_diurnal_period_codes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_diurnal_period_codes (
    id bigint NOT NULL,
    code character varying NOT NULL,
    description text,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: hd_stations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_stations (
    id bigint NOT NULL,
    hospital_unit_id bigint NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    name character varying,
    updated_by_id integer NOT NULL,
    created_by_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location_id integer
);


--
-- Name: hospital_units; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hospital_units (
    id integer NOT NULL,
    hospital_centre_id integer NOT NULL,
    name character varying NOT NULL,
    unit_code character varying NOT NULL,
    renal_registry_code character varying NOT NULL,
    unit_type character varying NOT NULL,
    is_hd_site boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_diary_matrix; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.hd_diary_matrix AS
 WITH hd_empty_diary_matrix AS (
         SELECT EXTRACT(year FROM the_date.the_date) AS year,
            EXTRACT(week FROM the_date.the_date) AS week_number,
            h.id AS hospital_unit_id,
            s.id AS station_id,
            a.day_of_week,
            period.id AS diurnal_period_code_id
           FROM ((((generate_series((now() - '1 year'::interval), (now() - '7 days'::interval), '7 days'::interval) the_date(the_date)
             CROSS JOIN renalware.hospital_units h)
             CROSS JOIN renalware.hd_stations s)
             CROSS JOIN ( SELECT generate_series(1, 7) AS day_of_week) a)
             CROSS JOIN renalware.hd_diurnal_period_codes period)
          WHERE (h.is_hd_site = true)
          ORDER BY (EXTRACT(year FROM the_date.the_date)), (EXTRACT(week FROM the_date.the_date)), h.id, s.id, a.day_of_week, period.id
        )
 SELECT m.year,
    m.week_number,
    m.hospital_unit_id,
    m.station_id,
    m.day_of_week,
    m.diurnal_period_code_id,
    wd.id AS weekly_diary_id,
    md.id AS master_diary_id,
    ws.id AS weekly_slot_id,
    ms.id AS master_slot_id,
    COALESCE(ws.patient_id, ms.patient_id) AS patient_id,
    ms.deleted_at,
    ms.created_by_id AS master_slot_created_by_id,
    ms.updated_by_id AS master_slot_updated_by_id,
    (ms.created_at)::date AS master_slot_created_at,
    (ms.updated_at)::date AS master_slot_updated_at,
    to_date((((((wd.year)::text || '-'::text) || (wd.week_number)::text) || '-'::text) || (ms.day_of_week)::text), 'iyyy-iw-ID'::text) AS slot_date
   FROM ((((hd_empty_diary_matrix m
     LEFT JOIN renalware.hd_diaries wd ON (((wd.hospital_unit_id = m.hospital_unit_id) AND ((wd.year)::numeric = m.year) AND ((wd.week_number)::numeric = m.week_number) AND (wd.master = false))))
     LEFT JOIN renalware.hd_diaries md ON (((md.hospital_unit_id = m.hospital_unit_id) AND (md.master = true))))
     LEFT JOIN renalware.hd_diary_slots ws ON (((ws.diary_id = wd.id) AND (ws.station_id = m.station_id) AND (ws.day_of_week = m.day_of_week) AND (ws.diurnal_period_code_id = m.diurnal_period_code_id))))
     LEFT JOIN renalware.hd_diary_slots ms ON (((ms.diary_id = md.id) AND (ms.station_id = m.station_id) AND (ms.day_of_week = m.day_of_week) AND (ms.diurnal_period_code_id = m.diurnal_period_code_id))));


--
-- Name: hd_diary_slots_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_diary_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_diary_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_diary_slots_id_seq OWNED BY renalware.hd_diary_slots.id;


--
-- Name: hd_diurnal_period_codes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_diurnal_period_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_diurnal_period_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_diurnal_period_codes_id_seq OWNED BY renalware.hd_diurnal_period_codes.id;


--
-- Name: hd_transmission_logs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_transmission_logs (
    id bigint NOT NULL,
    parent_id bigint,
    direction character varying NOT NULL,
    format character varying NOT NULL,
    status character varying,
    hd_provider_unit_id bigint,
    patient_id bigint,
    filepath character varying,
    payload text,
    result jsonb DEFAULT '{}'::jsonb,
    error_messages text[] DEFAULT '{}'::text[],
    transmitted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    external_session_id character varying,
    session_id bigint,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    warnings character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: hd_grouped_transmission_logs; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.hd_grouped_transmission_logs AS
 WITH RECURSIVE parent_child_logs(parent_id, id, uuid, level) AS (
         SELECT t.parent_id,
            t.id,
            t.uuid,
            1 AS level
           FROM renalware.hd_transmission_logs t
          WHERE (t.parent_id IS NULL)
        UNION ALL
         SELECT parent_child_logs.id,
            t.id,
            t.uuid,
            (parent_child_logs.level + 1)
           FROM (renalware.hd_transmission_logs t
             JOIN parent_child_logs ON ((t.parent_id = parent_child_logs.id)))
        ), ordered_parent_child_logs AS (
         SELECT parent_child_logs.id,
            parent_child_logs.parent_id,
            parent_child_logs.level,
            max(parent_child_logs.level) OVER (PARTITION BY parent_child_logs.id) AS maxlevel
           FROM parent_child_logs
        )
 SELECT h.id,
    h.parent_id,
    h.direction,
    h.format,
    h.status,
    h.hd_provider_unit_id,
    h.patient_id,
    h.filepath,
    h.payload,
    h.result,
    h.error_messages,
    h.transmitted_at,
    h.created_at,
    h.updated_at,
    h.external_session_id,
    h.session_id,
    h.uuid,
    h.warnings
   FROM (ordered_parent_child_logs
     JOIN renalware.hd_transmission_logs h ON ((h.id = ordered_parent_child_logs.id)))
  WHERE (ordered_parent_child_logs.level = ordered_parent_child_logs.maxlevel)
  ORDER BY h.id, h.updated_at;


--
-- Name: hd_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_profiles (
    id integer NOT NULL,
    patient_id integer,
    hospital_unit_id integer,
    other_schedule character varying,
    prescribed_time integer,
    prescribed_on date,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    prescriber_id integer,
    named_nurse_id_legacy integer,
    transport_decider_id integer,
    deactivated_at timestamp without time zone,
    active boolean DEFAULT true,
    schedule_definition_id integer,
    dialysate_id bigint,
    scheduled_time time without time zone,
    home_machine_identifier character varying
);


--
-- Name: COLUMN hd_profiles.home_machine_identifier; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_profiles.home_machine_identifier IS 'eg serial number of Baxter Home AK98 dialyser with which we sync via HDCloud API';


--
-- Name: hd_schedule_definitions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_schedule_definitions (
    id bigint NOT NULL,
    days integer[] DEFAULT '{}'::integer[] NOT NULL,
    diurnal_period_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    days_text text,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: hd_vnd_risk_assessments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_vnd_risk_assessments (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    risk1 renalware.hd_vnd_risk_level_itemised NOT NULL,
    risk2 renalware.hd_vnd_risk_level_itemised NOT NULL,
    risk3 renalware.hd_vnd_risk_level_itemised NOT NULL,
    risk4 renalware.hd_vnd_risk_level_itemised NOT NULL,
    overall_risk_score integer NOT NULL,
    overall_risk_level renalware.hd_vnd_risk_level_overall NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN hd_vnd_risk_assessments.risk1; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_vnd_risk_assessments.risk1 IS 'What is the likelihood that the staff (or carer) will fail to observe an actual or potential VND for this patient?';


--
-- Name: COLUMN hd_vnd_risk_assessments.risk2; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_vnd_risk_assessments.risk2 IS 'What is the likelihood that the patient will fail to raise the alarm if they experience VND?';


--
-- Name: COLUMN hd_vnd_risk_assessments.risk3; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_vnd_risk_assessments.risk3 IS 'What is the likelihood of the patient behaving in a way that could lead to VND?';


--
-- Name: COLUMN hd_vnd_risk_assessments.risk4; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_vnd_risk_assessments.risk4 IS 'What is the likelihood of the taping failing to ensure that the needle is secure throughout dialysis?';


--
-- Name: COLUMN hd_vnd_risk_assessments.overall_risk_score; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_vnd_risk_assessments.overall_risk_score IS 'Overall risk score for a serious Venous Needle Dislodgement incident eg 6';


--
-- Name: COLUMN hd_vnd_risk_assessments.overall_risk_level; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_vnd_risk_assessments.overall_risk_level IS 'Overall risk level for a serious Venous Needle Dislodgement incident eg ''high''';


--
-- Name: transplant_recipient_operations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_recipient_operations (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    performed_on date NOT NULL,
    theatre_case_start_time time without time zone,
    donor_kidney_removed_from_ice_at timestamp without time zone,
    operation_type character varying NOT NULL,
    hospital_centre_id integer NOT NULL,
    kidney_perfused_with_blood_at timestamp without time zone,
    cold_ischaemic_time integer,
    warm_ischaemic_time integer,
    notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    induction_agent_id bigint,
    immunological_risk character varying
);


--
-- Name: hd_mdm_patients; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.hd_mdm_patients AS
 SELECT p.id,
    p.secure_id,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    rprof.esrf_on,
    latest_op.performed_on AS last_operation_date,
    (date_part('year'::text, age((p.born_on)::timestamp with time zone)))::integer AS age,
    mx.modality_name,
        CASE
            WHEN (pw.id > 0) THEN true
            ELSE false
        END AS on_worryboard,
    at.name AS access,
    ( SELECT cv2.bmi
           FROM renalware.clinic_visits cv2
          WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
          ORDER BY cv2.date DESC
         LIMIT 1) AS bmi,
    ap.started_on AS access_date,
    aplantype.name AS access_plan,
    (aplan.created_at)::date AS plan_date,
    txrsd.name AS tx_status,
    unit.name AS hospital_unit,
    unit.unit_code AS dialysing_at,
    (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
    (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
    h.name AS hospital_centre,
    ((((hdp.document -> 'transport'::text) ->> 'has_transport'::text) || ': '::text) || ((hdp.document -> 'transport'::text) ->> 'type'::text)) AS transport,
    ((sched.days_text || ' '::text) || upper((diurnal.code)::text)) AS schedule,
    renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
    (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
    renalware.convert_to_float(((pa."values" -> 'PHOS'::text) ->> 'result'::text), NULL::double precision) AS phos,
    (((pa."values" -> 'PHOS'::text) ->> 'observed_at'::text))::date AS phos_date,
    renalware.convert_to_float(((pa."values" -> 'POT'::text) ->> 'result'::text), NULL::double precision) AS pot,
    (((pa."values" -> 'POT'::text) ->> 'observed_at'::text))::date AS pot_date,
    renalware.convert_to_float(((pa."values" -> 'PTHI'::text) ->> 'result'::text), NULL::double precision) AS pthi,
    (((pa."values" -> 'PTHI'::text) ->> 'observed_at'::text))::date AS pthi_date,
    renalware.convert_to_float(((pa."values" -> 'URR'::text) ->> 'result'::text), NULL::double precision) AS urr,
    (((pa."values" -> 'URR'::text) ->> 'observed_at'::text))::date AS urr_date,
    latest_vnd.overall_risk_score AS vnd_risk_score,
    latest_vnd.overall_risk_level AS vnd_risk_level
   FROM ((((((((((((((((((((renalware.patients p
     JOIN renalware.patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'hd'::text))))
     LEFT JOIN renalware.hd_profiles hdp ON (((hdp.patient_id = p.id) AND (hdp.deactivated_at IS NULL))))
     LEFT JOIN renalware.hospital_units unit ON ((unit.id = hdp.hospital_unit_id)))
     LEFT JOIN renalware.users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
     LEFT JOIN renalware.users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
     LEFT JOIN renalware.patient_worries pw ON ((pw.patient_id = p.id)))
     LEFT JOIN renalware.hd_schedule_definitions sched ON ((sched.id = hdp.schedule_definition_id)))
     LEFT JOIN renalware.hd_diurnal_period_codes diurnal ON ((diurnal.id = sched.diurnal_period_id)))
     LEFT JOIN renalware.pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
     LEFT JOIN renalware.hospital_centres h ON ((h.id = p.hospital_centre_id)))
     LEFT JOIN ( SELECT DISTINCT ON (access_profiles.patient_id) access_profiles.id,
            access_profiles.patient_id,
            access_profiles.formed_on,
            access_profiles.started_on,
            access_profiles.terminated_on,
            access_profiles.type_id,
            access_profiles.side,
            access_profiles.notes,
            access_profiles.created_by_id,
            access_profiles.updated_by_id,
            access_profiles.created_at,
            access_profiles.updated_at,
            access_profiles.decided_by_id
           FROM renalware.access_profiles
          WHERE (access_profiles.terminated_on IS NULL)
          ORDER BY access_profiles.patient_id, access_profiles.created_at DESC) ap ON ((ap.patient_id = p.id)))
     LEFT JOIN renalware.access_types at ON ((at.id = ap.type_id)))
     LEFT JOIN renalware.access_plans aplan ON (((aplan.patient_id = p.id) AND (aplan.terminated_at IS NULL))))
     LEFT JOIN renalware.access_plan_types aplantype ON ((aplantype.id = aplan.plan_type_id)))
     LEFT JOIN renalware.transplant_registrations txr ON ((txr.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
     LEFT JOIN renalware.transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
     LEFT JOIN renalware.renal_profiles rprof ON ((rprof.patient_id = p.id)))
     LEFT JOIN ( SELECT DISTINCT ON (hvra.patient_id) hvra.patient_id,
            hvra.overall_risk_score,
            hvra.overall_risk_level
           FROM renalware.hd_vnd_risk_assessments hvra
          ORDER BY hvra.patient_id, hvra.updated_at DESC) latest_vnd ON ((latest_vnd.patient_id = p.id)))
     LEFT JOIN ( SELECT DISTINCT ON (transplant_recipient_operations.patient_id) transplant_recipient_operations.patient_id,
            transplant_recipient_operations.performed_on
           FROM renalware.transplant_recipient_operations
          ORDER BY transplant_recipient_operations.patient_id, transplant_recipient_operations.performed_on DESC) latest_op ON ((latest_op.patient_id = p.id)));


--
-- Name: hd_patient_statistics; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_patient_statistics (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    hospital_unit_id integer NOT NULL,
    month integer,
    year integer,
    rolling boolean,
    pre_mean_systolic_blood_pressure numeric(10,2),
    pre_mean_diastolic_blood_pressure numeric(10,2),
    post_mean_systolic_blood_pressure numeric(10,2),
    post_mean_diastolic_blood_pressure numeric(10,2),
    lowest_systolic_blood_pressure numeric(10,2),
    highest_systolic_blood_pressure numeric(10,2),
    mean_fluid_removal numeric(10,2),
    mean_weight_loss numeric(10,2),
    mean_machine_ktv numeric(10,2),
    mean_blood_flow numeric(10,2),
    mean_litres_processed numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    session_count integer DEFAULT 0 NOT NULL,
    number_of_missed_sessions integer,
    dialysis_minutes_shortfall integer,
    dialysis_minutes_shortfall_percentage numeric(10,2),
    mean_ufr numeric(10,2),
    mean_weight_loss_as_percentage_of_body_weight numeric(10,2),
    number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct integer,
    pathology_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: hd_patient_statistics_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_patient_statistics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_patient_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_patient_statistics_id_seq OWNED BY renalware.hd_patient_statistics.id;


--
-- Name: hd_preference_sets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_preference_sets (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    hospital_unit_id integer,
    other_schedule character varying,
    entered_on date,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    schedule_definition_id integer
);


--
-- Name: hd_preference_sets_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_preference_sets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_preference_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_preference_sets_id_seq OWNED BY renalware.hd_preference_sets.id;


--
-- Name: hd_prescription_administration_reasons; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_prescription_administration_reasons (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_prescription_administration_reasons_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_prescription_administration_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_prescription_administration_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_prescription_administration_reasons_id_seq OWNED BY renalware.hd_prescription_administration_reasons.id;


--
-- Name: hd_prescription_administrations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_prescription_administrations (
    id integer NOT NULL,
    hd_session_id integer,
    prescription_id integer NOT NULL,
    administered boolean,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    administered_by_id bigint,
    witnessed_by_id bigint,
    administrator_authorised boolean DEFAULT false NOT NULL,
    witness_authorised boolean DEFAULT false NOT NULL,
    reason_id bigint,
    deleted_at timestamp without time zone,
    patient_id bigint,
    recorded_on date
);


--
-- Name: hd_prescription_administrations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_prescription_administrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_prescription_administrations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_prescription_administrations_id_seq OWNED BY renalware.hd_prescription_administrations.id;


--
-- Name: hd_profile_for_modalities; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.hd_profile_for_modalities AS
 WITH hd_modalities AS (
         SELECT m_1.patient_id,
            m_1.id AS modality_id,
            m_1.started_on,
            m_1.ended_on
           FROM (renalware.modality_modalities m_1
             JOIN renalware.modality_descriptions md ON ((md.id = m_1.description_id)))
          WHERE ((md.name)::text = 'HD'::text)
        ), distinct_hd_profiles AS (
         SELECT DISTINCT ON (hd_profiles.patient_id, ((hd_profiles.created_at)::date)) hd_profiles.id AS hd_profile_id,
            hd_profiles.patient_id,
            (COALESCE((hd_profiles.prescribed_on)::timestamp without time zone, hd_profiles.created_at))::date AS effective_prescribed_on,
            hd_profiles.prescribed_on,
            (hd_profiles.created_at)::date AS created_on,
            hd_profiles.created_at,
            hd_profiles.deactivated_at,
            hd_profiles.active
           FROM renalware.hd_profiles
          ORDER BY hd_profiles.patient_id, ((hd_profiles.created_at)::date), hd_profiles.created_at DESC
        )
 SELECT patient_id,
    modality_id,
    started_on,
    ended_on,
    ( SELECT hp.hd_profile_id
           FROM distinct_hd_profiles hp
          WHERE ((hp.patient_id = m.patient_id) AND ((hp.deactivated_at IS NULL) OR (hp.deactivated_at > m.started_on)))
          ORDER BY hp.created_at
         LIMIT 1) AS hd_profile_id
   FROM hd_modalities m;


--
-- Name: hd_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_profiles_id_seq OWNED BY renalware.hd_profiles.id;


--
-- Name: hd_provider_units; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_provider_units (
    id bigint NOT NULL,
    hospital_unit_id bigint NOT NULL,
    hd_provider_id bigint NOT NULL,
    providers_reference character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_provider_units_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_provider_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_provider_units_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_provider_units_id_seq OWNED BY renalware.hd_provider_units.id;


--
-- Name: hd_providers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_providers (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_providers_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_providers_id_seq OWNED BY renalware.hd_providers.id;


--
-- Name: hd_schedule_definition_filters; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.hd_schedule_definition_filters AS
 SELECT ids,
    ((days_text || ' '::text) || upper((dirunal_code)::text)) AS days
   FROM ( SELECT array_agg(s1.id) AS ids,
            0 AS dirunal_order,
            s1.days_text,
            ''::character varying AS dirunal_code
           FROM renalware.hd_schedule_definitions s1
          GROUP BY s1.days_text
        UNION ALL
         SELECT public.intset((s2.id)::integer) AS intset,
            hdpc.sort_order,
            s2.days_text,
            hdpc.code
           FROM (renalware.hd_schedule_definitions s2
             JOIN renalware.hd_diurnal_period_codes hdpc ON ((s2.diurnal_period_id = hdpc.id)))) filter
  ORDER BY days_text, dirunal_order;


--
-- Name: hd_schedule_definitions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_schedule_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_schedule_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_schedule_definitions_id_seq OWNED BY renalware.hd_schedule_definitions.id;


--
-- Name: hd_session_form_batch_items; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_session_form_batch_items (
    id bigint NOT NULL,
    batch_id bigint NOT NULL,
    printable_id integer NOT NULL,
    status smallint DEFAULT 0 NOT NULL
);


--
-- Name: hd_session_form_batch_items_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_session_form_batch_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_session_form_batch_items_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_session_form_batch_items_id_seq OWNED BY renalware.hd_session_form_batch_items.id;


--
-- Name: hd_session_form_batches; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_session_form_batches (
    id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    query_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    filepath character varying,
    last_error character varying,
    batch_items_count integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_session_form_batches_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_session_form_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_session_form_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_session_form_batches_id_seq OWNED BY renalware.hd_session_form_batches.id;


--
-- Name: hd_session_patient_group_directions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_session_patient_group_directions (
    id bigint NOT NULL,
    session_id bigint NOT NULL,
    patient_group_direction_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: hd_session_patient_group_directions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_session_patient_group_directions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_session_patient_group_directions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_session_patient_group_directions_id_seq OWNED BY renalware.hd_session_patient_group_directions.id;


--
-- Name: hd_sessions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_sessions (
    id integer NOT NULL,
    patient_id integer,
    hospital_unit_id integer,
    modality_description_id integer,
    performed_on date,
    start_time time without time zone,
    end_time time without time zone,
    duration integer,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    signed_on_by_id integer,
    signed_off_by_id integer,
    type character varying NOT NULL,
    signed_off_at timestamp without time zone,
    profile_id integer,
    dry_weight_id integer,
    dialysate_id bigint,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    external_id bigint,
    deleted_at timestamp without time zone,
    started_at timestamp without time zone,
    stopped_at timestamp without time zone,
    provider_id bigint,
    machine_ip_address character varying,
    hd_station_id bigint
);


--
-- Name: COLUMN hd_sessions.hd_station_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_sessions.hd_station_id IS 'The HD Station (eg ''Bay 1 Bed 2'') where the patient was dialysed';


--
-- Name: hd_sessions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_sessions_id_seq OWNED BY renalware.hd_sessions.id;


--
-- Name: hd_slot_request_access_states; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_slot_request_access_states (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


--
-- Name: hd_slot_request_access_states_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_slot_request_access_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_slot_request_access_states_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_slot_request_access_states_id_seq OWNED BY renalware.hd_slot_request_access_states.id;


--
-- Name: hd_slot_request_deletion_reasons; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_slot_request_deletion_reasons (
    id bigint NOT NULL,
    reason character varying,
    deleted_at timestamp(6) without time zone
);


--
-- Name: hd_slot_request_deletion_reasons_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_slot_request_deletion_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_slot_request_deletion_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_slot_request_deletion_reasons_id_seq OWNED BY renalware.hd_slot_request_deletion_reasons.id;


--
-- Name: hd_slot_request_locations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_slot_request_locations (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


--
-- Name: hd_slot_request_locations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_slot_request_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_slot_request_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_slot_request_locations_id_seq OWNED BY renalware.hd_slot_request_locations.id;


--
-- Name: hd_slot_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_slot_requests (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    urgency renalware.enum_hd_slot_request_urgency NOT NULL,
    inpatient boolean DEFAULT false NOT NULL,
    late_presenter boolean DEFAULT false NOT NULL,
    "boolean" boolean DEFAULT false NOT NULL,
    suitable_for_twilight_slots boolean DEFAULT false NOT NULL,
    specific_requirements text,
    notes text,
    allocated_at timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deletion_reason_id bigint,
    external_referral boolean DEFAULT false NOT NULL,
    medically_fit_for_discharge boolean DEFAULT false NOT NULL,
    medically_fit_for_discharge_at timestamp(6) without time zone,
    medically_fit_for_discharge_by_id bigint,
    location_id bigint,
    access_state_id bigint
);


--
-- Name: COLUMN hd_slot_requests.late_presenter; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_slot_requests.late_presenter IS 'known to service <90 days';


--
-- Name: COLUMN hd_slot_requests."boolean"; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_slot_requests."boolean" IS 'known to service <90 days';


--
-- Name: COLUMN hd_slot_requests.specific_requirements; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_slot_requests.specific_requirements IS 'transport requirements, blood borne viruses etc';


--
-- Name: COLUMN hd_slot_requests.medically_fit_for_discharge; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_slot_requests.medically_fit_for_discharge IS 'The datetime the MFFD checkbox was checked';


--
-- Name: COLUMN hd_slot_requests.medically_fit_for_discharge_at; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_slot_requests.medically_fit_for_discharge_at IS 'The datetime the MFFD checkbox was checked';


--
-- Name: COLUMN hd_slot_requests.medically_fit_for_discharge_by_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.hd_slot_requests.medically_fit_for_discharge_by_id IS 'The id of the user show checked the MFFD checkbox on the HD Slot Request form';


--
-- Name: hd_slot_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_slot_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_slot_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_slot_requests_id_seq OWNED BY renalware.hd_slot_requests.id;


--
-- Name: hd_station_locations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_station_locations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    colour character varying NOT NULL
);


--
-- Name: hd_station_locations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_station_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_station_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_station_locations_id_seq OWNED BY renalware.hd_station_locations.id;


--
-- Name: hd_stations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_stations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_stations_id_seq OWNED BY renalware.hd_stations.id;


--
-- Name: hd_transmission_logs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_transmission_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_transmission_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_transmission_logs_id_seq OWNED BY renalware.hd_transmission_logs.id;


--
-- Name: hd_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hd_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: hd_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_versions_id_seq OWNED BY renalware.hd_versions.id;


--
-- Name: hd_vnd_risk_assessments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hd_vnd_risk_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_vnd_risk_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hd_vnd_risk_assessments_id_seq OWNED BY renalware.hd_vnd_risk_assessments.id;


--
-- Name: hospital_centres_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hospital_centres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_centres_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hospital_centres_id_seq OWNED BY renalware.hospital_centres.id;


--
-- Name: hospital_departments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hospital_departments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    hospital_centre_id bigint NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: TABLE hospital_departments; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.hospital_departments IS 'Can be assigned for example to a Letters::Letterhead. Useful for e.g. when including the sending organisation''s details in a GP Connect message.';


--
-- Name: hospital_departments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hospital_departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_departments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hospital_departments_id_seq OWNED BY renalware.hospital_departments.id;


--
-- Name: hospital_units_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hospital_units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_units_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hospital_units_id_seq OWNED BY renalware.hospital_units.id;


--
-- Name: hospital_wards; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.hospital_wards (
    id bigint NOT NULL,
    name character varying NOT NULL,
    hospital_unit_id bigint NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    code character varying,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: hospital_wards_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.hospital_wards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_wards_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.hospital_wards_id_seq OWNED BY renalware.hospital_wards.id;


--
-- Name: letter_archives; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_archives (
    id integer NOT NULL,
    content text NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letter_id integer NOT NULL,
    pdf_content bytea,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: COLUMN letter_archives.pdf_content; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_archives.pdf_content IS 'Binary PDF letter data created by e.g. prawn. Definitive record of what was sent';


--
-- Name: letter_archives_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_archives_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_archives_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_archives_id_seq OWNED BY renalware.letter_archives.id;


--
-- Name: letter_batch_items; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_batch_items (
    id bigint NOT NULL,
    letter_id bigint NOT NULL,
    batch_id bigint NOT NULL,
    status smallint DEFAULT 0 NOT NULL
);


--
-- Name: letter_batch_items_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_batch_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_batch_items_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_batch_items_id_seq OWNED BY renalware.letter_batch_items.id;


--
-- Name: letter_batches; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_batches (
    id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    query_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    batch_items_count integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filepath character varying
);


--
-- Name: letter_batches_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_batches_id_seq OWNED BY renalware.letter_batches.id;


--
-- Name: letter_contact_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_contact_descriptions (
    id integer NOT NULL,
    system_code character varying NOT NULL,
    name character varying NOT NULL,
    "position" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: letter_contact_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_contact_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_contact_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_contact_descriptions_id_seq OWNED BY renalware.letter_contact_descriptions.id;


--
-- Name: letter_contacts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_contacts (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    default_cc boolean DEFAULT false NOT NULL,
    description_id integer NOT NULL,
    other_description character varying,
    notes text
);


--
-- Name: letter_contacts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_contacts_id_seq OWNED BY renalware.letter_contacts.id;


--
-- Name: letter_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_descriptions (
    id integer NOT NULL,
    text character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    section_identifiers character varying[] DEFAULT '{}'::character varying[],
    snomed_document_type_id bigint
);


--
-- Name: letter_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_descriptions_id_seq OWNED BY renalware.letter_descriptions.id;


--
-- Name: letter_electronic_receipts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_electronic_receipts (
    id bigint NOT NULL,
    letter_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    read_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_group_id bigint
);


--
-- Name: COLUMN letter_electronic_receipts.user_group_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_electronic_receipts.user_group_id IS 'If the user chose a user group as a the eCC recipient (rather than a user) then we split up the group and store each member as a row, but assign the letter_group_id for reference';


--
-- Name: letter_electronic_receipts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_electronic_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_electronic_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_electronic_receipts_id_seq OWNED BY renalware.letter_electronic_receipts.id;


--
-- Name: letter_letterheads; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_letterheads (
    id integer NOT NULL,
    name character varying NOT NULL,
    site_code character varying NOT NULL,
    unit_info character varying NOT NULL,
    trust_name character varying NOT NULL,
    trust_caption character varying NOT NULL,
    site_info text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    include_pathology_in_letter_body boolean DEFAULT true,
    hospital_department_id bigint
);


--
-- Name: letter_letterheads_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_letterheads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_letterheads_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_letterheads_id_seq OWNED BY renalware.letter_letterheads.id;


--
-- Name: letter_letters; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_letters (
    id integer NOT NULL,
    event_type character varying,
    event_id integer,
    patient_id integer,
    type character varying NOT NULL,
    legacy_issued_on date,
    description character varying,
    salutation character varying,
    body text,
    notes text,
    signed_at timestamp without time zone,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letterhead_id integer NOT NULL,
    author_id integer NOT NULL,
    clinical boolean,
    enclosures character varying,
    pathology_timestamp timestamp without time zone,
    pathology_snapshot jsonb DEFAULT '{}'::jsonb,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    submitted_for_approval_at timestamp without time zone,
    submitted_for_approval_by_id bigint,
    approved_at timestamp without time zone,
    approved_by_id bigint,
    completed_at timestamp without time zone,
    completed_by_id bigint,
    page_count integer,
    topic_id bigint,
    deleted_at timestamp(6) without time zone,
    deletion_notes text,
    deleted_by_id bigint,
    gp_send_status renalware.enum_letters_gp_send_status DEFAULT 'not_applicable'::renalware.enum_letters_gp_send_status NOT NULL
);


--
-- Name: COLUMN letter_letters.gp_send_status; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_letters.gp_send_status IS 'Captures the status of out attempt to send a copy of the letter to the GP over MESH using eg GP Connect.';


--
-- Name: letter_letters_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_letters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_letters_id_seq OWNED BY renalware.letter_letters.id;


--
-- Name: letter_mailshot_items; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_mailshot_items (
    id bigint NOT NULL,
    mailshot_id bigint NOT NULL,
    letter_id bigint NOT NULL
);


--
-- Name: TABLE letter_mailshot_items; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.letter_mailshot_items IS 'A record of the letters sent in a mailshot';


--
-- Name: letter_mailshot_items_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_mailshot_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_mailshot_items_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_mailshot_items_id_seq OWNED BY renalware.letter_mailshot_items.id;


--
-- Name: letter_mailshot_mailshots; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_mailshot_mailshots (
    id bigint NOT NULL,
    description character varying NOT NULL,
    sql_view_name character varying NOT NULL,
    body text NOT NULL,
    letterhead_id bigint NOT NULL,
    author_id bigint NOT NULL,
    letters_count integer,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status renalware.background_job_status,
    last_error text
);


--
-- Name: TABLE letter_mailshot_mailshots; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.letter_mailshot_mailshots IS 'A mailshot is an adhoc letter sent to a group of patients';


--
-- Name: COLUMN letter_mailshot_mailshots.description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mailshot_mailshots.description IS 'Some text to identify the mailshot purpose. Will be written to letter_letters.description column when letter created';


--
-- Name: COLUMN letter_mailshot_mailshots.sql_view_name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mailshot_mailshots.sql_view_name IS 'The name of the SQL view chosen as the data source';


--
-- Name: COLUMN letter_mailshot_mailshots.body; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mailshot_mailshots.body IS 'The body text that will be inserted into each letter';


--
-- Name: COLUMN letter_mailshot_mailshots.letters_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mailshot_mailshots.letters_count IS 'Counter cache column which Rails will update';


--
-- Name: letter_mailshot_mailshots_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_mailshot_mailshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_mailshot_mailshots_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_mailshot_mailshots_id_seq OWNED BY renalware.letter_mailshot_mailshots.id;


--
-- Name: letter_mesh_operations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_mesh_operations (
    id bigint NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    direction renalware.enum_mesh_message_direction DEFAULT 'outbound'::renalware.enum_mesh_message_direction NOT NULL,
    action renalware.enum_mesh_api_action NOT NULL,
    transmission_id bigint,
    parent_id bigint,
    mesh_message_id text,
    request_headers jsonb,
    response_headers jsonb,
    payload text,
    response_body text,
    unhandled_error text,
    http_response_code integer,
    http_response_description text,
    http_error boolean DEFAULT false NOT NULL,
    mesh_response_error_code text,
    mesh_response_error_description text,
    mesh_response_error_event text,
    mesh_error boolean DEFAULT false NOT NULL,
    itk3_response_type renalware.enum_mesh_itk3_response_type,
    itk3_response_code text,
    itk3_operation_outcome_type text,
    itk3_operation_outcome_severity text,
    itk3_operation_outcome_code text,
    itk3_operation_outcome_description text,
    itk3_error boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: TABLE letter_mesh_operations; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.letter_mesh_operations IS 'Each row represents a MESH API message. There are two types of message - outbound XML FHIR messages containing the letter content and supporting metadata - inbound XML FHIR messages containing a business or infrastructure response. The direction column specifies the direction.';


--
-- Name: COLUMN letter_mesh_operations.direction; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.direction IS 'See enum for options';


--
-- Name: COLUMN letter_mesh_operations.transmission_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.transmission_id IS 'A reference to the transmission ''transaction''';


--
-- Name: COLUMN letter_mesh_operations.parent_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.parent_id IS 'Parent operation - if if we are a download_message operation which needs to be associated with the earlier, parent send_message operation';


--
-- Name: COLUMN letter_mesh_operations.mesh_message_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.mesh_message_id IS 'The MESH message id for this message';


--
-- Name: COLUMN letter_mesh_operations.request_headers; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.request_headers IS 'Optional, useful for testing';


--
-- Name: COLUMN letter_mesh_operations.response_headers; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.response_headers IS 'Optional, useful for testing';


--
-- Name: COLUMN letter_mesh_operations.payload; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.payload IS 'The XML message body';


--
-- Name: COLUMN letter_mesh_operations.response_body; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.response_body IS 'The response body (eg JSON) if the message is outbound';


--
-- Name: COLUMN letter_mesh_operations.unhandled_error; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.unhandled_error IS 'Stores an unexpected exception';


--
-- Name: COLUMN letter_mesh_operations.http_response_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.http_response_code IS 'eg 200, 401';


--
-- Name: COLUMN letter_mesh_operations.http_response_description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.http_response_description IS 'e.g. OK, Unauthorised';


--
-- Name: COLUMN letter_mesh_operations.http_error; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.http_error IS 'true is eg response status > 299';


--
-- Name: COLUMN letter_mesh_operations.mesh_response_error_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.mesh_response_error_code IS 'MESH EPL mailbox/NHS number error code eg EPL-153';


--
-- Name: COLUMN letter_mesh_operations.mesh_response_error_description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.mesh_response_error_description IS 'e.g. for EPL-153, ''NHS Number not found''';


--
-- Name: COLUMN letter_mesh_operations.mesh_response_error_event; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.mesh_response_error_event IS 'eg SEND';


--
-- Name: COLUMN letter_mesh_operations.mesh_error; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.mesh_error IS 'true if a MESH error was returned from a API call';


--
-- Name: COLUMN letter_mesh_operations.itk3_response_type; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.itk3_response_type IS 'Incoming messages, where they are an async response to a previously sent message will be of type ''infrastructure'' or ''business''';


--
-- Name: COLUMN letter_mesh_operations.itk3_response_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.itk3_response_code IS 'from MessageHeader/response/code, e.g. fatal-error';


--
-- Name: COLUMN letter_mesh_operations.itk3_operation_outcome_type; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.itk3_operation_outcome_type IS 'from OperationOutcome/issue/code, eg processing, security etc';


--
-- Name: COLUMN letter_mesh_operations.itk3_operation_outcome_severity; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.itk3_operation_outcome_severity IS 'from MessageHeader/response/severity, e.g. fatal, success';


--
-- Name: COLUMN letter_mesh_operations.itk3_operation_outcome_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.itk3_operation_outcome_code IS 'from OperationOutcome/issues/details/coding/code - a numeric code e.g. 20001';


--
-- Name: COLUMN letter_mesh_operations.itk3_operation_outcome_description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.itk3_operation_outcome_description IS 'from OperationOutcome/issues/details/coding/display - code description eg ''Handling Specification Error''';


--
-- Name: COLUMN letter_mesh_operations.itk3_error; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_operations.itk3_error IS 'true if an ITK3 error was returned in a business or infrastructure reply';


--
-- Name: letter_mesh_transmissions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_mesh_transmissions (
    id bigint NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    letter_id bigint NOT NULL,
    status renalware.enum_mesh_transmission_status DEFAULT 'pending'::renalware.enum_mesh_transmission_status NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    comment text,
    active_job_id uuid,
    cancelled_at timestamp(6) without time zone,
    sent_to_practice_ods_code character varying
);


--
-- Name: COLUMN letter_mesh_transmissions.letter_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.letter_mesh_transmissions.letter_id IS 'A reference to the letter being sent';


--
-- Name: patient_practices; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_practices (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    telephone character varying,
    last_change_date date,
    active boolean DEFAULT true,
    mesh_mailbox_id character varying,
    mesh_mailbox_description character varying
);


--
-- Name: COLUMN patient_practices.mesh_mailbox_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.patient_practices.mesh_mailbox_id IS 'e.g. YGM24GPXXX. Populated by a call to MESHAPI endpointlookup.
Used when sending letters using TransferOfCare via MESH.
';


--
-- Name: COLUMN patient_practices.mesh_mailbox_description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.patient_practices.mesh_mailbox_description IS 'Mailbox description eg GP Connect TPP Mailbox One.
Populated by a call to MESHAPI endpointlookup.
';


--
-- Name: letter_mesh_letters; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.letter_mesh_letters AS
 SELECT ll.id,
    ll.approved_at,
    ll.completed_at,
    ll.gp_send_status,
    ll.type AS letter_type,
    (((p.family_name)::text || ', '::text) || (p.given_name)::text) AS patient_name,
    p.secure_id AS patient_secure_id,
    p.nhs_number AS patient_nhs_number,
    practice.code AS patient_practice_ods_code,
    lmt.sent_to_practice_ods_code,
    ((COALESCE(practice.code, ''::character varying))::text <> (COALESCE(lmt.sent_to_practice_ods_code, ''::character varying))::text) AS ods_code_mismatch,
    author.id AS author_id,
    (((author.family_name)::text || ', '::text) || (author.given_name)::text) AS author_name,
    typist.id AS typist_id,
    (((typist.family_name)::text || ', '::text) || (typist.given_name)::text) AS typist_name,
    lmt.id AS transmission_id,
    send_operation.mesh_response_error_code AS send_operation_mesh_response_error_code,
    send_operation.mesh_response_error_description AS send_operation_mesh_response_error_description,
    bus_download_operation.itk3_operation_outcome_code AS bus_download_operation_itk3_operation_outcome_code,
    bus_download_operation.itk3_operation_outcome_description AS bus_download_operation_itk3_operation_outcome_description,
    inf_download_operation.itk3_operation_outcome_code AS inf_download_operation_itk3_operation_outcome_code,
    inf_download_operation.itk3_operation_outcome_description AS inf_download_operation_itk3_operation_outcome_description
   FROM ((((((((renalware.letter_mesh_transmissions lmt
     JOIN renalware.letter_letters ll ON ((ll.id = lmt.letter_id)))
     JOIN renalware.patients p ON ((p.id = ll.patient_id)))
     JOIN renalware.users author ON ((author.id = ll.author_id)))
     JOIN renalware.users typist ON ((typist.id = ll.created_by_id)))
     LEFT JOIN renalware.patient_practices practice ON ((practice.id = p.practice_id)))
     LEFT JOIN LATERAL ( SELECT lmo.id,
            lmo.uuid,
            lmo.direction,
            lmo.action,
            lmo.transmission_id,
            lmo.parent_id,
            lmo.mesh_message_id,
            lmo.request_headers,
            lmo.response_headers,
            lmo.payload,
            lmo.response_body,
            lmo.unhandled_error,
            lmo.http_response_code,
            lmo.http_response_description,
            lmo.http_error,
            lmo.mesh_response_error_code,
            lmo.mesh_response_error_description,
            lmo.mesh_response_error_event,
            lmo.mesh_error,
            lmo.itk3_response_type,
            lmo.itk3_response_code,
            lmo.itk3_operation_outcome_type,
            lmo.itk3_operation_outcome_severity,
            lmo.itk3_operation_outcome_code,
            lmo.itk3_operation_outcome_description,
            lmo.itk3_error,
            lmo.created_at,
            lmo.updated_at
           FROM renalware.letter_mesh_operations lmo
          WHERE (lmo.action = 'send_message'::renalware.enum_mesh_api_action)) send_operation ON ((send_operation.transmission_id = lmt.id)))
     LEFT JOIN LATERAL ( SELECT lmo.id,
            lmo.uuid,
            lmo.direction,
            lmo.action,
            lmo.transmission_id,
            lmo.parent_id,
            lmo.mesh_message_id,
            lmo.request_headers,
            lmo.response_headers,
            lmo.payload,
            lmo.response_body,
            lmo.unhandled_error,
            lmo.http_response_code,
            lmo.http_response_description,
            lmo.http_error,
            lmo.mesh_response_error_code,
            lmo.mesh_response_error_description,
            lmo.mesh_response_error_event,
            lmo.mesh_error,
            lmo.itk3_response_type,
            lmo.itk3_response_code,
            lmo.itk3_operation_outcome_type,
            lmo.itk3_operation_outcome_severity,
            lmo.itk3_operation_outcome_code,
            lmo.itk3_operation_outcome_description,
            lmo.itk3_error,
            lmo.created_at,
            lmo.updated_at
           FROM renalware.letter_mesh_operations lmo
          WHERE (lmo.itk3_response_type = 'inf'::renalware.enum_mesh_itk3_response_type)) inf_download_operation ON ((inf_download_operation.transmission_id = lmt.id)))
     LEFT JOIN LATERAL ( SELECT lmo.id,
            lmo.uuid,
            lmo.direction,
            lmo.action,
            lmo.transmission_id,
            lmo.parent_id,
            lmo.mesh_message_id,
            lmo.request_headers,
            lmo.response_headers,
            lmo.payload,
            lmo.response_body,
            lmo.unhandled_error,
            lmo.http_response_code,
            lmo.http_response_description,
            lmo.http_error,
            lmo.mesh_response_error_code,
            lmo.mesh_response_error_description,
            lmo.mesh_response_error_event,
            lmo.mesh_error,
            lmo.itk3_response_type,
            lmo.itk3_response_code,
            lmo.itk3_operation_outcome_type,
            lmo.itk3_operation_outcome_severity,
            lmo.itk3_operation_outcome_code,
            lmo.itk3_operation_outcome_description,
            lmo.itk3_error,
            lmo.created_at,
            lmo.updated_at
           FROM renalware.letter_mesh_operations lmo
          WHERE (lmo.itk3_response_type = 'bus'::renalware.enum_mesh_itk3_response_type)) bus_download_operation ON ((bus_download_operation.transmission_id = lmt.id)));


--
-- Name: letter_mesh_operations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_mesh_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_mesh_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_mesh_operations_id_seq OWNED BY renalware.letter_mesh_operations.id;


--
-- Name: letter_mesh_transmissions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_mesh_transmissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_mesh_transmissions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_mesh_transmissions_id_seq OWNED BY renalware.letter_mesh_transmissions.id;


--
-- Name: letter_qr_encoded_online_reference_links; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_qr_encoded_online_reference_links (
    id bigint NOT NULL,
    letter_id bigint NOT NULL,
    online_reference_link_id bigint NOT NULL
);


--
-- Name: letter_qr_encoded_online_reference_links_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_qr_encoded_online_reference_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_qr_encoded_online_reference_links_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_qr_encoded_online_reference_links_id_seq OWNED BY renalware.letter_qr_encoded_online_reference_links.id;


--
-- Name: letter_recipients; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_recipients (
    id integer NOT NULL,
    role character varying NOT NULL,
    person_role character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letter_id integer NOT NULL,
    addressee_type character varying,
    addressee_id integer,
    emailed_at timestamp without time zone,
    printed_at timestamp without time zone
);


--
-- Name: letter_recipients_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_recipients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_recipients_id_seq OWNED BY renalware.letter_recipients.id;


--
-- Name: letter_section_snapshots; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_section_snapshots (
    id bigint NOT NULL,
    letter_id bigint NOT NULL,
    section_identifier character varying,
    content character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: letter_section_snapshots_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_section_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_section_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_section_snapshots_id_seq OWNED BY renalware.letter_section_snapshots.id;


--
-- Name: letter_signatures; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_signatures (
    id integer NOT NULL,
    signed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letter_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: letter_signatures_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_signatures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_signatures_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_signatures_id_seq OWNED BY renalware.letter_signatures.id;


--
-- Name: letter_snomed_document_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.letter_snomed_document_types (
    id bigint NOT NULL,
    title text NOT NULL,
    code text NOT NULL,
    default_type boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE letter_snomed_document_types; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.letter_snomed_document_types IS 'SNOMED codes and their description that are attached to a letter description (aka letter topic) and used as the FHIR Composition.document_type in GP Connect messages. There can be only one default type, and this is used wherever a letter description has no associated SNOMED document type.';


--
-- Name: letter_snomed_document_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.letter_snomed_document_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_snomed_document_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.letter_snomed_document_types_id_seq OWNED BY renalware.letter_snomed_document_types.id;


--
-- Name: low_clearance_dialysis_plans; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.low_clearance_dialysis_plans (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN low_clearance_dialysis_plans.code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.low_clearance_dialysis_plans.code IS 'Required only for migration from the code-based enumeration';


--
-- Name: low_clearance_dialysis_plans_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.low_clearance_dialysis_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: low_clearance_dialysis_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.low_clearance_dialysis_plans_id_seq OWNED BY renalware.low_clearance_dialysis_plans.id;


--
-- Name: low_clearance_mdm_patients; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.low_clearance_mdm_patients AS
 SELECT p.id,
    p.secure_id,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
    rprof.esrf_on,
    mx.modality_name,
        CASE
            WHEN (pw.id > 0) THEN true
            ELSE false
        END AS on_worryboard,
    ( SELECT clinic_visits.bmi
           FROM renalware.clinic_visits
          WHERE ((clinic_visits.patient_id = p.id) AND (clinic_visits.bmi > (0)::numeric))
          ORDER BY clinic_visits.date DESC
         LIMIT 1) AS bmi,
    txrsd.name AS tx_status,
    ((pa."values" -> 'HGB'::text) ->> 'result'::text) AS hgb,
    (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
    ((pa."values" -> 'URE'::text) ->> 'result'::text) AS ure,
    (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
    ((pa."values" -> 'CRE'::text) ->> 'result'::text) AS cre,
    (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
    ((pa."values" -> 'EGFR'::text) ->> 'result'::text) AS egfr,
        CASE
            WHEN ((txrsd.code)::text !~~* '%permanent'::text) THEN true
            ELSE false
        END AS tx_candidate,
        CASE
            WHEN (renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) < (100.0)::double precision) THEN '< 100'::text
            WHEN (renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text)) > (130.0)::double precision) THEN '> 130'::text
            ELSE NULL::text
        END AS hgb_range,
        CASE
            WHEN (renalware.convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text)) >= (30.0)::double precision) THEN '>= 30'::text
            ELSE NULL::text
        END AS urea_range
   FROM (((((((renalware.patients p
     LEFT JOIN renalware.patient_worries pw ON ((pw.patient_id = p.id)))
     LEFT JOIN renalware.pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
     LEFT JOIN renalware.renal_profiles rprof ON ((rprof.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registrations txr ON ((txr.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL) AND (txrs.started_on <= CURRENT_DATE))))
     LEFT JOIN renalware.transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
     JOIN renalware.patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'low_clearance'::text))));


--
-- Name: low_clearance_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.low_clearance_profiles (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    document jsonb,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    referrer_id bigint,
    dialysis_plan_id bigint
);


--
-- Name: low_clearance_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.low_clearance_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: low_clearance_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.low_clearance_profiles_id_seq OWNED BY renalware.low_clearance_profiles.id;


--
-- Name: low_clearance_referrers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.low_clearance_referrers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: low_clearance_referrers_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.low_clearance_referrers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: low_clearance_referrers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.low_clearance_referrers_id_seq OWNED BY renalware.low_clearance_referrers.id;


--
-- Name: low_clearance_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.low_clearance_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: low_clearance_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.low_clearance_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: low_clearance_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.low_clearance_versions_id_seq OWNED BY renalware.low_clearance_versions.id;


--
-- Name: medication_current_prescriptions; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.medication_current_prescriptions AS
 SELECT DISTINCT ON (mp.patient_id, mp.id) mp.id,
    mp.patient_id,
    mp.drug_id,
    mp.treatable_type,
    mp.treatable_id,
    mp.dose_amount,
    mp.dose_unit,
    mp.medication_route_id,
    mp.route_description,
    mp.frequency,
    mp.notes,
    mp.prescribed_on,
    mp.provider,
    mp.created_at,
    mp.updated_at,
    mp.created_by_id,
    mp.updated_by_id,
    mp.administer_on_hd,
    mp.last_delivery_date,
    drugs.name AS drug_name,
    drug_types.code AS drug_type_code,
    drug_types.name AS drug_type_name
   FROM ((((renalware.medication_prescriptions mp
     LEFT JOIN renalware.medication_prescription_terminations mpt ON ((mpt.prescription_id = mp.id)))
     JOIN renalware.drugs ON ((drugs.id = mp.drug_id)))
     LEFT JOIN renalware.drug_types_drugs ON ((drug_types_drugs.drug_id = drugs.id)))
     LEFT JOIN renalware.drug_types ON ((drug_types_drugs.drug_type_id = drug_types.id)))
  WHERE ((mpt.terminated_on IS NULL) OR (mpt.terminated_on > CURRENT_DATE))
  ORDER BY mp.patient_id, mp.id;


--
-- Name: medication_delivery_event_prescriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.medication_delivery_event_prescriptions (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    prescription_id bigint NOT NULL
);


--
-- Name: TABLE medication_delivery_event_prescriptions; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.medication_delivery_event_prescriptions IS 'A cross reference table between delivery_events and prescriptions';


--
-- Name: medication_delivery_event_prescriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.medication_delivery_event_prescriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_delivery_event_prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.medication_delivery_event_prescriptions_id_seq OWNED BY renalware.medication_delivery_event_prescriptions.id;


--
-- Name: medication_delivery_events; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.medication_delivery_events (
    id bigint NOT NULL,
    homecare_form_id bigint NOT NULL,
    drug_type_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    reference_number character varying,
    prescription_duration integer,
    printed boolean DEFAULT false NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: medication_delivery_events_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.medication_delivery_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_delivery_events_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.medication_delivery_events_id_seq OWNED BY renalware.medication_delivery_events.id;


--
-- Name: medication_delivery_purchase_order_number_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.medication_delivery_purchase_order_number_seq
    AS integer
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescription_terminations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.medication_prescription_terminations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescription_terminations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.medication_prescription_terminations_id_seq OWNED BY renalware.medication_prescription_terminations.id;


--
-- Name: medication_prescription_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.medication_prescription_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: medication_prescription_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.medication_prescription_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescription_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.medication_prescription_versions_id_seq OWNED BY renalware.medication_prescription_versions.id;


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.medication_prescriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.medication_prescriptions_id_seq OWNED BY renalware.medication_prescriptions.id;


--
-- Name: medication_routes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.medication_routes (
    id integer NOT NULL,
    legacy_code character varying,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rr_code character varying,
    code character varying,
    weighting integer DEFAULT 0 NOT NULL
);


--
-- Name: medication_routes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.medication_routes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.medication_routes_id_seq OWNED BY renalware.medication_routes.id;


--
-- Name: messaging_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.messaging_messages (
    id bigint NOT NULL,
    body text NOT NULL,
    subject character varying NOT NULL,
    urgent boolean DEFAULT false NOT NULL,
    sent_at timestamp without time zone NOT NULL,
    patient_id bigint NOT NULL,
    author_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    replying_to_message_id integer,
    type character varying NOT NULL,
    public boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN messaging_messages.public; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.messaging_messages.public IS 'If true, the message will be displayed on a patient''s clinical summary and their messages page. If false (ie private), the message can only be viewed by the sender (in their sent messages) and by the recipients. New messages once this migration is run will always have public=true. Historical messages will remain private.';


--
-- Name: messaging_messages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.messaging_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messaging_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.messaging_messages_id_seq OWNED BY renalware.messaging_messages.id;


--
-- Name: messaging_receipts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.messaging_receipts (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    read_at timestamp without time zone
);


--
-- Name: messaging_receipts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.messaging_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messaging_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.messaging_receipts_id_seq OWNED BY renalware.messaging_receipts.id;


--
-- Name: modality_change_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.modality_change_types (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    "default" boolean DEFAULT false NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    require_source_hospital_centre boolean DEFAULT false NOT NULL,
    require_destination_hospital_centre boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN modality_change_types.require_source_hospital_centre; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.modality_change_types.require_source_hospital_centre IS 'When true, a source hospital must be chosen when adding the modality';


--
-- Name: COLUMN modality_change_types.require_destination_hospital_centre; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.modality_change_types.require_destination_hospital_centre IS 'When true, a destination hospital must be chosen when adding the modality';


--
-- Name: modality_change_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.modality_change_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_change_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.modality_change_types_id_seq OWNED BY renalware.modality_change_types.id;


--
-- Name: modality_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.modality_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.modality_descriptions_id_seq OWNED BY renalware.modality_descriptions.id;


--
-- Name: modality_modalities_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.modality_modalities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_modalities_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.modality_modalities_id_seq OWNED BY renalware.modality_modalities.id;


--
-- Name: modality_reasons; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.modality_reasons (
    id integer NOT NULL,
    type character varying,
    rr_code integer,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: modality_reasons_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.modality_reasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.modality_reasons_id_seq OWNED BY renalware.modality_reasons.id;


--
-- Name: modality_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.modality_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp(6) without time zone
);


--
-- Name: modality_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.modality_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.modality_versions_id_seq OWNED BY renalware.modality_versions.id;


--
-- Name: old_passwords; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.old_passwords (
    id bigint NOT NULL,
    encrypted_password character varying NOT NULL,
    password_archivable_type character varying NOT NULL,
    password_archivable_id integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: old_passwords_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.old_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.old_passwords_id_seq OWNED BY renalware.old_passwords.id;


--
-- Name: pathology_calculation_sources; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_calculation_sources (
    id bigint NOT NULL,
    calculated_observation_id bigint NOT NULL,
    source_observation_id bigint NOT NULL
);


--
-- Name: COLUMN pathology_calculation_sources.calculated_observation_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_calculation_sources.calculated_observation_id IS 'Id of the calculated observation e.g. URR derived from pre and post UREA';


--
-- Name: COLUMN pathology_calculation_sources.source_observation_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_calculation_sources.source_observation_id IS 'Id of an observation used in the calculation e.g. a UREA observation';


--
-- Name: pathology_calculation_sources_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_calculation_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_calculation_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_calculation_sources_id_seq OWNED BY renalware.pathology_calculation_sources.id;


--
-- Name: pathology_chart_series; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_chart_series (
    id bigint NOT NULL,
    chart_id bigint NOT NULL,
    observation_description_id bigint NOT NULL,
    axis renalware.pathology_chart_axis DEFAULT 'y1'::renalware.pathology_chart_axis NOT NULL,
    colour character varying,
    options jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE pathology_chart_series; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.pathology_chart_series IS 'Defines the series displayed on a predefined chart';


--
-- Name: COLUMN pathology_chart_series.colour; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_chart_series.colour IS 'Usually null, but can override the colour in the chartable row here';


--
-- Name: COLUMN pathology_chart_series.options; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_chart_series.options IS 'Optional hash to override default series settings';


--
-- Name: pathology_chart_series_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_chart_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_chart_series_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_chart_series_id_seq OWNED BY renalware.pathology_chart_series.id;


--
-- Name: pathology_charts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_charts (
    id bigint NOT NULL,
    title character varying NOT NULL,
    description text,
    display_group integer DEFAULT 1 NOT NULL,
    display_order integer DEFAULT 1 NOT NULL,
    scope character varying DEFAULT 'charts'::character varying NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    owner_id bigint,
    options jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE pathology_charts; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.pathology_charts IS 'Pre-defined charts that can appear in various places';


--
-- Name: COLUMN pathology_charts.title; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_charts.title IS 'Appears on the page next to the chart';


--
-- Name: COLUMN pathology_charts.description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_charts.description IS 'For admin use only';


--
-- Name: COLUMN pathology_charts.display_group; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_charts.display_group IS 'For grouping charts';


--
-- Name: COLUMN pathology_charts.display_order; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_charts.display_order IS 'Position of chart in a group';


--
-- Name: COLUMN pathology_charts.scope; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_charts.scope IS 'E.g. page location for chart';


--
-- Name: COLUMN pathology_charts.owner_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_charts.owner_id IS 'If set, only this user sees this chart';


--
-- Name: COLUMN pathology_charts.options; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_charts.options IS 'Optional hash to override default chart settings';


--
-- Name: pathology_charts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_charts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_charts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_charts_id_seq OWNED BY renalware.pathology_charts.id;


--
-- Name: pathology_code_group_memberships; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_code_group_memberships (
    id bigint NOT NULL,
    code_group_id bigint NOT NULL,
    observation_description_id bigint NOT NULL,
    subgroup integer DEFAULT 1 NOT NULL,
    position_within_subgroup integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id bigint,
    updated_by_id bigint
);


--
-- Name: pathology_code_group_memberships_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_code_group_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_code_group_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_code_group_memberships_id_seq OWNED BY renalware.pathology_code_group_memberships.id;


--
-- Name: pathology_code_groups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_code_groups (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id bigint,
    updated_by_id bigint,
    title character varying,
    context_specific boolean DEFAULT false NOT NULL,
    subgroup_colours renalware.enum_colour_name[],
    subgroup_titles text[] DEFAULT '{}'::text[]
);


--
-- Name: pathology_code_groups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_code_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_code_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_code_groups_id_seq OWNED BY renalware.pathology_code_groups.id;


--
-- Name: pathology_current_observation_sets_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_current_observation_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_current_observation_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_current_observation_sets_id_seq OWNED BY renalware.pathology_current_observation_sets.id;


--
-- Name: pathology_labs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_labs (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: pathology_labs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_labs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_labs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_labs_id_seq OWNED BY renalware.pathology_labs.id;


--
-- Name: pathology_measurement_units; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_measurement_units (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    ukrdc_measurement_unit_id bigint
);


--
-- Name: pathology_measurement_units_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_measurement_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_measurement_units_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_measurement_units_id_seq OWNED BY renalware.pathology_measurement_units.id;


--
-- Name: pathology_observation_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_observation_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observation_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_observation_descriptions_id_seq OWNED BY renalware.pathology_observation_descriptions.id;


--
-- Name: pathology_observation_digests; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.pathology_observation_digests AS
 SELECT obs_req.patient_id,
    (obs.observed_at)::date AS observed_on,
    jsonb_object_agg(obs_desc.code, obs.result) AS results
   FROM ((renalware.pathology_observations obs
     JOIN renalware.pathology_observation_requests obs_req ON ((obs.request_id = obs_req.id)))
     JOIN renalware.pathology_observation_descriptions obs_desc ON ((obs.description_id = obs_desc.id)))
  GROUP BY obs_req.patient_id, ((obs.observed_at)::date)
  ORDER BY obs_req.patient_id, ((obs.observed_at)::date) DESC;


--
-- Name: pathology_observation_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_observation_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observation_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_observation_requests_id_seq OWNED BY renalware.pathology_observation_requests.id;


--
-- Name: pathology_observations_grouped_by_date; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.pathology_observations_grouped_by_date AS
 SELECT obr.patient_id,
    (obs.observed_at)::date AS observed_at,
    jsonb_object_agg(pod.code, ARRAY[obs.result, (obs.comment)::character varying] ORDER BY obs.observed_at) AS results,
    pcg2.name AS "group"
   FROM ((((renalware.pathology_observations obs
     JOIN renalware.pathology_observation_requests obr ON ((obs.request_id = obr.id)))
     JOIN renalware.pathology_observation_descriptions pod ON ((obs.description_id = pod.id)))
     JOIN renalware.pathology_code_group_memberships pcgm2 ON ((pcgm2.observation_description_id = pod.id)))
     JOIN renalware.pathology_code_groups pcg2 ON ((pcg2.id = pcgm2.code_group_id)))
  GROUP BY pcg2.name, obr.patient_id, ((obs.observed_at)::date)
  ORDER BY obr.patient_id, pcg2.name, ((obs.observed_at)::date) DESC;


--
-- Name: pathology_observations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_observations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_observations_id_seq OWNED BY renalware.pathology_observations.id;


--
-- Name: pathology_obx_mappings; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_obx_mappings (
    id bigint NOT NULL,
    code_alias character varying NOT NULL,
    comment text,
    sender_id bigint NOT NULL,
    observation_description_id bigint NOT NULL,
    updated_by_id bigint,
    created_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE pathology_obx_mappings; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.pathology_obx_mappings IS 'In a multi-site installation, one hospital might use a different OBX code (eg HB or HBN) from the one Renalware expects (in this case HGB). This table enables that mapping so that incoming OBX results from different sites are mapped to a single observation_description. This table defines the expected MSH sending facility/app to match against.';


--
-- Name: COLUMN pathology_obx_mappings.code_alias; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_obx_mappings.code_alias IS 'The hosp-specific code eg ''HB''';


--
-- Name: COLUMN pathology_obx_mappings.comment; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_obx_mappings.comment IS 'Optional text to help understand mapping issues';


--
-- Name: COLUMN pathology_obx_mappings.sender_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_obx_mappings.sender_id IS 'A definition of the sending facility (eg RAJ01) and sending app (eg WinPath)';


--
-- Name: COLUMN pathology_obx_mappings.observation_description_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_obx_mappings.observation_description_id IS 'The Renalware standarised OBX we are mapping to';


--
-- Name: pathology_obx_mappings_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_obx_mappings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_obx_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_obx_mappings_id_seq OWNED BY renalware.pathology_obx_mappings.id;


--
-- Name: pathology_request_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_request_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    required_observation_description_id integer,
    expiration_days integer DEFAULT 0 NOT NULL,
    lab_id integer NOT NULL,
    bottle_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: pathology_request_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_request_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_request_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_request_descriptions_id_seq OWNED BY renalware.pathology_request_descriptions.id;


--
-- Name: pathology_request_descriptions_requests_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_request_descriptions_requests_requests (
    id integer NOT NULL,
    request_id integer NOT NULL,
    request_description_id integer NOT NULL
);


--
-- Name: pathology_request_descriptions_requests_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_request_descriptions_requests_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_request_descriptions_requests_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_request_descriptions_requests_requests_id_seq OWNED BY renalware.pathology_request_descriptions_requests_requests.id;


--
-- Name: pathology_requests_drug_categories; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_drug_categories (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: pathology_requests_drug_categories_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_drug_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_drug_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_drug_categories_id_seq OWNED BY renalware.pathology_requests_drug_categories.id;


--
-- Name: pathology_requests_drugs_drug_categories; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_drugs_drug_categories (
    id integer NOT NULL,
    drug_id integer NOT NULL,
    drug_category_id integer NOT NULL
);


--
-- Name: pathology_requests_drugs_drug_categories_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_drugs_drug_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_drugs_drug_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_drugs_drug_categories_id_seq OWNED BY renalware.pathology_requests_drugs_drug_categories.id;


--
-- Name: pathology_requests_global_rule_sets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_global_rule_sets (
    id integer NOT NULL,
    request_description_id integer NOT NULL,
    frequency_type character varying NOT NULL,
    clinic_id integer
);


--
-- Name: pathology_requests_global_rule_sets_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_global_rule_sets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_global_rule_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_global_rule_sets_id_seq OWNED BY renalware.pathology_requests_global_rule_sets.id;


--
-- Name: pathology_requests_global_rules; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_global_rules (
    id integer NOT NULL,
    rule_set_id integer,
    type character varying,
    param_id character varying,
    param_comparison_operator character varying,
    param_comparison_value character varying,
    rule_set_type character varying NOT NULL
);


--
-- Name: pathology_requests_global_rules_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_global_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_global_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_global_rules_id_seq OWNED BY renalware.pathology_requests_global_rules.id;


--
-- Name: pathology_requests_patient_rules; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_patient_rules (
    id integer NOT NULL,
    test_description text,
    sample_number_bottles integer,
    sample_type character varying,
    frequency_type character varying,
    patient_id integer,
    start_date date,
    end_date date,
    lab_id integer
);


--
-- Name: pathology_requests_patient_rules_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_patient_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_patient_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_patient_rules_id_seq OWNED BY renalware.pathology_requests_patient_rules.id;


--
-- Name: pathology_requests_patient_rules_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_patient_rules_requests (
    id integer NOT NULL,
    request_id integer NOT NULL,
    patient_rule_id integer NOT NULL
);


--
-- Name: pathology_requests_patient_rules_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_patient_rules_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_patient_rules_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_patient_rules_requests_id_seq OWNED BY renalware.pathology_requests_patient_rules_requests.id;


--
-- Name: pathology_requests_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_requests (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    clinic_id integer NOT NULL,
    telephone character varying NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    template character varying NOT NULL,
    high_risk boolean NOT NULL,
    consultant_id bigint
);


--
-- Name: pathology_requests_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_requests_id_seq OWNED BY renalware.pathology_requests_requests.id;


--
-- Name: pathology_requests_sample_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_requests_sample_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pathology_requests_sample_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_requests_sample_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_sample_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_requests_sample_types_id_seq OWNED BY renalware.pathology_requests_sample_types.id;


--
-- Name: pathology_senders; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_senders (
    id bigint NOT NULL,
    sending_facility character varying NOT NULL,
    sending_application character varying DEFAULT '*'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE pathology_senders; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.pathology_senders IS 'The HL7 MSH segment defines a sending application and sending facility e.g. at MSE Basildon ''MSH|^~&|WinPath|RAJ01|RenalWare|MSE|202110261045||ORU^R01|116182217|P|2.3|1||AL'' has application ''WinPath'' and facility ''RAJ01'' (in this case fcaility is the hospital code but that is not guaranteed), and at Kings e.g. ''MSH|^~&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||'' contains application ''HM'' and facility ''LBE''. Defining in this table the expected HL7 sending facilities (and optional applications) allows us to use these definitions when creating OBX mappings - for instance we can delcare that the OBX code ''HB'' from sending facility ''RAJ32'' should map to the observation description with code ''HGB''.';


--
-- Name: COLUMN pathology_senders.sending_facility; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_senders.sending_facility IS 'From MSH segment';


--
-- Name: COLUMN pathology_senders.sending_application; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.pathology_senders.sending_application IS 'From MSH segment';


--
-- Name: pathology_senders_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_senders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_senders_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_senders_id_seq OWNED BY renalware.pathology_senders.id;


--
-- Name: pathology_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pathology_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: pathology_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pathology_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pathology_versions_id_seq OWNED BY renalware.pathology_versions.id;


--
-- Name: patient_alerts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_alerts (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    notes text,
    urgent boolean DEFAULT false NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    covid_19 boolean DEFAULT false NOT NULL
);


--
-- Name: patient_alerts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_alerts_id_seq OWNED BY renalware.patient_alerts.id;


--
-- Name: patient_attachment_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_attachment_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    store_file_externally boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_attachment_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_attachment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_attachment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_attachment_types_id_seq OWNED BY renalware.patient_attachment_types.id;


--
-- Name: patient_attachments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_attachments (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    attachment_type_id bigint NOT NULL,
    name character varying,
    description text,
    external_location character varying,
    updated_by_id bigint,
    created_by_id bigint,
    document_date date,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_attachments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_attachments_id_seq OWNED BY renalware.patient_attachments.id;


--
-- Name: patient_bookmarks; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_bookmarks (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text,
    urgent boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    tags character varying
);


--
-- Name: patient_bookmarks_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_bookmarks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_bookmarks_id_seq OWNED BY renalware.patient_bookmarks.id;


--
-- Name: patient_ethnicities; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_ethnicities (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cfh_name character varying,
    rr18_code character varying
);


--
-- Name: patient_ethnicities_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_ethnicities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_ethnicities_id_seq OWNED BY renalware.patient_ethnicities.id;


--
-- Name: patient_languages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_languages (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying
);


--
-- Name: patient_languages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_languages_id_seq OWNED BY renalware.patient_languages.id;


--
-- Name: patient_master_index; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_master_index (
    id bigint NOT NULL,
    patient_id bigint,
    nhs_number character varying,
    hospital_number character varying,
    title character varying,
    family_name character varying,
    middle_name character varying,
    given_name character varying,
    suffix character varying,
    sex character varying,
    born_on date,
    died_at timestamp without time zone,
    ethnicity character varying,
    practice_code character varying,
    gp_code character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_master_index_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_master_index_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_master_index_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_master_index_id_seq OWNED BY renalware.patient_master_index.id;


--
-- Name: patient_practice_memberships; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_practice_memberships (
    id integer NOT NULL,
    practice_id integer NOT NULL,
    primary_care_physician_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_change_date date,
    joined_on date,
    left_on date,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: patient_practice_memberships_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_practice_memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_practice_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_practice_memberships_id_seq OWNED BY renalware.patient_practice_memberships.id;


--
-- Name: patient_practices_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_practices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_practices_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_practices_id_seq OWNED BY renalware.patient_practices.id;


--
-- Name: patient_primary_care_physicians; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_primary_care_physicians (
    id integer NOT NULL,
    given_name character varying,
    family_name character varying,
    code character varying,
    practitioner_type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    telephone character varying,
    deleted_at timestamp without time zone,
    name character varying
);


--
-- Name: patient_primary_care_physicians_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_primary_care_physicians_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_primary_care_physicians_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_primary_care_physicians_id_seq OWNED BY renalware.patient_primary_care_physicians.id;


--
-- Name: patient_religions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_religions (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: patient_religions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_religions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_religions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_religions_id_seq OWNED BY renalware.patient_religions.id;


--
-- Name: problem_problems; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_problems (
    id integer NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    patient_id integer NOT NULL,
    description character varying NOT NULL,
    date date,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer,
    snomed_id character varying,
    date_display_style renalware.problem_date_display_style_enum
);


--
-- Name: patient_summaries; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.patient_summaries AS
 SELECT id AS patient_id,
    ( SELECT count(*) AS count
           FROM renalware.events
          WHERE ((events.patient_id = patients.id) AND (events.deleted_at IS NULL))) AS events_count,
    ( SELECT count(*) AS count
           FROM renalware.clinic_visits
          WHERE (clinic_visits.patient_id = patients.id)) AS clinic_visits_count,
    ( SELECT count(*) AS count
           FROM renalware.letter_letters
          WHERE (letter_letters.patient_id = patients.id)) AS letters_count,
    ( SELECT count(*) AS count
           FROM renalware.modality_modalities
          WHERE (modality_modalities.patient_id = patients.id)) AS modalities_count,
    ( SELECT count(*) AS count
           FROM renalware.problem_problems
          WHERE ((problem_problems.deleted_at IS NULL) AND (problem_problems.patient_id = patients.id))) AS problems_count,
    ( SELECT count(*) AS count
           FROM renalware.pathology_observation_requests
          WHERE (pathology_observation_requests.patient_id = patients.id)) AS observation_requests_count,
    ( SELECT count(*) AS count
           FROM (renalware.medication_prescriptions p
             FULL JOIN renalware.medication_prescription_terminations pt ON ((pt.prescription_id = p.id)))
          WHERE ((p.patient_id = patients.id) AND ((pt.terminated_on IS NULL) OR (pt.terminated_on > CURRENT_TIMESTAMP)))) AS prescriptions_count,
    ( SELECT count(*) AS count
           FROM renalware.letter_contacts
          WHERE (letter_contacts.patient_id = patients.id)) AS contacts_count,
    ( SELECT count(*) AS count
           FROM renalware.transplant_recipient_operations
          WHERE (transplant_recipient_operations.patient_id = patients.id)) AS recipient_operations_count,
    ( SELECT count(*) AS count
           FROM renalware.admission_admissions
          WHERE (admission_admissions.patient_id = patients.id)) AS admissions_count,
    ( SELECT count(*) AS count
           FROM renalware.patient_attachments
          WHERE ((patient_attachments.patient_id = patients.id) AND (patient_attachments.deleted_at IS NULL))) AS attachments_count
   FROM renalware.patients;


--
-- Name: patient_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: patient_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_versions_id_seq OWNED BY renalware.patient_versions.id;


--
-- Name: patient_worries_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_worries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_worries_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_worries_id_seq OWNED BY renalware.patient_worries.id;


--
-- Name: patient_worry_categories; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.patient_worry_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    worries_count integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: COLUMN patient_worry_categories.worries_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.patient_worry_categories.worries_count IS 'Counter cache for the number of worries with this category';


--
-- Name: patient_worry_categories_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patient_worry_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_worry_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patient_worry_categories_id_seq OWNED BY renalware.patient_worry_categories.id;


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.patients_id_seq OWNED BY renalware.patients.id;


--
-- Name: pd_adequacy_results; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_adequacy_results (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    performed_on date NOT NULL,
    dial_24_vol_in integer,
    dial_24_vol_out integer,
    dial_24_missing boolean DEFAULT false NOT NULL,
    urine_24_vol integer,
    urine_24_missing boolean DEFAULT false NOT NULL,
    serum_urea double precision,
    serum_creatinine double precision,
    plasma_glc double precision,
    serum_ab double precision,
    dialysate_urea double precision,
    dialysate_creatinine double precision,
    dialysate_glu double precision,
    dialysate_na double precision,
    dialysate_protein double precision,
    urine_urea double precision,
    urine_creatinine double precision,
    urine_na double precision,
    urine_k double precision,
    total_creatinine_clearance double precision,
    pertitoneal_creatinine_clearance double precision,
    renal_creatinine_clearance double precision,
    total_ktv double precision,
    pertitoneal_ktv double precision,
    renal_ktv double precision,
    dietry_protein_intake double precision,
    complete boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    height double precision,
    weight double precision
);


--
-- Name: pd_adequacy_results_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_adequacy_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_adequacy_results_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_adequacy_results_id_seq OWNED BY renalware.pd_adequacy_results.id;


--
-- Name: pd_assessments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_assessments (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    document jsonb,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_assessments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_assessments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_assessments_id_seq OWNED BY renalware.pd_assessments.id;


--
-- Name: pd_bag_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_bag_types (
    id integer NOT NULL,
    manufacturer character varying NOT NULL,
    description character varying NOT NULL,
    glucose_content numeric(4,2) NOT NULL,
    amino_acid boolean,
    icodextrin boolean,
    low_glucose_degradation boolean,
    low_sodium boolean,
    sodium_content integer,
    lactate_content integer,
    bicarbonate_content integer,
    calcium_content numeric(3,2),
    magnesium_content numeric(3,2),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    glucose_strength integer NOT NULL
);


--
-- Name: pd_bag_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_bag_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_bag_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_bag_types_id_seq OWNED BY renalware.pd_bag_types.id;


--
-- Name: pd_exit_site_infections; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_exit_site_infections (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    diagnosis_date date NOT NULL,
    treatment text,
    outcome text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recurrent boolean,
    cleared boolean,
    catheter_removed boolean,
    clinical_presentation character varying[]
);


--
-- Name: pd_exit_site_infections_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_exit_site_infections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_exit_site_infections_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_exit_site_infections_id_seq OWNED BY renalware.pd_exit_site_infections.id;


--
-- Name: pd_fluid_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_fluid_descriptions (
    id integer NOT NULL,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_fluid_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_fluid_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_fluid_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_fluid_descriptions_id_seq OWNED BY renalware.pd_fluid_descriptions.id;


--
-- Name: pd_infection_organisms; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_infection_organisms (
    id integer NOT NULL,
    organism_code_id integer NOT NULL,
    sensitivity text,
    infectable_type character varying,
    infectable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    resistance text
);


--
-- Name: pd_infection_organisms_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_infection_organisms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_infection_organisms_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_infection_organisms_id_seq OWNED BY renalware.pd_infection_organisms.id;


--
-- Name: pd_peritonitis_episodes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_peritonitis_episodes (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    diagnosis_date date NOT NULL,
    treatment_start_date date,
    treatment_end_date date,
    episode_type_id integer,
    catheter_removed boolean,
    line_break boolean,
    exit_site_infection boolean,
    diarrhoea boolean,
    abdominal_pain boolean,
    fluid_description_id integer,
    white_cell_total integer,
    white_cell_neutro integer,
    white_cell_lympho integer,
    white_cell_degen integer,
    white_cell_other integer,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_mdm_patients; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.pd_mdm_patients AS
 SELECT DISTINCT ON (p.id) p.id,
    p.secure_id,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
    rprof.esrf_on,
    mx.modality_name,
        CASE
            WHEN (pw.id > 0) THEN true
            ELSE false
        END AS on_worryboard,
    txrsd.name AS tx_status,
        CASE pr.type
            WHEN 'Renalware::PD::APDRegime'::text THEN 'APD'::text
            WHEN 'Renalware::PD::CAPDRegime'::text THEN 'CAPD'::text
            ELSE NULL::text
        END AS pd_type,
    ( SELECT date(e.date_time) AS date
           FROM (renalware.events e
             JOIN renalware.event_types et ON ((et.id = e.event_type_id)))
          WHERE (((et.slug)::text = 'pd_line_changes'::text) AND (e.patient_id = p.id) AND (e.deleted_at IS NULL))
          ORDER BY e.date_time DESC
         LIMIT 1) AS last_line_change_date,
    pesi.diagnosis_date AS last_esi_date,
    ppe.diagnosis_date AS last_peritonitis_date,
    ( SELECT cv2.bmi
           FROM renalware.clinic_visits cv2
          WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
          ORDER BY cv2.date DESC
         LIMIT 1) AS bmi,
    renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
    (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
    renalware.convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
    (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
    renalware.convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
    (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
    renalware.convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr,
    (((pa."values" -> 'POT'::text) ->> 'observed_at'::text))::date AS pot_date,
    renalware.convert_to_float(((pa."values" -> 'POT'::text) ->> 'result'::text), NULL::double precision) AS pot,
    (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
    (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
    h.name AS hospital_centre
   FROM (((((((((((((renalware.patients p
     LEFT JOIN renalware.patient_worries pw ON ((pw.patient_id = p.id)))
     LEFT JOIN renalware.pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
     LEFT JOIN renalware.renal_profiles rprof ON ((rprof.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registrations txr ON ((txr.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
     LEFT JOIN renalware.transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
     LEFT JOIN renalware.pd_regimes pr ON (((pr.patient_id = p.id) AND (pr.start_date <= CURRENT_DATE) AND (pr.end_date IS NULL))))
     LEFT JOIN renalware.pd_exit_site_infections pesi ON ((pesi.patient_id = p.id)))
     LEFT JOIN renalware.pd_peritonitis_episodes ppe ON ((ppe.patient_id = p.id)))
     LEFT JOIN renalware.users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
     LEFT JOIN renalware.users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
     LEFT JOIN renalware.hospital_centres h ON ((h.id = p.hospital_centre_id)))
     JOIN renalware.patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'pd'::text))))
  ORDER BY p.id, pr.start_date DESC, pr.created_at DESC, pesi.diagnosis_date DESC, ppe.diagnosis_date DESC;


--
-- Name: pd_organism_codes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_organism_codes (
    id integer NOT NULL,
    code character varying,
    name character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_organism_codes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_organism_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_organism_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_organism_codes_id_seq OWNED BY renalware.pd_organism_codes.id;


--
-- Name: pd_peritonitis_episode_type_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_peritonitis_episode_type_descriptions (
    id integer NOT NULL,
    term character varying,
    definition character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_peritonitis_episode_type_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_peritonitis_episode_type_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_peritonitis_episode_type_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_peritonitis_episode_type_descriptions_id_seq OWNED BY renalware.pd_peritonitis_episode_type_descriptions.id;


--
-- Name: pd_peritonitis_episode_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_peritonitis_episode_types (
    id integer NOT NULL,
    peritonitis_episode_id integer NOT NULL,
    peritonitis_episode_type_description_id integer NOT NULL
);


--
-- Name: pd_peritonitis_episode_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_peritonitis_episode_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_peritonitis_episode_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_peritonitis_episode_types_id_seq OWNED BY renalware.pd_peritonitis_episode_types.id;


--
-- Name: pd_peritonitis_episodes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_peritonitis_episodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_peritonitis_episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_peritonitis_episodes_id_seq OWNED BY renalware.pd_peritonitis_episodes.id;


--
-- Name: pd_pet_adequacy_results; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_pet_adequacy_results (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    pet_date date,
    pet_type character varying,
    pet_duration numeric(8,1),
    pet_net_uf integer,
    dialysate_creat_plasma_ratio numeric(8,2),
    dialysate_glucose_start numeric(8,1),
    dialysate_glucose_end numeric(8,1),
    adequacy_date date,
    ktv_total numeric(8,2),
    ktv_dialysate numeric(8,2),
    ktv_rrf numeric(8,2),
    crcl_total integer,
    crcl_dialysate integer,
    crcl_rrf integer,
    daily_uf integer,
    daily_urine integer,
    date_rff date,
    creat_value integer,
    dialysate_effluent_volume numeric(8,2),
    date_creat_clearance date,
    date_creat_value date,
    urine_urea_conc numeric(8,1),
    urine_creat_conc integer,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    dietry_protein_intake numeric(8,2)
);


--
-- Name: pd_pet_adequacy_results_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_pet_adequacy_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_pet_adequacy_results_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_pet_adequacy_results_id_seq OWNED BY renalware.pd_pet_adequacy_results.id;


--
-- Name: pd_pet_dextrose_concentrations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_pet_dextrose_concentrations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    value double precision NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_pet_dextrose_concentrations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_pet_dextrose_concentrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_pet_dextrose_concentrations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_pet_dextrose_concentrations_id_seq OWNED BY renalware.pd_pet_dextrose_concentrations.id;


--
-- Name: pd_pet_results; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_pet_results (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    performed_on date NOT NULL,
    test_type renalware.pd_pet_type NOT NULL,
    volume_in integer,
    volume_out integer,
    dextrose_concentration_id bigint,
    infusion_time integer,
    drain_time integer,
    overnight_volume_in integer,
    overnight_volume_out integer,
    overnight_dextrose_concentration_id bigint,
    overnight_dwell_time integer,
    sample_0hr_time double precision,
    sample_0hr_urea double precision,
    sample_0hr_creatinine double precision,
    sample_0hr_glc double precision,
    sample_0hr_sodium double precision,
    sample_0hr_protein double precision,
    sample_2hr_time double precision,
    sample_2hr_urea double precision,
    sample_2hr_creatinine double precision,
    sample_2hr_glc double precision,
    sample_2hr_sodium double precision,
    sample_2hr_protein double precision,
    sample_4hr_time double precision,
    sample_4hr_urea double precision,
    sample_4hr_creatinine double precision,
    sample_4hr_glc double precision,
    sample_4hr_sodium double precision,
    sample_4hr_protein double precision,
    sample_6hr_time double precision,
    sample_6hr_urea double precision,
    sample_6hr_creatinine double precision,
    sample_6hr_glc double precision,
    sample_6hr_sodium double precision,
    sample_6hr_protein double precision,
    serum_time double precision,
    serum_urea double precision,
    serum_creatinine double precision,
    plasma_glc double precision,
    serum_ab double precision,
    serum_na double precision,
    net_uf integer,
    d_pcr double precision,
    complete boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_pet_results_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_pet_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_pet_results_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_pet_results_id_seq OWNED BY renalware.pd_pet_results.id;


--
-- Name: pd_regime_bags; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_regime_bags (
    id integer NOT NULL,
    regime_id integer NOT NULL,
    bag_type_id integer NOT NULL,
    volume integer NOT NULL,
    per_week integer,
    monday boolean,
    tuesday boolean,
    wednesday boolean,
    thursday boolean,
    friday boolean,
    saturday boolean,
    sunday boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role character varying,
    capd_overnight_bag boolean DEFAULT false NOT NULL
);


--
-- Name: pd_regime_bags_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_regime_bags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regime_bags_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_regime_bags_id_seq OWNED BY renalware.pd_regime_bags.id;


--
-- Name: pd_regime_for_modalities; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.pd_regime_for_modalities AS
 WITH pd_modalities AS (
         SELECT m_1.patient_id,
            m_1.id AS modality_id,
            m_1.started_on,
            m_1.ended_on
           FROM (renalware.modality_modalities m_1
             JOIN renalware.modality_descriptions md ON ((md.id = m_1.description_id)))
          WHERE ((md.name)::text = 'PD'::text)
        ), distinct_pd_regimes AS (
         SELECT DISTINCT ON (pd_regimes.patient_id, pd_regimes.start_date) pd_regimes.id AS pd_regime_id,
            pd_regimes.patient_id,
            pd_regimes.start_date,
            pd_regimes.end_date,
            pd_regimes.created_at
           FROM renalware.pd_regimes
          ORDER BY pd_regimes.patient_id, pd_regimes.start_date, pd_regimes.created_at DESC
        )
 SELECT patient_id,
    modality_id,
    started_on,
    ended_on,
    ( SELECT pdr.pd_regime_id
           FROM distinct_pd_regimes pdr
          WHERE ((pdr.patient_id = m.patient_id) AND ((pdr.end_date IS NULL) OR (pdr.end_date > m.started_on)))
          ORDER BY pdr.created_at
         LIMIT 1) AS pd_regime_id
   FROM pd_modalities m
  ORDER BY patient_id;


--
-- Name: pd_regime_terminations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_regime_terminations (
    id integer NOT NULL,
    terminated_on date NOT NULL,
    regime_id integer NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_regime_terminations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_regime_terminations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regime_terminations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_regime_terminations_id_seq OWNED BY renalware.pd_regime_terminations.id;


--
-- Name: pd_regimes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_regimes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regimes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_regimes_id_seq OWNED BY renalware.pd_regimes.id;


--
-- Name: pd_systems; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_systems (
    id integer NOT NULL,
    pd_type character varying NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_systems_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_systems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_systems_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_systems_id_seq OWNED BY renalware.pd_systems.id;


--
-- Name: pd_training_sessions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_training_sessions (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    training_site_id integer NOT NULL,
    document jsonb,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    training_type_id integer NOT NULL
);


--
-- Name: pd_training_sessions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_training_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_training_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_training_sessions_id_seq OWNED BY renalware.pd_training_sessions.id;


--
-- Name: pd_training_sites; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_training_sites (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_training_sites_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_training_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_training_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_training_sites_id_seq OWNED BY renalware.pd_training_sites.id;


--
-- Name: pd_training_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.pd_training_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_training_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.pd_training_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_training_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.pd_training_types_id_seq OWNED BY renalware.pd_training_types.id;


--
-- Name: problem_comorbidities; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_comorbidities (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    description_id bigint NOT NULL,
    recognised renalware.tristate_type DEFAULT 'unknown'::renalware.tristate_type NOT NULL,
    recognised_at date,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    malignancy_site_id bigint,
    diabetes_type character varying
);


--
-- Name: TABLE problem_comorbidities; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.problem_comorbidities IS 'A single comobidity problem for a patient. A patient can only have one per description';


--
-- Name: COLUMN problem_comorbidities.recognised_at; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.problem_comorbidities.recognised_at IS 'Note often only year is known';


--
-- Name: problem_comorbidities_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_comorbidities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_comorbidities_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_comorbidities_id_seq OWNED BY renalware.problem_comorbidities.id;


--
-- Name: problem_comorbidity_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_comorbidity_descriptions (
    id bigint NOT NULL,
    name text NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    snomed_code character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    has_malignancy_site boolean DEFAULT false NOT NULL,
    has_diabetes_type boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE problem_comorbidity_descriptions; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.problem_comorbidity_descriptions IS 'The supported list of cormbidities that can be recorded for a patient';


--
-- Name: COLUMN problem_comorbidity_descriptions."position"; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.problem_comorbidity_descriptions."position" IS 'Display order';


--
-- Name: COLUMN problem_comorbidity_descriptions.snomed_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.problem_comorbidity_descriptions.snomed_code IS 'Used in UKRDC exports';


--
-- Name: problem_comorbidity_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_comorbidity_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_comorbidity_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_comorbidity_descriptions_id_seq OWNED BY renalware.problem_comorbidity_descriptions.id;


--
-- Name: problem_malignancy_sites; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_malignancy_sites (
    id bigint NOT NULL,
    description text NOT NULL,
    rr_19_code character varying
);


--
-- Name: COLUMN problem_malignancy_sites.rr_19_code; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.problem_malignancy_sites.rr_19_code IS 'Renal Registry dataset v5 RR19 code';


--
-- Name: problem_malignancy_sites_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_malignancy_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_malignancy_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_malignancy_sites_id_seq OWNED BY renalware.problem_malignancy_sites.id;


--
-- Name: problem_notes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_notes (
    id integer NOT NULL,
    problem_id integer,
    description text NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: problem_notes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_notes_id_seq OWNED BY renalware.problem_notes.id;


--
-- Name: problem_problems_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_problems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_problems_id_seq OWNED BY renalware.problem_problems.id;


--
-- Name: problem_radar_cohorts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_radar_cohorts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: problem_radar_cohorts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_radar_cohorts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_radar_cohorts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_radar_cohorts_id_seq OWNED BY renalware.problem_radar_cohorts.id;


--
-- Name: problem_radar_diagnoses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_radar_diagnoses (
    id bigint NOT NULL,
    cohort_id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description_regex text,
    snomed_regex text
);


--
-- Name: COLUMN problem_radar_diagnoses.description_regex; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.problem_radar_diagnoses.description_regex IS 'Optional regex eg ''AH (amyloidosis|amylidos.*)'' against which patient problem descriptions will be matched (in addition to matching purely against the diagnosis.name) when trying to ascertain if the patient has this rare renal diagnosis. Supporting regexes allows for problem variants and for spelling mistakes in non-SNOMED coded problems.';


--
-- Name: COLUMN problem_radar_diagnoses.snomed_regex; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.problem_radar_diagnoses.snomed_regex IS 'Optional regex eg ''(123123|345345|123123123123.*)'' against which patient problem snomed_codes will be matched (in addition to matching purely against the diagnosis.name) when trying to ascertain if the patient has this rare renal disease. Supporting regexes allows us to match a problem that has a SNOMED code that is the exact match, parent or child of the target RaDaR diagnosis SNOMED code.';


--
-- Name: problem_radar_diagnoses_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_radar_diagnoses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_radar_diagnoses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_radar_diagnoses_id_seq OWNED BY renalware.problem_radar_diagnoses.id;


--
-- Name: problem_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.problem_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: problem_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.problem_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.problem_versions_id_seq OWNED BY renalware.problem_versions.id;


--
-- Name: remote_monitoring_frequencies; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.remote_monitoring_frequencies (
    id bigint NOT NULL,
    period interval NOT NULL,
    deleted_at timestamp(6) without time zone,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: remote_monitoring_frequencies_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.remote_monitoring_frequencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: remote_monitoring_frequencies_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.remote_monitoring_frequencies_id_seq OWNED BY renalware.remote_monitoring_frequencies.id;


--
-- Name: remote_monitoring_referral_reasons; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.remote_monitoring_referral_reasons (
    id bigint NOT NULL,
    description text NOT NULL,
    deleted_at timestamp(6) without time zone,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: remote_monitoring_referral_reasons_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.remote_monitoring_referral_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: remote_monitoring_referral_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.remote_monitoring_referral_reasons_id_seq OWNED BY renalware.remote_monitoring_referral_reasons.id;


--
-- Name: renal_aki_alert_actions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.renal_aki_alert_actions (
    id bigint NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: renal_aki_alert_actions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.renal_aki_alert_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_aki_alert_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.renal_aki_alert_actions_id_seq OWNED BY renalware.renal_aki_alert_actions.id;


--
-- Name: renal_aki_alerts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.renal_aki_alerts (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    action_id bigint,
    hospital_ward_id bigint,
    hotlist boolean DEFAULT false NOT NULL,
    action character varying,
    notes text,
    updated_by_id bigint,
    created_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    max_cre integer,
    cre_date date,
    max_aki integer,
    aki_date date,
    hospital_centre_id bigint
);


--
-- Name: renal_aki_alerts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.renal_aki_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_aki_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.renal_aki_alerts_id_seq OWNED BY renalware.renal_aki_alerts.id;


--
-- Name: renal_prd_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.renal_prd_descriptions (
    id integer NOT NULL,
    code character varying,
    term character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: renal_prd_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.renal_prd_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_prd_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.renal_prd_descriptions_id_seq OWNED BY renalware.renal_prd_descriptions.id;


--
-- Name: renal_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.renal_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.renal_profiles_id_seq OWNED BY renalware.renal_profiles.id;


--
-- Name: renal_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.renal_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: renal_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.renal_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.renal_versions_id_seq OWNED BY renalware.renal_versions.id;


--
-- Name: reporting_anaemia_audit; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.reporting_anaemia_audit AS
 SELECT e1.modality_desc AS modality,
    count(e1.patient_id) AS patient_count,
    round(avg(e2.hgb), 2) AS avg_hgb,
    round((((count(e4.hgb_gt_eq_10))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_10,
    round((((count(e5.hgb_gt_eq_11))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_11,
    round((((count(e6.hgb_gt_eq_13))::numeric / GREATEST((count(e2.hgb))::numeric, 1.0)) * 100.0), 2) AS pct_hgb_gt_eq_13,
    round(avg(e3.fer), 2) AS avg_fer,
    round((((count(e7.fer_gt_eq_150))::numeric / GREATEST((count(e3.fer))::numeric, 1.0)) * 100.0), 2) AS pct_fer_gt_eq_150,
    (COALESCE(sum(immunosuppressants.ct), (0)::numeric))::integer AS count_epo,
    (COALESCE(sum(mircer.ct), (0)::numeric))::integer AS count_mircer,
    (COALESCE(sum(neo.ct), (0)::numeric))::integer AS count_neo,
    (COALESCE(sum(ara.ct), (0)::numeric))::integer AS count_ara
   FROM ((((((((((( SELECT p.id AS patient_id,
            md.name AS modality_desc,
            md.code AS modality_code
           FROM ((renalware.patients p
             JOIN renalware.modality_modalities m ON ((m.patient_id = p.id)))
             JOIN renalware.modality_descriptions md ON ((m.description_id = md.id)))
          WHERE ((m.ended_on IS NULL) OR (m.ended_on > CURRENT_TIMESTAMP))) e1
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM renalware.medication_current_prescriptions mcp
          WHERE ((mcp.drug_type_code)::text = 'immunosuppressant'::text)
          GROUP BY mcp.patient_id) immunosuppressants ON ((e1.patient_id = immunosuppressants.patient_id)))
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM renalware.medication_current_prescriptions mcp
          WHERE ((mcp.drug_name)::text ~~ 'Mircer%'::text)
          GROUP BY mcp.patient_id) mircer ON ((e1.patient_id = mircer.patient_id)))
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM renalware.medication_current_prescriptions mcp
          WHERE ((mcp.drug_name)::text ~~ 'Neo%'::text)
          GROUP BY mcp.patient_id) neo ON ((e1.patient_id = neo.patient_id)))
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM renalware.medication_current_prescriptions mcp
          WHERE ((mcp.drug_name)::text ~~ 'Ara%'::text)
          GROUP BY mcp.patient_id) ara ON ((e1.patient_id = ara.patient_id)))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS hgb
           FROM public.pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'HGB'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS fer
           FROM public.pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'FER'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_10
          WHERE (e2.hgb >= (10)::numeric)) e4 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_11
          WHERE (e2.hgb >= (11)::numeric)) e5 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_13
          WHERE (e2.hgb >= (13)::numeric)) e6 ON (true))
     LEFT JOIN LATERAL ( SELECT e3.fer AS fer_gt_eq_150
          WHERE (e3.fer >= (150)::numeric)) e7 ON (true))
  WHERE ((e1.modality_code)::text = ANY (ARRAY[('hd'::character varying)::text, ('pd'::character varying)::text, ('transplant'::character varying)::text, ('low_clearance'::character varying)::text, ('nephrology'::character varying)::text]))
  GROUP BY e1.modality_desc;


--
-- Name: reporting_audits; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.reporting_audits (
    id integer NOT NULL,
    name character varying NOT NULL,
    view_name character varying NOT NULL,
    refreshed_at timestamp without time zone,
    refresh_schedule character varying DEFAULT '1 0 * * 1-6'::character varying,
    display_configuration text DEFAULT '{}'::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    materialized boolean DEFAULT true NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


--
-- Name: reporting_audits_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.reporting_audits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reporting_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.reporting_audits_id_seq OWNED BY renalware.reporting_audits.id;


--
-- Name: reporting_bone_audit; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.reporting_bone_audit AS
 SELECT e1.modality_desc AS modality,
    count(e1.patient_id) AS patient_count,
    round(avg(e4.cca), 2) AS avg_cca,
    round((((count(e8.cca_2_1_to_2_4))::numeric / GREATEST((count(e4.cca))::numeric, 1.0)) * 100.0), 2) AS pct_cca_2_1_to_2_4,
    round((((count(e7.pth_gt_300))::numeric / GREATEST((count(e2.pth))::numeric, 1.0)) * 100.0), 2) AS pct_pth_gt_300,
    round((((count(e6.pth_gt_800))::numeric / GREATEST((count(e2.pth))::numeric, 1.0)) * 100.0), 2) AS pct_pth_gt_800_pct,
    round(avg(e3.phos), 2) AS avg_phos,
    max(e3.phos) AS max_phos,
    round((((count(e5.phos_lt_1_8))::numeric / GREATEST((count(e3.phos))::numeric, 1.0)) * 100.0), 2) AS pct_phos_lt_1_8
   FROM (((((((( SELECT p.id AS patient_id,
            md.name AS modality_desc,
            md.code AS modality_code
           FROM ((renalware.patients p
             JOIN renalware.modality_modalities m ON ((m.patient_id = p.id)))
             JOIN renalware.modality_descriptions md ON ((m.description_id = md.id)))) e1
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS pth
           FROM public.pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'PTHI'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS phos
           FROM public.pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'PHOS'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS cca
           FROM public.pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'CCA'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e4 ON (true))
     LEFT JOIN LATERAL ( SELECT e3.phos AS phos_lt_1_8
          WHERE (e3.phos < 1.8)) e5 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_800
          WHERE (e2.pth > (800)::numeric)) e6 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_300
          WHERE (e2.pth > (300)::numeric)) e7 ON (true))
     LEFT JOIN LATERAL ( SELECT e4.cca AS cca_2_1_to_2_4
          WHERE ((e4.cca >= 2.1) AND (e4.cca <= 2.4))) e8 ON (true))
  WHERE ((e1.modality_code)::text = ANY (ARRAY[('hd'::character varying)::text, ('pd'::character varying)::text, ('transplant'::character varying)::text, ('low_clearance'::character varying)::text]))
  GROUP BY e1.modality_desc;


--
-- Name: reporting_daily_letters; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.reporting_daily_letters AS
 SELECT ( SELECT count(*) AS count
           FROM renalware.letter_letters
          WHERE ((letter_letters.created_at)::date = (now())::date)) AS letters_created_today,
    ( SELECT count(*) AS count
           FROM renalware.letter_letters
          WHERE ((letter_letters.completed_at)::date = (now())::date)) AS letters_printed_today,
    ( SELECT count(*) AS count
           FROM renalware.letter_letters
          WHERE (((letter_letters.type)::text = 'Renalware::Letters::Letter::Draft'::text) AND (letter_letters.created_at < (CURRENT_DATE - '14 days'::interval)))) AS draft_letters_older_than_14_days;


--
-- Name: reporting_daily_ukrdc; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.reporting_daily_ukrdc AS
 SELECT ( SELECT count(*) AS count
           FROM renalware.patients
          WHERE ((patients.sent_to_ukrdc_at)::date = CURRENT_DATE)) AS patients_sent_to_ukrdc_today;


--
-- Name: reporting_hd_blood_pressures_audit; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW renalware.reporting_hd_blood_pressures_audit AS
 WITH blood_pressures AS (
         SELECT hd_sessions.id AS session_id,
            patients.id AS patient_id,
            hd_sessions.hospital_unit_id,
            (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_pre,
            (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_pre,
            (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_post,
            (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_post
           FROM (renalware.hd_sessions
             JOIN renalware.patients ON ((patients.id = hd_sessions.patient_id)))
          WHERE ((hd_sessions.signed_off_at IS NOT NULL) AND (hd_sessions.deleted_at IS NULL))
        ), some_other_derived_table_variable AS (
         SELECT 1 AS "?column?"
           FROM blood_pressures blood_pressures_1
        )
 SELECT hu.name AS hospital_unit_name,
    round(avg((blood_pressures.systolic_pre)::integer)) AS systolic_pre_avg,
    round(avg((blood_pressures.diastolic_pre)::integer)) AS diastolic_pre_avg,
    round(avg((blood_pressures.systolic_post)::integer)) AS systolic_post_avg,
    round(avg((blood_pressures.diastolic_post)::integer)) AS distolic_post_avg
   FROM (blood_pressures
     JOIN renalware.hospital_units hu ON ((hu.id = blood_pressures.hospital_unit_id)))
  GROUP BY hu.name
  WITH NO DATA;


--
-- Name: reporting_hd_overall_audit; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW renalware.reporting_hd_overall_audit AS
 WITH fistula_or_graft_access_types AS (
         SELECT access_types.id
           FROM renalware.access_types
          WHERE (((access_types.name)::text ~~* '%fistula%'::text) OR ((access_types.name)::text ~~* '%graft%'::text))
        ), patients_w_fistula_or_graft AS (
         SELECT access_profiles.patient_id
           FROM renalware.access_profiles
          WHERE (access_profiles.type_id IN ( SELECT fistula_or_graft_access_types.id
                   FROM fistula_or_graft_access_types))
        ), stats AS (
         SELECT s.patient_id,
            s.hospital_unit_id,
            s.month,
            s.year,
            s.session_count,
            s.number_of_missed_sessions,
            s.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct,
            (EXISTS ( SELECT x.patient_id
                   FROM patients_w_fistula_or_graft x
                  WHERE (x.patient_id = s.patient_id))) AS has_fistula_or_graft,
            ((((s.number_of_missed_sessions)::double precision / NULLIF((s.session_count)::double precision, (0)::double precision)) * (100.0)::double precision) > (10.0)::double precision) AS missed_sessions_gt_10_pct,
            (s.dialysis_minutes_shortfall)::double precision AS dialysis_minutes_shortfall,
            (renalware.convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (100)::double precision) AS hgb_gt_100,
            (renalware.convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (130)::double precision) AS hgb_gt_130,
            (renalware.convert_to_float(((s.pathology_snapshot -> 'PTHI'::text) ->> 'result'::text)) < (300)::double precision) AS pth_lt_300,
            (renalware.convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (64)::double precision) AS urr_gt_64,
            (renalware.convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (69)::double precision) AS urr_gt_69,
            (renalware.convert_to_float(((s.pathology_snapshot -> 'PHOS'::text) ->> 'result'::text)) < (1.8)::double precision) AS phos_lt_1_8
           FROM renalware.hd_patient_statistics s
          WHERE (s.rolling IS NULL)
        )
 SELECT hu.name,
    stats.year,
    stats.month,
    count(*) AS patient_count,
    round((avg(stats.dialysis_minutes_shortfall))::numeric, 2) AS avg_missed_hd_time,
    round(avg(stats.number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct), 2) AS pct_shortfall_gt_5_pct,
    round(((((count(*) FILTER (WHERE (stats.missed_sessions_gt_10_pct = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS pct_missed_sessions_gt_10_pct,
    round(((((count(*) FILTER (WHERE (stats.hgb_gt_100 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_hgb_gt_100,
    round(((((count(*) FILTER (WHERE (stats.hgb_gt_130 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_hgb_gt_130,
    round(((((count(*) FILTER (WHERE (stats.pth_lt_300 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_pth_lt_300,
    round(((((count(*) FILTER (WHERE (stats.urr_gt_64 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_urr_gt_64,
    round(((((count(*) FILTER (WHERE (stats.urr_gt_69 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_urr_gt_69,
    round(((((count(*) FILTER (WHERE (stats.phos_lt_1_8 = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_phosphate_lt_1_8,
    round(((((count(*) FILTER (WHERE (stats.has_fistula_or_graft = true)))::double precision / (count(*))::double precision) * (100)::double precision))::numeric, 2) AS percentage_access_fistula_or_graft
   FROM (stats
     JOIN renalware.hospital_units hu ON ((hu.id = stats.hospital_unit_id)))
  GROUP BY hu.name, stats.year, stats.month
  ORDER BY hu.name, stats.year, stats.month
  WITH NO DATA;


--
-- Name: reporting_main_authors_audit; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW renalware.reporting_main_authors_audit AS
 WITH archived_clinic_letters AS (
         SELECT date_part('year'::text, archive.created_at) AS year,
            to_char(archive.created_at, 'Month'::text) AS month,
            letters.author_id,
            date_part('day'::text, (archive.created_at - (visits.date)::timestamp without time zone)) AS days_to_archive
           FROM ((renalware.letter_letters letters
             JOIN renalware.letter_archives archive ON ((letters.id = archive.letter_id)))
             JOIN renalware.clinic_visits visits ON ((visits.id = letters.event_id)))
          WHERE (archive.created_at > (CURRENT_DATE - '3 mons'::interval))
        ), archived_clinic_letters_stats AS (
         SELECT archived_clinic_letters.author_id,
            count(*) AS total_letters,
            round(avg(archived_clinic_letters.days_to_archive)) AS avg_days_to_archive,
            (( SELECT count(*) AS count
                   FROM archived_clinic_letters acl
                  WHERE ((acl.days_to_archive <= (7)::double precision) AND (acl.author_id = archived_clinic_letters.author_id))))::numeric AS archived_within_7_days
           FROM archived_clinic_letters
          GROUP BY archived_clinic_letters.author_id
        )
 SELECT (((users.family_name)::text || ', '::text) || (users.given_name)::text) AS name,
    stats.total_letters,
    round(((stats.archived_within_7_days / (stats.total_letters)::numeric) * (100)::numeric)) AS percent_archived_within_7_days,
    stats.avg_days_to_archive,
    users.id AS user_id
   FROM (archived_clinic_letters_stats stats
     JOIN renalware.users ON ((stats.author_id = users.id)))
  ORDER BY stats.total_letters DESC
  WITH NO DATA;


--
-- Name: reporting_unit_patients; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.reporting_unit_patients AS
 WITH date_range AS (
         SELECT date_trunc('year'::text, (CURRENT_TIMESTAMP - '10 years'::interval)) AS start,
            CURRENT_TIMESTAMP AS stop
        ), month_range AS (
         SELECT 0 AS current_month,
            ((EXTRACT(year FROM age(date_range.start)) * (12)::numeric) + EXTRACT(month FROM age(date_range.start))) AS months_to_go_back
           FROM date_range
        ), months AS (
         SELECT generate_series(month_range.current_month, (month_range.months_to_go_back)::integer) AS month
           FROM month_range
        ), profile_history AS (
         SELECT hp.patient_id,
            hp.hospital_unit_id,
            ((EXTRACT(year FROM age(hp.created_at)) * (12)::numeric) + EXTRACT(month FROM age(hp.created_at))) AS start_month,
            COALESCE(((EXTRACT(year FROM age(hp.deactivated_at)) * (12)::numeric) + EXTRACT(month FROM age(hp.deactivated_at))), (0)::numeric) AS end_month
           FROM renalware.hd_profiles hp
          ORDER BY hp.patient_id
        ), deduplicated_profile_history AS (
         SELECT DISTINCT ON (profile_history.patient_id, profile_history.hospital_unit_id, profile_history.start_month, profile_history.end_month) profile_history.patient_id,
            profile_history.hospital_unit_id,
            profile_history.start_month,
            profile_history.end_month
           FROM profile_history
          ORDER BY profile_history.patient_id, profile_history.hospital_unit_id, profile_history.start_month, profile_history.end_month
        ), patient_counts AS (
         SELECT ph.hospital_unit_id,
            m_1.month,
            count(*) AS patients
           FROM (deduplicated_profile_history ph
             JOIN months m_1 ON ((((m_1.month)::numeric <= ph.start_month) AND ((m_1.month)::numeric >= ph.end_month))))
          GROUP BY ph.hospital_unit_id, m_1.month
          ORDER BY ph.hospital_unit_id, m_1.month
        )
 SELECT hc.name AS hospital,
    hu.name AS unit,
    (EXTRACT(year FROM (CURRENT_DATE - (((m.month)::text || ' month'::text))::interval)))::text AS year,
    to_char((CURRENT_DATE - (((m.month)::text || ' month'::text))::interval), 'Mon'::text) AS month,
    pc.patients
   FROM (((renalware.hospital_units hu
     JOIN renalware.hospital_centres hc ON ((hc.id = hu.hospital_centre_id)))
     JOIN months m ON ((1 = 1)))
     LEFT JOIN patient_counts pc ON (((pc.month = m.month) AND (pc.hospital_unit_id = hu.id))))
  ORDER BY hu.name, m.month;


--
-- Name: research_investigatorships; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.research_investigatorships (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    study_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    type character varying,
    document jsonb,
    started_on date,
    left_on date,
    manager boolean DEFAULT false NOT NULL
);


--
-- Name: research_investigatorships_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.research_investigatorships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: research_investigatorships_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.research_investigatorships_id_seq OWNED BY renalware.research_investigatorships.id;


--
-- Name: research_participations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.research_participations (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    study_id bigint NOT NULL,
    joined_on date NOT NULL,
    left_on date,
    deleted_at timestamp without time zone,
    updated_by_id bigint,
    created_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    external_id text,
    type character varying,
    document jsonb,
    external_id_deprecated integer,
    external_reference character varying
);


--
-- Name: COLUMN research_participations.external_id_deprecated; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.research_participations.external_id_deprecated IS 'Backup of external_id taken before changing its type from int to text';


--
-- Name: research_participations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.research_participations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: research_participations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.research_participations_id_seq OWNED BY renalware.research_participations.id;


--
-- Name: research_studies; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.research_studies (
    id bigint NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    leader character varying,
    notes text,
    started_on date,
    terminated_on date,
    deleted_at timestamp without time zone,
    updated_by_id bigint,
    created_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    application_url character varying,
    namespace character varying,
    type character varying,
    document jsonb,
    private boolean DEFAULT false NOT NULL
);


--
-- Name: research_studies_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.research_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: research_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.research_studies_id_seq OWNED BY renalware.research_studies.id;


--
-- Name: research_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.research_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit integer,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: research_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.research_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: research_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.research_versions_id_seq OWNED BY renalware.research_versions.id;


--
-- Name: roles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.roles (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    enforce boolean DEFAULT false NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.roles_id_seq OWNED BY renalware.roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.roles_users (
    role_id integer,
    user_id integer,
    id bigint NOT NULL
);


--
-- Name: roles_users_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.roles_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_users_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.roles_users_id_seq OWNED BY renalware.roles_users.id;


--
-- Name: snippets_snippets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.snippets_snippets (
    id bigint NOT NULL,
    title character varying NOT NULL,
    body text NOT NULL,
    last_used_on timestamp without time zone,
    times_used integer DEFAULT 0 NOT NULL,
    author_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snippets_snippets_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.snippets_snippets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snippets_snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.snippets_snippets_id_seq OWNED BY renalware.snippets_snippets.id;


--
-- Name: supportive_care_mdm_patients; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.supportive_care_mdm_patients AS
 SELECT p.id,
    p.secure_id,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    date_part('year'::text, age((p.born_on)::timestamp with time zone)) AS age,
    rprof.esrf_on,
    mx.modality_name,
        CASE
            WHEN (pw.id > 0) THEN true
            ELSE false
        END AS on_worryboard,
    ( SELECT cv2.bmi
           FROM renalware.clinic_visits cv2
          WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
          ORDER BY cv2.date DESC
         LIMIT 1) AS bmi,
    txrsd.name AS tx_status,
    renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
    (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
    renalware.convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
    (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
    renalware.convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
    (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
    renalware.convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr,
    (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
    (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
    h.name AS hospital_centre
   FROM ((((((((((renalware.patients p
     LEFT JOIN renalware.patient_worries pw ON ((pw.patient_id = p.id)))
     LEFT JOIN renalware.pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
     LEFT JOIN renalware.renal_profiles rprof ON ((rprof.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registrations txr ON ((txr.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
     LEFT JOIN renalware.transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
     LEFT JOIN renalware.users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
     LEFT JOIN renalware.users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
     LEFT JOIN renalware.hospital_centres h ON ((h.id = p.hospital_centre_id)))
     JOIN renalware.patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'supportive_care'::text))));


--
-- Name: survey_questions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.survey_questions (
    id bigint NOT NULL,
    survey_id bigint NOT NULL,
    code character varying NOT NULL,
    label character varying,
    "position" integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    validation_regex text,
    label_abbrv character varying
);


--
-- Name: COLUMN survey_questions.label_abbrv; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.survey_questions.label_abbrv IS 'If populated, used instead of label when displaying the table, to save space';


--
-- Name: survey_responses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.survey_responses (
    id bigint NOT NULL,
    answered_on date NOT NULL,
    patient_id bigint NOT NULL,
    question_id bigint NOT NULL,
    value character varying,
    reference character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    patient_question_text text
);


--
-- Name: survey_surveys; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.survey_surveys (
    id bigint NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: survey_eq5d_pivoted_responses; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.survey_eq5d_pivoted_responses AS
 SELECT r.answered_on,
    r.patient_id,
    max((
        CASE
            WHEN ((q.code)::text = 'YOHQ1'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YOHQ1",
    max((
        CASE
            WHEN ((q.code)::text = 'YOHQ2'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YOHQ2",
    max((
        CASE
            WHEN ((q.code)::text = 'YOHQ3'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YOHQ3",
    max((
        CASE
            WHEN ((q.code)::text = 'YOHQ4'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YOHQ4",
    max((
        CASE
            WHEN ((q.code)::text = 'YOHQ5'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YOHQ5",
    max((
        CASE
            WHEN ((q.code)::text = 'YOHQ6'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YOHQ6"
   FROM ((renalware.survey_responses r
     JOIN renalware.survey_questions q ON ((q.id = r.question_id)))
     JOIN renalware.survey_surveys s ON ((s.id = q.survey_id)))
  WHERE ((s.code)::text = 'eq5d'::text)
  GROUP BY r.answered_on, r.patient_id
  ORDER BY r.answered_on DESC;


--
-- Name: survey_pos_s_pivoted_responses; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.survey_pos_s_pivoted_responses AS
 SELECT r.answered_on,
    r.patient_id,
    (sum(renalware.convert_to_float((r.value)::text)))::integer AS total_score,
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ1'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ1",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ2'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ2",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ3'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ3",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ4'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ4",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ5'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ5",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ6'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ6",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ7'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ7",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ8'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ8",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ9'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ9",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ10'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ10",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ11'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ11",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ12'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ12",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ13'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ13",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ14'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ14",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ15'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ15",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ16'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ16",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ17'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ17",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ18'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ18",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ19'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ19",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ20'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ20",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ21'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ21",
    max((
        CASE
            WHEN ((q.code)::text = 'YSQ22'::text) THEN r.value
            ELSE NULL::character varying
        END)::text) AS "YSQ22",
    max(
        CASE
            WHEN ((q.code)::text = 'YSQ18'::text) THEN r.patient_question_text
            ELSE NULL::text
        END) AS "YSQ18_patient_question_text",
    max(
        CASE
            WHEN ((q.code)::text = 'YSQ19'::text) THEN r.patient_question_text
            ELSE NULL::text
        END) AS "YSQ19_patient_question_text",
    max(
        CASE
            WHEN ((q.code)::text = 'YSQ20'::text) THEN r.patient_question_text
            ELSE NULL::text
        END) AS "YSQ20_patient_question_text"
   FROM ((renalware.survey_responses r
     JOIN renalware.survey_questions q ON ((q.id = r.question_id)))
     JOIN renalware.survey_surveys s ON ((s.id = q.survey_id)))
  WHERE ((s.code)::text = 'prom'::text)
  GROUP BY r.answered_on, r.patient_id
  ORDER BY r.answered_on DESC;


--
-- Name: survey_questions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.survey_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.survey_questions_id_seq OWNED BY renalware.survey_questions.id;


--
-- Name: survey_responses_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.survey_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.survey_responses_id_seq OWNED BY renalware.survey_responses.id;


--
-- Name: survey_surveys_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.survey_surveys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.survey_surveys_id_seq OWNED BY renalware.survey_surveys.id;


--
-- Name: system_api_logs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_api_logs (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    status character varying NOT NULL,
    records_added integer DEFAULT 0 NOT NULL,
    records_updated integer DEFAULT 0 NOT NULL,
    dry_run boolean DEFAULT false NOT NULL,
    error text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pages integer DEFAULT 0 NOT NULL,
    "values" text[] DEFAULT '{}'::text[],
    elapsed_ms numeric
);


--
-- Name: COLUMN system_api_logs.elapsed_ms; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_api_logs.elapsed_ms IS 'Used for benchmarking';


--
-- Name: system_api_logs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_api_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_api_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_api_logs_id_seq OWNED BY renalware.system_api_logs.id;


--
-- Name: system_components; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_components (
    id bigint NOT NULL,
    class_name character varying NOT NULL,
    name character varying NOT NULL,
    dashboard boolean DEFAULT true NOT NULL,
    roles character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: TABLE system_components; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.system_components IS 'Available ruby display widgets for use e.g. in dashboards';


--
-- Name: COLUMN system_components.class_name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_components.class_name IS 'Component class eg Renalware::..';


--
-- Name: COLUMN system_components.name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_components.name IS 'Friendly component name e.g. ''Letters in Progress''';


--
-- Name: COLUMN system_components.dashboard; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_components.dashboard IS 'If true, can use on dashboards';


--
-- Name: COLUMN system_components.roles; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_components.roles IS 'Who can use or be assigned this component';


--
-- Name: system_components_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_components_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_components_id_seq OWNED BY renalware.system_components.id;


--
-- Name: system_countries; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_countries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    alpha2 character varying NOT NULL,
    alpha3 character varying NOT NULL,
    "position" integer
);


--
-- Name: system_countries_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_countries_id_seq OWNED BY renalware.system_countries.id;


--
-- Name: system_dashboard_components; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_dashboard_components (
    id bigint NOT NULL,
    dashboard_id bigint,
    component_id bigint,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE system_dashboard_components; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.system_dashboard_components IS 'Defines dashboard content';


--
-- Name: system_dashboard_components_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_dashboard_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_dashboard_components_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_dashboard_components_id_seq OWNED BY renalware.system_dashboard_components.id;


--
-- Name: system_dashboards; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_dashboards (
    id bigint NOT NULL,
    name character varying,
    description text,
    user_id bigint,
    cloned_from_dashboard_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: COLUMN system_dashboards.name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_dashboards.name IS 'A named dashboard e.g. default, hd_nurse';


--
-- Name: COLUMN system_dashboards.user_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_dashboards.user_id IS 'If present, this dashboard belongs to a user e.g. they have customised a named dashboard to make it their own';


--
-- Name: COLUMN system_dashboards.cloned_from_dashboard_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_dashboards.cloned_from_dashboard_id IS 'Is the user customised their dashboard we store the original here';


--
-- Name: system_dashboards_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_dashboards_id_seq OWNED BY renalware.system_dashboards.id;


--
-- Name: system_downloads; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_downloads (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    deleted_at timestamp without time zone,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    view_count integer DEFAULT 0 NOT NULL
);


--
-- Name: system_downloads_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_downloads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_downloads_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_downloads_id_seq OWNED BY renalware.system_downloads.id;


--
-- Name: system_events; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_events (
    id bigint NOT NULL,
    visit_id bigint,
    user_id bigint,
    "time" timestamp without time zone,
    name character varying,
    properties jsonb
);


--
-- Name: system_events_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_events_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_events_id_seq OWNED BY renalware.system_events.id;


--
-- Name: system_logs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_logs (
    id bigint NOT NULL,
    severity renalware.system_log_severity DEFAULT 'info'::renalware.system_log_severity NOT NULL,
    "group" renalware.system_log_group DEFAULT 'users'::renalware.system_log_group NOT NULL,
    owner_id bigint,
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: COLUMN system_logs.owner_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_logs.owner_id IS 'Optional - if targetted at a specific user';


--
-- Name: system_logs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_logs_id_seq OWNED BY renalware.system_logs.id;


--
-- Name: system_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_messages (
    id bigint NOT NULL,
    title character varying,
    body text NOT NULL,
    message_type integer DEFAULT 0 NOT NULL,
    severity character varying,
    display_from timestamp without time zone NOT NULL,
    display_until timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: system_messages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_messages_id_seq OWNED BY renalware.system_messages.id;


--
-- Name: system_nag_definitions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_nag_definitions (
    id bigint NOT NULL,
    scope renalware.system_nag_definition_scope NOT NULL,
    importance integer DEFAULT 1 NOT NULL,
    description text NOT NULL,
    hint text,
    sql_function_name text NOT NULL,
    title text,
    enabled boolean DEFAULT true NOT NULL,
    relative_link text,
    always_expire_cache_after_minutes integer DEFAULT 60 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: TABLE system_nag_definitions; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.system_nag_definitions IS 'Registers a ''missing data nag'' sql function and the text to display if the function evaluates to true';


--
-- Name: COLUMN system_nag_definitions.hint; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_nag_definitions.hint IS 'May be displayed when hovering over the nag';


--
-- Name: COLUMN system_nag_definitions.title; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_nag_definitions.title IS 'If present, text eg (''CFS:'') displayed to the left of the content in a nag';


--
-- Name: COLUMN system_nag_definitions.always_expire_cache_after_minutes; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_nag_definitions.always_expire_cache_after_minutes IS 'Number of minutes to cache this nag before the cache is automatically invalidated. The cache may be invalidated earlier if the nag_definition.updated_at or patient.updated_at timestamps change.';


--
-- Name: system_nag_definitions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_nag_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_nag_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_nag_definitions_id_seq OWNED BY renalware.system_nag_definitions.id;


--
-- Name: system_online_reference_links; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_online_reference_links (
    id bigint NOT NULL,
    title character varying NOT NULL,
    url character varying NOT NULL,
    description text,
    usage_count integer DEFAULT 0,
    last_used_at timestamp without time zone,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    include_in_letters_from date,
    include_in_letters_until date
);


--
-- Name: COLUMN system_online_reference_links.title; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_online_reference_links.title IS 'The name of this resource, for display in the UI only';


--
-- Name: COLUMN system_online_reference_links.url; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_online_reference_links.url IS 'A URL linking to a helpful online reference for patients. May be rendered as a QR code.';


--
-- Name: COLUMN system_online_reference_links.description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_online_reference_links.description IS 'Text displayed alongside the link or QR code';


--
-- Name: COLUMN system_online_reference_links.include_in_letters_from; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_online_reference_links.include_in_letters_from IS 'If set, the QR code will be included in any new letters created on orafter this date - ie its the start of the window of auto-inclusion';


--
-- Name: COLUMN system_online_reference_links.include_in_letters_until; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_online_reference_links.include_in_letters_until IS 'If ''include_in_letters_from'' is set, letters created after this date will no longer have the QR code automatically inserted - ie its the end of the window of auto-inclusion';


--
-- Name: system_online_reference_links_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_online_reference_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_online_reference_links_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_online_reference_links_id_seq OWNED BY renalware.system_online_reference_links.id;


--
-- Name: system_sql_functions; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.system_sql_functions AS
 SELECT n.nspname AS schema,
    p.proname AS sql_function_name
   FROM (pg_proc p
     LEFT JOIN pg_namespace n ON ((p.pronamespace = n.oid)))
  WHERE ((n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name])) AND (n.nspname ~~ 'renalware%'::text))
  ORDER BY n.nspname, p.proname;


--
-- Name: system_templates; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_templates (
    id integer NOT NULL,
    name character varying NOT NULL,
    title character varying,
    description character varying NOT NULL,
    body text NOT NULL
);


--
-- Name: system_templates_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_templates_id_seq OWNED BY renalware.system_templates.id;


--
-- Name: system_user_feedback; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_user_feedback (
    id bigint NOT NULL,
    author_id bigint NOT NULL,
    category character varying NOT NULL,
    comment text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin_notes text,
    acknowledged boolean
);


--
-- Name: system_user_feedback_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_user_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_user_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_user_feedback_id_seq OWNED BY renalware.system_user_feedback.id;


--
-- Name: system_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: system_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_versions_id_seq OWNED BY renalware.system_versions.id;


--
-- Name: system_view_calls; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_view_calls (
    id bigint NOT NULL,
    view_metadata_id bigint NOT NULL,
    user_id bigint NOT NULL,
    called_at timestamp(6) without time zone NOT NULL
);


--
-- Name: system_view_calls_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_view_calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_view_calls_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_view_calls_id_seq OWNED BY renalware.system_view_calls.id;


--
-- Name: system_view_metadata; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_view_metadata (
    id bigint NOT NULL,
    schema_name text NOT NULL,
    view_name text NOT NULL,
    slug text,
    scope text,
    parent_name text,
    parent_id bigint,
    title text,
    columns jsonb DEFAULT '[]'::jsonb NOT NULL,
    filters jsonb DEFAULT '[]'::jsonb NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_type renalware.system_view_display_type DEFAULT 'tabular'::renalware.system_view_display_type NOT NULL,
    category renalware.system_view_category DEFAULT 'mdm'::renalware.system_view_category NOT NULL,
    sub_category character varying,
    materialized boolean DEFAULT false,
    materialized_view_refreshed_at timestamp without time zone,
    refresh_schedule text,
    refresh_concurrently boolean DEFAULT false NOT NULL,
    patient_landing_page renalware.enum_patient_landing_page,
    calls_count integer DEFAULT 0,
    last_called_at timestamp(6) without time zone,
    chart jsonb DEFAULT '{}'::jsonb NOT NULL,
    chart_raw jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: TABLE system_view_metadata; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TABLE renalware.system_view_metadata IS 'Holds descriptive and layout data to help us construct data-driven parts of the Renalware UI e.g. MDMs';


--
-- Name: COLUMN system_view_metadata.slug; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.slug IS 'May be used in urls - must be lower case with no spaces';


--
-- Name: COLUMN system_view_metadata.scope; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.scope IS 'e.g. PD';


--
-- Name: COLUMN system_view_metadata.parent_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.parent_id IS 'Self-join in case a view should have children';


--
-- Name: COLUMN system_view_metadata.title; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.title IS 'A label that may appear in the UI';


--
-- Name: COLUMN system_view_metadata.columns; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.columns IS 'Array of column_names. If empty, all cols displayed. Array order is the display order';


--
-- Name: COLUMN system_view_metadata.filters; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.filters IS 'Array of filter definition for generating filters. Must be the name of a column in the SQL view. ';


--
-- Name: COLUMN system_view_metadata.description; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.description IS 'A description of the SQL view''s function';


--
-- Name: COLUMN system_view_metadata.refresh_schedule; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.refresh_schedule IS 'Cron or fugit schedule string for refreshing the view if it is materialized eg ''every day at 6am'' or ''0 * * * *'' (every hour) or @hourly (turns into ''0 * * * *'') or ''0 0 L * *'' (last day of month at 00:00)';


--
-- Name: COLUMN system_view_metadata.refresh_concurrently; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.refresh_concurrently IS 'where refresh_schedule is set, if refresh_concurrently is true then provided the materialised view has a unique index, the data will be reloaded without locking the table for selects - which is clearly advantageous';


--
-- Name: COLUMN system_view_metadata.patient_landing_page; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.system_view_metadata.patient_landing_page IS 'If present, any patient links generated the report associated with this row will take the user indicated landing area eg patients/123/hd, where these landing areas are routes defined by each RW module and often redirect, e.g. to a dashboard or profile page';


--
-- Name: system_view_metadata_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_view_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_view_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_view_metadata_id_seq OWNED BY renalware.system_view_metadata.id;


--
-- Name: system_visits; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.system_visits (
    id bigint NOT NULL,
    visit_token character varying,
    visitor_token character varying,
    user_id bigint,
    ip character varying,
    user_agent text,
    referrer text,
    referring_domain character varying,
    search_keyword character varying,
    landing_page text,
    browser character varying,
    os character varying,
    device_type character varying,
    started_at timestamp without time zone
);


--
-- Name: system_visits_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.system_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.system_visits_id_seq OWNED BY renalware.system_visits.id;


--
-- Name: transplant_donations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_donations (
    id integer NOT NULL,
    patient_id integer,
    recipient_id integer,
    state character varying NOT NULL,
    relationship_with_recipient character varying NOT NULL,
    relationship_with_recipient_other character varying,
    blood_group_compatibility character varying,
    mismatch_grade character varying,
    paired_pooled_donation character varying,
    volunteered_on date,
    first_seen_on date,
    workup_completed_on date,
    donated_on date,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_donations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_donations_id_seq OWNED BY renalware.transplant_donations.id;


--
-- Name: transplant_donor_followups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_donor_followups (
    id integer NOT NULL,
    operation_id integer NOT NULL,
    notes text,
    followed_up boolean,
    ukt_center_code character varying,
    last_seen_on date,
    lost_to_followup boolean,
    transferred_for_followup boolean,
    dead_on date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_followups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_donor_followups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_donor_followups_id_seq OWNED BY renalware.transplant_donor_followups.id;


--
-- Name: transplant_donor_operations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_donor_operations (
    id integer NOT NULL,
    patient_id integer,
    performed_on date NOT NULL,
    anaesthetist character varying,
    donor_splenectomy_peri_or_post_operatively character varying,
    kidney_side character varying,
    nephrectomy_type character varying,
    nephrectomy_type_other character varying,
    operating_surgeon character varying,
    notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_operations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_donor_operations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_donor_operations_id_seq OWNED BY renalware.transplant_donor_operations.id;


--
-- Name: transplant_donor_stage_positions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_donor_stage_positions (
    id integer NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_stage_positions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_donor_stage_positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_stage_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_donor_stage_positions_id_seq OWNED BY renalware.transplant_donor_stage_positions.id;


--
-- Name: transplant_donor_stage_statuses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_donor_stage_statuses (
    id integer NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_stage_statuses_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_donor_stage_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_stage_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_donor_stage_statuses_id_seq OWNED BY renalware.transplant_donor_stage_statuses.id;


--
-- Name: transplant_donor_stages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_donor_stages (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    stage_position_id integer NOT NULL,
    stage_status_id integer NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    started_on timestamp without time zone NOT NULL,
    terminated_on timestamp without time zone,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_stages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_donor_stages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_donor_stages_id_seq OWNED BY renalware.transplant_donor_stages.id;


--
-- Name: transplant_donor_workups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_donor_workups (
    id integer NOT NULL,
    patient_id integer,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_workups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_donor_workups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_donor_workups_id_seq OWNED BY renalware.transplant_donor_workups.id;


--
-- Name: transplant_failure_cause_description_groups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_failure_cause_description_groups (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_failure_cause_description_groups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_failure_cause_description_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_failure_cause_description_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_failure_cause_description_groups_id_seq OWNED BY renalware.transplant_failure_cause_description_groups.id;


--
-- Name: transplant_failure_cause_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_failure_cause_descriptions (
    id integer NOT NULL,
    group_id integer,
    code character varying NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_failure_cause_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_failure_cause_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_failure_cause_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_failure_cause_descriptions_id_seq OWNED BY renalware.transplant_failure_cause_descriptions.id;


--
-- Name: transplant_induction_agents; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_induction_agents (
    id bigint NOT NULL,
    name text NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    drug_name text,
    snomed_code text,
    atc_code text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: transplant_induction_agents_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_induction_agents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_induction_agents_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_induction_agents_id_seq OWNED BY renalware.transplant_induction_agents.id;


--
-- Name: transplant_investigation_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_investigation_types (
    id bigint NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: transplant_investigation_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_investigation_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_investigation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_investigation_types_id_seq OWNED BY renalware.transplant_investigation_types.id;


--
-- Name: transplant_mdm_patients; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.transplant_mdm_patients AS
 SELECT p.id,
    p.secure_id,
    ((upper((p.family_name)::text) || ', '::text) || (p.given_name)::text) AS patient_name,
    p.nhs_number,
    p.local_patient_id AS hospital_numbers,
    p.sex,
    p.born_on,
    rprof.esrf_on,
    latest_op.performed_on AS last_operation_date,
    (date_part('year'::text, age((p.born_on)::timestamp with time zone)))::integer AS age,
    mx.modality_name,
        CASE
            WHEN (pw.id > 0) THEN 'Y'::text
            ELSE 'N'::text
        END AS on_worryboard,
    ( SELECT cv2.bmi
           FROM renalware.clinic_visits cv2
          WHERE ((cv2.patient_id = p.id) AND (cv2.bmi > (0)::numeric))
          ORDER BY cv2.date DESC
         LIMIT 1) AS bmi,
        CASE
            WHEN (latest_op.performed_on >= (now() - '3 mons'::interval)) THEN true
            ELSE false
        END AS tx_in_past_3m,
        CASE
            WHEN (latest_op.performed_on >= (now() - '1 year'::interval)) THEN true
            ELSE false
        END AS tx_in_past_12m,
    txrsd.name AS tx_status,
    renalware.convert_to_float(((pa."values" -> 'HGB'::text) ->> 'result'::text), NULL::double precision) AS hgb,
    (((pa."values" -> 'HGB'::text) ->> 'observed_at'::text))::date AS hgb_date,
    renalware.convert_to_float(((pa."values" -> 'URE'::text) ->> 'result'::text), NULL::double precision) AS ure,
    (((pa."values" -> 'URE'::text) ->> 'observed_at'::text))::date AS ure_date,
    renalware.convert_to_float(((pa."values" -> 'CRE'::text) ->> 'result'::text), NULL::double precision) AS cre,
    (((pa."values" -> 'CRE'::text) ->> 'observed_at'::text))::date AS cre_date,
    renalware.convert_to_float(((pa."values" -> 'EGFR'::text) ->> 'result'::text), NULL::double precision) AS egfr_on,
    (((named_nurses.family_name)::text || ', '::text) || (named_nurses.given_name)::text) AS named_nurse,
    (((named_consultants.family_name)::text || ', '::text) || (named_consultants.given_name)::text) AS named_consultant,
    h.name AS hospital_centre
   FROM (((((((((((renalware.patients p
     JOIN renalware.patient_current_modalities mx ON (((mx.patient_id = p.id) AND ((mx.modality_code)::text = 'transplant'::text))))
     LEFT JOIN renalware.pathology_current_observation_sets pa ON ((pa.patient_id = p.id)))
     LEFT JOIN renalware.patient_worries pw ON ((pw.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registrations txr ON ((txr.patient_id = p.id)))
     LEFT JOIN renalware.transplant_registration_statuses txrs ON (((txrs.registration_id = txr.id) AND (txrs.terminated_on IS NULL))))
     LEFT JOIN renalware.transplant_registration_status_descriptions txrsd ON ((txrsd.id = txrs.description_id)))
     LEFT JOIN renalware.renal_profiles rprof ON ((rprof.patient_id = p.id)))
     LEFT JOIN renalware.users named_nurses ON ((named_nurses.id = p.named_nurse_id)))
     LEFT JOIN renalware.users named_consultants ON ((named_consultants.id = p.named_consultant_id)))
     LEFT JOIN renalware.hospital_centres h ON ((h.id = p.hospital_centre_id)))
     LEFT JOIN ( SELECT DISTINCT ON (transplant_recipient_operations.patient_id) transplant_recipient_operations.id,
            transplant_recipient_operations.patient_id,
            transplant_recipient_operations.performed_on,
            transplant_recipient_operations.theatre_case_start_time,
            transplant_recipient_operations.donor_kidney_removed_from_ice_at,
            transplant_recipient_operations.operation_type,
            transplant_recipient_operations.hospital_centre_id,
            transplant_recipient_operations.kidney_perfused_with_blood_at,
            transplant_recipient_operations.cold_ischaemic_time,
            transplant_recipient_operations.warm_ischaemic_time,
            transplant_recipient_operations.notes,
            transplant_recipient_operations.document,
            transplant_recipient_operations.created_at,
            transplant_recipient_operations.updated_at
           FROM renalware.transplant_recipient_operations
          ORDER BY transplant_recipient_operations.patient_id, transplant_recipient_operations.performed_on DESC) latest_op ON ((latest_op.patient_id = p.id)));


--
-- Name: transplant_recipient_followups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_recipient_followups (
    id integer NOT NULL,
    operation_id integer NOT NULL,
    notes text,
    stent_removed_on date,
    transplant_failed boolean,
    transplant_failed_on date,
    transplant_failure_cause_description_id integer,
    transplant_failure_cause_other character varying,
    transplant_failure_notes text,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    graft_nephrectomy_on date,
    graft_function_onset character varying,
    last_post_transplant_dialysis_on date,
    return_to_regular_dialysis_on date
);


--
-- Name: transplant_recipient_followups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_recipient_followups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_recipient_followups_id_seq OWNED BY renalware.transplant_recipient_followups.id;


--
-- Name: transplant_recipient_operations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_recipient_operations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_recipient_operations_id_seq OWNED BY renalware.transplant_recipient_operations.id;


--
-- Name: transplant_recipient_workups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_recipient_workups (
    id integer NOT NULL,
    patient_id integer,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: transplant_recipient_workups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_recipient_workups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_recipient_workups_id_seq OWNED BY renalware.transplant_recipient_workups.id;


--
-- Name: transplant_registration_status_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_registration_status_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registration_status_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_registration_status_descriptions_id_seq OWNED BY renalware.transplant_registration_status_descriptions.id;


--
-- Name: transplant_registration_statuses_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_registration_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registration_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_registration_statuses_id_seq OWNED BY renalware.transplant_registration_statuses.id;


--
-- Name: transplant_registrations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_registrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_registrations_id_seq OWNED BY renalware.transplant_registrations.id;


--
-- Name: transplant_rejection_episodes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_rejection_episodes (
    id bigint NOT NULL,
    recorded_on date NOT NULL,
    notes text,
    followup_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    treatment_id bigint
);


--
-- Name: transplant_rejection_episodes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_rejection_episodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_rejection_episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_rejection_episodes_id_seq OWNED BY renalware.transplant_rejection_episodes.id;


--
-- Name: transplant_rejection_treatments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_rejection_treatments (
    id bigint NOT NULL,
    name text NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_rejection_treatments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_rejection_treatments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_rejection_treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_rejection_treatments_id_seq OWNED BY renalware.transplant_rejection_treatments.id;


--
-- Name: transplant_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.transplant_versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: transplant_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.transplant_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.transplant_versions_id_seq OWNED BY renalware.transplant_versions.id;


--
-- Name: ukrdc_batches; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.ukrdc_batches (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ukrdc_batches_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.ukrdc_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ukrdc_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.ukrdc_batches_id_seq OWNED BY renalware.ukrdc_batches.id;


--
-- Name: ukrdc_transmission_logs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.ukrdc_transmission_logs (
    id bigint NOT NULL,
    patient_id bigint,
    sent_at timestamp without time zone,
    status integer NOT NULL,
    request_uuid uuid,
    payload_hash text,
    payload xml,
    error text[] DEFAULT '{}'::text[],
    file_path character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    direction integer DEFAULT 0 NOT NULL,
    batch_id bigint
);


--
-- Name: ukrdc_daily_summaries; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW renalware.ukrdc_daily_summaries AS
 SELECT (created_at)::date AS date,
    count(*) AS total,
    count(
        CASE
            WHEN (status = 3) THEN 1
            ELSE NULL::integer
        END) AS sent,
    count(
        CASE
            WHEN (status = 2) THEN 1
            ELSE NULL::integer
        END) AS unsent_no_change,
    count(
        CASE
            WHEN (status = 1) THEN 1
            ELSE NULL::integer
        END) AS error
   FROM renalware.ukrdc_transmission_logs utl
  GROUP BY ((created_at)::date)
  ORDER BY ((created_at)::date);


--
-- Name: ukrdc_measurement_units; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.ukrdc_measurement_units (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ukrdc_measurement_units_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.ukrdc_measurement_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ukrdc_measurement_units_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.ukrdc_measurement_units_id_seq OWNED BY renalware.ukrdc_measurement_units.id;


--
-- Name: ukrdc_modality_codes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.ukrdc_modality_codes (
    id bigint NOT NULL,
    qbl_code character varying,
    txt_code character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ukrdc_modality_codes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.ukrdc_modality_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ukrdc_modality_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.ukrdc_modality_codes_id_seq OWNED BY renalware.ukrdc_modality_codes.id;


--
-- Name: ukrdc_transmission_logs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.ukrdc_transmission_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ukrdc_transmission_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.ukrdc_transmission_logs_id_seq OWNED BY renalware.ukrdc_transmission_logs.id;


--
-- Name: ukrdc_treatments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.ukrdc_treatments (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    clinician_id bigint,
    modality_code_id bigint NOT NULL,
    modality_id bigint,
    modality_description_id bigint,
    hospital_centre_id bigint,
    hospital_unit_id bigint,
    started_on date NOT NULL,
    ended_on date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hd_profile_id bigint,
    pd_regime_id bigint,
    discharge_reason_code integer,
    discharge_reason_comment character varying,
    hd_type character varying
);


--
-- Name: ukrdc_treatments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.ukrdc_treatments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ukrdc_treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.ukrdc_treatments_id_seq OWNED BY renalware.ukrdc_treatments.id;


--
-- Name: user_group_memberships; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.user_group_memberships (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    user_group_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_group_memberships_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.user_group_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_group_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.user_group_memberships_id_seq OWNED BY renalware.user_group_memberships.id;


--
-- Name: user_groups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.user_groups (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    active boolean DEFAULT true NOT NULL,
    memberships_count integer DEFAULT 0 NOT NULL,
    letter_electronic_ccs boolean DEFAULT false NOT NULL,
    created_by_id bigint NOT NULL,
    updated_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN user_groups.name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.user_groups.name IS 'e.g. ''Transplant Cordinators''';


--
-- Name: COLUMN user_groups.active; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.user_groups.active IS 'If false, the group will not be displayed anywhere prospectively';


--
-- Name: COLUMN user_groups.memberships_count; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.user_groups.memberships_count IS 'Counter cache for the number of memberships in this group';


--
-- Name: COLUMN user_groups.letter_electronic_ccs; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON COLUMN renalware.user_groups.letter_electronic_ccs IS 'If true, the group can be chosen from the electronic CCs recipients dropdown in letters';


--
-- Name: user_groups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.user_groups_id_seq OWNED BY renalware.user_groups.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.users_id_seq OWNED BY renalware.users.id;


--
-- Name: versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    object_changes jsonb,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.versions_id_seq OWNED BY renalware.versions.id;


--
-- Name: virology_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.virology_profiles (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    document jsonb DEFAULT '{}'::jsonb NOT NULL,
    updated_by_id bigint,
    created_by_id bigint,
    updated_at timestamp without time zone,
    created_at timestamp without time zone
);


--
-- Name: virology_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.virology_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virology_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.virology_profiles_id_seq OWNED BY renalware.virology_profiles.id;


--
-- Name: virology_vaccination_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.virology_vaccination_types (
    id bigint NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    atc_codes character varying[] DEFAULT '{}'::character varying[] NOT NULL
);


--
-- Name: virology_vaccination_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.virology_vaccination_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virology_vaccination_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.virology_vaccination_types_id_seq OWNED BY renalware.virology_vaccination_types.id;


--
-- Name: virology_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renalware.virology_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: virology_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renalware.virology_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virology_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renalware.virology_versions_id_seq OWNED BY renalware.virology_versions.id;


--
-- Name: reporting_example_data; Type: VIEW; Schema: renalware_demo; Owner: -
--

CREATE VIEW renalware_demo.reporting_example_data AS
 WITH dates AS (
         SELECT (date_trunc('day'::text, dd.dd))::date AS dt
           FROM generate_series('2023-01-01 00:00:00'::timestamp without time zone, '2023-12-31 00:00:00'::timestamp without time zone, '7 days'::interval) dd(dd)
        )
 SELECT dt AS date,
    (((10)::double precision + ((9)::double precision * random())) * (row_number() OVER ())::double precision) AS series1,
    (((2)::double precision + ((7)::double precision * random())) * (row_number() OVER ())::double precision) AS series2
   FROM dates;


--
-- Name: solid_cache_entries; Type: TABLE; Schema: renalware_demo; Owner: -
--

CREATE TABLE renalware_demo.solid_cache_entries (
    id bigint NOT NULL,
    key bytea NOT NULL,
    value bytea NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    key_hash bigint NOT NULL,
    byte_size integer NOT NULL
);


--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE; Schema: renalware_demo; Owner: -
--

CREATE SEQUENCE renalware_demo.solid_cache_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware_demo; Owner: -
--

ALTER SEQUENCE renalware_demo.solid_cache_entries_id_seq OWNED BY renalware_demo.solid_cache_entries.id;


--
-- Name: access_assessments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_assessments ALTER COLUMN id SET DEFAULT nextval('renalware.access_assessments_id_seq'::regclass);


--
-- Name: access_catheter_insertion_techniques id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_catheter_insertion_techniques ALTER COLUMN id SET DEFAULT nextval('renalware.access_catheter_insertion_techniques_id_seq'::regclass);


--
-- Name: access_needling_assessments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_needling_assessments ALTER COLUMN id SET DEFAULT nextval('renalware.access_needling_assessments_id_seq'::regclass);


--
-- Name: access_plan_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plan_types ALTER COLUMN id SET DEFAULT nextval('renalware.access_plan_types_id_seq'::regclass);


--
-- Name: access_plans id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plans ALTER COLUMN id SET DEFAULT nextval('renalware.access_plans_id_seq'::regclass);


--
-- Name: access_procedures id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_procedures ALTER COLUMN id SET DEFAULT nextval('renalware.access_procedures_id_seq'::regclass);


--
-- Name: access_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_profiles ALTER COLUMN id SET DEFAULT nextval('renalware.access_profiles_id_seq'::regclass);


--
-- Name: access_sites id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_sites ALTER COLUMN id SET DEFAULT nextval('renalware.access_sites_id_seq'::regclass);


--
-- Name: access_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_types ALTER COLUMN id SET DEFAULT nextval('renalware.access_types_id_seq'::regclass);


--
-- Name: access_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_versions ALTER COLUMN id SET DEFAULT nextval('renalware.access_versions_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('renalware.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('renalware.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('renalware.active_storage_variant_records_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.addresses ALTER COLUMN id SET DEFAULT nextval('renalware.addresses_id_seq'::regclass);


--
-- Name: admission_admissions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions ALTER COLUMN id SET DEFAULT nextval('renalware.admission_admissions_id_seq'::regclass);


--
-- Name: admission_consult_sites id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consult_sites ALTER COLUMN id SET DEFAULT nextval('renalware.admission_consult_sites_id_seq'::regclass);


--
-- Name: admission_consults id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults ALTER COLUMN id SET DEFAULT nextval('renalware.admission_consults_id_seq'::regclass);


--
-- Name: admission_request_reasons id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_request_reasons ALTER COLUMN id SET DEFAULT nextval('renalware.admission_request_reasons_id_seq'::regclass);


--
-- Name: admission_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_requests ALTER COLUMN id SET DEFAULT nextval('renalware.admission_requests_id_seq'::regclass);


--
-- Name: admission_specialties id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_specialties ALTER COLUMN id SET DEFAULT nextval('renalware.admission_specialties_id_seq'::regclass);


--
-- Name: clinic_appointments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments ALTER COLUMN id SET DEFAULT nextval('renalware.clinic_appointments_id_seq'::regclass);


--
-- Name: clinic_clinics id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_clinics ALTER COLUMN id SET DEFAULT nextval('renalware.clinic_clinics_id_seq'::regclass);


--
-- Name: clinic_consultants id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_consultants ALTER COLUMN id SET DEFAULT nextval('renalware.clinic_consultants_id_seq'::regclass);


--
-- Name: clinic_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_versions ALTER COLUMN id SET DEFAULT nextval('renalware.clinic_versions_id_seq'::regclass);


--
-- Name: clinic_visit_locations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visit_locations ALTER COLUMN id SET DEFAULT nextval('renalware.clinic_visit_locations_id_seq'::regclass);


--
-- Name: clinic_visits id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visits ALTER COLUMN id SET DEFAULT nextval('renalware.clinic_visits_id_seq'::regclass);


--
-- Name: clinical_allergies id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_allergies ALTER COLUMN id SET DEFAULT nextval('renalware.clinical_allergies_id_seq'::regclass);


--
-- Name: clinical_body_compositions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_body_compositions ALTER COLUMN id SET DEFAULT nextval('renalware.clinical_body_compositions_id_seq'::regclass);


--
-- Name: clinical_dry_weights id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_dry_weights ALTER COLUMN id SET DEFAULT nextval('renalware.clinical_dry_weights_id_seq'::regclass);


--
-- Name: clinical_igan_risks id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_igan_risks ALTER COLUMN id SET DEFAULT nextval('renalware.clinical_igan_risks_id_seq'::regclass);


--
-- Name: clinical_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_versions ALTER COLUMN id SET DEFAULT nextval('renalware.clinical_versions_id_seq'::regclass);


--
-- Name: death_causes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.death_causes ALTER COLUMN id SET DEFAULT nextval('renalware.death_causes_id_seq'::regclass);


--
-- Name: death_locations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.death_locations ALTER COLUMN id SET DEFAULT nextval('renalware.death_locations_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.delayed_jobs ALTER COLUMN id SET DEFAULT nextval('renalware.delayed_jobs_id_seq'::regclass);


--
-- Name: directory_people id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.directory_people ALTER COLUMN id SET DEFAULT nextval('renalware.directory_people_id_seq'::regclass);


--
-- Name: drug_dmd_actual_medical_products id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_actual_medical_products ALTER COLUMN id SET DEFAULT nextval('renalware.drug_dmd_actual_medical_products_id_seq'::regclass);


--
-- Name: drug_dmd_matches id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_matches ALTER COLUMN id SET DEFAULT nextval('renalware.drug_dmd_matches_id_seq'::regclass);


--
-- Name: drug_dmd_virtual_medical_products id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_virtual_medical_products ALTER COLUMN id SET DEFAULT nextval('renalware.drug_dmd_virtual_medical_products_id_seq'::regclass);


--
-- Name: drug_dmd_virtual_therapeutic_moieties id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_virtual_therapeutic_moieties ALTER COLUMN id SET DEFAULT nextval('renalware.drug_dmd_virtual_therapeutic_moieties_id_seq'::regclass);


--
-- Name: drug_forms id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_forms ALTER COLUMN id SET DEFAULT nextval('renalware.drug_forms_id_seq'::regclass);


--
-- Name: drug_frequencies id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_frequencies ALTER COLUMN id SET DEFAULT nextval('renalware.drug_frequencies_id_seq'::regclass);


--
-- Name: drug_homecare_forms id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_homecare_forms ALTER COLUMN id SET DEFAULT nextval('renalware.drug_homecare_forms_id_seq'::regclass);


--
-- Name: drug_patient_group_directions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_patient_group_directions ALTER COLUMN id SET DEFAULT nextval('renalware.drug_patient_group_directions_id_seq'::regclass);


--
-- Name: drug_suppliers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_suppliers ALTER COLUMN id SET DEFAULT nextval('renalware.drug_suppliers_id_seq'::regclass);


--
-- Name: drug_trade_families id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_trade_families ALTER COLUMN id SET DEFAULT nextval('renalware.drug_trade_families_id_seq'::regclass);


--
-- Name: drug_trade_family_classifications id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_trade_family_classifications ALTER COLUMN id SET DEFAULT nextval('renalware.drug_trade_family_classifications_id_seq'::regclass);


--
-- Name: drug_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_types ALTER COLUMN id SET DEFAULT nextval('renalware.drug_types_id_seq'::regclass);


--
-- Name: drug_types_drugs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_types_drugs ALTER COLUMN id SET DEFAULT nextval('renalware.drug_types_drugs_id_seq'::regclass);


--
-- Name: drug_unit_of_measures id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_unit_of_measures ALTER COLUMN id SET DEFAULT nextval('renalware.drug_unit_of_measures_id_seq'::regclass);


--
-- Name: drug_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_versions ALTER COLUMN id SET DEFAULT nextval('renalware.drug_versions_id_seq'::regclass);


--
-- Name: drug_vmp_classifications id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_vmp_classifications ALTER COLUMN id SET DEFAULT nextval('renalware.drug_vmp_classifications_id_seq'::regclass);


--
-- Name: drugs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drugs ALTER COLUMN id SET DEFAULT nextval('renalware.drugs_id_seq'::regclass);


--
-- Name: event_categories id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_categories ALTER COLUMN id SET DEFAULT nextval('renalware.event_categories_id_seq'::regclass);


--
-- Name: event_subtypes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_subtypes ALTER COLUMN id SET DEFAULT nextval('renalware.event_subtypes_id_seq'::regclass);


--
-- Name: event_type_alert_triggers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_type_alert_triggers ALTER COLUMN id SET DEFAULT nextval('renalware.event_type_alert_triggers_id_seq'::regclass);


--
-- Name: event_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_types ALTER COLUMN id SET DEFAULT nextval('renalware.event_types_id_seq'::regclass);


--
-- Name: event_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_versions ALTER COLUMN id SET DEFAULT nextval('renalware.event_versions_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.events ALTER COLUMN id SET DEFAULT nextval('renalware.events_id_seq'::regclass);


--
-- Name: feed_file_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_file_types ALTER COLUMN id SET DEFAULT nextval('renalware.feed_file_types_id_seq'::regclass);


--
-- Name: feed_files id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_files ALTER COLUMN id SET DEFAULT nextval('renalware.feed_files_id_seq'::regclass);


--
-- Name: feed_gps id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_gps ALTER COLUMN id SET DEFAULT nextval('renalware.feed_gps_id_seq'::regclass);


--
-- Name: feed_hl7_test_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_hl7_test_messages ALTER COLUMN id SET DEFAULT nextval('renalware.feed_hl7_test_messages_id_seq'::regclass);


--
-- Name: feed_logs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_logs ALTER COLUMN id SET DEFAULT nextval('renalware.feed_logs_id_seq'::regclass);


--
-- Name: feed_message_replays id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_message_replays ALTER COLUMN id SET DEFAULT nextval('renalware.feed_message_replays_id_seq'::regclass);


--
-- Name: feed_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_messages ALTER COLUMN id SET DEFAULT nextval('renalware.feed_messages_id_seq'::regclass);


--
-- Name: feed_outgoing_documents id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_outgoing_documents ALTER COLUMN id SET DEFAULT nextval('renalware.feed_outgoing_documents_id_seq'::regclass);


--
-- Name: feed_practice_gps id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_practice_gps ALTER COLUMN id SET DEFAULT nextval('renalware.feed_practice_gps_id_seq'::regclass);


--
-- Name: feed_raw_hl7_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_raw_hl7_messages ALTER COLUMN id SET DEFAULT nextval('renalware.feed_raw_hl7_messages_id_seq'::regclass);


--
-- Name: feed_replay_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_replay_requests ALTER COLUMN id SET DEFAULT nextval('renalware.feed_replay_requests_id_seq'::regclass);


--
-- Name: feed_sausage_queue id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_sausage_queue ALTER COLUMN id SET DEFAULT nextval('renalware.feed_sausage_queue_id_seq'::regclass);


--
-- Name: feed_sausages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_sausages ALTER COLUMN id SET DEFAULT nextval('renalware.feed_sausages_id_seq'::regclass);


--
-- Name: geography_local_authority_districts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_local_authority_districts ALTER COLUMN id SET DEFAULT nextval('renalware.geography_local_authority_districts_id_seq'::regclass);


--
-- Name: geography_lower_super_output_areas id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_lower_super_output_areas ALTER COLUMN id SET DEFAULT nextval('renalware.geography_lower_super_output_areas_id_seq'::regclass);


--
-- Name: geography_middle_super_output_areas id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_middle_super_output_areas ALTER COLUMN id SET DEFAULT nextval('renalware.geography_middle_super_output_areas_id_seq'::regclass);


--
-- Name: geography_output_areas id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_output_areas ALTER COLUMN id SET DEFAULT nextval('renalware.geography_output_areas_id_seq'::regclass);


--
-- Name: geography_postcodes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_postcodes ALTER COLUMN id SET DEFAULT nextval('renalware.geography_postcodes_id_seq'::regclass);


--
-- Name: hd_cannulation_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_cannulation_types ALTER COLUMN id SET DEFAULT nextval('renalware.hd_cannulation_types_id_seq'::regclass);


--
-- Name: hd_dialysates id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_dialysates ALTER COLUMN id SET DEFAULT nextval('renalware.hd_dialysates_id_seq'::regclass);


--
-- Name: hd_dialysers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_dialysers ALTER COLUMN id SET DEFAULT nextval('renalware.hd_dialysers_id_seq'::regclass);


--
-- Name: hd_diaries id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diaries ALTER COLUMN id SET DEFAULT nextval('renalware.hd_diaries_id_seq'::regclass);


--
-- Name: hd_diary_slots id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots ALTER COLUMN id SET DEFAULT nextval('renalware.hd_diary_slots_id_seq'::regclass);


--
-- Name: hd_diurnal_period_codes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diurnal_period_codes ALTER COLUMN id SET DEFAULT nextval('renalware.hd_diurnal_period_codes_id_seq'::regclass);


--
-- Name: hd_patient_statistics id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_patient_statistics ALTER COLUMN id SET DEFAULT nextval('renalware.hd_patient_statistics_id_seq'::regclass);


--
-- Name: hd_preference_sets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_preference_sets ALTER COLUMN id SET DEFAULT nextval('renalware.hd_preference_sets_id_seq'::regclass);


--
-- Name: hd_prescription_administration_reasons id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administration_reasons ALTER COLUMN id SET DEFAULT nextval('renalware.hd_prescription_administration_reasons_id_seq'::regclass);


--
-- Name: hd_prescription_administrations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations ALTER COLUMN id SET DEFAULT nextval('renalware.hd_prescription_administrations_id_seq'::regclass);


--
-- Name: hd_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles ALTER COLUMN id SET DEFAULT nextval('renalware.hd_profiles_id_seq'::regclass);


--
-- Name: hd_provider_units id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_provider_units ALTER COLUMN id SET DEFAULT nextval('renalware.hd_provider_units_id_seq'::regclass);


--
-- Name: hd_providers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_providers ALTER COLUMN id SET DEFAULT nextval('renalware.hd_providers_id_seq'::regclass);


--
-- Name: hd_schedule_definitions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_schedule_definitions ALTER COLUMN id SET DEFAULT nextval('renalware.hd_schedule_definitions_id_seq'::regclass);


--
-- Name: hd_session_form_batch_items id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_form_batch_items ALTER COLUMN id SET DEFAULT nextval('renalware.hd_session_form_batch_items_id_seq'::regclass);


--
-- Name: hd_session_form_batches id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_form_batches ALTER COLUMN id SET DEFAULT nextval('renalware.hd_session_form_batches_id_seq'::regclass);


--
-- Name: hd_session_patient_group_directions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_patient_group_directions ALTER COLUMN id SET DEFAULT nextval('renalware.hd_session_patient_group_directions_id_seq'::regclass);


--
-- Name: hd_sessions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions ALTER COLUMN id SET DEFAULT nextval('renalware.hd_sessions_id_seq'::regclass);


--
-- Name: hd_slot_request_access_states id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_request_access_states ALTER COLUMN id SET DEFAULT nextval('renalware.hd_slot_request_access_states_id_seq'::regclass);


--
-- Name: hd_slot_request_deletion_reasons id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_request_deletion_reasons ALTER COLUMN id SET DEFAULT nextval('renalware.hd_slot_request_deletion_reasons_id_seq'::regclass);


--
-- Name: hd_slot_request_locations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_request_locations ALTER COLUMN id SET DEFAULT nextval('renalware.hd_slot_request_locations_id_seq'::regclass);


--
-- Name: hd_slot_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests ALTER COLUMN id SET DEFAULT nextval('renalware.hd_slot_requests_id_seq'::regclass);


--
-- Name: hd_station_locations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_station_locations ALTER COLUMN id SET DEFAULT nextval('renalware.hd_station_locations_id_seq'::regclass);


--
-- Name: hd_stations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_stations ALTER COLUMN id SET DEFAULT nextval('renalware.hd_stations_id_seq'::regclass);


--
-- Name: hd_transmission_logs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_transmission_logs ALTER COLUMN id SET DEFAULT nextval('renalware.hd_transmission_logs_id_seq'::regclass);


--
-- Name: hd_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_versions ALTER COLUMN id SET DEFAULT nextval('renalware.hd_versions_id_seq'::regclass);


--
-- Name: hd_vnd_risk_assessments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_vnd_risk_assessments ALTER COLUMN id SET DEFAULT nextval('renalware.hd_vnd_risk_assessments_id_seq'::regclass);


--
-- Name: hospital_centres id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_centres ALTER COLUMN id SET DEFAULT nextval('renalware.hospital_centres_id_seq'::regclass);


--
-- Name: hospital_departments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_departments ALTER COLUMN id SET DEFAULT nextval('renalware.hospital_departments_id_seq'::regclass);


--
-- Name: hospital_units id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_units ALTER COLUMN id SET DEFAULT nextval('renalware.hospital_units_id_seq'::regclass);


--
-- Name: hospital_wards id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_wards ALTER COLUMN id SET DEFAULT nextval('renalware.hospital_wards_id_seq'::regclass);


--
-- Name: letter_archives id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_archives ALTER COLUMN id SET DEFAULT nextval('renalware.letter_archives_id_seq'::regclass);


--
-- Name: letter_batch_items id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batch_items ALTER COLUMN id SET DEFAULT nextval('renalware.letter_batch_items_id_seq'::regclass);


--
-- Name: letter_batches id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batches ALTER COLUMN id SET DEFAULT nextval('renalware.letter_batches_id_seq'::regclass);


--
-- Name: letter_contact_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_contact_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.letter_contact_descriptions_id_seq'::regclass);


--
-- Name: letter_contacts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_contacts ALTER COLUMN id SET DEFAULT nextval('renalware.letter_contacts_id_seq'::regclass);


--
-- Name: letter_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.letter_descriptions_id_seq'::regclass);


--
-- Name: letter_electronic_receipts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_electronic_receipts ALTER COLUMN id SET DEFAULT nextval('renalware.letter_electronic_receipts_id_seq'::regclass);


--
-- Name: letter_letterheads id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letterheads ALTER COLUMN id SET DEFAULT nextval('renalware.letter_letterheads_id_seq'::regclass);


--
-- Name: letter_letters id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters ALTER COLUMN id SET DEFAULT nextval('renalware.letter_letters_id_seq'::regclass);


--
-- Name: letter_mailshot_items id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_items ALTER COLUMN id SET DEFAULT nextval('renalware.letter_mailshot_items_id_seq'::regclass);


--
-- Name: letter_mailshot_mailshots id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_mailshots ALTER COLUMN id SET DEFAULT nextval('renalware.letter_mailshot_mailshots_id_seq'::regclass);


--
-- Name: letter_mesh_operations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mesh_operations ALTER COLUMN id SET DEFAULT nextval('renalware.letter_mesh_operations_id_seq'::regclass);


--
-- Name: letter_mesh_transmissions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mesh_transmissions ALTER COLUMN id SET DEFAULT nextval('renalware.letter_mesh_transmissions_id_seq'::regclass);


--
-- Name: letter_qr_encoded_online_reference_links id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_qr_encoded_online_reference_links ALTER COLUMN id SET DEFAULT nextval('renalware.letter_qr_encoded_online_reference_links_id_seq'::regclass);


--
-- Name: letter_recipients id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_recipients ALTER COLUMN id SET DEFAULT nextval('renalware.letter_recipients_id_seq'::regclass);


--
-- Name: letter_section_snapshots id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_section_snapshots ALTER COLUMN id SET DEFAULT nextval('renalware.letter_section_snapshots_id_seq'::regclass);


--
-- Name: letter_signatures id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_signatures ALTER COLUMN id SET DEFAULT nextval('renalware.letter_signatures_id_seq'::regclass);


--
-- Name: letter_snomed_document_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_snomed_document_types ALTER COLUMN id SET DEFAULT nextval('renalware.letter_snomed_document_types_id_seq'::regclass);


--
-- Name: low_clearance_dialysis_plans id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_dialysis_plans ALTER COLUMN id SET DEFAULT nextval('renalware.low_clearance_dialysis_plans_id_seq'::regclass);


--
-- Name: low_clearance_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_profiles ALTER COLUMN id SET DEFAULT nextval('renalware.low_clearance_profiles_id_seq'::regclass);


--
-- Name: low_clearance_referrers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_referrers ALTER COLUMN id SET DEFAULT nextval('renalware.low_clearance_referrers_id_seq'::regclass);


--
-- Name: low_clearance_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_versions ALTER COLUMN id SET DEFAULT nextval('renalware.low_clearance_versions_id_seq'::regclass);


--
-- Name: medication_delivery_event_prescriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_event_prescriptions ALTER COLUMN id SET DEFAULT nextval('renalware.medication_delivery_event_prescriptions_id_seq'::regclass);


--
-- Name: medication_delivery_events id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_events ALTER COLUMN id SET DEFAULT nextval('renalware.medication_delivery_events_id_seq'::regclass);


--
-- Name: medication_prescription_terminations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescription_terminations ALTER COLUMN id SET DEFAULT nextval('renalware.medication_prescription_terminations_id_seq'::regclass);


--
-- Name: medication_prescription_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescription_versions ALTER COLUMN id SET DEFAULT nextval('renalware.medication_prescription_versions_id_seq'::regclass);


--
-- Name: medication_prescriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions ALTER COLUMN id SET DEFAULT nextval('renalware.medication_prescriptions_id_seq'::regclass);


--
-- Name: medication_routes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_routes ALTER COLUMN id SET DEFAULT nextval('renalware.medication_routes_id_seq'::regclass);


--
-- Name: messaging_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_messages ALTER COLUMN id SET DEFAULT nextval('renalware.messaging_messages_id_seq'::regclass);


--
-- Name: messaging_receipts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_receipts ALTER COLUMN id SET DEFAULT nextval('renalware.messaging_receipts_id_seq'::regclass);


--
-- Name: modality_change_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_change_types ALTER COLUMN id SET DEFAULT nextval('renalware.modality_change_types_id_seq'::regclass);


--
-- Name: modality_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.modality_descriptions_id_seq'::regclass);


--
-- Name: modality_modalities id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities ALTER COLUMN id SET DEFAULT nextval('renalware.modality_modalities_id_seq'::regclass);


--
-- Name: modality_reasons id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_reasons ALTER COLUMN id SET DEFAULT nextval('renalware.modality_reasons_id_seq'::regclass);


--
-- Name: modality_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_versions ALTER COLUMN id SET DEFAULT nextval('renalware.modality_versions_id_seq'::regclass);


--
-- Name: old_passwords id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.old_passwords ALTER COLUMN id SET DEFAULT nextval('renalware.old_passwords_id_seq'::regclass);


--
-- Name: pathology_calculation_sources id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_calculation_sources ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_calculation_sources_id_seq'::regclass);


--
-- Name: pathology_chart_series id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_chart_series ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_chart_series_id_seq'::regclass);


--
-- Name: pathology_charts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_charts ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_charts_id_seq'::regclass);


--
-- Name: pathology_code_group_memberships id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_group_memberships ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_code_group_memberships_id_seq'::regclass);


--
-- Name: pathology_code_groups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_groups ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_code_groups_id_seq'::regclass);


--
-- Name: pathology_current_observation_sets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_current_observation_sets ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_current_observation_sets_id_seq'::regclass);


--
-- Name: pathology_labs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_labs ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_labs_id_seq'::regclass);


--
-- Name: pathology_measurement_units id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_measurement_units ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_measurement_units_id_seq'::regclass);


--
-- Name: pathology_observation_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_observation_descriptions_id_seq'::regclass);


--
-- Name: pathology_observation_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_requests ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_observation_requests_id_seq'::regclass);


--
-- Name: pathology_observations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observations ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_observations_id_seq'::regclass);


--
-- Name: pathology_obx_mappings id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_obx_mappings ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_obx_mappings_id_seq'::regclass);


--
-- Name: pathology_request_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_request_descriptions_id_seq'::regclass);


--
-- Name: pathology_request_descriptions_requests_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions_requests_requests ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_request_descriptions_requests_requests_id_seq'::regclass);


--
-- Name: pathology_requests_drug_categories id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_drug_categories ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_drug_categories_id_seq'::regclass);


--
-- Name: pathology_requests_drugs_drug_categories id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_drugs_drug_categories ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_drugs_drug_categories_id_seq'::regclass);


--
-- Name: pathology_requests_global_rule_sets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_global_rule_sets ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_global_rule_sets_id_seq'::regclass);


--
-- Name: pathology_requests_global_rules id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_global_rules ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_global_rules_id_seq'::regclass);


--
-- Name: pathology_requests_patient_rules id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_patient_rules_id_seq'::regclass);


--
-- Name: pathology_requests_patient_rules_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules_requests ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_patient_rules_requests_id_seq'::regclass);


--
-- Name: pathology_requests_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_requests ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_requests_id_seq'::regclass);


--
-- Name: pathology_requests_sample_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_sample_types ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_requests_sample_types_id_seq'::regclass);


--
-- Name: pathology_senders id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_senders ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_senders_id_seq'::regclass);


--
-- Name: pathology_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_versions ALTER COLUMN id SET DEFAULT nextval('renalware.pathology_versions_id_seq'::regclass);


--
-- Name: patient_alerts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_alerts ALTER COLUMN id SET DEFAULT nextval('renalware.patient_alerts_id_seq'::regclass);


--
-- Name: patient_attachment_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachment_types ALTER COLUMN id SET DEFAULT nextval('renalware.patient_attachment_types_id_seq'::regclass);


--
-- Name: patient_attachments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachments ALTER COLUMN id SET DEFAULT nextval('renalware.patient_attachments_id_seq'::regclass);


--
-- Name: patient_bookmarks id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_bookmarks ALTER COLUMN id SET DEFAULT nextval('renalware.patient_bookmarks_id_seq'::regclass);


--
-- Name: patient_ethnicities id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_ethnicities ALTER COLUMN id SET DEFAULT nextval('renalware.patient_ethnicities_id_seq'::regclass);


--
-- Name: patient_languages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_languages ALTER COLUMN id SET DEFAULT nextval('renalware.patient_languages_id_seq'::regclass);


--
-- Name: patient_master_index id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_master_index ALTER COLUMN id SET DEFAULT nextval('renalware.patient_master_index_id_seq'::regclass);


--
-- Name: patient_practice_memberships id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_practice_memberships ALTER COLUMN id SET DEFAULT nextval('renalware.patient_practice_memberships_id_seq'::regclass);


--
-- Name: patient_practices id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_practices ALTER COLUMN id SET DEFAULT nextval('renalware.patient_practices_id_seq'::regclass);


--
-- Name: patient_primary_care_physicians id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_primary_care_physicians ALTER COLUMN id SET DEFAULT nextval('renalware.patient_primary_care_physicians_id_seq'::regclass);


--
-- Name: patient_religions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_religions ALTER COLUMN id SET DEFAULT nextval('renalware.patient_religions_id_seq'::regclass);


--
-- Name: patient_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_versions ALTER COLUMN id SET DEFAULT nextval('renalware.patient_versions_id_seq'::regclass);


--
-- Name: patient_worries id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worries ALTER COLUMN id SET DEFAULT nextval('renalware.patient_worries_id_seq'::regclass);


--
-- Name: patient_worry_categories id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worry_categories ALTER COLUMN id SET DEFAULT nextval('renalware.patient_worry_categories_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients ALTER COLUMN id SET DEFAULT nextval('renalware.patients_id_seq'::regclass);


--
-- Name: pd_adequacy_results id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_adequacy_results ALTER COLUMN id SET DEFAULT nextval('renalware.pd_adequacy_results_id_seq'::regclass);


--
-- Name: pd_assessments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_assessments ALTER COLUMN id SET DEFAULT nextval('renalware.pd_assessments_id_seq'::regclass);


--
-- Name: pd_bag_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_bag_types ALTER COLUMN id SET DEFAULT nextval('renalware.pd_bag_types_id_seq'::regclass);


--
-- Name: pd_exit_site_infections id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_exit_site_infections ALTER COLUMN id SET DEFAULT nextval('renalware.pd_exit_site_infections_id_seq'::regclass);


--
-- Name: pd_fluid_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_fluid_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.pd_fluid_descriptions_id_seq'::regclass);


--
-- Name: pd_infection_organisms id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_infection_organisms ALTER COLUMN id SET DEFAULT nextval('renalware.pd_infection_organisms_id_seq'::regclass);


--
-- Name: pd_organism_codes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_organism_codes ALTER COLUMN id SET DEFAULT nextval('renalware.pd_organism_codes_id_seq'::regclass);


--
-- Name: pd_peritonitis_episode_type_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episode_type_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.pd_peritonitis_episode_type_descriptions_id_seq'::regclass);


--
-- Name: pd_peritonitis_episode_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episode_types ALTER COLUMN id SET DEFAULT nextval('renalware.pd_peritonitis_episode_types_id_seq'::regclass);


--
-- Name: pd_peritonitis_episodes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episodes ALTER COLUMN id SET DEFAULT nextval('renalware.pd_peritonitis_episodes_id_seq'::regclass);


--
-- Name: pd_pet_adequacy_results id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_adequacy_results ALTER COLUMN id SET DEFAULT nextval('renalware.pd_pet_adequacy_results_id_seq'::regclass);


--
-- Name: pd_pet_dextrose_concentrations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_dextrose_concentrations ALTER COLUMN id SET DEFAULT nextval('renalware.pd_pet_dextrose_concentrations_id_seq'::regclass);


--
-- Name: pd_pet_results id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_results ALTER COLUMN id SET DEFAULT nextval('renalware.pd_pet_results_id_seq'::regclass);


--
-- Name: pd_regime_bags id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_bags ALTER COLUMN id SET DEFAULT nextval('renalware.pd_regime_bags_id_seq'::regclass);


--
-- Name: pd_regime_terminations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_terminations ALTER COLUMN id SET DEFAULT nextval('renalware.pd_regime_terminations_id_seq'::regclass);


--
-- Name: pd_regimes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regimes ALTER COLUMN id SET DEFAULT nextval('renalware.pd_regimes_id_seq'::regclass);


--
-- Name: pd_systems id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_systems ALTER COLUMN id SET DEFAULT nextval('renalware.pd_systems_id_seq'::regclass);


--
-- Name: pd_training_sessions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sessions ALTER COLUMN id SET DEFAULT nextval('renalware.pd_training_sessions_id_seq'::regclass);


--
-- Name: pd_training_sites id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sites ALTER COLUMN id SET DEFAULT nextval('renalware.pd_training_sites_id_seq'::regclass);


--
-- Name: pd_training_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_types ALTER COLUMN id SET DEFAULT nextval('renalware.pd_training_types_id_seq'::regclass);


--
-- Name: problem_comorbidities id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidities ALTER COLUMN id SET DEFAULT nextval('renalware.problem_comorbidities_id_seq'::regclass);


--
-- Name: problem_comorbidity_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidity_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.problem_comorbidity_descriptions_id_seq'::regclass);


--
-- Name: problem_malignancy_sites id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_malignancy_sites ALTER COLUMN id SET DEFAULT nextval('renalware.problem_malignancy_sites_id_seq'::regclass);


--
-- Name: problem_notes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_notes ALTER COLUMN id SET DEFAULT nextval('renalware.problem_notes_id_seq'::regclass);


--
-- Name: problem_problems id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_problems ALTER COLUMN id SET DEFAULT nextval('renalware.problem_problems_id_seq'::regclass);


--
-- Name: problem_radar_cohorts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_radar_cohorts ALTER COLUMN id SET DEFAULT nextval('renalware.problem_radar_cohorts_id_seq'::regclass);


--
-- Name: problem_radar_diagnoses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_radar_diagnoses ALTER COLUMN id SET DEFAULT nextval('renalware.problem_radar_diagnoses_id_seq'::regclass);


--
-- Name: problem_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_versions ALTER COLUMN id SET DEFAULT nextval('renalware.problem_versions_id_seq'::regclass);


--
-- Name: remote_monitoring_frequencies id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.remote_monitoring_frequencies ALTER COLUMN id SET DEFAULT nextval('renalware.remote_monitoring_frequencies_id_seq'::regclass);


--
-- Name: remote_monitoring_referral_reasons id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.remote_monitoring_referral_reasons ALTER COLUMN id SET DEFAULT nextval('renalware.remote_monitoring_referral_reasons_id_seq'::regclass);


--
-- Name: renal_aki_alert_actions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alert_actions ALTER COLUMN id SET DEFAULT nextval('renalware.renal_aki_alert_actions_id_seq'::regclass);


--
-- Name: renal_aki_alerts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts ALTER COLUMN id SET DEFAULT nextval('renalware.renal_aki_alerts_id_seq'::regclass);


--
-- Name: renal_prd_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_prd_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.renal_prd_descriptions_id_seq'::regclass);


--
-- Name: renal_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_profiles ALTER COLUMN id SET DEFAULT nextval('renalware.renal_profiles_id_seq'::regclass);


--
-- Name: renal_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_versions ALTER COLUMN id SET DEFAULT nextval('renalware.renal_versions_id_seq'::regclass);


--
-- Name: reporting_audits id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.reporting_audits ALTER COLUMN id SET DEFAULT nextval('renalware.reporting_audits_id_seq'::regclass);


--
-- Name: research_investigatorships id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_investigatorships ALTER COLUMN id SET DEFAULT nextval('renalware.research_investigatorships_id_seq'::regclass);


--
-- Name: research_participations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_participations ALTER COLUMN id SET DEFAULT nextval('renalware.research_participations_id_seq'::regclass);


--
-- Name: research_studies id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_studies ALTER COLUMN id SET DEFAULT nextval('renalware.research_studies_id_seq'::regclass);


--
-- Name: research_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_versions ALTER COLUMN id SET DEFAULT nextval('renalware.research_versions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.roles ALTER COLUMN id SET DEFAULT nextval('renalware.roles_id_seq'::regclass);


--
-- Name: roles_users id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.roles_users ALTER COLUMN id SET DEFAULT nextval('renalware.roles_users_id_seq'::regclass);


--
-- Name: snippets_snippets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.snippets_snippets ALTER COLUMN id SET DEFAULT nextval('renalware.snippets_snippets_id_seq'::regclass);


--
-- Name: survey_questions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_questions ALTER COLUMN id SET DEFAULT nextval('renalware.survey_questions_id_seq'::regclass);


--
-- Name: survey_responses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_responses ALTER COLUMN id SET DEFAULT nextval('renalware.survey_responses_id_seq'::regclass);


--
-- Name: survey_surveys id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_surveys ALTER COLUMN id SET DEFAULT nextval('renalware.survey_surveys_id_seq'::regclass);


--
-- Name: system_api_logs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_api_logs ALTER COLUMN id SET DEFAULT nextval('renalware.system_api_logs_id_seq'::regclass);


--
-- Name: system_components id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_components ALTER COLUMN id SET DEFAULT nextval('renalware.system_components_id_seq'::regclass);


--
-- Name: system_countries id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_countries ALTER COLUMN id SET DEFAULT nextval('renalware.system_countries_id_seq'::regclass);


--
-- Name: system_dashboard_components id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_dashboard_components ALTER COLUMN id SET DEFAULT nextval('renalware.system_dashboard_components_id_seq'::regclass);


--
-- Name: system_dashboards id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_dashboards ALTER COLUMN id SET DEFAULT nextval('renalware.system_dashboards_id_seq'::regclass);


--
-- Name: system_downloads id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_downloads ALTER COLUMN id SET DEFAULT nextval('renalware.system_downloads_id_seq'::regclass);


--
-- Name: system_events id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_events ALTER COLUMN id SET DEFAULT nextval('renalware.system_events_id_seq'::regclass);


--
-- Name: system_logs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_logs ALTER COLUMN id SET DEFAULT nextval('renalware.system_logs_id_seq'::regclass);


--
-- Name: system_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_messages ALTER COLUMN id SET DEFAULT nextval('renalware.system_messages_id_seq'::regclass);


--
-- Name: system_nag_definitions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_nag_definitions ALTER COLUMN id SET DEFAULT nextval('renalware.system_nag_definitions_id_seq'::regclass);


--
-- Name: system_online_reference_links id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_online_reference_links ALTER COLUMN id SET DEFAULT nextval('renalware.system_online_reference_links_id_seq'::regclass);


--
-- Name: system_templates id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_templates ALTER COLUMN id SET DEFAULT nextval('renalware.system_templates_id_seq'::regclass);


--
-- Name: system_user_feedback id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_user_feedback ALTER COLUMN id SET DEFAULT nextval('renalware.system_user_feedback_id_seq'::regclass);


--
-- Name: system_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_versions ALTER COLUMN id SET DEFAULT nextval('renalware.system_versions_id_seq'::regclass);


--
-- Name: system_view_calls id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_view_calls ALTER COLUMN id SET DEFAULT nextval('renalware.system_view_calls_id_seq'::regclass);


--
-- Name: system_view_metadata id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_view_metadata ALTER COLUMN id SET DEFAULT nextval('renalware.system_view_metadata_id_seq'::regclass);


--
-- Name: system_visits id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_visits ALTER COLUMN id SET DEFAULT nextval('renalware.system_visits_id_seq'::regclass);


--
-- Name: transplant_donations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donations ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_donations_id_seq'::regclass);


--
-- Name: transplant_donor_followups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_followups ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_donor_followups_id_seq'::regclass);


--
-- Name: transplant_donor_operations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_operations ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_donor_operations_id_seq'::regclass);


--
-- Name: transplant_donor_stage_positions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stage_positions ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_donor_stage_positions_id_seq'::regclass);


--
-- Name: transplant_donor_stage_statuses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stage_statuses ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_donor_stage_statuses_id_seq'::regclass);


--
-- Name: transplant_donor_stages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stages ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_donor_stages_id_seq'::regclass);


--
-- Name: transplant_donor_workups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_workups ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_donor_workups_id_seq'::regclass);


--
-- Name: transplant_failure_cause_description_groups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_failure_cause_description_groups ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_failure_cause_description_groups_id_seq'::regclass);


--
-- Name: transplant_failure_cause_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_failure_cause_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_failure_cause_descriptions_id_seq'::regclass);


--
-- Name: transplant_induction_agents id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_induction_agents ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_induction_agents_id_seq'::regclass);


--
-- Name: transplant_investigation_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_investigation_types ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_investigation_types_id_seq'::regclass);


--
-- Name: transplant_recipient_followups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_followups ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_recipient_followups_id_seq'::regclass);


--
-- Name: transplant_recipient_operations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_operations ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_recipient_operations_id_seq'::regclass);


--
-- Name: transplant_recipient_workups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_workups ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_recipient_workups_id_seq'::regclass);


--
-- Name: transplant_registration_status_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_status_descriptions ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_registration_status_descriptions_id_seq'::regclass);


--
-- Name: transplant_registration_statuses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_statuses ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_registration_statuses_id_seq'::regclass);


--
-- Name: transplant_registrations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registrations ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_registrations_id_seq'::regclass);


--
-- Name: transplant_rejection_episodes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_episodes ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_rejection_episodes_id_seq'::regclass);


--
-- Name: transplant_rejection_treatments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_treatments ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_rejection_treatments_id_seq'::regclass);


--
-- Name: transplant_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_versions ALTER COLUMN id SET DEFAULT nextval('renalware.transplant_versions_id_seq'::regclass);


--
-- Name: ukrdc_batches id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_batches ALTER COLUMN id SET DEFAULT nextval('renalware.ukrdc_batches_id_seq'::regclass);


--
-- Name: ukrdc_measurement_units id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_measurement_units ALTER COLUMN id SET DEFAULT nextval('renalware.ukrdc_measurement_units_id_seq'::regclass);


--
-- Name: ukrdc_modality_codes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_modality_codes ALTER COLUMN id SET DEFAULT nextval('renalware.ukrdc_modality_codes_id_seq'::regclass);


--
-- Name: ukrdc_transmission_logs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_transmission_logs ALTER COLUMN id SET DEFAULT nextval('renalware.ukrdc_transmission_logs_id_seq'::regclass);


--
-- Name: ukrdc_treatments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments ALTER COLUMN id SET DEFAULT nextval('renalware.ukrdc_treatments_id_seq'::regclass);


--
-- Name: user_group_memberships id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_group_memberships ALTER COLUMN id SET DEFAULT nextval('renalware.user_group_memberships_id_seq'::regclass);


--
-- Name: user_groups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_groups ALTER COLUMN id SET DEFAULT nextval('renalware.user_groups_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.users ALTER COLUMN id SET DEFAULT nextval('renalware.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.versions ALTER COLUMN id SET DEFAULT nextval('renalware.versions_id_seq'::regclass);


--
-- Name: virology_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_profiles ALTER COLUMN id SET DEFAULT nextval('renalware.virology_profiles_id_seq'::regclass);


--
-- Name: virology_vaccination_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_vaccination_types ALTER COLUMN id SET DEFAULT nextval('renalware.virology_vaccination_types_id_seq'::regclass);


--
-- Name: virology_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_versions ALTER COLUMN id SET DEFAULT nextval('renalware.virology_versions_id_seq'::regclass);


--
-- Name: solid_cache_entries id; Type: DEFAULT; Schema: renalware_demo; Owner: -
--

ALTER TABLE ONLY renalware_demo.solid_cache_entries ALTER COLUMN id SET DEFAULT nextval('renalware_demo.solid_cache_entries_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: access_assessments access_assessments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_assessments
    ADD CONSTRAINT access_assessments_pkey PRIMARY KEY (id);


--
-- Name: access_catheter_insertion_techniques access_catheter_insertion_techniques_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_catheter_insertion_techniques
    ADD CONSTRAINT access_catheter_insertion_techniques_pkey PRIMARY KEY (id);


--
-- Name: access_needling_assessments access_needling_assessments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_needling_assessments
    ADD CONSTRAINT access_needling_assessments_pkey PRIMARY KEY (id);


--
-- Name: access_plan_types access_plan_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plan_types
    ADD CONSTRAINT access_plan_types_pkey PRIMARY KEY (id);


--
-- Name: access_plans access_plans_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plans
    ADD CONSTRAINT access_plans_pkey PRIMARY KEY (id);


--
-- Name: access_procedures access_procedures_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_procedures
    ADD CONSTRAINT access_procedures_pkey PRIMARY KEY (id);


--
-- Name: access_profiles access_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_profiles
    ADD CONSTRAINT access_profiles_pkey PRIMARY KEY (id);


--
-- Name: access_sites access_sites_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_sites
    ADD CONSTRAINT access_sites_pkey PRIMARY KEY (id);


--
-- Name: access_types access_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_types
    ADD CONSTRAINT access_types_pkey PRIMARY KEY (id);


--
-- Name: access_versions access_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_versions
    ADD CONSTRAINT access_versions_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: activesupport_cache_entries activesupport_cache_entries_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.activesupport_cache_entries
    ADD CONSTRAINT activesupport_cache_entries_pkey PRIMARY KEY (key);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admission_admissions admission_admissions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions
    ADD CONSTRAINT admission_admissions_pkey PRIMARY KEY (id);


--
-- Name: admission_consult_sites admission_consult_sites_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consult_sites
    ADD CONSTRAINT admission_consult_sites_pkey PRIMARY KEY (id);


--
-- Name: admission_consults admission_consults_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults
    ADD CONSTRAINT admission_consults_pkey PRIMARY KEY (id);


--
-- Name: admission_request_reasons admission_request_reasons_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_request_reasons
    ADD CONSTRAINT admission_request_reasons_pkey PRIMARY KEY (id);


--
-- Name: admission_requests admission_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_requests
    ADD CONSTRAINT admission_requests_pkey PRIMARY KEY (id);


--
-- Name: admission_specialties admission_specialties_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_specialties
    ADD CONSTRAINT admission_specialties_pkey PRIMARY KEY (id);


--
-- Name: clinic_appointments clinic_appointments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments
    ADD CONSTRAINT clinic_appointments_pkey PRIMARY KEY (id);


--
-- Name: clinic_clinics clinic_clinics_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_clinics
    ADD CONSTRAINT clinic_clinics_pkey PRIMARY KEY (id);


--
-- Name: clinic_consultants clinic_consultants_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_consultants
    ADD CONSTRAINT clinic_consultants_pkey PRIMARY KEY (id);


--
-- Name: clinic_versions clinic_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_versions
    ADD CONSTRAINT clinic_versions_pkey PRIMARY KEY (id);


--
-- Name: clinic_visit_locations clinic_visit_locations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visit_locations
    ADD CONSTRAINT clinic_visit_locations_pkey PRIMARY KEY (id);


--
-- Name: clinic_visits clinic_visits_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visits
    ADD CONSTRAINT clinic_visits_pkey PRIMARY KEY (id);


--
-- Name: clinical_allergies clinical_allergies_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_allergies
    ADD CONSTRAINT clinical_allergies_pkey PRIMARY KEY (id);


--
-- Name: clinical_body_compositions clinical_body_compositions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_body_compositions
    ADD CONSTRAINT clinical_body_compositions_pkey PRIMARY KEY (id);


--
-- Name: clinical_dry_weights clinical_dry_weights_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_dry_weights
    ADD CONSTRAINT clinical_dry_weights_pkey PRIMARY KEY (id);


--
-- Name: clinical_igan_risks clinical_igan_risks_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_igan_risks
    ADD CONSTRAINT clinical_igan_risks_pkey PRIMARY KEY (id);


--
-- Name: clinical_versions clinical_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_versions
    ADD CONSTRAINT clinical_versions_pkey PRIMARY KEY (id);


--
-- Name: hd_schedule_definitions days_array_unique_scoped_to_period; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_schedule_definitions
    ADD CONSTRAINT days_array_unique_scoped_to_period EXCLUDE USING gist (diurnal_period_id WITH =, days WITH =);


--
-- Name: death_causes death_causes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.death_causes
    ADD CONSTRAINT death_causes_pkey PRIMARY KEY (id);


--
-- Name: death_locations death_locations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.death_locations
    ADD CONSTRAINT death_locations_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: directory_people directory_people_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.directory_people
    ADD CONSTRAINT directory_people_pkey PRIMARY KEY (id);


--
-- Name: drug_dmd_actual_medical_products drug_dmd_actual_medical_products_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_actual_medical_products
    ADD CONSTRAINT drug_dmd_actual_medical_products_pkey PRIMARY KEY (id);


--
-- Name: drug_dmd_matches drug_dmd_matches_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_matches
    ADD CONSTRAINT drug_dmd_matches_pkey PRIMARY KEY (id);


--
-- Name: drug_dmd_virtual_medical_products drug_dmd_virtual_medical_products_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_virtual_medical_products
    ADD CONSTRAINT drug_dmd_virtual_medical_products_pkey PRIMARY KEY (id);


--
-- Name: drug_dmd_virtual_therapeutic_moieties drug_dmd_virtual_therapeutic_moieties_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_dmd_virtual_therapeutic_moieties
    ADD CONSTRAINT drug_dmd_virtual_therapeutic_moieties_pkey PRIMARY KEY (id);


--
-- Name: drug_forms drug_forms_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_forms
    ADD CONSTRAINT drug_forms_pkey PRIMARY KEY (id);


--
-- Name: drug_frequencies drug_frequencies_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_frequencies
    ADD CONSTRAINT drug_frequencies_pkey PRIMARY KEY (id);


--
-- Name: drug_homecare_forms drug_homecare_forms_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_homecare_forms
    ADD CONSTRAINT drug_homecare_forms_pkey PRIMARY KEY (id);


--
-- Name: drug_patient_group_directions drug_patient_group_directions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_patient_group_directions
    ADD CONSTRAINT drug_patient_group_directions_pkey PRIMARY KEY (id);


--
-- Name: drug_suppliers drug_suppliers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_suppliers
    ADD CONSTRAINT drug_suppliers_pkey PRIMARY KEY (id);


--
-- Name: drug_trade_families drug_trade_families_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_trade_families
    ADD CONSTRAINT drug_trade_families_pkey PRIMARY KEY (id);


--
-- Name: drug_trade_family_classifications drug_trade_family_classifications_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_trade_family_classifications
    ADD CONSTRAINT drug_trade_family_classifications_pkey PRIMARY KEY (id);


--
-- Name: drug_types_drugs drug_types_drugs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_types_drugs
    ADD CONSTRAINT drug_types_drugs_pkey PRIMARY KEY (id);


--
-- Name: drug_types drug_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_types
    ADD CONSTRAINT drug_types_pkey PRIMARY KEY (id);


--
-- Name: drug_unit_of_measures drug_unit_of_measures_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_unit_of_measures
    ADD CONSTRAINT drug_unit_of_measures_pkey PRIMARY KEY (id);


--
-- Name: drug_versions drug_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_versions
    ADD CONSTRAINT drug_versions_pkey PRIMARY KEY (id);


--
-- Name: drug_vmp_classifications drug_vmp_classifications_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_vmp_classifications
    ADD CONSTRAINT drug_vmp_classifications_pkey PRIMARY KEY (id);


--
-- Name: drugs drugs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: event_categories event_categories_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_categories
    ADD CONSTRAINT event_categories_pkey PRIMARY KEY (id);


--
-- Name: event_subtypes event_subtypes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_subtypes
    ADD CONSTRAINT event_subtypes_pkey PRIMARY KEY (id);


--
-- Name: event_type_alert_triggers event_type_alert_triggers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_type_alert_triggers
    ADD CONSTRAINT event_type_alert_triggers_pkey PRIMARY KEY (id);


--
-- Name: event_types event_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_types
    ADD CONSTRAINT event_types_pkey PRIMARY KEY (id);


--
-- Name: event_versions event_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_versions
    ADD CONSTRAINT event_versions_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: feed_file_types feed_file_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_file_types
    ADD CONSTRAINT feed_file_types_pkey PRIMARY KEY (id);


--
-- Name: feed_files feed_files_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_files
    ADD CONSTRAINT feed_files_pkey PRIMARY KEY (id);


--
-- Name: feed_gps feed_gps_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_gps
    ADD CONSTRAINT feed_gps_pkey PRIMARY KEY (id);


--
-- Name: feed_hl7_test_messages feed_hl7_test_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_hl7_test_messages
    ADD CONSTRAINT feed_hl7_test_messages_pkey PRIMARY KEY (id);


--
-- Name: feed_logs feed_logs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_logs
    ADD CONSTRAINT feed_logs_pkey PRIMARY KEY (id);


--
-- Name: feed_message_replays feed_message_replays_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_message_replays
    ADD CONSTRAINT feed_message_replays_pkey PRIMARY KEY (id);


--
-- Name: feed_messages feed_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_messages
    ADD CONSTRAINT feed_messages_pkey PRIMARY KEY (id);


--
-- Name: feed_outgoing_documents feed_outgoing_documents_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_outgoing_documents
    ADD CONSTRAINT feed_outgoing_documents_pkey PRIMARY KEY (id);


--
-- Name: feed_practice_gps feed_practice_gps_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_practice_gps
    ADD CONSTRAINT feed_practice_gps_pkey PRIMARY KEY (id);


--
-- Name: feed_raw_hl7_messages feed_raw_hl7_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_raw_hl7_messages
    ADD CONSTRAINT feed_raw_hl7_messages_pkey PRIMARY KEY (id);


--
-- Name: feed_replay_requests feed_replay_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_replay_requests
    ADD CONSTRAINT feed_replay_requests_pkey PRIMARY KEY (id);


--
-- Name: feed_sausage_queue feed_sausage_queue_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_sausage_queue
    ADD CONSTRAINT feed_sausage_queue_pkey PRIMARY KEY (id);


--
-- Name: feed_sausages feed_sausages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_sausages
    ADD CONSTRAINT feed_sausages_pkey PRIMARY KEY (id);


--
-- Name: geography_local_authority_districts geography_local_authority_districts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_local_authority_districts
    ADD CONSTRAINT geography_local_authority_districts_pkey PRIMARY KEY (id);


--
-- Name: geography_lower_super_output_areas geography_lower_super_output_areas_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_lower_super_output_areas
    ADD CONSTRAINT geography_lower_super_output_areas_pkey PRIMARY KEY (id);


--
-- Name: geography_middle_super_output_areas geography_middle_super_output_areas_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_middle_super_output_areas
    ADD CONSTRAINT geography_middle_super_output_areas_pkey PRIMARY KEY (id);


--
-- Name: geography_output_areas geography_output_areas_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_output_areas
    ADD CONSTRAINT geography_output_areas_pkey PRIMARY KEY (id);


--
-- Name: geography_postcodes geography_postcodes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_postcodes
    ADD CONSTRAINT geography_postcodes_pkey PRIMARY KEY (id);


--
-- Name: good_job_batches good_job_batches_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.good_job_batches
    ADD CONSTRAINT good_job_batches_pkey PRIMARY KEY (id);


--
-- Name: good_job_executions good_job_executions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.good_job_executions
    ADD CONSTRAINT good_job_executions_pkey PRIMARY KEY (id);


--
-- Name: good_job_processes good_job_processes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.good_job_processes
    ADD CONSTRAINT good_job_processes_pkey PRIMARY KEY (id);


--
-- Name: good_job_settings good_job_settings_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.good_job_settings
    ADD CONSTRAINT good_job_settings_pkey PRIMARY KEY (id);


--
-- Name: good_jobs good_jobs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);


--
-- Name: hd_cannulation_types hd_cannulation_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_cannulation_types
    ADD CONSTRAINT hd_cannulation_types_pkey PRIMARY KEY (id);


--
-- Name: hd_dialysates hd_dialysates_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_dialysates
    ADD CONSTRAINT hd_dialysates_pkey PRIMARY KEY (id);


--
-- Name: hd_dialysers hd_dialysers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_dialysers
    ADD CONSTRAINT hd_dialysers_pkey PRIMARY KEY (id);


--
-- Name: hd_diaries hd_diaries_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diaries
    ADD CONSTRAINT hd_diaries_pkey PRIMARY KEY (id);


--
-- Name: hd_diary_slots hd_diary_slots_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots
    ADD CONSTRAINT hd_diary_slots_pkey PRIMARY KEY (id);


--
-- Name: hd_diurnal_period_codes hd_diurnal_period_codes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diurnal_period_codes
    ADD CONSTRAINT hd_diurnal_period_codes_pkey PRIMARY KEY (id);


--
-- Name: hd_patient_statistics hd_patient_statistics_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_patient_statistics
    ADD CONSTRAINT hd_patient_statistics_pkey PRIMARY KEY (id);


--
-- Name: hd_preference_sets hd_preference_sets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_preference_sets
    ADD CONSTRAINT hd_preference_sets_pkey PRIMARY KEY (id);


--
-- Name: hd_prescription_administration_reasons hd_prescription_administration_reasons_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administration_reasons
    ADD CONSTRAINT hd_prescription_administration_reasons_pkey PRIMARY KEY (id);


--
-- Name: hd_prescription_administrations hd_prescription_administrations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT hd_prescription_administrations_pkey PRIMARY KEY (id);


--
-- Name: hd_profiles hd_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT hd_profiles_pkey PRIMARY KEY (id);


--
-- Name: hd_provider_units hd_provider_units_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_provider_units
    ADD CONSTRAINT hd_provider_units_pkey PRIMARY KEY (id);


--
-- Name: hd_providers hd_providers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_providers
    ADD CONSTRAINT hd_providers_pkey PRIMARY KEY (id);


--
-- Name: hd_schedule_definitions hd_schedule_definitions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_schedule_definitions
    ADD CONSTRAINT hd_schedule_definitions_pkey PRIMARY KEY (id);


--
-- Name: hd_session_form_batch_items hd_session_form_batch_items_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_form_batch_items
    ADD CONSTRAINT hd_session_form_batch_items_pkey PRIMARY KEY (id);


--
-- Name: hd_session_form_batches hd_session_form_batches_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_form_batches
    ADD CONSTRAINT hd_session_form_batches_pkey PRIMARY KEY (id);


--
-- Name: hd_session_patient_group_directions hd_session_patient_group_directions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_patient_group_directions
    ADD CONSTRAINT hd_session_patient_group_directions_pkey PRIMARY KEY (id);


--
-- Name: hd_sessions hd_sessions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT hd_sessions_pkey PRIMARY KEY (id);


--
-- Name: hd_slot_request_access_states hd_slot_request_access_states_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_request_access_states
    ADD CONSTRAINT hd_slot_request_access_states_pkey PRIMARY KEY (id);


--
-- Name: hd_slot_request_deletion_reasons hd_slot_request_deletion_reasons_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_request_deletion_reasons
    ADD CONSTRAINT hd_slot_request_deletion_reasons_pkey PRIMARY KEY (id);


--
-- Name: hd_slot_request_locations hd_slot_request_locations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_request_locations
    ADD CONSTRAINT hd_slot_request_locations_pkey PRIMARY KEY (id);


--
-- Name: hd_slot_requests hd_slot_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests
    ADD CONSTRAINT hd_slot_requests_pkey PRIMARY KEY (id);


--
-- Name: hd_station_locations hd_station_locations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_station_locations
    ADD CONSTRAINT hd_station_locations_pkey PRIMARY KEY (id);


--
-- Name: hd_stations hd_stations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_stations
    ADD CONSTRAINT hd_stations_pkey PRIMARY KEY (id);


--
-- Name: hd_transmission_logs hd_transmission_logs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_transmission_logs
    ADD CONSTRAINT hd_transmission_logs_pkey PRIMARY KEY (id);


--
-- Name: hd_versions hd_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_versions
    ADD CONSTRAINT hd_versions_pkey PRIMARY KEY (id);


--
-- Name: hd_vnd_risk_assessments hd_vnd_risk_assessments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_vnd_risk_assessments
    ADD CONSTRAINT hd_vnd_risk_assessments_pkey PRIMARY KEY (id);


--
-- Name: hospital_centres hospital_centres_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_centres
    ADD CONSTRAINT hospital_centres_pkey PRIMARY KEY (id);


--
-- Name: hospital_departments hospital_departments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_departments
    ADD CONSTRAINT hospital_departments_pkey PRIMARY KEY (id);


--
-- Name: hospital_units hospital_units_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_units
    ADD CONSTRAINT hospital_units_pkey PRIMARY KEY (id);


--
-- Name: hospital_wards hospital_wards_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_wards
    ADD CONSTRAINT hospital_wards_pkey PRIMARY KEY (id);


--
-- Name: letter_archives letter_archives_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_archives
    ADD CONSTRAINT letter_archives_pkey PRIMARY KEY (id);


--
-- Name: letter_batch_items letter_batch_items_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batch_items
    ADD CONSTRAINT letter_batch_items_pkey PRIMARY KEY (id);


--
-- Name: letter_batches letter_batches_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batches
    ADD CONSTRAINT letter_batches_pkey PRIMARY KEY (id);


--
-- Name: letter_contact_descriptions letter_contact_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_contact_descriptions
    ADD CONSTRAINT letter_contact_descriptions_pkey PRIMARY KEY (id);


--
-- Name: letter_contacts letter_contacts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_contacts
    ADD CONSTRAINT letter_contacts_pkey PRIMARY KEY (id);


--
-- Name: letter_descriptions letter_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_descriptions
    ADD CONSTRAINT letter_descriptions_pkey PRIMARY KEY (id);


--
-- Name: letter_electronic_receipts letter_electronic_receipts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_electronic_receipts
    ADD CONSTRAINT letter_electronic_receipts_pkey PRIMARY KEY (id);


--
-- Name: letter_letterheads letter_letterheads_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letterheads
    ADD CONSTRAINT letter_letterheads_pkey PRIMARY KEY (id);


--
-- Name: letter_letters letter_letters_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT letter_letters_pkey PRIMARY KEY (id);


--
-- Name: letter_mailshot_items letter_mailshot_items_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_items
    ADD CONSTRAINT letter_mailshot_items_pkey PRIMARY KEY (id);


--
-- Name: letter_mailshot_mailshots letter_mailshot_mailshots_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_mailshots
    ADD CONSTRAINT letter_mailshot_mailshots_pkey PRIMARY KEY (id);


--
-- Name: letter_mesh_operations letter_mesh_operations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mesh_operations
    ADD CONSTRAINT letter_mesh_operations_pkey PRIMARY KEY (id);


--
-- Name: letter_mesh_transmissions letter_mesh_transmissions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mesh_transmissions
    ADD CONSTRAINT letter_mesh_transmissions_pkey PRIMARY KEY (id);


--
-- Name: letter_qr_encoded_online_reference_links letter_qr_encoded_online_reference_links_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_qr_encoded_online_reference_links
    ADD CONSTRAINT letter_qr_encoded_online_reference_links_pkey PRIMARY KEY (id);


--
-- Name: letter_recipients letter_recipients_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_recipients
    ADD CONSTRAINT letter_recipients_pkey PRIMARY KEY (id);


--
-- Name: letter_section_snapshots letter_section_snapshots_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_section_snapshots
    ADD CONSTRAINT letter_section_snapshots_pkey PRIMARY KEY (id);


--
-- Name: letter_signatures letter_signatures_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_signatures
    ADD CONSTRAINT letter_signatures_pkey PRIMARY KEY (id);


--
-- Name: letter_snomed_document_types letter_snomed_document_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_snomed_document_types
    ADD CONSTRAINT letter_snomed_document_types_pkey PRIMARY KEY (id);


--
-- Name: low_clearance_dialysis_plans low_clearance_dialysis_plans_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_dialysis_plans
    ADD CONSTRAINT low_clearance_dialysis_plans_pkey PRIMARY KEY (id);


--
-- Name: low_clearance_profiles low_clearance_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_profiles
    ADD CONSTRAINT low_clearance_profiles_pkey PRIMARY KEY (id);


--
-- Name: low_clearance_referrers low_clearance_referrers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_referrers
    ADD CONSTRAINT low_clearance_referrers_pkey PRIMARY KEY (id);


--
-- Name: low_clearance_versions low_clearance_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_versions
    ADD CONSTRAINT low_clearance_versions_pkey PRIMARY KEY (id);


--
-- Name: medication_delivery_event_prescriptions medication_delivery_event_prescriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_event_prescriptions
    ADD CONSTRAINT medication_delivery_event_prescriptions_pkey PRIMARY KEY (id);


--
-- Name: medication_delivery_events medication_delivery_events_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_events
    ADD CONSTRAINT medication_delivery_events_pkey PRIMARY KEY (id);


--
-- Name: medication_prescription_terminations medication_prescription_terminations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescription_terminations
    ADD CONSTRAINT medication_prescription_terminations_pkey PRIMARY KEY (id);


--
-- Name: medication_prescription_versions medication_prescription_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescription_versions
    ADD CONSTRAINT medication_prescription_versions_pkey PRIMARY KEY (id);


--
-- Name: medication_prescriptions medication_prescriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT medication_prescriptions_pkey PRIMARY KEY (id);


--
-- Name: medication_routes medication_routes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_routes
    ADD CONSTRAINT medication_routes_pkey PRIMARY KEY (id);


--
-- Name: messaging_messages messaging_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_messages
    ADD CONSTRAINT messaging_messages_pkey PRIMARY KEY (id);


--
-- Name: messaging_receipts messaging_receipts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_receipts
    ADD CONSTRAINT messaging_receipts_pkey PRIMARY KEY (id);


--
-- Name: modality_change_types modality_change_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_change_types
    ADD CONSTRAINT modality_change_types_pkey PRIMARY KEY (id);


--
-- Name: modality_descriptions modality_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_descriptions
    ADD CONSTRAINT modality_descriptions_pkey PRIMARY KEY (id);


--
-- Name: modality_modalities modality_modalities_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT modality_modalities_pkey PRIMARY KEY (id);


--
-- Name: modality_reasons modality_reasons_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_reasons
    ADD CONSTRAINT modality_reasons_pkey PRIMARY KEY (id);


--
-- Name: modality_versions modality_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_versions
    ADD CONSTRAINT modality_versions_pkey PRIMARY KEY (id);


--
-- Name: old_passwords old_passwords_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.old_passwords
    ADD CONSTRAINT old_passwords_pkey PRIMARY KEY (id);


--
-- Name: pathology_calculation_sources pathology_calculation_sources_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_calculation_sources
    ADD CONSTRAINT pathology_calculation_sources_pkey PRIMARY KEY (id);


--
-- Name: pathology_chart_series pathology_chart_series_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_chart_series
    ADD CONSTRAINT pathology_chart_series_pkey PRIMARY KEY (id);


--
-- Name: pathology_charts pathology_charts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_charts
    ADD CONSTRAINT pathology_charts_pkey PRIMARY KEY (id);


--
-- Name: pathology_code_group_memberships pathology_code_group_memberships_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_group_memberships
    ADD CONSTRAINT pathology_code_group_memberships_pkey PRIMARY KEY (id);


--
-- Name: pathology_code_groups pathology_code_groups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_groups
    ADD CONSTRAINT pathology_code_groups_pkey PRIMARY KEY (id);


--
-- Name: pathology_current_observation_sets pathology_current_observation_sets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_current_observation_sets
    ADD CONSTRAINT pathology_current_observation_sets_pkey PRIMARY KEY (id);


--
-- Name: pathology_labs pathology_labs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_labs
    ADD CONSTRAINT pathology_labs_pkey PRIMARY KEY (id);


--
-- Name: pathology_measurement_units pathology_measurement_units_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_measurement_units
    ADD CONSTRAINT pathology_measurement_units_pkey PRIMARY KEY (id);


--
-- Name: pathology_observation_descriptions pathology_observation_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_descriptions
    ADD CONSTRAINT pathology_observation_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pathology_observation_requests pathology_observation_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_requests
    ADD CONSTRAINT pathology_observation_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_observations pathology_observations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observations
    ADD CONSTRAINT pathology_observations_pkey PRIMARY KEY (id);


--
-- Name: pathology_obx_mappings pathology_obx_mappings_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_obx_mappings
    ADD CONSTRAINT pathology_obx_mappings_pkey PRIMARY KEY (id);


--
-- Name: pathology_request_descriptions pathology_request_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions
    ADD CONSTRAINT pathology_request_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pathology_request_descriptions_requests_requests pathology_request_descriptions_requests_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions_requests_requests
    ADD CONSTRAINT pathology_request_descriptions_requests_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_drug_categories pathology_requests_drug_categories_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_drug_categories
    ADD CONSTRAINT pathology_requests_drug_categories_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_drugs_drug_categories pathology_requests_drugs_drug_categories_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_drugs_drug_categories
    ADD CONSTRAINT pathology_requests_drugs_drug_categories_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_global_rule_sets pathology_requests_global_rule_sets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_global_rule_sets
    ADD CONSTRAINT pathology_requests_global_rule_sets_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_global_rules pathology_requests_global_rules_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_global_rules
    ADD CONSTRAINT pathology_requests_global_rules_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_patient_rules pathology_requests_patient_rules_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules
    ADD CONSTRAINT pathology_requests_patient_rules_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_patient_rules_requests pathology_requests_patient_rules_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules_requests
    ADD CONSTRAINT pathology_requests_patient_rules_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_requests pathology_requests_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_requests
    ADD CONSTRAINT pathology_requests_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_sample_types pathology_requests_sample_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_sample_types
    ADD CONSTRAINT pathology_requests_sample_types_pkey PRIMARY KEY (id);


--
-- Name: pathology_senders pathology_senders_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_senders
    ADD CONSTRAINT pathology_senders_pkey PRIMARY KEY (id);


--
-- Name: pathology_versions pathology_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_versions
    ADD CONSTRAINT pathology_versions_pkey PRIMARY KEY (id);


--
-- Name: patient_alerts patient_alerts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_alerts
    ADD CONSTRAINT patient_alerts_pkey PRIMARY KEY (id);


--
-- Name: patient_attachment_types patient_attachment_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachment_types
    ADD CONSTRAINT patient_attachment_types_pkey PRIMARY KEY (id);


--
-- Name: patient_attachments patient_attachments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachments
    ADD CONSTRAINT patient_attachments_pkey PRIMARY KEY (id);


--
-- Name: patient_bookmarks patient_bookmarks_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_bookmarks
    ADD CONSTRAINT patient_bookmarks_pkey PRIMARY KEY (id);


--
-- Name: patient_ethnicities patient_ethnicities_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_ethnicities
    ADD CONSTRAINT patient_ethnicities_pkey PRIMARY KEY (id);


--
-- Name: patient_languages patient_languages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_languages
    ADD CONSTRAINT patient_languages_pkey PRIMARY KEY (id);


--
-- Name: patient_master_index patient_master_index_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_master_index
    ADD CONSTRAINT patient_master_index_pkey PRIMARY KEY (id);


--
-- Name: patient_practice_memberships patient_practice_memberships_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_practice_memberships
    ADD CONSTRAINT patient_practice_memberships_pkey PRIMARY KEY (id);


--
-- Name: patient_practices patient_practices_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_practices
    ADD CONSTRAINT patient_practices_pkey PRIMARY KEY (id);


--
-- Name: patient_primary_care_physicians patient_primary_care_physicians_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_primary_care_physicians
    ADD CONSTRAINT patient_primary_care_physicians_pkey PRIMARY KEY (id);


--
-- Name: patient_religions patient_religions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_religions
    ADD CONSTRAINT patient_religions_pkey PRIMARY KEY (id);


--
-- Name: patient_versions patient_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_versions
    ADD CONSTRAINT patient_versions_pkey PRIMARY KEY (id);


--
-- Name: patient_worries patient_worries_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worries
    ADD CONSTRAINT patient_worries_pkey PRIMARY KEY (id);


--
-- Name: patient_worry_categories patient_worry_categories_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worry_categories
    ADD CONSTRAINT patient_worry_categories_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: pd_adequacy_results pd_adequacy_results_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_adequacy_results
    ADD CONSTRAINT pd_adequacy_results_pkey PRIMARY KEY (id);


--
-- Name: pd_assessments pd_assessments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_assessments
    ADD CONSTRAINT pd_assessments_pkey PRIMARY KEY (id);


--
-- Name: pd_bag_types pd_bag_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_bag_types
    ADD CONSTRAINT pd_bag_types_pkey PRIMARY KEY (id);


--
-- Name: pd_exit_site_infections pd_exit_site_infections_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_exit_site_infections
    ADD CONSTRAINT pd_exit_site_infections_pkey PRIMARY KEY (id);


--
-- Name: pd_fluid_descriptions pd_fluid_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_fluid_descriptions
    ADD CONSTRAINT pd_fluid_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pd_infection_organisms pd_infection_organisms_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_infection_organisms
    ADD CONSTRAINT pd_infection_organisms_pkey PRIMARY KEY (id);


--
-- Name: pd_organism_codes pd_organism_codes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_organism_codes
    ADD CONSTRAINT pd_organism_codes_pkey PRIMARY KEY (id);


--
-- Name: pd_peritonitis_episode_type_descriptions pd_peritonitis_episode_type_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episode_type_descriptions
    ADD CONSTRAINT pd_peritonitis_episode_type_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pd_peritonitis_episode_types pd_peritonitis_episode_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episode_types
    ADD CONSTRAINT pd_peritonitis_episode_types_pkey PRIMARY KEY (id);


--
-- Name: pd_peritonitis_episodes pd_peritonitis_episodes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episodes
    ADD CONSTRAINT pd_peritonitis_episodes_pkey PRIMARY KEY (id);


--
-- Name: pd_pet_adequacy_results pd_pet_adequacy_results_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_adequacy_results
    ADD CONSTRAINT pd_pet_adequacy_results_pkey PRIMARY KEY (id);


--
-- Name: pd_pet_dextrose_concentrations pd_pet_dextrose_concentrations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_dextrose_concentrations
    ADD CONSTRAINT pd_pet_dextrose_concentrations_pkey PRIMARY KEY (id);


--
-- Name: pd_pet_results pd_pet_results_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_results
    ADD CONSTRAINT pd_pet_results_pkey PRIMARY KEY (id);


--
-- Name: pd_regime_bags pd_regime_bags_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_bags
    ADD CONSTRAINT pd_regime_bags_pkey PRIMARY KEY (id);


--
-- Name: pd_regime_terminations pd_regime_terminations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_terminations
    ADD CONSTRAINT pd_regime_terminations_pkey PRIMARY KEY (id);


--
-- Name: pd_regimes pd_regimes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regimes
    ADD CONSTRAINT pd_regimes_pkey PRIMARY KEY (id);


--
-- Name: pd_systems pd_systems_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_systems
    ADD CONSTRAINT pd_systems_pkey PRIMARY KEY (id);


--
-- Name: pd_training_sessions pd_training_sessions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sessions
    ADD CONSTRAINT pd_training_sessions_pkey PRIMARY KEY (id);


--
-- Name: pd_training_sites pd_training_sites_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sites
    ADD CONSTRAINT pd_training_sites_pkey PRIMARY KEY (id);


--
-- Name: pd_training_types pd_training_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_types
    ADD CONSTRAINT pd_training_types_pkey PRIMARY KEY (id);


--
-- Name: problem_comorbidities problem_comorbidities_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidities
    ADD CONSTRAINT problem_comorbidities_pkey PRIMARY KEY (id);


--
-- Name: problem_comorbidity_descriptions problem_comorbidity_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidity_descriptions
    ADD CONSTRAINT problem_comorbidity_descriptions_pkey PRIMARY KEY (id);


--
-- Name: problem_malignancy_sites problem_malignancy_sites_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_malignancy_sites
    ADD CONSTRAINT problem_malignancy_sites_pkey PRIMARY KEY (id);


--
-- Name: problem_notes problem_notes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_notes
    ADD CONSTRAINT problem_notes_pkey PRIMARY KEY (id);


--
-- Name: problem_problems problem_problems_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_problems
    ADD CONSTRAINT problem_problems_pkey PRIMARY KEY (id);


--
-- Name: problem_radar_cohorts problem_radar_cohorts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_radar_cohorts
    ADD CONSTRAINT problem_radar_cohorts_pkey PRIMARY KEY (id);


--
-- Name: problem_radar_diagnoses problem_radar_diagnoses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_radar_diagnoses
    ADD CONSTRAINT problem_radar_diagnoses_pkey PRIMARY KEY (id);


--
-- Name: problem_versions problem_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_versions
    ADD CONSTRAINT problem_versions_pkey PRIMARY KEY (id);


--
-- Name: remote_monitoring_frequencies remote_monitoring_frequencies_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.remote_monitoring_frequencies
    ADD CONSTRAINT remote_monitoring_frequencies_pkey PRIMARY KEY (id);


--
-- Name: remote_monitoring_referral_reasons remote_monitoring_referral_reasons_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.remote_monitoring_referral_reasons
    ADD CONSTRAINT remote_monitoring_referral_reasons_pkey PRIMARY KEY (id);


--
-- Name: renal_aki_alert_actions renal_aki_alert_actions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alert_actions
    ADD CONSTRAINT renal_aki_alert_actions_pkey PRIMARY KEY (id);


--
-- Name: renal_aki_alerts renal_aki_alerts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts
    ADD CONSTRAINT renal_aki_alerts_pkey PRIMARY KEY (id);


--
-- Name: renal_prd_descriptions renal_prd_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_prd_descriptions
    ADD CONSTRAINT renal_prd_descriptions_pkey PRIMARY KEY (id);


--
-- Name: renal_profiles renal_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_profiles
    ADD CONSTRAINT renal_profiles_pkey PRIMARY KEY (id);


--
-- Name: renal_versions renal_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_versions
    ADD CONSTRAINT renal_versions_pkey PRIMARY KEY (id);


--
-- Name: reporting_audits reporting_audits_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.reporting_audits
    ADD CONSTRAINT reporting_audits_pkey PRIMARY KEY (id);


--
-- Name: research_investigatorships research_investigatorships_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_investigatorships
    ADD CONSTRAINT research_investigatorships_pkey PRIMARY KEY (id);


--
-- Name: research_participations research_participations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_participations
    ADD CONSTRAINT research_participations_pkey PRIMARY KEY (id);


--
-- Name: research_studies research_studies_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_studies
    ADD CONSTRAINT research_studies_pkey PRIMARY KEY (id);


--
-- Name: research_versions research_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_versions
    ADD CONSTRAINT research_versions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles_users roles_users_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.roles_users
    ADD CONSTRAINT roles_users_pkey PRIMARY KEY (id);


--
-- Name: snippets_snippets snippets_snippets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.snippets_snippets
    ADD CONSTRAINT snippets_snippets_pkey PRIMARY KEY (id);


--
-- Name: survey_questions survey_questions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_questions
    ADD CONSTRAINT survey_questions_pkey PRIMARY KEY (id);


--
-- Name: survey_responses survey_responses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_responses
    ADD CONSTRAINT survey_responses_pkey PRIMARY KEY (id);


--
-- Name: survey_surveys survey_surveys_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_surveys
    ADD CONSTRAINT survey_surveys_pkey PRIMARY KEY (id);


--
-- Name: system_api_logs system_api_logs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_api_logs
    ADD CONSTRAINT system_api_logs_pkey PRIMARY KEY (id);


--
-- Name: system_components system_components_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_components
    ADD CONSTRAINT system_components_pkey PRIMARY KEY (id);


--
-- Name: system_countries system_countries_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_countries
    ADD CONSTRAINT system_countries_pkey PRIMARY KEY (id);


--
-- Name: system_dashboard_components system_dashboard_components_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_dashboard_components
    ADD CONSTRAINT system_dashboard_components_pkey PRIMARY KEY (id);


--
-- Name: system_dashboards system_dashboards_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_dashboards
    ADD CONSTRAINT system_dashboards_pkey PRIMARY KEY (id);


--
-- Name: system_downloads system_downloads_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_downloads
    ADD CONSTRAINT system_downloads_pkey PRIMARY KEY (id);


--
-- Name: system_events system_events_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_events
    ADD CONSTRAINT system_events_pkey PRIMARY KEY (id);


--
-- Name: system_logs system_logs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_logs
    ADD CONSTRAINT system_logs_pkey PRIMARY KEY (id);


--
-- Name: system_messages system_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_messages
    ADD CONSTRAINT system_messages_pkey PRIMARY KEY (id);


--
-- Name: system_nag_definitions system_nag_definitions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_nag_definitions
    ADD CONSTRAINT system_nag_definitions_pkey PRIMARY KEY (id);


--
-- Name: system_online_reference_links system_online_reference_links_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_online_reference_links
    ADD CONSTRAINT system_online_reference_links_pkey PRIMARY KEY (id);


--
-- Name: system_templates system_templates_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_templates
    ADD CONSTRAINT system_templates_pkey PRIMARY KEY (id);


--
-- Name: system_user_feedback system_user_feedback_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_user_feedback
    ADD CONSTRAINT system_user_feedback_pkey PRIMARY KEY (id);


--
-- Name: system_versions system_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_versions
    ADD CONSTRAINT system_versions_pkey PRIMARY KEY (id);


--
-- Name: system_view_calls system_view_calls_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_view_calls
    ADD CONSTRAINT system_view_calls_pkey PRIMARY KEY (id);


--
-- Name: system_view_metadata system_view_metadata_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_view_metadata
    ADD CONSTRAINT system_view_metadata_pkey PRIMARY KEY (id);


--
-- Name: system_visits system_visits_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_visits
    ADD CONSTRAINT system_visits_pkey PRIMARY KEY (id);


--
-- Name: transplant_donations transplant_donations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donations
    ADD CONSTRAINT transplant_donations_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_followups transplant_donor_followups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_followups
    ADD CONSTRAINT transplant_donor_followups_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_operations transplant_donor_operations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_operations
    ADD CONSTRAINT transplant_donor_operations_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_stage_positions transplant_donor_stage_positions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stage_positions
    ADD CONSTRAINT transplant_donor_stage_positions_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_stage_statuses transplant_donor_stage_statuses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stage_statuses
    ADD CONSTRAINT transplant_donor_stage_statuses_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_stages transplant_donor_stages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stages
    ADD CONSTRAINT transplant_donor_stages_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_workups transplant_donor_workups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_workups
    ADD CONSTRAINT transplant_donor_workups_pkey PRIMARY KEY (id);


--
-- Name: transplant_failure_cause_description_groups transplant_failure_cause_description_groups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_failure_cause_description_groups
    ADD CONSTRAINT transplant_failure_cause_description_groups_pkey PRIMARY KEY (id);


--
-- Name: transplant_failure_cause_descriptions transplant_failure_cause_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_failure_cause_descriptions
    ADD CONSTRAINT transplant_failure_cause_descriptions_pkey PRIMARY KEY (id);


--
-- Name: transplant_induction_agents transplant_induction_agents_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_induction_agents
    ADD CONSTRAINT transplant_induction_agents_pkey PRIMARY KEY (id);


--
-- Name: transplant_investigation_types transplant_investigation_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_investigation_types
    ADD CONSTRAINT transplant_investigation_types_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_followups transplant_recipient_followups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_followups
    ADD CONSTRAINT transplant_recipient_followups_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_operations transplant_recipient_operations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_operations
    ADD CONSTRAINT transplant_recipient_operations_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_workups transplant_recipient_workups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_workups
    ADD CONSTRAINT transplant_recipient_workups_pkey PRIMARY KEY (id);


--
-- Name: transplant_registration_status_descriptions transplant_registration_status_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_status_descriptions
    ADD CONSTRAINT transplant_registration_status_descriptions_pkey PRIMARY KEY (id);


--
-- Name: transplant_registration_statuses transplant_registration_statuses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_statuses
    ADD CONSTRAINT transplant_registration_statuses_pkey PRIMARY KEY (id);


--
-- Name: transplant_registrations transplant_registrations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registrations
    ADD CONSTRAINT transplant_registrations_pkey PRIMARY KEY (id);


--
-- Name: transplant_rejection_episodes transplant_rejection_episodes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_episodes
    ADD CONSTRAINT transplant_rejection_episodes_pkey PRIMARY KEY (id);


--
-- Name: transplant_rejection_treatments transplant_rejection_treatments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_treatments
    ADD CONSTRAINT transplant_rejection_treatments_pkey PRIMARY KEY (id);


--
-- Name: transplant_versions transplant_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_versions
    ADD CONSTRAINT transplant_versions_pkey PRIMARY KEY (id);


--
-- Name: ukrdc_batches ukrdc_batches_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_batches
    ADD CONSTRAINT ukrdc_batches_pkey PRIMARY KEY (id);


--
-- Name: ukrdc_measurement_units ukrdc_measurement_units_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_measurement_units
    ADD CONSTRAINT ukrdc_measurement_units_pkey PRIMARY KEY (id);


--
-- Name: ukrdc_modality_codes ukrdc_modality_codes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_modality_codes
    ADD CONSTRAINT ukrdc_modality_codes_pkey PRIMARY KEY (id);


--
-- Name: ukrdc_transmission_logs ukrdc_transmission_logs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_transmission_logs
    ADD CONSTRAINT ukrdc_transmission_logs_pkey PRIMARY KEY (id);


--
-- Name: ukrdc_treatments ukrdc_treatments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT ukrdc_treatments_pkey PRIMARY KEY (id);


--
-- Name: user_group_memberships user_group_memberships_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_group_memberships
    ADD CONSTRAINT user_group_memberships_pkey PRIMARY KEY (id);


--
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: virology_profiles virology_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_profiles
    ADD CONSTRAINT virology_profiles_pkey PRIMARY KEY (id);


--
-- Name: virology_vaccination_types virology_vaccination_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_vaccination_types
    ADD CONSTRAINT virology_vaccination_types_pkey PRIMARY KEY (id);


--
-- Name: virology_versions virology_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_versions
    ADD CONSTRAINT virology_versions_pkey PRIMARY KEY (id);


--
-- Name: solid_cache_entries solid_cache_entries_pkey; Type: CONSTRAINT; Schema: renalware_demo; Owner: -
--

ALTER TABLE ONLY renalware_demo.solid_cache_entries
    ADD CONSTRAINT solid_cache_entries_pkey PRIMARY KEY (id);


--
-- Name: access_plan_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX access_plan_uniqueness ON renalware.access_plans USING btree (patient_id, COALESCE(terminated_at, '1970-01-01 00:00:00'::timestamp without time zone));


--
-- Name: access_procedure_pd_catheter_tech_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX access_procedure_pd_catheter_tech_idx ON renalware.access_procedures USING btree (pd_catheter_insertion_technique_id);


--
-- Name: access_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX access_versions_type_id ON renalware.access_versions USING btree (item_type, item_id);


--
-- Name: clinic_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX clinic_versions_type_id ON renalware.clinic_versions USING btree (item_type, item_id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX delayed_jobs_priority ON renalware.delayed_jobs USING btree (priority, run_at);


--
-- Name: hd_diary_slots_unique_by_day_period_patient; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX hd_diary_slots_unique_by_day_period_patient ON renalware.hd_diary_slots USING btree (diary_id, day_of_week, diurnal_period_code_id, patient_id) WHERE (deleted_at IS NULL);


--
-- Name: hd_diary_slots_unique_by_station_day_period; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX hd_diary_slots_unique_by_station_day_period ON renalware.hd_diary_slots USING btree (diary_id, station_id, day_of_week, diurnal_period_code_id) WHERE (deleted_at IS NULL);


--
-- Name: hd_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX hd_versions_type_id ON renalware.hd_versions USING btree (item_type, item_id);


--
-- Name: idx_dashboard_component_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_dashboard_component_position ON renalware.system_dashboard_components USING btree (dashboard_id, "position");


--
-- Name: INDEX idx_dashboard_component_position; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.idx_dashboard_component_position IS 'Position must be unique within a dashboard';


--
-- Name: idx_dashboard_component_useage_unique; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_dashboard_component_useage_unique ON renalware.system_dashboard_components USING btree (dashboard_id, component_id);


--
-- Name: INDEX idx_dashboard_component_useage_unique; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.idx_dashboard_component_useage_unique IS 'Allow only one instance of a component on any dashboard';


--
-- Name: idx_death_locations_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_death_locations_name ON renalware.death_locations USING btree (TRIM(BOTH FROM lower((name)::text))) WHERE (deleted_at IS NULL);


--
-- Name: idx_hd_session_pgds_pgd_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_hd_session_pgds_pgd_id ON renalware.hd_session_patient_group_directions USING btree (patient_group_direction_id);


--
-- Name: idx_hd_session_pgds_session_pgd; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_hd_session_pgds_session_pgd ON renalware.hd_session_patient_group_directions USING btree (session_id, patient_group_direction_id);


--
-- Name: idx_infection_organisms; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_infection_organisms ON renalware.pd_infection_organisms USING btree (organism_code_id, infectable_id, infectable_type);


--
-- Name: idx_infection_organisms_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_infection_organisms_type ON renalware.pd_infection_organisms USING btree (infectable_id, infectable_type);


--
-- Name: idx_medication_delivery_event_prescriptions; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_medication_delivery_event_prescriptions ON renalware.medication_delivery_event_prescriptions USING btree (event_id, prescription_id);


--
-- Name: idx_medication_prescriptions_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_medication_prescriptions_type ON renalware.medication_prescriptions USING btree (treatable_id, treatable_type);


--
-- Name: idx_mp_patient_id_medication_route_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_mp_patient_id_medication_route_id ON renalware.medication_prescriptions USING btree (patient_id, medication_route_id);


--
-- Name: idx_on_code_local_authority_district_id_fe2b0c7d98; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_on_code_local_authority_district_id_fe2b0c7d98 ON renalware.geography_middle_super_output_areas USING btree (code, local_authority_district_id);


--
-- Name: idx_on_local_authority_district_id_103e1854df; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_on_local_authority_district_id_103e1854df ON renalware.geography_middle_super_output_areas USING btree (local_authority_district_id);


--
-- Name: idx_on_middle_super_output_area_id_b9987db7f1; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_on_middle_super_output_area_id_b9987db7f1 ON renalware.geography_lower_super_output_areas USING btree (middle_super_output_area_id);


--
-- Name: idx_on_study_id_external_reference_a07278c0eb; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_on_study_id_external_reference_a07278c0eb ON renalware.research_participations USING btree (study_id, external_reference) WHERE ((deleted_at IS NULL) AND ((COALESCE(external_reference, ''::character varying))::text <> ''::text));


--
-- Name: idx_path_cst_obx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_path_cst_obx ON renalware.pathology_chart_series USING btree (observation_description_id);


--
-- Name: idx_patients_on_lower_family_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_patients_on_lower_family_name ON renalware.patients USING btree (lower((family_name)::text), given_name);


--
-- Name: idx_practice_membership; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_practice_membership ON renalware.patient_practice_memberships USING btree (practice_id, primary_care_physician_id);


--
-- Name: idx_system_view_calls_all; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_system_view_calls_all ON renalware.system_view_calls USING btree (view_metadata_id, user_id, called_at);


--
-- Name: idx_unique_diaryslot_patients; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_unique_diaryslot_patients ON renalware.hd_diary_slots USING btree (diary_id, diurnal_period_code_id, day_of_week, patient_id);


--
-- Name: idx_unread_messaging_receipts; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_unread_messaging_receipts ON renalware.messaging_receipts USING btree (recipient_id) WHERE (read_at IS NULL);


--
-- Name: index_access_assessments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_created_by_id ON renalware.access_assessments USING btree (created_by_id);


--
-- Name: index_access_assessments_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_document ON renalware.access_assessments USING gin (document);


--
-- Name: index_access_assessments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_patient_id ON renalware.access_assessments USING btree (patient_id);


--
-- Name: index_access_assessments_on_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_type_id ON renalware.access_assessments USING btree (type_id);


--
-- Name: index_access_assessments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_updated_by_id ON renalware.access_assessments USING btree (updated_by_id);


--
-- Name: index_access_needling_assessments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_needling_assessments_on_created_by_id ON renalware.access_needling_assessments USING btree (created_by_id);


--
-- Name: index_access_needling_assessments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_needling_assessments_on_patient_id ON renalware.access_needling_assessments USING btree (patient_id);


--
-- Name: index_access_needling_assessments_on_patient_id_and_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_needling_assessments_on_patient_id_and_created_at ON renalware.access_needling_assessments USING btree (patient_id, created_at);


--
-- Name: index_access_needling_assessments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_needling_assessments_on_updated_by_id ON renalware.access_needling_assessments USING btree (updated_by_id);


--
-- Name: index_access_plan_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plan_types_on_deleted_at ON renalware.access_plan_types USING btree (deleted_at);


--
-- Name: index_access_plan_types_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plan_types_on_position ON renalware.access_plan_types USING btree ("position");


--
-- Name: index_access_plans_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_created_by_id ON renalware.access_plans USING btree (created_by_id);


--
-- Name: index_access_plans_on_decided_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_decided_by_id ON renalware.access_plans USING btree (decided_by_id);


--
-- Name: index_access_plans_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_patient_id ON renalware.access_plans USING btree (patient_id);


--
-- Name: index_access_plans_on_plan_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_plan_type_id ON renalware.access_plans USING btree (plan_type_id);


--
-- Name: index_access_plans_on_terminated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_terminated_at ON renalware.access_plans USING btree (terminated_at);


--
-- Name: index_access_plans_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_updated_by_id ON renalware.access_plans USING btree (updated_by_id);


--
-- Name: index_access_procedures_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_created_by_id ON renalware.access_procedures USING btree (created_by_id);


--
-- Name: index_access_procedures_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_patient_id ON renalware.access_procedures USING btree (patient_id);


--
-- Name: index_access_procedures_on_performed_by; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_performed_by ON renalware.access_procedures USING btree (performed_by);


--
-- Name: index_access_procedures_on_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_type_id ON renalware.access_procedures USING btree (type_id);


--
-- Name: index_access_procedures_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_updated_by_id ON renalware.access_procedures USING btree (updated_by_id);


--
-- Name: index_access_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_created_by_id ON renalware.access_profiles USING btree (created_by_id);


--
-- Name: index_access_profiles_on_decided_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_decided_by_id ON renalware.access_profiles USING btree (decided_by_id);


--
-- Name: index_access_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_patient_id ON renalware.access_profiles USING btree (patient_id);


--
-- Name: index_access_profiles_on_started_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_started_on ON renalware.access_profiles USING btree (started_on);


--
-- Name: index_access_profiles_on_terminated_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_terminated_on ON renalware.access_profiles USING btree (terminated_on);


--
-- Name: index_access_profiles_on_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_type_id ON renalware.access_profiles USING btree (type_id);


--
-- Name: index_access_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_updated_by_id ON renalware.access_profiles USING btree (updated_by_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON renalware.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON renalware.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON renalware.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON renalware.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_activesupport_cache_entries_on_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_activesupport_cache_entries_on_created_at ON renalware.activesupport_cache_entries USING btree (created_at);


--
-- Name: index_activesupport_cache_entries_on_expires_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_activesupport_cache_entries_on_expires_at ON renalware.activesupport_cache_entries USING btree (expires_at);


--
-- Name: index_activesupport_cache_entries_on_version; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_activesupport_cache_entries_on_version ON renalware.activesupport_cache_entries USING btree (version);


--
-- Name: index_addresses_on_addressable_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_addresses_on_addressable_id ON renalware.addresses USING btree (addressable_id);


--
-- Name: index_addresses_on_addressable_type_and_addressable_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_addresses_on_addressable_type_and_addressable_id ON renalware.addresses USING btree (addressable_type, addressable_id);


--
-- Name: index_addresses_on_country_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_addresses_on_country_id ON renalware.addresses USING btree (country_id);


--
-- Name: index_admission_admissions_on_admitted_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_admitted_on ON renalware.admission_admissions USING btree (admitted_on);


--
-- Name: index_admission_admissions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_created_by_id ON renalware.admission_admissions USING btree (created_by_id);


--
-- Name: index_admission_admissions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_deleted_at ON renalware.admission_admissions USING btree (deleted_at);


--
-- Name: index_admission_admissions_on_discharged_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_discharged_on ON renalware.admission_admissions USING btree (discharged_on);


--
-- Name: index_admission_admissions_on_hospital_ward_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_hospital_ward_id ON renalware.admission_admissions USING btree (hospital_ward_id);


--
-- Name: index_admission_admissions_on_modality_at_admission_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_modality_at_admission_id ON renalware.admission_admissions USING btree (modality_at_admission_id);


--
-- Name: index_admission_admissions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_patient_id ON renalware.admission_admissions USING btree (patient_id);


--
-- Name: index_admission_admissions_on_summarised_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_summarised_by_id ON renalware.admission_admissions USING btree (summarised_by_id);


--
-- Name: index_admission_admissions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_updated_by_id ON renalware.admission_admissions USING btree (updated_by_id);


--
-- Name: index_admission_consult_sites_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consult_sites_on_name ON renalware.admission_consult_sites USING btree (name);


--
-- Name: index_admission_consults_on_consult_site_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_consult_site_id ON renalware.admission_consults USING btree (consult_site_id);


--
-- Name: index_admission_consults_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_created_by_id ON renalware.admission_consults USING btree (created_by_id);


--
-- Name: index_admission_consults_on_hospital_ward_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_hospital_ward_id ON renalware.admission_consults USING btree (hospital_ward_id);


--
-- Name: index_admission_consults_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_patient_id ON renalware.admission_consults USING btree (patient_id);


--
-- Name: index_admission_consults_on_priority; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_priority ON renalware.admission_consults USING btree (priority);


--
-- Name: index_admission_consults_on_seen_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_seen_by_id ON renalware.admission_consults USING btree (seen_by_id);


--
-- Name: index_admission_consults_on_specialty_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_specialty_id ON renalware.admission_consults USING btree (specialty_id);


--
-- Name: index_admission_consults_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_updated_by_id ON renalware.admission_consults USING btree (updated_by_id);


--
-- Name: index_admission_request_reasons_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_request_reasons_on_deleted_at ON renalware.admission_request_reasons USING btree (deleted_at);


--
-- Name: index_admission_requests_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_created_by_id ON renalware.admission_requests USING btree (created_by_id);


--
-- Name: index_admission_requests_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_deleted_at ON renalware.admission_requests USING btree (deleted_at);


--
-- Name: index_admission_requests_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_hospital_unit_id ON renalware.admission_requests USING btree (hospital_unit_id);


--
-- Name: index_admission_requests_on_patient_id_and_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_admission_requests_on_patient_id_and_deleted_at ON renalware.admission_requests USING btree (patient_id, deleted_at);


--
-- Name: index_admission_requests_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_position ON renalware.admission_requests USING btree ("position");


--
-- Name: index_admission_requests_on_reason_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_reason_id ON renalware.admission_requests USING btree (reason_id);


--
-- Name: index_admission_requests_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_updated_by_id ON renalware.admission_requests USING btree (updated_by_id);


--
-- Name: index_admission_specialties_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_admission_specialties_on_name ON renalware.admission_specialties USING btree (name);


--
-- Name: index_clinic_appointments_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_clinic_id ON renalware.clinic_appointments USING btree (clinic_id);


--
-- Name: index_clinic_appointments_on_consultant_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_consultant_id ON renalware.clinic_appointments USING btree (consultant_id);


--
-- Name: index_clinic_appointments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_created_by_id ON renalware.clinic_appointments USING btree (created_by_id);


--
-- Name: index_clinic_appointments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_patient_id ON renalware.clinic_appointments USING btree (patient_id);


--
-- Name: index_clinic_appointments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_updated_by_id ON renalware.clinic_appointments USING btree (updated_by_id);


--
-- Name: index_clinic_appointments_on_visit_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_visit_number ON renalware.clinic_appointments USING btree (visit_number);


--
-- Name: index_clinic_clinics_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_clinic_clinics_on_code ON renalware.clinic_clinics USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: index_clinic_clinics_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_clinics_on_created_by_id ON renalware.clinic_clinics USING btree (created_by_id);


--
-- Name: index_clinic_clinics_on_default_modality_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_clinics_on_default_modality_description_id ON renalware.clinic_clinics USING btree (default_modality_description_id);


--
-- Name: index_clinic_clinics_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_clinics_on_deleted_at ON renalware.clinic_clinics USING btree (deleted_at);


--
-- Name: index_clinic_clinics_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_clinics_on_updated_by_id ON renalware.clinic_clinics USING btree (updated_by_id);


--
-- Name: index_clinic_clinics_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_clinics_on_user_id ON renalware.clinic_clinics USING btree (user_id);


--
-- Name: index_clinic_consultants_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_clinic_consultants_on_code ON renalware.clinic_consultants USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: index_clinic_consultants_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_consultants_on_created_by_id ON renalware.clinic_consultants USING btree (created_by_id);


--
-- Name: index_clinic_consultants_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_consultants_on_deleted_at ON renalware.clinic_consultants USING btree (deleted_at);


--
-- Name: index_clinic_consultants_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_clinic_consultants_on_name ON renalware.clinic_consultants USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: index_clinic_consultants_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_consultants_on_updated_by_id ON renalware.clinic_consultants USING btree (updated_by_id);


--
-- Name: index_clinic_visit_locations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visit_locations_on_created_by_id ON renalware.clinic_visit_locations USING btree (created_by_id);


--
-- Name: index_clinic_visit_locations_on_default_location; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_clinic_visit_locations_on_default_location ON renalware.clinic_visit_locations USING btree (default_location) WHERE ((default_location = true) AND (deleted_at IS NULL));


--
-- Name: index_clinic_visit_locations_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visit_locations_on_deleted_at ON renalware.clinic_visit_locations USING btree (deleted_at);


--
-- Name: index_clinic_visit_locations_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_clinic_visit_locations_on_name ON renalware.clinic_visit_locations USING btree (name);


--
-- Name: index_clinic_visit_locations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visit_locations_on_updated_by_id ON renalware.clinic_visit_locations USING btree (updated_by_id);


--
-- Name: index_clinic_visits_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_clinic_id ON renalware.clinic_visits USING btree (clinic_id);


--
-- Name: index_clinic_visits_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_created_by_id ON renalware.clinic_visits USING btree (created_by_id);


--
-- Name: index_clinic_visits_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_document ON renalware.clinic_visits USING gin (document);


--
-- Name: index_clinic_visits_on_location_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_location_id ON renalware.clinic_visits USING btree (location_id);


--
-- Name: index_clinic_visits_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_patient_id ON renalware.clinic_visits USING btree (patient_id);


--
-- Name: index_clinic_visits_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_type ON renalware.clinic_visits USING btree (type);


--
-- Name: index_clinic_visits_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_updated_by_id ON renalware.clinic_visits USING btree (updated_by_id);


--
-- Name: index_clinical_allergies_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_created_by_id ON renalware.clinical_allergies USING btree (created_by_id);


--
-- Name: index_clinical_allergies_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_deleted_at ON renalware.clinical_allergies USING btree (deleted_at);


--
-- Name: index_clinical_allergies_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_patient_id ON renalware.clinical_allergies USING btree (patient_id);


--
-- Name: index_clinical_allergies_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_updated_by_id ON renalware.clinical_allergies USING btree (updated_by_id);


--
-- Name: index_clinical_body_compositions_on_assessor_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_assessor_id ON renalware.clinical_body_compositions USING btree (assessor_id);


--
-- Name: index_clinical_body_compositions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_created_by_id ON renalware.clinical_body_compositions USING btree (created_by_id);


--
-- Name: index_clinical_body_compositions_on_modality_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_modality_description_id ON renalware.clinical_body_compositions USING btree (modality_description_id);


--
-- Name: index_clinical_body_compositions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_patient_id ON renalware.clinical_body_compositions USING btree (patient_id);


--
-- Name: index_clinical_body_compositions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_updated_by_id ON renalware.clinical_body_compositions USING btree (updated_by_id);


--
-- Name: index_clinical_dry_weights_on_assessor_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_assessor_id ON renalware.clinical_dry_weights USING btree (assessor_id);


--
-- Name: index_clinical_dry_weights_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_created_by_id ON renalware.clinical_dry_weights USING btree (created_by_id);


--
-- Name: index_clinical_dry_weights_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_patient_id ON renalware.clinical_dry_weights USING btree (patient_id);


--
-- Name: index_clinical_dry_weights_on_patient_id_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_patient_id_created_at ON renalware.clinical_dry_weights USING btree (patient_id, created_at DESC);


--
-- Name: INDEX index_clinical_dry_weights_on_patient_id_created_at; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_clinical_dry_weights_on_patient_id_created_at IS 'Ordered index to speed up latest dry weight queries';


--
-- Name: index_clinical_dry_weights_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_updated_by_id ON renalware.clinical_dry_weights USING btree (updated_by_id);


--
-- Name: index_clinical_igan_risks_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_igan_risks_on_created_by_id ON renalware.clinical_igan_risks USING btree (created_by_id);


--
-- Name: index_clinical_igan_risks_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_igan_risks_on_patient_id ON renalware.clinical_igan_risks USING btree (patient_id);


--
-- Name: index_clinical_igan_risks_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_igan_risks_on_updated_by_id ON renalware.clinical_igan_risks USING btree (updated_by_id);


--
-- Name: index_clinical_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_versions_on_item_type_and_item_id ON renalware.clinical_versions USING btree (item_type, item_id);


--
-- Name: index_death_causes_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_death_causes_on_code ON renalware.death_causes USING btree (code);


--
-- Name: index_death_locations_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_death_locations_on_deleted_at ON renalware.death_locations USING btree (deleted_at);


--
-- Name: index_directory_people_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_directory_people_on_created_by_id ON renalware.directory_people USING btree (created_by_id);


--
-- Name: index_directory_people_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_directory_people_on_updated_by_id ON renalware.directory_people USING btree (updated_by_id);


--
-- Name: index_drug_dmd_actual_medical_products_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_dmd_actual_medical_products_on_code ON renalware.drug_dmd_actual_medical_products USING btree (code);


--
-- Name: index_drug_dmd_matches_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_dmd_matches_on_drug_id ON renalware.drug_dmd_matches USING btree (drug_id);


--
-- Name: index_drug_dmd_virtual_medical_products_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_dmd_virtual_medical_products_on_code ON renalware.drug_dmd_virtual_medical_products USING btree (code);


--
-- Name: index_drug_dmd_vtm_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_dmd_vtm_on_code ON renalware.drug_dmd_virtual_therapeutic_moieties USING btree (code);


--
-- Name: index_drug_forms_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_forms_on_code ON renalware.drug_forms USING btree (code);


--
-- Name: index_drug_frequencies_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_frequencies_on_name ON renalware.drug_frequencies USING btree (name);


--
-- Name: index_drug_frequencies_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_frequencies_on_position ON renalware.drug_frequencies USING btree ("position");


--
-- Name: index_drug_homecare_forms_on_drug_type_id_and_supplier_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_homecare_forms_on_drug_type_id_and_supplier_id ON renalware.drug_homecare_forms USING btree (drug_type_id, supplier_id);


--
-- Name: INDEX index_drug_homecare_forms_on_drug_type_id_and_supplier_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_drug_homecare_forms_on_drug_type_id_and_supplier_id IS 'A supplier can only have one form active for any drug type';


--
-- Name: index_drug_homecare_forms_on_supplier_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_homecare_forms_on_supplier_id ON renalware.drug_homecare_forms USING btree (supplier_id);


--
-- Name: index_drug_patient_group_directions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_patient_group_directions_on_code ON renalware.drug_patient_group_directions USING btree (code) WHERE ((ends_on IS NULL) AND (deleted_at IS NULL));


--
-- Name: index_drug_prescribable_drugs_on_compound_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_prescribable_drugs_on_compound_id ON renalware.drug_prescribable_drugs USING btree (compound_id);


--
-- Name: INDEX index_drug_prescribable_drugs_on_compound_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_drug_prescribable_drugs_on_compound_id IS 'Unique idx on this materialized view enables us to refresh concurrently';


--
-- Name: index_drug_prescribable_drugs_on_compound_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_prescribable_drugs_on_compound_name ON renalware.drug_prescribable_drugs USING gist (compound_name renalware.gist_trgm_ops);


--
-- Name: index_drug_prescribable_drugs_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_prescribable_drugs_on_drug_id ON renalware.drug_prescribable_drugs USING btree (drug_id);


--
-- Name: index_drug_trade_families_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_trade_families_on_code ON renalware.drug_trade_families USING btree (code);


--
-- Name: index_drug_trade_family_class_on_drug_id_and_trade_family; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_trade_family_class_on_drug_id_and_trade_family ON renalware.drug_trade_family_classifications USING btree (drug_id, trade_family_id);


--
-- Name: index_drug_trade_family_classifications_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_trade_family_classifications_on_drug_id ON renalware.drug_trade_family_classifications USING btree (drug_id);


--
-- Name: index_drug_trade_family_classifications_on_trade_family_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_trade_family_classifications_on_trade_family_id ON renalware.drug_trade_family_classifications USING btree (trade_family_id);


--
-- Name: index_drug_types_drugs_on_drug_id_and_drug_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_types_drugs_on_drug_id_and_drug_type_id ON renalware.drug_types_drugs USING btree (drug_id, drug_type_id);


--
-- Name: index_drug_types_drugs_on_drug_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_types_drugs_on_drug_type_id ON renalware.drug_types_drugs USING btree (drug_type_id);


--
-- Name: index_drug_types_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_types_on_code ON renalware.drug_types USING btree (code);


--
-- Name: index_drug_types_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_types_on_name ON renalware.drug_types USING btree (name);


--
-- Name: index_drug_unit_of_measures_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_unit_of_measures_on_code ON renalware.drug_unit_of_measures USING btree (code);


--
-- Name: index_drug_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_versions_on_item_type_and_item_id ON renalware.drug_versions USING btree (item_type, item_id);


--
-- Name: index_drug_vmp_classifications_on_active_ing_st_num_uom_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_vmp_classifications_on_active_ing_st_num_uom_id ON renalware.drug_vmp_classifications USING btree (active_ingredient_strength_numerator_uom_id);


--
-- Name: index_drug_vmp_classifications_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_vmp_classifications_on_code ON renalware.drug_vmp_classifications USING btree (code);


--
-- Name: index_drug_vmp_classifications_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_vmp_classifications_on_drug_id ON renalware.drug_vmp_classifications USING btree (drug_id);


--
-- Name: index_drug_vmp_classifications_on_form_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_vmp_classifications_on_form_id ON renalware.drug_vmp_classifications USING btree (form_id);


--
-- Name: index_drug_vmp_classifications_on_route_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_vmp_classifications_on_route_id ON renalware.drug_vmp_classifications USING btree (route_id);


--
-- Name: index_drug_vmp_classifications_on_unit_dose_form_size_uom_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_vmp_classifications_on_unit_dose_form_size_uom_id ON renalware.drug_vmp_classifications USING btree (unit_dose_form_size_uom_id);


--
-- Name: index_drug_vmp_classifications_on_unit_dose_uom_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_vmp_classifications_on_unit_dose_uom_id ON renalware.drug_vmp_classifications USING btree (unit_dose_uom_id);


--
-- Name: index_drug_vmp_classifications_on_unit_of_measure_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_vmp_classifications_on_unit_of_measure_id ON renalware.drug_vmp_classifications USING btree (unit_of_measure_id);


--
-- Name: index_drugs_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drugs_on_code ON renalware.drugs USING btree (code);


--
-- Name: index_drugs_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drugs_on_deleted_at ON renalware.drugs USING btree (deleted_at);


--
-- Name: index_event_categories_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_categories_on_deleted_at ON renalware.event_categories USING btree (deleted_at);


--
-- Name: index_event_categories_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_event_categories_on_name ON renalware.event_categories USING btree (name);


--
-- Name: index_event_subtypes_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_subtypes_on_created_by_id ON renalware.event_subtypes USING btree (created_by_id);


--
-- Name: index_event_subtypes_on_deactivated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_subtypes_on_deactivated_at ON renalware.event_subtypes USING btree (deactivated_at);


--
-- Name: index_event_subtypes_on_event_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_subtypes_on_event_type_id ON renalware.event_subtypes USING btree (event_type_id);


--
-- Name: index_event_subtypes_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_subtypes_on_updated_by_id ON renalware.event_subtypes USING btree (updated_by_id);


--
-- Name: index_event_type_alert_triggers_on_event_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_type_alert_triggers_on_event_type_id ON renalware.event_type_alert_triggers USING btree (event_type_id);


--
-- Name: index_event_types_on_category_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_types_on_category_id ON renalware.event_types USING btree (category_id);


--
-- Name: index_event_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_types_on_deleted_at ON renalware.event_types USING btree (deleted_at);


--
-- Name: index_event_types_on_hidden; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_types_on_hidden ON renalware.event_types USING btree (hidden);


--
-- Name: index_event_types_on_slug; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_event_types_on_slug ON renalware.event_types USING btree (slug);


--
-- Name: index_event_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_versions_on_item_type_and_item_id ON renalware.event_versions USING btree (item_type, item_id);


--
-- Name: index_events_on_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_created_at ON renalware.events USING btree (created_at DESC);


--
-- Name: index_events_on_created_at_as_date; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_created_at_as_date ON renalware.events USING btree (date(created_at) DESC NULLS LAST);


--
-- Name: index_events_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_created_by_id ON renalware.events USING btree (created_by_id);


--
-- Name: index_events_on_date_time_desc_nulls_last; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_date_time_desc_nulls_last ON renalware.events USING btree (date_time DESC NULLS LAST);


--
-- Name: index_events_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_deleted_at ON renalware.events USING btree (deleted_at);


--
-- Name: index_events_on_event_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_event_type_id ON renalware.events USING btree (event_type_id);


--
-- Name: index_events_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_patient_id ON renalware.events USING btree (patient_id);


--
-- Name: index_events_on_patient_id_not_deleted; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_patient_id_not_deleted ON renalware.events USING btree (patient_id, deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: INDEX index_events_on_patient_id_not_deleted; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_events_on_patient_id_not_deleted IS 'conditional index to speed up count()ing a patient''s undeleted events';


--
-- Name: index_events_on_subtype_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_subtype_id ON renalware.events USING btree (subtype_id);


--
-- Name: index_events_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_type ON renalware.events USING btree (type);


--
-- Name: index_events_on_updated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_updated_at ON renalware.events USING btree (updated_at DESC);


--
-- Name: index_events_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_updated_by_id ON renalware.events USING btree (updated_by_id);


--
-- Name: index_feed_file_types_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_file_types_on_name ON renalware.feed_file_types USING btree (name);


--
-- Name: index_feed_files_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_files_on_created_by_id ON renalware.feed_files USING btree (created_by_id);


--
-- Name: index_feed_files_on_file_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_files_on_file_type_id ON renalware.feed_files USING btree (file_type_id);


--
-- Name: index_feed_files_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_files_on_updated_by_id ON renalware.feed_files USING btree (updated_by_id);


--
-- Name: index_feed_gps_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_feed_gps_on_code ON renalware.feed_gps USING btree (code);


--
-- Name: index_feed_hl7_test_messages_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_hl7_test_messages_on_name ON renalware.feed_hl7_test_messages USING btree (name);


--
-- Name: index_feed_logs_on_log_reason; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_logs_on_log_reason ON renalware.feed_logs USING btree (log_reason);


--
-- Name: index_feed_logs_on_log_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_logs_on_log_type ON renalware.feed_logs USING btree (log_type);


--
-- Name: index_feed_logs_on_message_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_logs_on_message_id ON renalware.feed_logs USING btree (message_id);


--
-- Name: index_feed_logs_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_logs_on_patient_id ON renalware.feed_logs USING btree (patient_id);


--
-- Name: index_feed_message_replays_on_message_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_message_replays_on_message_id ON renalware.feed_message_replays USING btree (message_id);


--
-- Name: index_feed_message_replays_on_replay_request_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_message_replays_on_replay_request_id ON renalware.feed_message_replays USING btree (replay_request_id);


--
-- Name: index_feed_message_replays_on_urn; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_message_replays_on_urn ON renalware.feed_message_replays USING btree (urn);


--
-- Name: index_feed_messages_created_at_nonauto; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_created_at_nonauto ON renalware.feed_messages USING btree (created_at DESC);


--
-- Name: index_feed_messages_on_body_hash; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_feed_messages_on_body_hash ON renalware.feed_messages USING btree (body_hash);


--
-- Name: index_feed_messages_on_dob; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_dob ON renalware.feed_messages USING btree (dob);


--
-- Name: index_feed_messages_on_local_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_local_patient_id ON renalware.feed_messages USING btree (local_patient_id);


--
-- Name: index_feed_messages_on_local_patient_id_2; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_local_patient_id_2 ON renalware.feed_messages USING btree (local_patient_id_2);


--
-- Name: index_feed_messages_on_local_patient_id_3; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_local_patient_id_3 ON renalware.feed_messages USING btree (local_patient_id_3);


--
-- Name: index_feed_messages_on_local_patient_id_4; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_local_patient_id_4 ON renalware.feed_messages USING btree (local_patient_id_4);


--
-- Name: index_feed_messages_on_local_patient_id_5; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_local_patient_id_5 ON renalware.feed_messages USING btree (local_patient_id_5);


--
-- Name: index_feed_messages_on_message_type_event_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_message_type_event_type ON renalware.feed_messages USING btree (message_type, event_type);


--
-- Name: index_feed_messages_on_nhs_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_nhs_number ON renalware.feed_messages USING btree (nhs_number);


--
-- Name: index_feed_messages_on_orc_filler_order_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_orc_filler_order_number ON renalware.feed_messages USING btree (orc_filler_order_number);


--
-- Name: index_feed_messages_on_patient_identifiers; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_patient_identifiers ON renalware.feed_messages USING gin (patient_identifiers);


--
-- Name: index_feed_messages_on_sent_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_sent_at ON renalware.feed_messages USING btree (sent_at);


--
-- Name: index_feed_outgoing_documents_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_outgoing_documents_on_created_by_id ON renalware.feed_outgoing_documents USING btree (created_by_id);


--
-- Name: index_feed_outgoing_documents_on_external_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_feed_outgoing_documents_on_external_uuid ON renalware.feed_outgoing_documents USING btree (external_uuid);


--
-- Name: index_feed_outgoing_documents_on_renderable; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_outgoing_documents_on_renderable ON renalware.feed_outgoing_documents USING btree (renderable_type, renderable_id);


--
-- Name: index_feed_outgoing_documents_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_outgoing_documents_on_updated_by_id ON renalware.feed_outgoing_documents USING btree (updated_by_id);


--
-- Name: index_feed_raw_hl7_messages_on_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_raw_hl7_messages_on_created_at ON renalware.feed_raw_hl7_messages USING btree (created_at);


--
-- Name: INDEX index_feed_raw_hl7_messages_on_created_at; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_feed_raw_hl7_messages_on_created_at IS 'We query for rows ordering by created_at asc to give us a chance to process in FIFO order, so having an ordered index means when we use a LIMIT (batching) in the query, rows will be determined by index scan without having to look to the end of the table - or something like that! In fact the index is implicitly ordered already but having created_at: :asc here makes our intention more explicit.';


--
-- Name: index_feed_replay_requests_on_criteria; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_replay_requests_on_criteria ON renalware.feed_replay_requests USING gin (criteria);


--
-- Name: index_feed_replay_requests_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_replay_requests_on_patient_id ON renalware.feed_replay_requests USING btree (patient_id);


--
-- Name: index_feed_sausage_queue_on_feed_sausage_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_sausage_queue_on_feed_sausage_id ON renalware.feed_sausage_queue USING btree (feed_sausage_id);


--
-- Name: index_feed_sausages_on_orc_filler_order_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_feed_sausages_on_orc_filler_order_number ON renalware.feed_sausages USING btree (orc_filler_order_number) WHERE ((orc_filler_order_number IS NOT NULL) AND ((orc_filler_order_number)::text <> ''::text));


--
-- Name: index_feed_sausages_on_sent_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_sausages_on_sent_at ON renalware.feed_sausages USING btree (sent_at);


--
-- Name: index_geography_local_authority_districts_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_geography_local_authority_districts_on_code ON renalware.geography_local_authority_districts USING btree (code);


--
-- Name: index_geography_local_authority_districts_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_geography_local_authority_districts_on_name ON renalware.geography_local_authority_districts USING btree (name);


--
-- Name: index_geography_lower_super_output_areas_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_geography_lower_super_output_areas_on_code ON renalware.geography_lower_super_output_areas USING btree (code);


--
-- Name: index_geography_middle_super_output_areas_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_geography_middle_super_output_areas_on_code ON renalware.geography_middle_super_output_areas USING btree (code);


--
-- Name: index_geography_middle_super_output_areas_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_geography_middle_super_output_areas_on_name ON renalware.geography_middle_super_output_areas USING btree (name);


--
-- Name: index_geography_output_areas_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_geography_output_areas_on_code ON renalware.geography_output_areas USING btree (code);


--
-- Name: index_geography_output_areas_on_lower_super_output_area_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_geography_output_areas_on_lower_super_output_area_id ON renalware.geography_output_areas USING btree (lower_super_output_area_id);


--
-- Name: index_geography_postcodes_on_lower_super_output_area_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_geography_postcodes_on_lower_super_output_area_id ON renalware.geography_postcodes USING btree (lower_super_output_area_id);


--
-- Name: index_geography_postcodes_on_postal_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_geography_postcodes_on_postal_code ON renalware.geography_postcodes USING btree (postal_code);


--
-- Name: index_good_job_executions_on_active_job_id_and_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_job_executions_on_active_job_id_and_created_at ON renalware.good_job_executions USING btree (active_job_id, created_at);


--
-- Name: index_good_job_executions_on_process_id_and_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_job_executions_on_process_id_and_created_at ON renalware.good_job_executions USING btree (process_id, created_at);


--
-- Name: index_good_job_jobs_for_candidate_lookup; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_job_jobs_for_candidate_lookup ON renalware.good_jobs USING btree (priority, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_job_settings_on_key; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_good_job_settings_on_key ON renalware.good_job_settings USING btree (key);


--
-- Name: index_good_jobs_jobs_on_finished_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_finished_at ON renalware.good_jobs USING btree (finished_at) WHERE ((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL));


--
-- Name: index_good_jobs_jobs_on_priority_created_at_when_unfinished; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_priority_created_at_when_unfinished ON renalware.good_jobs USING btree (priority DESC NULLS LAST, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_active_job_id_and_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON renalware.good_jobs USING btree (active_job_id, created_at);


--
-- Name: index_good_jobs_on_batch_callback_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_callback_id ON renalware.good_jobs USING btree (batch_callback_id) WHERE (batch_callback_id IS NOT NULL);


--
-- Name: index_good_jobs_on_batch_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_id ON renalware.good_jobs USING btree (batch_id) WHERE (batch_id IS NOT NULL);


--
-- Name: index_good_jobs_on_concurrency_key_when_unfinished; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON renalware.good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_cron_key_and_created_at_cond; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at_cond ON renalware.good_jobs USING btree (cron_key, created_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_cron_key_and_cron_at_cond; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at_cond ON renalware.good_jobs USING btree (cron_key, cron_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_labels; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_labels ON renalware.good_jobs USING gin (labels) WHERE (labels IS NOT NULL);


--
-- Name: index_good_jobs_on_locked_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_locked_by_id ON renalware.good_jobs USING btree (locked_by_id) WHERE (locked_by_id IS NOT NULL);


--
-- Name: index_good_jobs_on_priority_scheduled_at_unfinished_unlocked; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_priority_scheduled_at_unfinished_unlocked ON renalware.good_jobs USING btree (priority, scheduled_at) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));


--
-- Name: index_good_jobs_on_queue_name_and_scheduled_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON renalware.good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON renalware.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_hd_cannulation_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_cannulation_types_on_deleted_at ON renalware.hd_cannulation_types USING btree (deleted_at);


--
-- Name: index_hd_dialysates_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_dialysates_on_deleted_at ON renalware.hd_dialysates USING btree (deleted_at);


--
-- Name: index_hd_diaries_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_created_by_id ON renalware.hd_diaries USING btree (created_by_id);


--
-- Name: index_hd_diaries_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_deleted_at ON renalware.hd_diaries USING btree (deleted_at);


--
-- Name: index_hd_diaries_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_hospital_unit_id ON renalware.hd_diaries USING btree (hospital_unit_id);


--
-- Name: index_hd_diaries_on_hospital_unit_id_and_week_number_and_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_diaries_on_hospital_unit_id_and_week_number_and_year ON renalware.hd_diaries USING btree (hospital_unit_id, week_number, year) WHERE (master = false);


--
-- Name: index_hd_diaries_on_master_diary_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_master_diary_id ON renalware.hd_diaries USING btree (master_diary_id);


--
-- Name: index_hd_diaries_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_type ON renalware.hd_diaries USING btree (type);


--
-- Name: index_hd_diaries_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_updated_by_id ON renalware.hd_diaries USING btree (updated_by_id);


--
-- Name: index_hd_diaries_on_week_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_week_number ON renalware.hd_diaries USING btree (week_number);


--
-- Name: index_hd_diaries_on_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_year ON renalware.hd_diaries USING btree (year);


--
-- Name: index_hd_diary_slots_on_archived; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_archived ON renalware.hd_diary_slots USING btree (archived);


--
-- Name: index_hd_diary_slots_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_created_by_id ON renalware.hd_diary_slots USING btree (created_by_id);


--
-- Name: index_hd_diary_slots_on_day_of_week; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_day_of_week ON renalware.hd_diary_slots USING btree (day_of_week);


--
-- Name: index_hd_diary_slots_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_deleted_at ON renalware.hd_diary_slots USING btree (deleted_at);


--
-- Name: index_hd_diary_slots_on_diary_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_diary_id ON renalware.hd_diary_slots USING btree (diary_id);


--
-- Name: index_hd_diary_slots_on_diurnal_period_code_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_diurnal_period_code_id ON renalware.hd_diary_slots USING btree (diurnal_period_code_id);


--
-- Name: index_hd_diary_slots_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_patient_id ON renalware.hd_diary_slots USING btree (patient_id);


--
-- Name: index_hd_diary_slots_on_station_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_station_id ON renalware.hd_diary_slots USING btree (station_id);


--
-- Name: index_hd_diary_slots_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_updated_by_id ON renalware.hd_diary_slots USING btree (updated_by_id);


--
-- Name: index_hd_diurnal_period_codes_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_diurnal_period_codes_on_code ON renalware.hd_diurnal_period_codes USING btree (code);


--
-- Name: index_hd_patient_statistics_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_hospital_unit_id ON renalware.hd_patient_statistics USING btree (hospital_unit_id);


--
-- Name: index_hd_patient_statistics_on_month; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_month ON renalware.hd_patient_statistics USING btree (month);


--
-- Name: index_hd_patient_statistics_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_patient_id ON renalware.hd_patient_statistics USING btree (patient_id);


--
-- Name: index_hd_patient_statistics_on_patient_id_and_month_and_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_patient_statistics_on_patient_id_and_month_and_year ON renalware.hd_patient_statistics USING btree (patient_id, month, year);


--
-- Name: index_hd_patient_statistics_on_patient_id_and_rolling; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_patient_statistics_on_patient_id_and_rolling ON renalware.hd_patient_statistics USING btree (patient_id, rolling);


--
-- Name: index_hd_patient_statistics_on_rolling; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_rolling ON renalware.hd_patient_statistics USING btree (rolling);


--
-- Name: index_hd_patient_statistics_on_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_year ON renalware.hd_patient_statistics USING btree (year);


--
-- Name: index_hd_preference_sets_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_created_by_id ON renalware.hd_preference_sets USING btree (created_by_id);


--
-- Name: index_hd_preference_sets_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_hospital_unit_id ON renalware.hd_preference_sets USING btree (hospital_unit_id);


--
-- Name: index_hd_preference_sets_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_patient_id ON renalware.hd_preference_sets USING btree (patient_id);


--
-- Name: index_hd_preference_sets_on_schedule_definition_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_schedule_definition_id ON renalware.hd_preference_sets USING btree (schedule_definition_id);


--
-- Name: index_hd_preference_sets_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_updated_by_id ON renalware.hd_preference_sets USING btree (updated_by_id);


--
-- Name: index_hd_prescription_administration_reasons_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_prescription_administration_reasons_on_name ON renalware.hd_prescription_administration_reasons USING btree (name);


--
-- Name: index_hd_prescription_administrations_on_administered_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_administered_by_id ON renalware.hd_prescription_administrations USING btree (administered_by_id);


--
-- Name: index_hd_prescription_administrations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_created_by_id ON renalware.hd_prescription_administrations USING btree (created_by_id);


--
-- Name: index_hd_prescription_administrations_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_deleted_at ON renalware.hd_prescription_administrations USING btree (deleted_at);


--
-- Name: index_hd_prescription_administrations_on_hd_session_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_hd_session_id ON renalware.hd_prescription_administrations USING btree (hd_session_id);


--
-- Name: index_hd_prescription_administrations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_patient_id ON renalware.hd_prescription_administrations USING btree (patient_id);


--
-- Name: index_hd_prescription_administrations_on_prescription_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_prescription_id ON renalware.hd_prescription_administrations USING btree (prescription_id);


--
-- Name: index_hd_prescription_administrations_on_reason_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_reason_id ON renalware.hd_prescription_administrations USING btree (reason_id);


--
-- Name: index_hd_prescription_administrations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_updated_by_id ON renalware.hd_prescription_administrations USING btree (updated_by_id);


--
-- Name: index_hd_prescription_administrations_on_witnessed_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_witnessed_by_id ON renalware.hd_prescription_administrations USING btree (witnessed_by_id);


--
-- Name: index_hd_profiles_on_active_and_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_profiles_on_active_and_patient_id ON renalware.hd_profiles USING btree (active, patient_id);


--
-- Name: index_hd_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_created_by_id ON renalware.hd_profiles USING btree (created_by_id);


--
-- Name: index_hd_profiles_on_deactivated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_deactivated_at ON renalware.hd_profiles USING btree (deactivated_at);


--
-- Name: index_hd_profiles_on_dialysate_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_dialysate_id ON renalware.hd_profiles USING btree (dialysate_id);


--
-- Name: index_hd_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_document ON renalware.hd_profiles USING gin (document);


--
-- Name: index_hd_profiles_on_home_machine_identifier; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_profiles_on_home_machine_identifier ON renalware.hd_profiles USING btree (home_machine_identifier) WHERE ((deactivated_at IS NULL) AND ((COALESCE(home_machine_identifier, ''::character varying))::text <> ''::text));


--
-- Name: INDEX index_hd_profiles_on_home_machine_identifier; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_hd_profiles_on_home_machine_identifier IS 'Must be unique among active HD Profiles, ignoring blanks';


--
-- Name: index_hd_profiles_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_hospital_unit_id ON renalware.hd_profiles USING btree (hospital_unit_id);


--
-- Name: index_hd_profiles_on_named_nurse_id_legacy; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_named_nurse_id_legacy ON renalware.hd_profiles USING btree (named_nurse_id_legacy);


--
-- Name: index_hd_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_patient_id ON renalware.hd_profiles USING btree (patient_id);


--
-- Name: index_hd_profiles_on_prescriber_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_prescriber_id ON renalware.hd_profiles USING btree (prescriber_id);


--
-- Name: index_hd_profiles_on_schedule_definition_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_schedule_definition_id ON renalware.hd_profiles USING btree (schedule_definition_id);


--
-- Name: index_hd_profiles_on_transport_decider_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_transport_decider_id ON renalware.hd_profiles USING btree (transport_decider_id);


--
-- Name: index_hd_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_updated_by_id ON renalware.hd_profiles USING btree (updated_by_id);


--
-- Name: index_hd_provider_units_on_hd_provider_id_and_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_provider_units_on_hd_provider_id_and_hospital_unit_id ON renalware.hd_provider_units USING btree (hd_provider_id, hospital_unit_id);


--
-- Name: index_hd_schedule_definitions_on_days; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_schedule_definitions_on_days ON renalware.hd_schedule_definitions USING gin (days);


--
-- Name: index_hd_schedule_definitions_on_diurnal_period_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_schedule_definitions_on_diurnal_period_id ON renalware.hd_schedule_definitions USING btree (diurnal_period_id);


--
-- Name: index_hd_session_form_batch_items_on_batch_id_and_printable_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_session_form_batch_items_on_batch_id_and_printable_id ON renalware.hd_session_form_batch_items USING btree (batch_id, printable_id);


--
-- Name: index_hd_session_form_batch_items_on_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_session_form_batch_items_on_status ON renalware.hd_session_form_batch_items USING btree (status);


--
-- Name: index_hd_session_form_batches_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_session_form_batches_on_created_by_id ON renalware.hd_session_form_batches USING btree (created_by_id);


--
-- Name: index_hd_session_form_batches_on_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_session_form_batches_on_status ON renalware.hd_session_form_batches USING btree (status);


--
-- Name: index_hd_session_form_batches_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_session_form_batches_on_updated_by_id ON renalware.hd_session_form_batches USING btree (updated_by_id);


--
-- Name: index_hd_session_patient_group_directions_on_session_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_session_patient_group_directions_on_session_id ON renalware.hd_session_patient_group_directions USING btree (session_id);


--
-- Name: index_hd_sessions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_created_by_id ON renalware.hd_sessions USING btree (created_by_id);


--
-- Name: index_hd_sessions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_deleted_at ON renalware.hd_sessions USING btree (deleted_at);


--
-- Name: index_hd_sessions_on_dialysate_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_dialysate_id ON renalware.hd_sessions USING btree (dialysate_id);


--
-- Name: index_hd_sessions_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_document ON renalware.hd_sessions USING gin (document);


--
-- Name: index_hd_sessions_on_dry_weight_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_dry_weight_id ON renalware.hd_sessions USING btree (dry_weight_id);


--
-- Name: index_hd_sessions_on_external_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_sessions_on_external_id ON renalware.hd_sessions USING btree (external_id);


--
-- Name: index_hd_sessions_on_hd_station_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_hd_station_id ON renalware.hd_sessions USING btree (hd_station_id);


--
-- Name: index_hd_sessions_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_hospital_unit_id ON renalware.hd_sessions USING btree (hospital_unit_id);


--
-- Name: index_hd_sessions_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_id_and_type ON renalware.hd_sessions USING btree (id, type);


--
-- Name: index_hd_sessions_on_modality_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_modality_description_id ON renalware.hd_sessions USING btree (modality_description_id);


--
-- Name: index_hd_sessions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_patient_id ON renalware.hd_sessions USING btree (patient_id);


--
-- Name: index_hd_sessions_on_performed_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_performed_on ON renalware.hd_sessions USING btree (performed_on);


--
-- Name: index_hd_sessions_on_profile_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_profile_id ON renalware.hd_sessions USING btree (profile_id);


--
-- Name: index_hd_sessions_on_provider_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_provider_id ON renalware.hd_sessions USING btree (provider_id);


--
-- Name: index_hd_sessions_on_signed_off_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_off_at ON renalware.hd_sessions USING btree (signed_off_at);


--
-- Name: index_hd_sessions_on_signed_off_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_off_by_id ON renalware.hd_sessions USING btree (signed_off_by_id);


--
-- Name: index_hd_sessions_on_signed_on_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_on_by_id ON renalware.hd_sessions USING btree (signed_on_by_id);


--
-- Name: index_hd_sessions_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_type ON renalware.hd_sessions USING btree (type);


--
-- Name: index_hd_sessions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_updated_by_id ON renalware.hd_sessions USING btree (updated_by_id);


--
-- Name: index_hd_sessions_on_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_uuid ON renalware.hd_sessions USING btree (uuid);


--
-- Name: index_hd_slot_request_access_states_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_slot_request_access_states_on_name ON renalware.hd_slot_request_access_states USING btree (lower(name));


--
-- Name: index_hd_slot_request_deletion_reasons_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_request_deletion_reasons_on_deleted_at ON renalware.hd_slot_request_deletion_reasons USING btree (deleted_at);


--
-- Name: index_hd_slot_request_locations_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_slot_request_locations_on_name ON renalware.hd_slot_request_locations USING btree (lower(name));


--
-- Name: index_hd_slot_requests_on_access_state_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_access_state_id ON renalware.hd_slot_requests USING btree (access_state_id);


--
-- Name: index_hd_slot_requests_on_allocated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_allocated_at ON renalware.hd_slot_requests USING btree (allocated_at);


--
-- Name: index_hd_slot_requests_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_created_by_id ON renalware.hd_slot_requests USING btree (created_by_id);


--
-- Name: index_hd_slot_requests_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_deleted_at ON renalware.hd_slot_requests USING btree (deleted_at);


--
-- Name: index_hd_slot_requests_on_deletion_reason_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_deletion_reason_id ON renalware.hd_slot_requests USING btree (deletion_reason_id);


--
-- Name: index_hd_slot_requests_on_location_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_location_id ON renalware.hd_slot_requests USING btree (location_id);


--
-- Name: index_hd_slot_requests_on_medically_fit_for_discharge_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_medically_fit_for_discharge_by_id ON renalware.hd_slot_requests USING btree (medically_fit_for_discharge_by_id);


--
-- Name: index_hd_slot_requests_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_patient_id ON renalware.hd_slot_requests USING btree (patient_id);


--
-- Name: index_hd_slot_requests_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_slot_requests_on_updated_by_id ON renalware.hd_slot_requests USING btree (updated_by_id);


--
-- Name: index_hd_station_locations_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_station_locations_on_name ON renalware.hd_station_locations USING btree (name);


--
-- Name: index_hd_stations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_created_by_id ON renalware.hd_stations USING btree (created_by_id);


--
-- Name: index_hd_stations_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_deleted_at ON renalware.hd_stations USING btree (deleted_at);


--
-- Name: index_hd_stations_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_hospital_unit_id ON renalware.hd_stations USING btree (hospital_unit_id);


--
-- Name: index_hd_stations_on_location_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_location_id ON renalware.hd_stations USING btree (location_id);


--
-- Name: index_hd_stations_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_position ON renalware.hd_stations USING btree ("position");


--
-- Name: index_hd_stations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_updated_by_id ON renalware.hd_stations USING btree (updated_by_id);


--
-- Name: index_hd_transmission_logs_on_session_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_transmission_logs_on_session_id ON renalware.hd_transmission_logs USING btree (session_id);


--
-- Name: index_hd_vnd_risk_assessments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_vnd_risk_assessments_on_created_by_id ON renalware.hd_vnd_risk_assessments USING btree (created_by_id);


--
-- Name: index_hd_vnd_risk_assessments_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_vnd_risk_assessments_on_deleted_at ON renalware.hd_vnd_risk_assessments USING btree (deleted_at);


--
-- Name: index_hd_vnd_risk_assessments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_vnd_risk_assessments_on_patient_id ON renalware.hd_vnd_risk_assessments USING btree (patient_id);


--
-- Name: index_hd_vnd_risk_assessments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_vnd_risk_assessments_on_updated_by_id ON renalware.hd_vnd_risk_assessments USING btree (updated_by_id);


--
-- Name: index_hospital_centres_on_abbrev; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hospital_centres_on_abbrev ON renalware.hospital_centres USING btree (abbrev);


--
-- Name: index_hospital_centres_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_centres_on_code ON renalware.hospital_centres USING btree (code);


--
-- Name: index_hospital_centres_on_host_site; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_centres_on_host_site ON renalware.hospital_centres USING btree (host_site);


--
-- Name: index_hospital_departments_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_departments_on_deleted_at ON renalware.hospital_departments USING btree (deleted_at);


--
-- Name: index_hospital_departments_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_departments_on_hospital_centre_id ON renalware.hospital_departments USING btree (hospital_centre_id);


--
-- Name: index_hospital_units_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_units_on_hospital_centre_id ON renalware.hospital_units USING btree (hospital_centre_id);


--
-- Name: index_hospital_units_on_is_hd_site; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_units_on_is_hd_site ON renalware.hospital_units USING btree (is_hd_site);


--
-- Name: index_hospital_wards_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_wards_on_code ON renalware.hospital_wards USING btree (code);


--
-- Name: index_hospital_wards_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_wards_on_hospital_unit_id ON renalware.hospital_wards USING btree (hospital_unit_id);


--
-- Name: index_hospital_wards_on_name_and_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hospital_wards_on_name_and_hospital_unit_id ON renalware.hospital_wards USING btree (name, hospital_unit_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: index_letter_archives_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_archives_on_created_by_id ON renalware.letter_archives USING btree (created_by_id);


--
-- Name: index_letter_archives_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_archives_on_letter_id ON renalware.letter_archives USING btree (letter_id);


--
-- Name: index_letter_archives_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_archives_on_updated_by_id ON renalware.letter_archives USING btree (updated_by_id);


--
-- Name: index_letter_archives_on_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_archives_on_uuid ON renalware.letter_archives USING btree (uuid);


--
-- Name: index_letter_batch_items_on_batch_id_and_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_batch_items_on_batch_id_and_status ON renalware.letter_batch_items USING btree (batch_id, status);


--
-- Name: index_letter_batch_items_on_letter_id_and_batch_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_batch_items_on_letter_id_and_batch_id ON renalware.letter_batch_items USING btree (letter_id, batch_id);


--
-- Name: index_letter_batches_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_batches_on_created_by_id ON renalware.letter_batches USING btree (created_by_id);


--
-- Name: index_letter_batches_on_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_batches_on_status ON renalware.letter_batches USING btree (status);


--
-- Name: index_letter_batches_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_batches_on_updated_by_id ON renalware.letter_batches USING btree (updated_by_id);


--
-- Name: index_letter_contact_descriptions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_name ON renalware.letter_contact_descriptions USING btree (name);


--
-- Name: index_letter_contact_descriptions_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_position ON renalware.letter_contact_descriptions USING btree ("position");


--
-- Name: index_letter_contact_descriptions_on_system_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_system_code ON renalware.letter_contact_descriptions USING btree (system_code);


--
-- Name: index_letter_contacts_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_contacts_on_description_id ON renalware.letter_contacts USING btree (description_id);


--
-- Name: index_letter_contacts_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_contacts_on_patient_id ON renalware.letter_contacts USING btree (patient_id);


--
-- Name: index_letter_contacts_on_person_id_and_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contacts_on_person_id_and_patient_id ON renalware.letter_contacts USING btree (person_id, patient_id);


--
-- Name: index_letter_descriptions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_descriptions_on_deleted_at ON renalware.letter_descriptions USING btree (deleted_at);


--
-- Name: index_letter_descriptions_on_snomed_document_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_descriptions_on_snomed_document_type_id ON renalware.letter_descriptions USING btree (snomed_document_type_id);


--
-- Name: index_letter_electronic_receipts_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_electronic_receipts_on_letter_id ON renalware.letter_electronic_receipts USING btree (letter_id);


--
-- Name: index_letter_electronic_receipts_on_read_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_electronic_receipts_on_read_at ON renalware.letter_electronic_receipts USING btree (read_at);


--
-- Name: index_letter_electronic_receipts_on_recipient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_electronic_receipts_on_recipient_id ON renalware.letter_electronic_receipts USING btree (recipient_id);


--
-- Name: index_letter_electronic_receipts_on_user_group_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_electronic_receipts_on_user_group_id ON renalware.letter_electronic_receipts USING btree (user_group_id);


--
-- Name: index_letter_letterheads_on_hospital_department_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letterheads_on_hospital_department_id ON renalware.letter_letterheads USING btree (hospital_department_id);


--
-- Name: index_letter_letters_on_approved_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_approved_at ON renalware.letter_letters USING btree (approved_at);


--
-- Name: index_letter_letters_on_approved_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_approved_by_id ON renalware.letter_letters USING btree (approved_by_id);


--
-- Name: index_letter_letters_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_author_id ON renalware.letter_letters USING btree (author_id);


--
-- Name: index_letter_letters_on_completed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_completed_at ON renalware.letter_letters USING btree (completed_at);


--
-- Name: index_letter_letters_on_completed_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_completed_by_id ON renalware.letter_letters USING btree (completed_by_id);


--
-- Name: index_letter_letters_on_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_created_at ON renalware.letter_letters USING btree (created_at);


--
-- Name: index_letter_letters_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_created_by_id ON renalware.letter_letters USING btree (created_by_id);


--
-- Name: index_letter_letters_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_deleted_at ON renalware.letter_letters USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: index_letter_letters_on_deleted_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_deleted_by_id ON renalware.letter_letters USING btree (deleted_by_id);


--
-- Name: index_letter_letters_on_event_type_and_event_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_event_type_and_event_id ON renalware.letter_letters USING btree (event_type, event_id);


--
-- Name: index_letter_letters_on_gp_send_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_gp_send_status ON renalware.letter_letters USING btree (gp_send_status);


--
-- Name: index_letter_letters_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_id_and_type ON renalware.letter_letters USING btree (id, type);


--
-- Name: index_letter_letters_on_letterhead_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_letterhead_id ON renalware.letter_letters USING btree (letterhead_id);


--
-- Name: index_letter_letters_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_patient_id ON renalware.letter_letters USING btree (patient_id);


--
-- Name: index_letter_letters_on_submitted_for_approval_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_submitted_for_approval_at ON renalware.letter_letters USING btree (submitted_for_approval_at);


--
-- Name: index_letter_letters_on_submitted_for_approval_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_submitted_for_approval_by_id ON renalware.letter_letters USING btree (submitted_for_approval_by_id);


--
-- Name: index_letter_letters_on_topic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_topic_id ON renalware.letter_letters USING btree (topic_id);


--
-- Name: index_letter_letters_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_type ON renalware.letter_letters USING btree (type);


--
-- Name: index_letter_letters_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_updated_by_id ON renalware.letter_letters USING btree (updated_by_id);


--
-- Name: index_letter_letters_on_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_uuid ON renalware.letter_letters USING btree (uuid);


--
-- Name: index_letter_mailshot_items_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mailshot_items_on_letter_id ON renalware.letter_mailshot_items USING btree (letter_id);


--
-- Name: index_letter_mailshot_items_on_mailshot_id_and_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_mailshot_items_on_mailshot_id_and_letter_id ON renalware.letter_mailshot_items USING btree (mailshot_id, letter_id);


--
-- Name: INDEX index_letter_mailshot_items_on_mailshot_id_and_letter_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_letter_mailshot_items_on_mailshot_id_and_letter_id IS 'A sanity check that a letter appears only once in a mailshot';


--
-- Name: index_letter_mailshot_mailshots_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mailshot_mailshots_on_author_id ON renalware.letter_mailshot_mailshots USING btree (author_id);


--
-- Name: index_letter_mailshot_mailshots_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mailshot_mailshots_on_created_by_id ON renalware.letter_mailshot_mailshots USING btree (created_by_id);


--
-- Name: index_letter_mailshot_mailshots_on_letterhead_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mailshot_mailshots_on_letterhead_id ON renalware.letter_mailshot_mailshots USING btree (letterhead_id);


--
-- Name: index_letter_mailshot_mailshots_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mailshot_mailshots_on_updated_by_id ON renalware.letter_mailshot_mailshots USING btree (updated_by_id);


--
-- Name: index_letter_mesh_operations_on_action; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_operations_on_action ON renalware.letter_mesh_operations USING btree (action);


--
-- Name: index_letter_mesh_operations_on_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_operations_on_created_at ON renalware.letter_mesh_operations USING btree (created_at);


--
-- Name: index_letter_mesh_operations_on_direction; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_operations_on_direction ON renalware.letter_mesh_operations USING btree (direction);


--
-- Name: index_letter_mesh_operations_on_itk3_response_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_operations_on_itk3_response_type ON renalware.letter_mesh_operations USING btree (itk3_response_type);


--
-- Name: index_letter_mesh_operations_on_parent_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_operations_on_parent_id ON renalware.letter_mesh_operations USING btree (parent_id);


--
-- Name: index_letter_mesh_operations_on_transmission_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_operations_on_transmission_id ON renalware.letter_mesh_operations USING btree (transmission_id);


--
-- Name: index_letter_mesh_operations_on_updated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_operations_on_updated_at ON renalware.letter_mesh_operations USING btree (updated_at);


--
-- Name: index_letter_mesh_transmissions_on_active_job_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_transmissions_on_active_job_id ON renalware.letter_mesh_transmissions USING btree (active_job_id);


--
-- Name: index_letter_mesh_transmissions_on_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_transmissions_on_created_at ON renalware.letter_mesh_transmissions USING btree (created_at);


--
-- Name: index_letter_mesh_transmissions_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_transmissions_on_letter_id ON renalware.letter_mesh_transmissions USING btree (letter_id);


--
-- Name: index_letter_mesh_transmissions_on_sent_to_practice_ods_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_transmissions_on_sent_to_practice_ods_code ON renalware.letter_mesh_transmissions USING btree (sent_to_practice_ods_code);


--
-- Name: index_letter_mesh_transmissions_on_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_transmissions_on_status ON renalware.letter_mesh_transmissions USING btree (status);


--
-- Name: index_letter_mesh_transmissions_on_updated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_mesh_transmissions_on_updated_at ON renalware.letter_mesh_transmissions USING btree (updated_at);


--
-- Name: index_letter_recipients_on_addressee_type_and_addressee_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_addressee_type_and_addressee_id ON renalware.letter_recipients USING btree (addressee_type, addressee_id);


--
-- Name: index_letter_recipients_on_emailed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_emailed_at ON renalware.letter_recipients USING btree (emailed_at);


--
-- Name: index_letter_recipients_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_letter_id ON renalware.letter_recipients USING btree (letter_id);


--
-- Name: index_letter_recipients_on_printed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_printed_at ON renalware.letter_recipients USING btree (printed_at);


--
-- Name: index_letter_recipients_on_role; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_role ON renalware.letter_recipients USING btree (role);


--
-- Name: index_letter_section_snapshots_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_section_snapshots_on_letter_id ON renalware.letter_section_snapshots USING btree (letter_id);


--
-- Name: index_letter_signatures_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_signatures_on_letter_id ON renalware.letter_signatures USING btree (letter_id);


--
-- Name: index_letter_signatures_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_signatures_on_user_id ON renalware.letter_signatures USING btree (user_id);


--
-- Name: index_letter_snomed_document_types_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_snomed_document_types_on_code ON renalware.letter_snomed_document_types USING btree (code);


--
-- Name: index_letter_snomed_document_types_on_default_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_snomed_document_types_on_default_type ON renalware.letter_snomed_document_types USING btree (default_type) WHERE (default_type = true);


--
-- Name: index_letter_snomed_document_types_on_title; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_snomed_document_types_on_title ON renalware.letter_snomed_document_types USING btree (title);


--
-- Name: index_low_clearance_dialysis_plans_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_low_clearance_dialysis_plans_on_code ON renalware.low_clearance_dialysis_plans USING btree (code);


--
-- Name: index_low_clearance_dialysis_plans_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_dialysis_plans_on_deleted_at ON renalware.low_clearance_dialysis_plans USING btree (deleted_at);


--
-- Name: index_low_clearance_dialysis_plans_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_low_clearance_dialysis_plans_on_name ON renalware.low_clearance_dialysis_plans USING btree (name);


--
-- Name: index_low_clearance_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_created_by_id ON renalware.low_clearance_profiles USING btree (created_by_id);


--
-- Name: index_low_clearance_profiles_on_dialysis_plan_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_dialysis_plan_id ON renalware.low_clearance_profiles USING btree (dialysis_plan_id);


--
-- Name: index_low_clearance_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_document ON renalware.low_clearance_profiles USING gin (document);


--
-- Name: index_low_clearance_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_low_clearance_profiles_on_patient_id ON renalware.low_clearance_profiles USING btree (patient_id);


--
-- Name: index_low_clearance_profiles_on_referrer_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_referrer_id ON renalware.low_clearance_profiles USING btree (referrer_id);


--
-- Name: index_low_clearance_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_updated_by_id ON renalware.low_clearance_profiles USING btree (updated_by_id);


--
-- Name: index_low_clearance_referrers_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_low_clearance_referrers_on_name ON renalware.low_clearance_referrers USING btree (name);


--
-- Name: index_low_clearance_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_versions_on_item_type_and_item_id ON renalware.low_clearance_versions USING btree (item_type, item_id);


--
-- Name: index_medication_delivery_events_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_delivery_events_on_created_by_id ON renalware.medication_delivery_events USING btree (created_by_id);


--
-- Name: index_medication_delivery_events_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_delivery_events_on_deleted_at ON renalware.medication_delivery_events USING btree (deleted_at);


--
-- Name: index_medication_delivery_events_on_drug_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_delivery_events_on_drug_type_id ON renalware.medication_delivery_events USING btree (drug_type_id);


--
-- Name: index_medication_delivery_events_on_homecare_form_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_delivery_events_on_homecare_form_id ON renalware.medication_delivery_events USING btree (homecare_form_id);


--
-- Name: index_medication_delivery_events_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_delivery_events_on_patient_id ON renalware.medication_delivery_events USING btree (patient_id);


--
-- Name: index_medication_delivery_events_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_delivery_events_on_updated_by_id ON renalware.medication_delivery_events USING btree (updated_by_id);


--
-- Name: index_medication_prescription_terminations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_created_by_id ON renalware.medication_prescription_terminations USING btree (created_by_id);


--
-- Name: index_medication_prescription_terminations_on_prescription_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_prescription_id ON renalware.medication_prescription_terminations USING btree (prescription_id);


--
-- Name: index_medication_prescription_terminations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_updated_by_id ON renalware.medication_prescription_terminations USING btree (updated_by_id);


--
-- Name: index_medication_prescription_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_versions_on_item_type_and_item_id ON renalware.medication_prescription_versions USING btree (item_type, item_id);


--
-- Name: index_medication_prescriptions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_created_by_id ON renalware.medication_prescriptions USING btree (created_by_id);


--
-- Name: index_medication_prescriptions_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_drug_id ON renalware.medication_prescriptions USING btree (drug_id);


--
-- Name: index_medication_prescriptions_on_drug_id_and_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_drug_id_and_patient_id ON renalware.medication_prescriptions USING btree (drug_id, patient_id);


--
-- Name: index_medication_prescriptions_on_form_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_form_id ON renalware.medication_prescriptions USING btree (form_id);


--
-- Name: index_medication_prescriptions_on_medication_route_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_medication_route_id ON renalware.medication_prescriptions USING btree (medication_route_id);


--
-- Name: index_medication_prescriptions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_patient_id ON renalware.medication_prescriptions USING btree (patient_id);


--
-- Name: index_medication_prescriptions_on_trade_family_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_trade_family_id ON renalware.medication_prescriptions USING btree (trade_family_id);


--
-- Name: index_medication_prescriptions_on_unit_of_measure_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_unit_of_measure_id ON renalware.medication_prescriptions USING btree (unit_of_measure_id);


--
-- Name: index_medication_prescriptions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_updated_by_id ON renalware.medication_prescriptions USING btree (updated_by_id);


--
-- Name: index_medication_routes_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_medication_routes_on_code ON renalware.medication_routes USING btree (code);


--
-- Name: index_medication_routes_on_weighting; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_routes_on_weighting ON renalware.medication_routes USING btree (weighting);


--
-- Name: index_messaging_messages_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_author_id ON renalware.messaging_messages USING btree (author_id);


--
-- Name: index_messaging_messages_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_patient_id ON renalware.messaging_messages USING btree (patient_id);


--
-- Name: index_messaging_messages_on_replying_to_message_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_replying_to_message_id ON renalware.messaging_messages USING btree (replying_to_message_id);


--
-- Name: index_messaging_messages_on_subject; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_subject ON renalware.messaging_messages USING btree (subject);


--
-- Name: index_messaging_messages_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_type ON renalware.messaging_messages USING btree (type);


--
-- Name: index_messaging_receipts_on_message_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_receipts_on_message_id ON renalware.messaging_receipts USING btree (message_id);


--
-- Name: index_messaging_receipts_on_read_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_receipts_on_read_at ON renalware.messaging_receipts USING btree (read_at);


--
-- Name: index_messaging_receipts_on_recipient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_receipts_on_recipient_id ON renalware.messaging_receipts USING btree (recipient_id);


--
-- Name: index_modality_change_types_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_change_types_on_created_by_id ON renalware.modality_change_types USING btree (created_by_id);


--
-- Name: index_modality_change_types_on_default; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_modality_change_types_on_default ON renalware.modality_change_types USING btree ("default") WHERE ("default" = true);


--
-- Name: index_modality_change_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_change_types_on_deleted_at ON renalware.modality_change_types USING btree (deleted_at);


--
-- Name: index_modality_change_types_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_change_types_on_updated_by_id ON renalware.modality_change_types USING btree (updated_by_id);


--
-- Name: index_modality_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_modality_descriptions_on_code ON renalware.modality_descriptions USING btree (code);


--
-- Name: index_modality_descriptions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_deleted_at ON renalware.modality_descriptions USING btree (deleted_at);


--
-- Name: index_modality_descriptions_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_id_and_type ON renalware.modality_descriptions USING btree (id, type);


--
-- Name: index_modality_descriptions_on_ignore_for_kfre; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_ignore_for_kfre ON renalware.modality_descriptions USING btree (ignore_for_kfre);


--
-- Name: index_modality_descriptions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_name ON renalware.modality_descriptions USING btree (name);


--
-- Name: index_modality_descriptions_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_type ON renalware.modality_descriptions USING btree (type);


--
-- Name: index_modality_descriptions_on_ukrdc_modality_code_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_ukrdc_modality_code_id ON renalware.modality_descriptions USING btree (ukrdc_modality_code_id);


--
-- Name: index_modality_modalities_on_change_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_change_type_id ON renalware.modality_modalities USING btree (change_type_id);


--
-- Name: index_modality_modalities_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_created_by_id ON renalware.modality_modalities USING btree (created_by_id);


--
-- Name: index_modality_modalities_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_description_id ON renalware.modality_modalities USING btree (description_id);


--
-- Name: index_modality_modalities_on_destination_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_destination_hospital_centre_id ON renalware.modality_modalities USING btree (destination_hospital_centre_id);


--
-- Name: index_modality_modalities_on_ended_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_ended_on ON renalware.modality_modalities USING btree (ended_on);


--
-- Name: index_modality_modalities_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_patient_id ON renalware.modality_modalities USING btree (patient_id);


--
-- Name: index_modality_modalities_on_patient_id_and_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_patient_id_and_description_id ON renalware.modality_modalities USING btree (patient_id, description_id);


--
-- Name: index_modality_modalities_on_reason_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_reason_id ON renalware.modality_modalities USING btree (reason_id);


--
-- Name: index_modality_modalities_on_source_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_source_hospital_centre_id ON renalware.modality_modalities USING btree (source_hospital_centre_id);


--
-- Name: index_modality_modalities_on_state; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_state ON renalware.modality_modalities USING btree (state);


--
-- Name: index_modality_modalities_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_updated_by_id ON renalware.modality_modalities USING btree (updated_by_id);


--
-- Name: index_modality_reasons_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_reasons_on_id_and_type ON renalware.modality_reasons USING btree (id, type);


--
-- Name: index_modality_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_versions_on_item_type_and_item_id ON renalware.modality_versions USING btree (item_type, item_id);


--
-- Name: index_password_archivable; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_password_archivable ON renalware.old_passwords USING btree (password_archivable_type, password_archivable_id);


--
-- Name: index_pathology_chart_series_on_chart_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_chart_series_on_chart_id ON renalware.pathology_chart_series USING btree (chart_id);


--
-- Name: index_pathology_charts_on_enabled; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_charts_on_enabled ON renalware.pathology_charts USING btree (enabled);


--
-- Name: index_pathology_charts_on_owner_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_charts_on_owner_id ON renalware.pathology_charts USING btree (owner_id);


--
-- Name: index_pathology_charts_on_title; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_charts_on_title ON renalware.pathology_charts USING btree (title);


--
-- Name: index_pathology_code_group_memberships_on_code_group_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_code_group_memberships_on_code_group_id ON renalware.pathology_code_group_memberships USING btree (code_group_id);


--
-- Name: index_pathology_code_group_memberships_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_code_group_memberships_on_created_by_id ON renalware.pathology_code_group_memberships USING btree (created_by_id);


--
-- Name: index_pathology_code_group_memberships_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_code_group_memberships_on_updated_by_id ON renalware.pathology_code_group_memberships USING btree (updated_by_id);


--
-- Name: index_pathology_code_group_memberships_uniq; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_code_group_memberships_uniq ON renalware.pathology_code_group_memberships USING btree (code_group_id, observation_description_id);


--
-- Name: index_pathology_code_groups_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_code_groups_on_created_by_id ON renalware.pathology_code_groups USING btree (created_by_id);


--
-- Name: index_pathology_code_groups_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_code_groups_on_name ON renalware.pathology_code_groups USING btree (name);


--
-- Name: index_pathology_code_groups_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_code_groups_on_updated_by_id ON renalware.pathology_code_groups USING btree (updated_by_id);


--
-- Name: index_pathology_current_observation_sets_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_current_observation_sets_on_patient_id ON renalware.pathology_current_observation_sets USING btree (patient_id);


--
-- Name: index_pathology_current_observation_sets_on_values; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_current_observation_sets_on_values ON renalware.pathology_current_observation_sets USING gin ("values");


--
-- Name: index_pathology_measurement_units_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_measurement_units_on_name ON renalware.pathology_measurement_units USING btree (name);


--
-- Name: index_pathology_measurement_units_ukrdc_mu; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_measurement_units_ukrdc_mu ON renalware.pathology_measurement_units USING btree (ukrdc_measurement_unit_id);


--
-- Name: index_pathology_observation_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_observation_descriptions_on_code ON renalware.pathology_observation_descriptions USING btree (code);


--
-- Name: index_pathology_observation_descriptions_on_measurement_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_descriptions_on_measurement_unit_id ON renalware.pathology_observation_descriptions USING btree (measurement_unit_id);


--
-- Name: index_pathology_observation_requests_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_description_id ON renalware.pathology_observation_requests USING btree (description_id);


--
-- Name: index_pathology_observation_requests_on_feed_message_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_feed_message_id ON renalware.pathology_observation_requests USING btree (feed_message_id);


--
-- Name: index_pathology_observation_requests_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_patient_id ON renalware.pathology_observation_requests USING btree (patient_id);


--
-- Name: index_pathology_observation_requests_on_requested_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_requested_at ON renalware.pathology_observation_requests USING btree (requested_at);


--
-- Name: index_pathology_observation_requests_on_requestor_order_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_requestor_order_number ON renalware.pathology_observation_requests USING btree (requestor_order_number);


--
-- Name: index_pathology_observations_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observations_on_description_id ON renalware.pathology_observations USING btree (description_id);


--
-- Name: index_pathology_observations_on_observed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observations_on_observed_at ON renalware.pathology_observations USING btree (observed_at);


--
-- Name: index_pathology_observations_on_request_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observations_on_request_id ON renalware.pathology_observations USING btree (request_id);


--
-- Name: index_pathology_obx_mappings_on_code_alias; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_obx_mappings_on_code_alias ON renalware.pathology_obx_mappings USING btree (code_alias);


--
-- Name: index_pathology_obx_mappings_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_obx_mappings_on_created_by_id ON renalware.pathology_obx_mappings USING btree (created_by_id);


--
-- Name: index_pathology_obx_mappings_on_observation_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_obx_mappings_on_observation_description_id ON renalware.pathology_obx_mappings USING btree (observation_description_id);


--
-- Name: index_pathology_obx_mappings_on_sender_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_obx_mappings_on_sender_id ON renalware.pathology_obx_mappings USING btree (sender_id);


--
-- Name: index_pathology_obx_mappings_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_obx_mappings_on_updated_by_id ON renalware.pathology_obx_mappings USING btree (updated_by_id);


--
-- Name: index_pathology_request_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_request_descriptions_on_code ON renalware.pathology_request_descriptions USING btree (code);


--
-- Name: index_pathology_request_descriptions_on_lab_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_request_descriptions_on_lab_id ON renalware.pathology_request_descriptions USING btree (lab_id);


--
-- Name: index_pathology_requests_drug_categories_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_drug_categories_on_name ON renalware.pathology_requests_drug_categories USING btree (name);


--
-- Name: index_pathology_requests_drugs_drug_categories_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_drugs_drug_categories_on_drug_id ON renalware.pathology_requests_drugs_drug_categories USING btree (drug_id);


--
-- Name: index_pathology_requests_global_rule_sets_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_global_rule_sets_on_clinic_id ON renalware.pathology_requests_global_rule_sets USING btree (clinic_id);


--
-- Name: index_pathology_requests_global_rules_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_global_rules_on_id_and_type ON renalware.pathology_requests_global_rules USING btree (id, type);


--
-- Name: index_pathology_requests_global_rules_on_rule_set_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_global_rules_on_rule_set_type ON renalware.pathology_requests_global_rules USING btree (rule_set_type);


--
-- Name: index_pathology_requests_patient_rules_on_lab_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_patient_rules_on_lab_id ON renalware.pathology_requests_patient_rules USING btree (lab_id);


--
-- Name: index_pathology_requests_patient_rules_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_patient_rules_on_patient_id ON renalware.pathology_requests_patient_rules USING btree (patient_id);


--
-- Name: index_pathology_requests_patient_rules_requests_on_request_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_patient_rules_requests_on_request_id ON renalware.pathology_requests_patient_rules_requests USING btree (request_id);


--
-- Name: index_pathology_requests_requests_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_clinic_id ON renalware.pathology_requests_requests USING btree (clinic_id);


--
-- Name: index_pathology_requests_requests_on_consultant_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_consultant_id ON renalware.pathology_requests_requests USING btree (consultant_id);


--
-- Name: index_pathology_requests_requests_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_created_by_id ON renalware.pathology_requests_requests USING btree (created_by_id);


--
-- Name: index_pathology_requests_requests_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_patient_id ON renalware.pathology_requests_requests USING btree (patient_id);


--
-- Name: index_pathology_requests_requests_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_updated_by_id ON renalware.pathology_requests_requests USING btree (updated_by_id);


--
-- Name: index_pathology_requests_sample_types_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_requests_sample_types_on_code ON renalware.pathology_requests_sample_types USING btree (code);


--
-- Name: index_pathology_requests_sample_types_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_requests_sample_types_on_name ON renalware.pathology_requests_sample_types USING btree (name);


--
-- Name: index_pathology_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_versions_on_item_type_and_item_id ON renalware.pathology_versions USING btree (item_type, item_id);


--
-- Name: index_patient_alerts_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_created_by_id ON renalware.patient_alerts USING btree (created_by_id);


--
-- Name: index_patient_alerts_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_deleted_at ON renalware.patient_alerts USING btree (deleted_at);


--
-- Name: index_patient_alerts_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_patient_id ON renalware.patient_alerts USING btree (patient_id);


--
-- Name: index_patient_alerts_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_updated_by_id ON renalware.patient_alerts USING btree (updated_by_id);


--
-- Name: index_patient_attachment_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachment_types_on_deleted_at ON renalware.patient_attachment_types USING btree (deleted_at);


--
-- Name: index_patient_attachment_types_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_attachment_types_on_name ON renalware.patient_attachment_types USING btree (name);


--
-- Name: index_patient_attachments_on_attachment_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachments_on_attachment_type_id ON renalware.patient_attachments USING btree (attachment_type_id);


--
-- Name: index_patient_attachments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachments_on_created_by_id ON renalware.patient_attachments USING btree (created_by_id);


--
-- Name: index_patient_attachments_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachments_on_deleted_at ON renalware.patient_attachments USING btree (deleted_at);


--
-- Name: index_patient_attachments_on_document_date; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachments_on_document_date ON renalware.patient_attachments USING btree (document_date);


--
-- Name: index_patient_attachments_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachments_on_name ON renalware.patient_attachments USING btree (name);


--
-- Name: index_patient_attachments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachments_on_patient_id ON renalware.patient_attachments USING btree (patient_id);


--
-- Name: index_patient_attachments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_attachments_on_updated_by_id ON renalware.patient_attachments USING btree (updated_by_id);


--
-- Name: index_patient_bookmarks_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_deleted_at ON renalware.patient_bookmarks USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: index_patient_bookmarks_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_patient_id ON renalware.patient_bookmarks USING btree (patient_id);


--
-- Name: index_patient_bookmarks_on_urgent; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_urgent ON renalware.patient_bookmarks USING btree (urgent);


--
-- Name: index_patient_bookmarks_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_user_id ON renalware.patient_bookmarks USING btree (user_id);


--
-- Name: index_patient_ethnicities_on_cfh_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_ethnicities_on_cfh_name ON renalware.patient_ethnicities USING btree (cfh_name);


--
-- Name: index_patient_languages_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_languages_on_code ON renalware.patient_languages USING btree (code);


--
-- Name: index_patient_master_index_on_family_name_and_given_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_master_index_on_family_name_and_given_name ON renalware.patient_master_index USING btree (family_name, given_name);


--
-- Name: index_patient_master_index_on_hospital_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_master_index_on_hospital_number ON renalware.patient_master_index USING btree (hospital_number);


--
-- Name: index_patient_master_index_on_nhs_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_master_index_on_nhs_number ON renalware.patient_master_index USING btree (nhs_number);


--
-- Name: index_patient_master_index_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_master_index_on_patient_id ON renalware.patient_master_index USING btree (patient_id);


--
-- Name: index_patient_practice_memberships_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_practice_memberships_on_deleted_at ON renalware.patient_practice_memberships USING btree (deleted_at);


--
-- Name: index_patient_practice_memberships_on_practice_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_practice_memberships_on_practice_id ON renalware.patient_practice_memberships USING btree (practice_id);


--
-- Name: index_patient_practice_memberships_on_primary_care_physician_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_practice_memberships_on_primary_care_physician_id ON renalware.patient_practice_memberships USING btree (primary_care_physician_id);


--
-- Name: index_patient_practices_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_practices_on_code ON renalware.patient_practices USING btree (code);


--
-- Name: index_patient_primary_care_physicians_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_primary_care_physicians_on_code ON renalware.patient_primary_care_physicians USING btree (code);


--
-- Name: index_patient_primary_care_physicians_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_primary_care_physicians_on_deleted_at ON renalware.patient_primary_care_physicians USING btree (deleted_at);


--
-- Name: index_patient_primary_care_physicians_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_primary_care_physicians_on_name ON renalware.patient_primary_care_physicians USING btree (name);


--
-- Name: index_patient_worries_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worries_on_created_by_id ON renalware.patient_worries USING btree (created_by_id);


--
-- Name: index_patient_worries_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worries_on_deleted_at ON renalware.patient_worries USING btree (deleted_at);


--
-- Name: index_patient_worries_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_worries_on_patient_id ON renalware.patient_worries USING btree (patient_id) WHERE (deleted_at IS NULL);


--
-- Name: index_patient_worries_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worries_on_updated_by_id ON renalware.patient_worries USING btree (updated_by_id);


--
-- Name: index_patient_worries_on_worry_category_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worries_on_worry_category_id ON renalware.patient_worries USING btree (worry_category_id);


--
-- Name: index_patient_worry_categories_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worry_categories_on_created_by_id ON renalware.patient_worry_categories USING btree (created_by_id);


--
-- Name: index_patient_worry_categories_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worry_categories_on_deleted_at ON renalware.patient_worry_categories USING btree (deleted_at);


--
-- Name: index_patient_worry_categories_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_worry_categories_on_name ON renalware.patient_worry_categories USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: INDEX index_patient_worry_categories_on_name; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_patient_worry_categories_on_name IS 'Disallow duplicate undeleted names';


--
-- Name: index_patient_worry_categories_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worry_categories_on_updated_by_id ON renalware.patient_worry_categories USING btree (updated_by_id);


--
-- Name: index_patients_on_actual_death_location_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_actual_death_location_id ON renalware.patients USING btree (actual_death_location_id);


--
-- Name: index_patients_on_country_of_birth_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_country_of_birth_id ON renalware.patients USING btree (country_of_birth_id);


--
-- Name: index_patients_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_created_by_id ON renalware.patients USING btree (created_by_id);


--
-- Name: index_patients_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_document ON renalware.patients USING gin (document);


--
-- Name: index_patients_on_ethnicity_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_ethnicity_id ON renalware.patients USING btree (ethnicity_id);


--
-- Name: index_patients_on_external_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_external_patient_id ON renalware.patients USING btree (external_patient_id);


--
-- Name: index_patients_on_first_cause_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_first_cause_id ON renalware.patients USING btree (first_cause_id);


--
-- Name: index_patients_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_hospital_centre_id ON renalware.patients USING btree (hospital_centre_id);


--
-- Name: index_patients_on_language_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_language_id ON renalware.patients USING btree (language_id);


--
-- Name: index_patients_on_legacy_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_legacy_patient_id ON renalware.patients USING btree (legacy_patient_id);


--
-- Name: index_patients_on_local_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_local_patient_id ON renalware.patients USING btree (local_patient_id);


--
-- Name: index_patients_on_local_patient_id_2; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_local_patient_id_2 ON renalware.patients USING btree (local_patient_id_2);


--
-- Name: index_patients_on_local_patient_id_3; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_local_patient_id_3 ON renalware.patients USING btree (local_patient_id_3);


--
-- Name: index_patients_on_local_patient_id_4; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_local_patient_id_4 ON renalware.patients USING btree (local_patient_id_4);


--
-- Name: index_patients_on_local_patient_id_5; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_local_patient_id_5 ON renalware.patients USING btree (local_patient_id_5);


--
-- Name: index_patients_on_named_consultant_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_named_consultant_id ON renalware.patients USING btree (named_consultant_id);


--
-- Name: index_patients_on_named_nurse_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_named_nurse_id ON renalware.patients USING btree (named_nurse_id);


--
-- Name: index_patients_on_practice_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_practice_id ON renalware.patients USING btree (practice_id);


--
-- Name: index_patients_on_preferred_death_location_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_preferred_death_location_id ON renalware.patients USING btree (preferred_death_location_id);


--
-- Name: index_patients_on_primary_care_physician_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_primary_care_physician_id ON renalware.patients USING btree (primary_care_physician_id);


--
-- Name: index_patients_on_religion_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_religion_id ON renalware.patients USING btree (religion_id);


--
-- Name: index_patients_on_renal_registry_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_renal_registry_id ON renalware.patients USING btree (renal_registry_id);


--
-- Name: index_patients_on_second_cause_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_second_cause_id ON renalware.patients USING btree (second_cause_id);


--
-- Name: index_patients_on_secure_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_secure_id ON renalware.patients USING btree (secure_id);


--
-- Name: index_patients_on_send_to_renalreg; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_send_to_renalreg ON renalware.patients USING btree (send_to_renalreg);


--
-- Name: index_patients_on_send_to_rpv; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_send_to_rpv ON renalware.patients USING btree (send_to_rpv);


--
-- Name: index_patients_on_sent_to_ukrdc_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_sent_to_ukrdc_at ON renalware.patients USING btree (sent_to_ukrdc_at);


--
-- Name: index_patients_on_ukrdc_anonymise; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_ukrdc_anonymise ON renalware.patients USING btree (ukrdc_anonymise);


--
-- Name: index_patients_on_ukrdc_external_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_ukrdc_external_id ON renalware.patients USING btree (ukrdc_external_id);


--
-- Name: index_patients_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_updated_by_id ON renalware.patients USING btree (updated_by_id);


--
-- Name: index_pd_adequacy_results_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_adequacy_results_on_created_by_id ON renalware.pd_adequacy_results USING btree (created_by_id);


--
-- Name: index_pd_adequacy_results_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_adequacy_results_on_deleted_at ON renalware.pd_adequacy_results USING btree (deleted_at);


--
-- Name: index_pd_adequacy_results_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_adequacy_results_on_patient_id ON renalware.pd_adequacy_results USING btree (patient_id);


--
-- Name: index_pd_adequacy_results_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_adequacy_results_on_updated_by_id ON renalware.pd_adequacy_results USING btree (updated_by_id);


--
-- Name: index_pd_assessments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_assessments_on_created_by_id ON renalware.pd_assessments USING btree (created_by_id);


--
-- Name: index_pd_assessments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_assessments_on_patient_id ON renalware.pd_assessments USING btree (patient_id);


--
-- Name: index_pd_assessments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_assessments_on_updated_by_id ON renalware.pd_assessments USING btree (updated_by_id);


--
-- Name: index_pd_bag_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_bag_types_on_deleted_at ON renalware.pd_bag_types USING btree (deleted_at);


--
-- Name: index_pd_exit_site_infections_on_clinical_presentation; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_exit_site_infections_on_clinical_presentation ON renalware.pd_exit_site_infections USING gin (clinical_presentation);


--
-- Name: index_pd_exit_site_infections_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_exit_site_infections_on_patient_id ON renalware.pd_exit_site_infections USING btree (patient_id);


--
-- Name: index_pd_peritonitis_episode_types_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episode_types_description_id ON renalware.pd_peritonitis_episode_types USING btree (peritonitis_episode_type_description_id);


--
-- Name: index_pd_peritonitis_episodes_on_episode_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_episode_type_id ON renalware.pd_peritonitis_episodes USING btree (episode_type_id);


--
-- Name: index_pd_peritonitis_episodes_on_fluid_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_fluid_description_id ON renalware.pd_peritonitis_episodes USING btree (fluid_description_id);


--
-- Name: index_pd_peritonitis_episodes_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_patient_id ON renalware.pd_peritonitis_episodes USING btree (patient_id);


--
-- Name: index_pd_pet_adequacy_results_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_adequacy_results_on_created_by_id ON renalware.pd_pet_adequacy_results USING btree (created_by_id);


--
-- Name: index_pd_pet_adequacy_results_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_adequacy_results_on_patient_id ON renalware.pd_pet_adequacy_results USING btree (patient_id);


--
-- Name: index_pd_pet_adequacy_results_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_adequacy_results_on_updated_by_id ON renalware.pd_pet_adequacy_results USING btree (updated_by_id);


--
-- Name: index_pd_pet_dextrose_concentrations_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pd_pet_dextrose_concentrations_on_name ON renalware.pd_pet_dextrose_concentrations USING btree (name);


--
-- Name: index_pd_pet_dextrose_concentrations_on_value; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pd_pet_dextrose_concentrations_on_value ON renalware.pd_pet_dextrose_concentrations USING btree (value);


--
-- Name: index_pd_pet_results_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_results_on_created_by_id ON renalware.pd_pet_results USING btree (created_by_id);


--
-- Name: index_pd_pet_results_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_results_on_deleted_at ON renalware.pd_pet_results USING btree (deleted_at);


--
-- Name: index_pd_pet_results_on_dextrose_concentration_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_results_on_dextrose_concentration_id ON renalware.pd_pet_results USING btree (dextrose_concentration_id);


--
-- Name: index_pd_pet_results_on_overnight_dextrose_concentration_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_results_on_overnight_dextrose_concentration_id ON renalware.pd_pet_results USING btree (overnight_dextrose_concentration_id);


--
-- Name: index_pd_pet_results_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_results_on_patient_id ON renalware.pd_pet_results USING btree (patient_id);


--
-- Name: index_pd_pet_results_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_results_on_updated_by_id ON renalware.pd_pet_results USING btree (updated_by_id);


--
-- Name: index_pd_regime_bags_on_bag_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_bags_on_bag_type_id ON renalware.pd_regime_bags USING btree (bag_type_id);


--
-- Name: index_pd_regime_bags_on_regime_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_bags_on_regime_id ON renalware.pd_regime_bags USING btree (regime_id);


--
-- Name: index_pd_regime_terminations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_terminations_on_created_by_id ON renalware.pd_regime_terminations USING btree (created_by_id);


--
-- Name: index_pd_regime_terminations_on_regime_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_terminations_on_regime_id ON renalware.pd_regime_terminations USING btree (regime_id);


--
-- Name: index_pd_regime_terminations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_terminations_on_updated_by_id ON renalware.pd_regime_terminations USING btree (updated_by_id);


--
-- Name: index_pd_regimes_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_created_by_id ON renalware.pd_regimes USING btree (created_by_id);


--
-- Name: index_pd_regimes_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_id_and_type ON renalware.pd_regimes USING btree (id, type);


--
-- Name: index_pd_regimes_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_patient_id ON renalware.pd_regimes USING btree (patient_id);


--
-- Name: index_pd_regimes_on_system_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_system_id ON renalware.pd_regimes USING btree (system_id);


--
-- Name: index_pd_regimes_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_updated_by_id ON renalware.pd_regimes USING btree (updated_by_id);


--
-- Name: index_pd_systems_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_systems_on_deleted_at ON renalware.pd_systems USING btree (deleted_at);


--
-- Name: index_pd_systems_on_pd_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_systems_on_pd_type ON renalware.pd_systems USING btree (pd_type);


--
-- Name: index_pd_training_sessions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_created_by_id ON renalware.pd_training_sessions USING btree (created_by_id);


--
-- Name: index_pd_training_sessions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_patient_id ON renalware.pd_training_sessions USING btree (patient_id);


--
-- Name: index_pd_training_sessions_on_training_site_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_training_site_id ON renalware.pd_training_sessions USING btree (training_site_id);


--
-- Name: index_pd_training_sessions_on_training_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_training_type_id ON renalware.pd_training_sessions USING btree (training_type_id);


--
-- Name: index_pd_training_sessions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_updated_by_id ON renalware.pd_training_sessions USING btree (updated_by_id);


--
-- Name: index_problem_comorbidities_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_comorbidities_on_created_by_id ON renalware.problem_comorbidities USING btree (created_by_id);


--
-- Name: index_problem_comorbidities_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_comorbidities_on_description_id ON renalware.problem_comorbidities USING btree (description_id);


--
-- Name: index_problem_comorbidities_on_malignancy_site_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_comorbidities_on_malignancy_site_id ON renalware.problem_comorbidities USING btree (malignancy_site_id);


--
-- Name: index_problem_comorbidities_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_comorbidities_on_patient_id ON renalware.problem_comorbidities USING btree (patient_id);


--
-- Name: index_problem_comorbidities_on_patient_id_and_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_problem_comorbidities_on_patient_id_and_description_id ON renalware.problem_comorbidities USING btree (patient_id, description_id);


--
-- Name: INDEX index_problem_comorbidities_on_patient_id_and_description_id; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.index_problem_comorbidities_on_patient_id_and_description_id IS 'Only 1 unique description allowed per patient';


--
-- Name: index_problem_comorbidities_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_comorbidities_on_updated_by_id ON renalware.problem_comorbidities USING btree (updated_by_id);


--
-- Name: index_problem_comorbidity_descriptions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_comorbidity_descriptions_on_deleted_at ON renalware.problem_comorbidity_descriptions USING btree (deleted_at);


--
-- Name: index_problem_comorbidity_descriptions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_problem_comorbidity_descriptions_on_name ON renalware.problem_comorbidity_descriptions USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: index_problem_comorbidity_descriptions_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_comorbidity_descriptions_on_position ON renalware.problem_comorbidity_descriptions USING btree ("position");


--
-- Name: index_problem_malignancy_sites_on_description; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_problem_malignancy_sites_on_description ON renalware.problem_malignancy_sites USING btree (description);


--
-- Name: index_problem_notes_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_notes_on_created_by_id ON renalware.problem_notes USING btree (created_by_id);


--
-- Name: index_problem_notes_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_notes_on_deleted_at ON renalware.problem_notes USING btree (deleted_at);


--
-- Name: index_problem_notes_on_problem_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_notes_on_problem_id ON renalware.problem_notes USING btree (problem_id);


--
-- Name: index_problem_notes_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_notes_on_updated_by_id ON renalware.problem_notes USING btree (updated_by_id);


--
-- Name: index_problem_problems_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_created_by_id ON renalware.problem_problems USING btree (created_by_id);


--
-- Name: index_problem_problems_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_deleted_at ON renalware.problem_problems USING btree (deleted_at);


--
-- Name: index_problem_problems_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_patient_id ON renalware.problem_problems USING btree (patient_id);


--
-- Name: index_problem_problems_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_position ON renalware.problem_problems USING btree ("position");


--
-- Name: index_problem_problems_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_updated_by_id ON renalware.problem_problems USING btree (updated_by_id);


--
-- Name: index_problem_radar_cohorts_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_problem_radar_cohorts_on_name ON renalware.problem_radar_cohorts USING btree (name);


--
-- Name: index_problem_radar_diagnoses_on_cohort_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_radar_diagnoses_on_cohort_id ON renalware.problem_radar_diagnoses USING btree (cohort_id);


--
-- Name: index_problem_radar_diagnoses_on_cohort_id_and_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_problem_radar_diagnoses_on_cohort_id_and_name ON renalware.problem_radar_diagnoses USING btree (cohort_id, name);


--
-- Name: index_problem_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_versions_on_item_type_and_item_id ON renalware.problem_versions USING btree (item_type, item_id);


--
-- Name: index_remote_monitoring_frequencies_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_remote_monitoring_frequencies_on_deleted_at ON renalware.remote_monitoring_frequencies USING btree (deleted_at);


--
-- Name: index_remote_monitoring_frequencies_on_period; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_remote_monitoring_frequencies_on_period ON renalware.remote_monitoring_frequencies USING btree (period) WHERE (deleted_at IS NULL);


--
-- Name: index_remote_monitoring_frequencies_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_remote_monitoring_frequencies_on_position ON renalware.remote_monitoring_frequencies USING btree ("position");


--
-- Name: index_remote_monitoring_referral_reasons_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_remote_monitoring_referral_reasons_on_deleted_at ON renalware.remote_monitoring_referral_reasons USING btree (deleted_at);


--
-- Name: index_remote_monitoring_referral_reasons_on_description; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_remote_monitoring_referral_reasons_on_description ON renalware.remote_monitoring_referral_reasons USING btree (description) WHERE (deleted_at IS NULL);


--
-- Name: index_remote_monitoring_referral_reasons_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_remote_monitoring_referral_reasons_on_position ON renalware.remote_monitoring_referral_reasons USING btree ("position");


--
-- Name: index_renal_aki_alert_actions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alert_actions_on_name ON renalware.renal_aki_alert_actions USING btree (name);


--
-- Name: index_renal_aki_alerts_on_action; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_action ON renalware.renal_aki_alerts USING btree (action);


--
-- Name: index_renal_aki_alerts_on_action_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_action_id ON renalware.renal_aki_alerts USING btree (action_id);


--
-- Name: index_renal_aki_alerts_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_created_by_id ON renalware.renal_aki_alerts USING btree (created_by_id);


--
-- Name: index_renal_aki_alerts_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_hospital_centre_id ON renalware.renal_aki_alerts USING btree (hospital_centre_id);


--
-- Name: index_renal_aki_alerts_on_hospital_ward_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_hospital_ward_id ON renalware.renal_aki_alerts USING btree (hospital_ward_id);


--
-- Name: index_renal_aki_alerts_on_hotlist; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_hotlist ON renalware.renal_aki_alerts USING btree (hotlist);


--
-- Name: index_renal_aki_alerts_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_patient_id ON renalware.renal_aki_alerts USING btree (patient_id);


--
-- Name: index_renal_aki_alerts_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_updated_by_id ON renalware.renal_aki_alerts USING btree (updated_by_id);


--
-- Name: index_renal_prd_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_renal_prd_descriptions_on_code ON renalware.renal_prd_descriptions USING btree (code);


--
-- Name: index_renal_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_profiles_on_document ON renalware.renal_profiles USING gin (document);


--
-- Name: index_renal_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_renal_profiles_on_patient_id ON renalware.renal_profiles USING btree (patient_id);


--
-- Name: index_renal_profiles_on_prd_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_profiles_on_prd_description_id ON renalware.renal_profiles USING btree (prd_description_id);


--
-- Name: index_renal_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_versions_on_item_type_and_item_id ON renalware.renal_versions USING btree (item_type, item_id);


--
-- Name: index_renalware.hd_provider_units_on_hd_provider_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_provider_units_on_hd_provider_id" ON renalware.hd_provider_units USING btree (hd_provider_id);


--
-- Name: index_renalware.hd_provider_units_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_provider_units_on_hospital_unit_id" ON renalware.hd_provider_units USING btree (hospital_unit_id);


--
-- Name: index_renalware.hd_provider_units_on_providers_reference; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_provider_units_on_providers_reference" ON renalware.hd_provider_units USING btree (providers_reference);


--
-- Name: index_renalware.hd_transmission_logs_on_direction; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_direction" ON renalware.hd_transmission_logs USING btree (direction);


--
-- Name: index_renalware.hd_transmission_logs_on_format; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_format" ON renalware.hd_transmission_logs USING btree (format);


--
-- Name: index_renalware.hd_transmission_logs_on_hd_provider_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_hd_provider_unit_id" ON renalware.hd_transmission_logs USING btree (hd_provider_unit_id);


--
-- Name: index_renalware.hd_transmission_logs_on_parent_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_parent_id" ON renalware.hd_transmission_logs USING btree (parent_id);


--
-- Name: index_renalware.hd_transmission_logs_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_patient_id" ON renalware.hd_transmission_logs USING btree (patient_id);


--
-- Name: index_renalware.hd_transmission_logs_on_result; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_result" ON renalware.hd_transmission_logs USING gin (result);


--
-- Name: index_renalware.hd_transmission_logs_on_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_status" ON renalware.hd_transmission_logs USING btree (status);


--
-- Name: index_renalware.hd_transmission_logs_on_transmitted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_transmitted_at" ON renalware.hd_transmission_logs USING btree (transmitted_at);


--
-- Name: index_reporting_hd_blood_pressures_audit_on_hospital_unit_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_reporting_hd_blood_pressures_audit_on_hospital_unit_name ON renalware.reporting_hd_blood_pressures_audit USING btree (hospital_unit_name);


--
-- Name: index_research_investigatorships_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_investigatorships_on_created_by_id ON renalware.research_investigatorships USING btree (created_by_id);


--
-- Name: index_research_investigatorships_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_investigatorships_on_deleted_at ON renalware.research_investigatorships USING btree (deleted_at);


--
-- Name: index_research_investigatorships_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_investigatorships_on_document ON renalware.research_investigatorships USING gin (document);


--
-- Name: index_research_investigatorships_on_study_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_investigatorships_on_study_id ON renalware.research_investigatorships USING btree (study_id);


--
-- Name: index_research_investigatorships_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_investigatorships_on_updated_by_id ON renalware.research_investigatorships USING btree (updated_by_id);


--
-- Name: index_research_investigatorships_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_investigatorships_on_user_id ON renalware.research_investigatorships USING btree (user_id);


--
-- Name: index_research_participations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_participations_on_created_by_id ON renalware.research_participations USING btree (created_by_id);


--
-- Name: index_research_participations_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_participations_on_deleted_at ON renalware.research_participations USING btree (deleted_at);


--
-- Name: index_research_participations_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_participations_on_document ON renalware.research_participations USING gin (document);


--
-- Name: index_research_participations_on_external_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_research_participations_on_external_id ON renalware.research_participations USING btree (external_id);


--
-- Name: index_research_participations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_participations_on_patient_id ON renalware.research_participations USING btree (patient_id);


--
-- Name: index_research_participations_on_study_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_participations_on_study_id ON renalware.research_participations USING btree (study_id);


--
-- Name: index_research_participations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_participations_on_updated_by_id ON renalware.research_participations USING btree (updated_by_id);


--
-- Name: index_research_studies_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_research_studies_on_code ON renalware.research_studies USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: index_research_studies_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_created_by_id ON renalware.research_studies USING btree (created_by_id);


--
-- Name: index_research_studies_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_deleted_at ON renalware.research_studies USING btree (deleted_at);


--
-- Name: index_research_studies_on_description; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_description ON renalware.research_studies USING btree (description);


--
-- Name: index_research_studies_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_document ON renalware.research_studies USING gin (document);


--
-- Name: index_research_studies_on_leader; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_leader ON renalware.research_studies USING btree (leader);


--
-- Name: index_research_studies_on_private; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_private ON renalware.research_studies USING btree (private);


--
-- Name: index_research_studies_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_updated_by_id ON renalware.research_studies USING btree (updated_by_id);


--
-- Name: index_research_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_versions_on_item_type_and_item_id ON renalware.research_versions USING btree (item_type, item_id);


--
-- Name: index_research_versions_on_whodunnit; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_versions_on_whodunnit ON renalware.research_versions USING btree (whodunnit);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_roles_on_name ON renalware.roles USING btree (name);


--
-- Name: index_roles_users_on_role_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_roles_users_on_role_id ON renalware.roles_users USING btree (role_id);


--
-- Name: index_roles_users_on_user_id_and_role_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_roles_users_on_user_id_and_role_id ON renalware.roles_users USING btree (user_id, role_id);


--
-- Name: index_snippets_snippets_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_snippets_snippets_on_author_id ON renalware.snippets_snippets USING btree (author_id);


--
-- Name: index_snippets_snippets_on_title; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_snippets_snippets_on_title ON renalware.snippets_snippets USING btree (title);


--
-- Name: index_survey_questions_on_code_and_survey_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_survey_questions_on_code_and_survey_id ON renalware.survey_questions USING btree (code, survey_id) WHERE (deleted_at IS NULL);


--
-- Name: index_survey_questions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_survey_questions_on_deleted_at ON renalware.survey_questions USING btree (deleted_at);


--
-- Name: index_survey_questions_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_survey_questions_on_position ON renalware.survey_questions USING btree ("position");


--
-- Name: index_survey_questions_on_survey_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_survey_questions_on_survey_id ON renalware.survey_questions USING btree (survey_id);


--
-- Name: index_survey_questions_on_survey_id_and_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_survey_questions_on_survey_id_and_code ON renalware.survey_questions USING btree (survey_id, code) WHERE (deleted_at IS NULL);


--
-- Name: index_survey_responses_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_survey_responses_on_patient_id ON renalware.survey_responses USING btree (patient_id);


--
-- Name: index_survey_responses_on_question_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_survey_responses_on_question_id ON renalware.survey_responses USING btree (question_id);


--
-- Name: index_survey_surveys_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_survey_surveys_on_code ON renalware.survey_surveys USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: index_survey_surveys_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_survey_surveys_on_deleted_at ON renalware.survey_surveys USING btree (deleted_at);


--
-- Name: index_survey_surveys_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_survey_surveys_on_name ON renalware.survey_surveys USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: index_system_api_logs_on_identifier; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_api_logs_on_identifier ON renalware.system_api_logs USING btree (identifier);


--
-- Name: index_system_api_logs_on_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_api_logs_on_status ON renalware.system_api_logs USING btree (status);


--
-- Name: index_system_components_on_class_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_components_on_class_name ON renalware.system_components USING btree (class_name);


--
-- Name: index_system_components_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_components_on_name ON renalware.system_components USING btree (name);


--
-- Name: index_system_components_on_roles; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_components_on_roles ON renalware.system_components USING btree (roles);


--
-- Name: index_system_countries_on_alpha2; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_countries_on_alpha2 ON renalware.system_countries USING btree (alpha2);


--
-- Name: index_system_countries_on_alpha3; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_countries_on_alpha3 ON renalware.system_countries USING btree (alpha3);


--
-- Name: index_system_countries_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_countries_on_name ON renalware.system_countries USING btree (name);


--
-- Name: index_system_countries_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_countries_on_position ON renalware.system_countries USING btree ("position");


--
-- Name: index_system_dashboard_components_on_component_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_dashboard_components_on_component_id ON renalware.system_dashboard_components USING btree (component_id);


--
-- Name: index_system_dashboards_on_cloned_from_dashboard_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_dashboards_on_cloned_from_dashboard_id ON renalware.system_dashboards USING btree (cloned_from_dashboard_id);


--
-- Name: index_system_dashboards_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_dashboards_on_name ON renalware.system_dashboards USING btree (name);


--
-- Name: index_system_dashboards_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_dashboards_on_user_id ON renalware.system_dashboards USING btree (user_id);


--
-- Name: index_system_downloads_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_downloads_on_created_by_id ON renalware.system_downloads USING btree (created_by_id);


--
-- Name: index_system_downloads_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_downloads_on_deleted_at ON renalware.system_downloads USING btree (deleted_at);


--
-- Name: index_system_downloads_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_downloads_on_name ON renalware.system_downloads USING btree (name);


--
-- Name: index_system_downloads_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_downloads_on_updated_by_id ON renalware.system_downloads USING btree (updated_by_id);


--
-- Name: index_system_events_on_name_and_time; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_name_and_time ON renalware.system_events USING btree (name, "time");


--
-- Name: index_system_events_on_properties_jsonb_path_ops; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_properties_jsonb_path_ops ON renalware.system_events USING gin (properties jsonb_path_ops);


--
-- Name: index_system_events_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_user_id ON renalware.system_events USING btree (user_id);


--
-- Name: index_system_events_on_visit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_visit_id ON renalware.system_events USING btree (visit_id);


--
-- Name: index_system_logs_on_group; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_logs_on_group ON renalware.system_logs USING btree ("group");


--
-- Name: index_system_logs_on_owner_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_logs_on_owner_id ON renalware.system_logs USING btree (owner_id);


--
-- Name: index_system_logs_on_severity; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_logs_on_severity ON renalware.system_logs USING btree (severity);


--
-- Name: index_system_nag_definitions_on_description; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_nag_definitions_on_description ON renalware.system_nag_definitions USING btree (description);


--
-- Name: index_system_nag_definitions_on_enabled; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_nag_definitions_on_enabled ON renalware.system_nag_definitions USING btree (enabled);


--
-- Name: index_system_nag_definitions_on_scope_and_importance; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_nag_definitions_on_scope_and_importance ON renalware.system_nag_definitions USING btree (scope, importance);


--
-- Name: index_system_online_reference_links_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_online_reference_links_on_created_by_id ON renalware.system_online_reference_links USING btree (created_by_id);


--
-- Name: index_system_online_reference_links_on_title; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_online_reference_links_on_title ON renalware.system_online_reference_links USING btree (title);


--
-- Name: index_system_online_reference_links_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_online_reference_links_on_updated_by_id ON renalware.system_online_reference_links USING btree (updated_by_id);


--
-- Name: index_system_online_reference_links_on_url; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_online_reference_links_on_url ON renalware.system_online_reference_links USING btree (url);


--
-- Name: index_system_templates_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_templates_on_name ON renalware.system_templates USING btree (name);


--
-- Name: index_system_user_feedback_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_user_feedback_on_author_id ON renalware.system_user_feedback USING btree (author_id);


--
-- Name: index_system_user_feedback_on_category; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_user_feedback_on_category ON renalware.system_user_feedback USING btree (category);


--
-- Name: index_system_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_versions_on_item_type_and_item_id ON renalware.system_versions USING btree (item_type, item_id);


--
-- Name: index_system_view_calls_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_view_calls_on_user_id ON renalware.system_view_calls USING btree (user_id);


--
-- Name: index_system_view_calls_on_view_metadata_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_view_calls_on_view_metadata_id ON renalware.system_view_calls USING btree (view_metadata_id);


--
-- Name: index_system_view_metadata_on_parent_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_view_metadata_on_parent_id ON renalware.system_view_metadata USING btree (parent_id);


--
-- Name: index_system_visits_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_visits_on_user_id ON renalware.system_visits USING btree (user_id);


--
-- Name: index_system_visits_on_visit_token; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_visits_on_visit_token ON renalware.system_visits USING btree (visit_token);


--
-- Name: index_transplant_donations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donations_on_patient_id ON renalware.transplant_donations USING btree (patient_id);


--
-- Name: index_transplant_donations_on_recipient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donations_on_recipient_id ON renalware.transplant_donations USING btree (recipient_id);


--
-- Name: index_transplant_donor_followups_on_operation_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_followups_on_operation_id ON renalware.transplant_donor_followups USING btree (operation_id);


--
-- Name: index_transplant_donor_operations_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_operations_on_document ON renalware.transplant_donor_operations USING gin (document);


--
-- Name: index_transplant_donor_operations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_operations_on_patient_id ON renalware.transplant_donor_operations USING btree (patient_id);


--
-- Name: index_transplant_donor_stage_positions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_donor_stage_positions_on_name ON renalware.transplant_donor_stage_positions USING btree (name);


--
-- Name: index_transplant_donor_stage_positions_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stage_positions_on_position ON renalware.transplant_donor_stage_positions USING btree ("position");


--
-- Name: index_transplant_donor_stage_statuses_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_donor_stage_statuses_on_name ON renalware.transplant_donor_stage_statuses USING btree (name);


--
-- Name: index_transplant_donor_stage_statuses_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stage_statuses_on_position ON renalware.transplant_donor_stage_statuses USING btree ("position");


--
-- Name: index_transplant_donor_stages_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stages_on_created_by_id ON renalware.transplant_donor_stages USING btree (created_by_id);


--
-- Name: index_transplant_donor_stages_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stages_on_patient_id ON renalware.transplant_donor_stages USING btree (patient_id);


--
-- Name: index_transplant_donor_stages_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stages_on_updated_by_id ON renalware.transplant_donor_stages USING btree (updated_by_id);


--
-- Name: index_transplant_donor_workups_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_workups_on_document ON renalware.transplant_donor_workups USING gin (document);


--
-- Name: index_transplant_donor_workups_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_workups_on_patient_id ON renalware.transplant_donor_workups USING btree (patient_id);


--
-- Name: index_transplant_failure_cause_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_failure_cause_descriptions_on_code ON renalware.transplant_failure_cause_descriptions USING btree (code);


--
-- Name: index_transplant_failure_cause_descriptions_on_group_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_failure_cause_descriptions_on_group_id ON renalware.transplant_failure_cause_descriptions USING btree (group_id);


--
-- Name: index_transplant_induction_agents_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_induction_agents_on_name ON renalware.transplant_induction_agents USING btree (lower(name));


--
-- Name: index_transplant_investigation_types_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_investigation_types_on_code ON renalware.transplant_investigation_types USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: index_transplant_investigation_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_investigation_types_on_deleted_at ON renalware.transplant_investigation_types USING btree (deleted_at);


--
-- Name: index_transplant_recipient_followups_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_followups_on_document ON renalware.transplant_recipient_followups USING gin (document);


--
-- Name: index_transplant_recipient_followups_on_operation_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_followups_on_operation_id ON renalware.transplant_recipient_followups USING btree (operation_id);


--
-- Name: index_transplant_recipient_operations_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_document ON renalware.transplant_recipient_operations USING gin (document);


--
-- Name: index_transplant_recipient_operations_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_hospital_centre_id ON renalware.transplant_recipient_operations USING btree (hospital_centre_id);


--
-- Name: index_transplant_recipient_operations_on_induction_agent_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_induction_agent_id ON renalware.transplant_recipient_operations USING btree (induction_agent_id);


--
-- Name: index_transplant_recipient_operations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_patient_id ON renalware.transplant_recipient_operations USING btree (patient_id);


--
-- Name: index_transplant_recipient_workups_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_created_by_id ON renalware.transplant_recipient_workups USING btree (created_by_id);


--
-- Name: index_transplant_recipient_workups_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_document ON renalware.transplant_recipient_workups USING gin (document);


--
-- Name: index_transplant_recipient_workups_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_patient_id ON renalware.transplant_recipient_workups USING btree (patient_id);


--
-- Name: index_transplant_recipient_workups_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_updated_by_id ON renalware.transplant_recipient_workups USING btree (updated_by_id);


--
-- Name: index_transplant_registration_status_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_status_descriptions_on_code ON renalware.transplant_registration_status_descriptions USING btree (code);


--
-- Name: index_transplant_registration_status_descriptions_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_status_descriptions_on_position ON renalware.transplant_registration_status_descriptions USING btree ("position");


--
-- Name: index_transplant_registration_statuses_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_created_by_id ON renalware.transplant_registration_statuses USING btree (created_by_id);


--
-- Name: index_transplant_registration_statuses_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_description_id ON renalware.transplant_registration_statuses USING btree (description_id);


--
-- Name: index_transplant_registration_statuses_on_registration_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_registration_id ON renalware.transplant_registration_statuses USING btree (registration_id);


--
-- Name: index_transplant_registration_statuses_on_started_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_started_on ON renalware.transplant_registration_statuses USING btree (started_on);


--
-- Name: index_transplant_registration_statuses_on_terminated_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_terminated_on ON renalware.transplant_registration_statuses USING btree (terminated_on);


--
-- Name: index_transplant_registration_statuses_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_updated_by_id ON renalware.transplant_registration_statuses USING btree (updated_by_id);


--
-- Name: index_transplant_registrations_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registrations_on_document ON renalware.transplant_registrations USING gin (document);


--
-- Name: index_transplant_registrations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_registrations_on_patient_id ON renalware.transplant_registrations USING btree (patient_id);


--
-- Name: index_transplant_rejection_episodes_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_rejection_episodes_on_created_by_id ON renalware.transplant_rejection_episodes USING btree (created_by_id);


--
-- Name: index_transplant_rejection_episodes_on_followup_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_rejection_episodes_on_followup_id ON renalware.transplant_rejection_episodes USING btree (followup_id);


--
-- Name: index_transplant_rejection_episodes_on_treatment_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_rejection_episodes_on_treatment_id ON renalware.transplant_rejection_episodes USING btree (treatment_id);


--
-- Name: index_transplant_rejection_episodes_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_rejection_episodes_on_updated_by_id ON renalware.transplant_rejection_episodes USING btree (updated_by_id);


--
-- Name: index_transplant_rejection_treatments_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_rejection_treatments_on_name ON renalware.transplant_rejection_treatments USING btree (name);


--
-- Name: index_transplant_rejection_treatments_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_rejection_treatments_on_position ON renalware.transplant_rejection_treatments USING btree ("position");


--
-- Name: index_transplant_versions_on_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_versions_on_item_id ON renalware.transplant_versions USING btree (item_id);


--
-- Name: index_ukrdc_measurement_units_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_measurement_units_on_name ON renalware.ukrdc_measurement_units USING btree (name);


--
-- Name: index_ukrdc_modality_codes_on_qbl_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_modality_codes_on_qbl_code ON renalware.ukrdc_modality_codes USING btree (qbl_code);


--
-- Name: index_ukrdc_modality_codes_on_txt_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_modality_codes_on_txt_code ON renalware.ukrdc_modality_codes USING btree (txt_code);


--
-- Name: index_ukrdc_transmission_logs_on_batch_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_transmission_logs_on_batch_id ON renalware.ukrdc_transmission_logs USING btree (batch_id);


--
-- Name: index_ukrdc_transmission_logs_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_transmission_logs_on_patient_id ON renalware.ukrdc_transmission_logs USING btree (patient_id);


--
-- Name: index_ukrdc_transmission_logs_on_request_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_transmission_logs_on_request_uuid ON renalware.ukrdc_transmission_logs USING btree (request_uuid);


--
-- Name: index_ukrdc_treatments_on_clinician_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_clinician_id ON renalware.ukrdc_treatments USING btree (clinician_id);


--
-- Name: index_ukrdc_treatments_on_hd_profile_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_hd_profile_id ON renalware.ukrdc_treatments USING btree (hd_profile_id);


--
-- Name: index_ukrdc_treatments_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_hospital_centre_id ON renalware.ukrdc_treatments USING btree (hospital_centre_id);


--
-- Name: index_ukrdc_treatments_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_hospital_unit_id ON renalware.ukrdc_treatments USING btree (hospital_unit_id);


--
-- Name: index_ukrdc_treatments_on_modality_code_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_modality_code_id ON renalware.ukrdc_treatments USING btree (modality_code_id);


--
-- Name: index_ukrdc_treatments_on_modality_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_modality_description_id ON renalware.ukrdc_treatments USING btree (modality_description_id);


--
-- Name: index_ukrdc_treatments_on_modality_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_modality_id ON renalware.ukrdc_treatments USING btree (modality_id);


--
-- Name: index_ukrdc_treatments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_patient_id ON renalware.ukrdc_treatments USING btree (patient_id);


--
-- Name: index_ukrdc_treatments_on_pd_regime_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_treatments_on_pd_regime_id ON renalware.ukrdc_treatments USING btree (pd_regime_id);


--
-- Name: index_user_group_memberships_on_user_group_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_user_group_memberships_on_user_group_id ON renalware.user_group_memberships USING btree (user_group_id);


--
-- Name: index_user_group_memberships_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_user_group_memberships_on_user_id ON renalware.user_group_memberships USING btree (user_id);


--
-- Name: index_user_group_memberships_on_user_id_and_user_group_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_user_group_memberships_on_user_id_and_user_group_id ON renalware.user_group_memberships USING btree (user_id, user_group_id);


--
-- Name: index_user_groups_on_active; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_user_groups_on_active ON renalware.user_groups USING btree (active);


--
-- Name: index_user_groups_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_user_groups_on_created_by_id ON renalware.user_groups USING btree (created_by_id);


--
-- Name: index_user_groups_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_user_groups_on_name ON renalware.user_groups USING btree (name);


--
-- Name: index_user_groups_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_user_groups_on_updated_by_id ON renalware.user_groups USING btree (updated_by_id);


--
-- Name: index_users_on_approved; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_approved ON renalware.users USING btree (approved);


--
-- Name: index_users_on_expired_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_expired_at ON renalware.users USING btree (expired_at);


--
-- Name: index_users_on_family_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_family_name ON renalware.users USING btree (family_name);


--
-- Name: index_users_on_given_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_given_name ON renalware.users USING btree (given_name);


--
-- Name: index_users_on_hidden; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_hidden ON renalware.users USING btree (hidden);


--
-- Name: index_users_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_hospital_centre_id ON renalware.users USING btree (hospital_centre_id);


--
-- Name: index_users_on_last_activity_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_last_activity_at ON renalware.users USING btree (last_activity_at);


--
-- Name: index_users_on_lower_email; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_users_on_lower_email ON renalware.users USING btree (lower((email)::text));


--
-- Name: index_users_on_lower_username; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_users_on_lower_username ON renalware.users USING btree (lower((username)::text));


--
-- Name: index_users_on_password_changed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_password_changed_at ON renalware.users USING btree (password_changed_at);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON renalware.users USING btree (reset_password_token);


--
-- Name: index_users_on_signature; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_signature ON renalware.users USING btree (signature);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON renalware.users USING btree (unlock_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON renalware.versions USING btree (item_type, item_id);


--
-- Name: index_virology_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_profiles_on_created_by_id ON renalware.virology_profiles USING btree (created_by_id);


--
-- Name: index_virology_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_profiles_on_document ON renalware.virology_profiles USING gin (document);


--
-- Name: index_virology_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_virology_profiles_on_patient_id ON renalware.virology_profiles USING btree (patient_id);


--
-- Name: index_virology_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_profiles_on_updated_by_id ON renalware.virology_profiles USING btree (updated_by_id);


--
-- Name: index_virology_vaccination_types_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_virology_vaccination_types_on_code ON renalware.virology_vaccination_types USING btree (code);


--
-- Name: index_virology_vaccination_types_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_virology_vaccination_types_on_name ON renalware.virology_vaccination_types USING btree (name);


--
-- Name: index_virology_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_versions_on_item_type_and_item_id ON renalware.virology_versions USING btree (item_type, item_id);


--
-- Name: letter_effective_date_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX letter_effective_date_idx ON renalware.letter_letters USING btree (COALESCE(completed_at, approved_at, submitted_for_approval_at, created_at));


--
-- Name: letter_online_references_uniq_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX letter_online_references_uniq_idx ON renalware.letter_qr_encoded_online_reference_links USING btree (letter_id, online_reference_link_id);


--
-- Name: INDEX letter_online_references_uniq_idx; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.letter_online_references_uniq_idx IS 'A letter cannot have duplicate online references';


--
-- Name: master_index_hd_diaries_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX master_index_hd_diaries_on_hospital_unit_id ON renalware.hd_diaries USING btree (hospital_unit_id) WHERE (master = true);


--
-- Name: obx_unique_display_grouping; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX obx_unique_display_grouping ON renalware.pathology_observation_descriptions USING btree (display_group, display_order);


--
-- Name: obx_unique_letter_grouping; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX obx_unique_letter_grouping ON renalware.pathology_observation_descriptions USING btree (letter_group, letter_order);


--
-- Name: pathology_calculation_sources_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX pathology_calculation_sources_idx ON renalware.pathology_calculation_sources USING btree (calculated_observation_id, source_observation_id);


--
-- Name: pathology_code_group_membership_obx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX pathology_code_group_membership_obx ON renalware.pathology_code_group_memberships USING btree (observation_description_id);


--
-- Name: pathology_observation_descriptions_sender; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX pathology_observation_descriptions_sender ON renalware.pathology_observation_descriptions USING btree (created_by_sender_id);


--
-- Name: pathology_obx_mappings_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX pathology_obx_mappings_uniqueness ON renalware.pathology_obx_mappings USING btree (code_alias, sender_id);


--
-- Name: INDEX pathology_obx_mappings_uniqueness; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON INDEX renalware.pathology_obx_mappings_uniqueness IS 'Ensures only one mapping row per sender + code_alias.';


--
-- Name: pathology_senders_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX pathology_senders_idx ON renalware.pathology_senders USING btree (sending_facility, sending_application);


--
-- Name: patient_bookmarks_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX patient_bookmarks_uniqueness ON renalware.patient_bookmarks USING btree (patient_id, user_id, COALESCE(deleted_at, '1970-01-01 00:00:00'::timestamp without time zone));


--
-- Name: patient_versions_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX patient_versions_versions_type_id ON renalware.patient_versions USING btree (item_type, item_id);


--
-- Name: pd_peritonitis_episode_types_unique_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX pd_peritonitis_episode_types_unique_id ON renalware.pd_peritonitis_episode_types USING btree (peritonitis_episode_id, peritonitis_episode_type_description_id);


--
-- Name: prd_required_observation_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prd_required_observation_description_id_idx ON renalware.pathology_request_descriptions USING btree (required_observation_description_id);


--
-- Name: prddc_drug_category_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prddc_drug_category_id_idx ON renalware.pathology_requests_drugs_drug_categories USING btree (drug_category_id);


--
-- Name: prddc_request_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prddc_request_description_id_idx ON renalware.pathology_requests_global_rule_sets USING btree (request_description_id);


--
-- Name: prdr_requests_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prdr_requests_description_id_idx ON renalware.pathology_request_descriptions_requests_requests USING btree (request_description_id);


--
-- Name: prdr_requests_request_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prdr_requests_request_id_idx ON renalware.pathology_request_descriptions_requests_requests USING btree (request_id);


--
-- Name: prgr_rule_set_id_and_rule_set_type_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prgr_rule_set_id_and_rule_set_type_idx ON renalware.pathology_requests_global_rules USING btree (rule_set_id, rule_set_type);


--
-- Name: prprr_patient_rule_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prprr_patient_rule_id_idx ON renalware.pathology_requests_patient_rules_requests USING btree (patient_rule_id);


--
-- Name: survey_responses_compound_index; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX survey_responses_compound_index ON renalware.survey_responses USING btree (answered_on, patient_id, question_id);


--
-- Name: tx_donor_stage_position_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_donor_stage_position_idx ON renalware.transplant_donor_stages USING btree (stage_position_id);


--
-- Name: tx_donor_stage_status_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_donor_stage_status_idx ON renalware.transplant_donor_stages USING btree (stage_status_id);


--
-- Name: tx_recip_fol_failure_cause_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_recip_fol_failure_cause_description_id_idx ON renalware.transplant_recipient_followups USING btree (transplant_failure_cause_description_id);


--
-- Name: tx_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_versions_type_id ON renalware.transplant_versions USING btree (item_type, item_id);


--
-- Name: unique_study_participants; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX unique_study_participants ON renalware.research_participations USING btree (patient_id, study_id) WHERE (deleted_at IS NULL);


--
-- Name: index_solid_cache_entries_on_byte_size; Type: INDEX; Schema: renalware_demo; Owner: -
--

CREATE INDEX index_solid_cache_entries_on_byte_size ON renalware_demo.solid_cache_entries USING btree (byte_size);


--
-- Name: index_solid_cache_entries_on_key_hash; Type: INDEX; Schema: renalware_demo; Owner: -
--

CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON renalware_demo.solid_cache_entries USING btree (key_hash);


--
-- Name: index_solid_cache_entries_on_key_hash_and_byte_size; Type: INDEX; Schema: renalware_demo; Owner: -
--

CREATE INDEX index_solid_cache_entries_on_key_hash_and_byte_size ON renalware_demo.solid_cache_entries USING btree (key_hash, byte_size);


--
-- Name: delayed_jobs feed_messages_preprocessing_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER feed_messages_preprocessing_trigger BEFORE INSERT ON renalware.delayed_jobs FOR EACH ROW EXECUTE FUNCTION renalware.preprocess_hl7_message();


--
-- Name: pathology_observations update_current_observation_set_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER update_current_observation_set_trigger AFTER INSERT OR UPDATE ON renalware.pathology_observations FOR EACH ROW EXECUTE FUNCTION renalware.update_current_observation_set_from_trigger();


--
-- Name: hd_sessions update_hd_sessions_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER update_hd_sessions_trigger BEFORE INSERT OR UPDATE ON renalware.hd_sessions FOR EACH ROW EXECUTE FUNCTION renalware.update_hd_sessions_from_trigger();


--
-- Name: pathology_observations update_pathology_observations_nresult_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER update_pathology_observations_nresult_trigger BEFORE INSERT OR UPDATE ON renalware.pathology_observations FOR EACH ROW EXECUTE FUNCTION renalware.update_pathology_observations_nresult_from_trigger();


--
-- Name: TRIGGER update_pathology_observations_nresult_trigger ON pathology_observations; Type: COMMENT; Schema: renalware; Owner: -
--

COMMENT ON TRIGGER update_pathology_observations_nresult_trigger ON renalware.pathology_observations IS 'When a row is updated or inserted into pathology_observations, call a function to try and
coerce the result into a new float column which can be more easily consumed for graphing etc';


--
-- Name: research_participations update_research_study_participants_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER update_research_study_participants_trigger BEFORE INSERT ON renalware.research_participations FOR EACH ROW EXECUTE FUNCTION renalware.update_research_study_participants_from_trigger();


--
-- Name: access_assessments access_assessments_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_assessments
    ADD CONSTRAINT access_assessments_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: access_assessments access_assessments_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_assessments
    ADD CONSTRAINT access_assessments_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: access_procedures access_procedures_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_procedures
    ADD CONSTRAINT access_procedures_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: access_procedures access_procedures_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_procedures
    ADD CONSTRAINT access_procedures_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: access_profiles access_profiles_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_profiles
    ADD CONSTRAINT access_profiles_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: access_profiles access_profiles_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_profiles
    ADD CONSTRAINT access_profiles_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: clinic_visits clinic_visits_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visits
    ADD CONSTRAINT clinic_visits_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: clinic_visits clinic_visits_patient_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visits
    ADD CONSTRAINT clinic_visits_patient_id_fk FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: clinic_visits clinic_visits_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visits
    ADD CONSTRAINT clinic_visits_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: directory_people directory_people_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.directory_people
    ADD CONSTRAINT directory_people_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: directory_people directory_people_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.directory_people
    ADD CONSTRAINT directory_people_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: events events_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.events
    ADD CONSTRAINT events_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: events events_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.events
    ADD CONSTRAINT events_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: patients fk_rails_01ec61436d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_01ec61436d FOREIGN KEY (religion_id) REFERENCES renalware.patient_religions(id);


--
-- Name: clinical_igan_risks fk_rails_0341ed8b89; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_igan_risks
    ADD CONSTRAINT fk_rails_0341ed8b89 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: patients fk_rails_042462eeb9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_042462eeb9 FOREIGN KEY (language_id) REFERENCES renalware.patient_languages(id);


--
-- Name: patient_attachments fk_rails_04327b7e88; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachments
    ADD CONSTRAINT fk_rails_04327b7e88 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: modality_modalities fk_rails_0447199042; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT fk_rails_0447199042 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: feed_logs fk_rails_04812100dd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_logs
    ADD CONSTRAINT fk_rails_04812100dd FOREIGN KEY (message_id) REFERENCES renalware.feed_messages(id);


--
-- Name: pathology_observation_requests fk_rails_050f679712; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_requests
    ADD CONSTRAINT fk_rails_050f679712 FOREIGN KEY (description_id) REFERENCES renalware.pathology_request_descriptions(id);


--
-- Name: virology_profiles fk_rails_05a8d28840; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_profiles
    ADD CONSTRAINT fk_rails_05a8d28840 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_requests_patient_rules_requests fk_rails_06517764c3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules_requests
    ADD CONSTRAINT fk_rails_06517764c3 FOREIGN KEY (patient_rule_id) REFERENCES renalware.pathology_requests_patient_rules(id);


--
-- Name: event_subtypes fk_rails_06e2a8feaf; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_subtypes
    ADD CONSTRAINT fk_rails_06e2a8feaf FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_diaries fk_rails_07d7a349f6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diaries
    ADD CONSTRAINT fk_rails_07d7a349f6 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_schedule_definitions fk_rails_083e4d9774; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_schedule_definitions
    ADD CONSTRAINT fk_rails_083e4d9774 FOREIGN KEY (diurnal_period_id) REFERENCES renalware.hd_diurnal_period_codes(id);


--
-- Name: renal_aki_alerts fk_rails_088cb68322; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts
    ADD CONSTRAINT fk_rails_088cb68322 FOREIGN KEY (hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: hd_prescription_administrations fk_rails_09b9e3828d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_09b9e3828d FOREIGN KEY (administered_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_slot_requests fk_rails_0a97b4f5d5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests
    ADD CONSTRAINT fk_rails_0a97b4f5d5 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_profiles fk_rails_0aab25a07c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT fk_rails_0aab25a07c FOREIGN KEY (named_nurse_id_legacy) REFERENCES renalware.users(id);


--
-- Name: event_types fk_rails_0af1b89c85; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_types
    ADD CONSTRAINT fk_rails_0af1b89c85 FOREIGN KEY (category_id) REFERENCES renalware.event_categories(id);


--
-- Name: transplant_rejection_episodes fk_rails_0b121fa111; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_episodes
    ADD CONSTRAINT fk_rails_0b121fa111 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: transplant_donations fk_rails_0b66891291; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donations
    ADD CONSTRAINT fk_rails_0b66891291 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: renal_aki_alerts fk_rails_0bac5aa8d3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts
    ADD CONSTRAINT fk_rails_0bac5aa8d3 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_electronic_receipts fk_rails_0c14df6b87; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_electronic_receipts
    ADD CONSTRAINT fk_rails_0c14df6b87 FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: modality_modalities fk_rails_0c63f0044a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT fk_rails_0c63f0044a FOREIGN KEY (destination_hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: problem_comorbidities fk_rails_0cf23c6bfe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidities
    ADD CONSTRAINT fk_rails_0cf23c6bfe FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: clinical_allergies fk_rails_0d8b5ebbad; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_allergies
    ADD CONSTRAINT fk_rails_0d8b5ebbad FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: medication_delivery_events fk_rails_0e10e5038b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_events
    ADD CONSTRAINT fk_rails_0e10e5038b FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: access_procedures fk_rails_11c7f6fec3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_procedures
    ADD CONSTRAINT fk_rails_11c7f6fec3 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: pathology_obx_mappings fk_rails_1240cbc05a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_obx_mappings
    ADD CONSTRAINT fk_rails_1240cbc05a FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_vnd_risk_assessments fk_rails_15202d155f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_vnd_risk_assessments
    ADD CONSTRAINT fk_rails_15202d155f FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: transplant_donor_stages fk_rails_15abd8aa8d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stages
    ADD CONSTRAINT fk_rails_15abd8aa8d FOREIGN KEY (stage_status_id) REFERENCES renalware.transplant_donor_stage_statuses(id);


--
-- Name: pathology_requests_patient_rules fk_rails_15f58845a2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules
    ADD CONSTRAINT fk_rails_15f58845a2 FOREIGN KEY (lab_id) REFERENCES renalware.pathology_labs(id);


--
-- Name: pd_adequacy_results fk_rails_16cf8add93; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_adequacy_results
    ADD CONSTRAINT fk_rails_16cf8add93 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: medication_prescriptions fk_rails_17327d4301; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_17327d4301 FOREIGN KEY (medication_route_id) REFERENCES renalware.medication_routes(id);


--
-- Name: letter_descriptions fk_rails_1bc6285553; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_descriptions
    ADD CONSTRAINT fk_rails_1bc6285553 FOREIGN KEY (snomed_document_type_id) REFERENCES renalware.letter_snomed_document_types(id);


--
-- Name: medication_prescription_terminations fk_rails_1f3fb8ef97; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescription_terminations
    ADD CONSTRAINT fk_rails_1f3fb8ef97 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_pet_adequacy_results fk_rails_1f91303c21; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_adequacy_results
    ADD CONSTRAINT fk_rails_1f91303c21 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: problem_radar_diagnoses fk_rails_205f920f0a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_radar_diagnoses
    ADD CONSTRAINT fk_rails_205f920f0a FOREIGN KEY (cohort_id) REFERENCES renalware.problem_radar_cohorts(id);


--
-- Name: hd_diary_slots fk_rails_206582e5c0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots
    ADD CONSTRAINT fk_rails_206582e5c0 FOREIGN KEY (station_id) REFERENCES renalware.hd_stations(id);


--
-- Name: low_clearance_profiles fk_rails_20f40e75a5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_profiles
    ADD CONSTRAINT fk_rails_20f40e75a5 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: research_investigatorships fk_rails_210ebee29e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_investigatorships
    ADD CONSTRAINT fk_rails_210ebee29e FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: modality_modalities fk_rails_21e1b74109; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT fk_rails_21e1b74109 FOREIGN KEY (description_id) REFERENCES renalware.modality_descriptions(id);


--
-- Name: system_dashboard_components fk_rails_222354af97; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_dashboard_components
    ADD CONSTRAINT fk_rails_222354af97 FOREIGN KEY (component_id) REFERENCES renalware.system_components(id);


--
-- Name: patient_worry_categories fk_rails_22a4887738; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worry_categories
    ADD CONSTRAINT fk_rails_22a4887738 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_assessments fk_rails_22dc579c4a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_assessments
    ADD CONSTRAINT fk_rails_22dc579c4a FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_sessions fk_rails_23d8c477eb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_23d8c477eb FOREIGN KEY (dialysate_id) REFERENCES renalware.hd_dialysates(id);


--
-- Name: pathology_obx_mappings fk_rails_244dcc392f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_obx_mappings
    ADD CONSTRAINT fk_rails_244dcc392f FOREIGN KEY (observation_description_id) REFERENCES renalware.pathology_observation_descriptions(id);


--
-- Name: pathology_requests_drugs_drug_categories fk_rails_24de49b694; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_drugs_drug_categories
    ADD CONSTRAINT fk_rails_24de49b694 FOREIGN KEY (drug_id) REFERENCES renalware.drugs(id);


--
-- Name: medication_prescriptions fk_rails_25e627b557; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_25e627b557 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: transplant_recipient_operations fk_rails_261be64bf6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_operations
    ADD CONSTRAINT fk_rails_261be64bf6 FOREIGN KEY (induction_agent_id) REFERENCES renalware.transplant_induction_agents(id);


--
-- Name: survey_responses fk_rails_26b13a300f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_responses
    ADD CONSTRAINT fk_rails_26b13a300f FOREIGN KEY (question_id) REFERENCES renalware.survey_questions(id);


--
-- Name: hd_slot_requests fk_rails_26e1f2feb3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests
    ADD CONSTRAINT fk_rails_26e1f2feb3 FOREIGN KEY (access_state_id) REFERENCES renalware.hd_slot_request_access_states(id);


--
-- Name: patient_worries fk_rails_27dc6e2dc8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worries
    ADD CONSTRAINT fk_rails_27dc6e2dc8 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: medication_prescriptions fk_rails_27e92c81fe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_27e92c81fe FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: admission_consults fk_rails_2805127005; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults
    ADD CONSTRAINT fk_rails_2805127005 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_session_form_batch_items fk_rails_282567e56b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_form_batch_items
    ADD CONSTRAINT fk_rails_282567e56b FOREIGN KEY (batch_id) REFERENCES renalware.hd_session_form_batches(id);


--
-- Name: pd_pet_results fk_rails_2929069647; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_results
    ADD CONSTRAINT fk_rails_2929069647 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_obx_mappings fk_rails_2971fdcb21; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_obx_mappings
    ADD CONSTRAINT fk_rails_2971fdcb21 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: ukrdc_treatments fk_rails_2a03129a59; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_2a03129a59 FOREIGN KEY (modality_code_id) REFERENCES renalware.ukrdc_modality_codes(id);


--
-- Name: patients fk_rails_2a3ebeae72; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_2a3ebeae72 FOREIGN KEY (hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: medication_prescriptions fk_rails_2ae6a3ad59; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_2ae6a3ad59 FOREIGN KEY (drug_id) REFERENCES renalware.drugs(id);


--
-- Name: medication_prescription_terminations fk_rails_2bd34b98f9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescription_terminations
    ADD CONSTRAINT fk_rails_2bd34b98f9 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: ukrdc_treatments fk_rails_2bf0a6c5e9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_2bf0a6c5e9 FOREIGN KEY (clinician_id) REFERENCES renalware.users(id);


--
-- Name: hd_profiles fk_rails_2c988cf1f6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT fk_rails_2c988cf1f6 FOREIGN KEY (schedule_definition_id) REFERENCES renalware.hd_schedule_definitions(id);


--
-- Name: pathology_code_groups fk_rails_2d8bebdd35; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_groups
    ADD CONSTRAINT fk_rails_2d8bebdd35 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: clinic_appointments fk_rails_2eaec177ff; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments
    ADD CONSTRAINT fk_rails_2eaec177ff FOREIGN KEY (becomes_visit_id) REFERENCES renalware.clinic_visits(id);


--
-- Name: pd_peritonitis_episode_types fk_rails_2f135fd6d9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episode_types
    ADD CONSTRAINT fk_rails_2f135fd6d9 FOREIGN KEY (peritonitis_episode_id) REFERENCES renalware.pd_peritonitis_episodes(id);


--
-- Name: hd_transmission_logs fk_rails_30b8eea154; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_transmission_logs
    ADD CONSTRAINT fk_rails_30b8eea154 FOREIGN KEY (hd_provider_unit_id) REFERENCES renalware.hd_provider_units(id);


--
-- Name: pathology_calculation_sources fk_rails_3131e61ddd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_calculation_sources
    ADD CONSTRAINT fk_rails_3131e61ddd FOREIGN KEY (calculated_observation_id) REFERENCES renalware.pathology_observations(id);


--
-- Name: clinical_dry_weights fk_rails_31546389ab; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_dry_weights
    ADD CONSTRAINT fk_rails_31546389ab FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: feed_files fk_rails_3196424d66; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_files
    ADD CONSTRAINT fk_rails_3196424d66 FOREIGN KEY (file_type_id) REFERENCES renalware.feed_file_types(id);


--
-- Name: pd_regimes fk_rails_32abe9ee95; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regimes
    ADD CONSTRAINT fk_rails_32abe9ee95 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: access_plans fk_rails_32c8b62063; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plans
    ADD CONSTRAINT fk_rails_32c8b62063 FOREIGN KEY (plan_type_id) REFERENCES renalware.access_plan_types(id);


--
-- Name: transplant_registration_statuses fk_rails_32f4ff205a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_statuses
    ADD CONSTRAINT fk_rails_32f4ff205a FOREIGN KEY (registration_id) REFERENCES renalware.transplant_registrations(id);


--
-- Name: transplant_registrations fk_rails_33f3612955; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registrations
    ADD CONSTRAINT fk_rails_33f3612955 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: letter_contacts fk_rails_33f61c70e6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_contacts
    ADD CONSTRAINT fk_rails_33f61c70e6 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: modality_modalities fk_rails_345aeedf24; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT fk_rails_345aeedf24 FOREIGN KEY (change_type_id) REFERENCES renalware.modality_change_types(id);


--
-- Name: messaging_messages fk_rails_3567fcbb87; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_messages
    ADD CONSTRAINT fk_rails_3567fcbb87 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: research_studies fk_rails_36273417ff; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_studies
    ADD CONSTRAINT fk_rails_36273417ff FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_diary_slots fk_rails_36ae60c09d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots
    ADD CONSTRAINT fk_rails_36ae60c09d FOREIGN KEY (diurnal_period_code_id) REFERENCES renalware.hd_diurnal_period_codes(id);


--
-- Name: transplant_registration_statuses fk_rails_36cb307ab5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_statuses
    ADD CONSTRAINT fk_rails_36cb307ab5 FOREIGN KEY (description_id) REFERENCES renalware.transplant_registration_status_descriptions(id);


--
-- Name: patient_master_index fk_rails_37b31022ff; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_master_index
    ADD CONSTRAINT fk_rails_37b31022ff FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: patients fk_rails_3848395513; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_3848395513 FOREIGN KEY (named_consultant_id) REFERENCES renalware.users(id);


--
-- Name: medication_prescriptions fk_rails_38f0cfe718; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_38f0cfe718 FOREIGN KEY (unit_of_measure_id) REFERENCES renalware.drug_unit_of_measures(id);


--
-- Name: pathology_request_descriptions_requests_requests fk_rails_3916726775; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions_requests_requests
    ADD CONSTRAINT fk_rails_3916726775 FOREIGN KEY (request_id) REFERENCES renalware.pathology_requests_requests(id);


--
-- Name: letter_mailshot_mailshots fk_rails_393db6be40; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_mailshots
    ADD CONSTRAINT fk_rails_393db6be40 FOREIGN KEY (letterhead_id) REFERENCES renalware.letter_letterheads(id);


--
-- Name: letter_letters fk_rails_39983ddc03; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT fk_rails_39983ddc03 FOREIGN KEY (letterhead_id) REFERENCES renalware.letter_letterheads(id);


--
-- Name: pathology_request_descriptions fk_rails_39da21b3fe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions
    ADD CONSTRAINT fk_rails_39da21b3fe FOREIGN KEY (required_observation_description_id) REFERENCES renalware.pathology_observation_descriptions(id);


--
-- Name: patients fk_rails_39e5ee7d7e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_39e5ee7d7e FOREIGN KEY (preferred_death_location_id) REFERENCES renalware.death_locations(id);


--
-- Name: transplant_donor_stages fk_rails_3a0cb37b2f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stages
    ADD CONSTRAINT fk_rails_3a0cb37b2f FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: transplant_recipient_operations fk_rails_3a852d1667; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_operations
    ADD CONSTRAINT fk_rails_3a852d1667 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: patient_worries fk_rails_3abd39ab04; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worries
    ADD CONSTRAINT fk_rails_3abd39ab04 FOREIGN KEY (worry_category_id) REFERENCES renalware.patient_worry_categories(id);


--
-- Name: hd_transmission_logs fk_rails_3b842bb40e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_transmission_logs
    ADD CONSTRAINT fk_rails_3b842bb40e FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: drug_types_drugs fk_rails_3bafe36805; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_types_drugs
    ADD CONSTRAINT fk_rails_3bafe36805 FOREIGN KEY (drug_type_id) REFERENCES renalware.drug_types(id);


--
-- Name: access_needling_assessments fk_rails_3c9303db18; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_needling_assessments
    ADD CONSTRAINT fk_rails_3c9303db18 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: clinical_body_compositions fk_rails_3cab0126da; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_body_compositions
    ADD CONSTRAINT fk_rails_3cab0126da FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: letter_mailshot_mailshots fk_rails_3db22bcf9b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_mailshots
    ADD CONSTRAINT fk_rails_3db22bcf9b FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_letters fk_rails_3de9a678b4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT fk_rails_3de9a678b4 FOREIGN KEY (approved_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_sessions fk_rails_3e035fe47f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_3e035fe47f FOREIGN KEY (profile_id) REFERENCES renalware.hd_profiles(id);


--
-- Name: hd_sessions fk_rails_3e0f147311; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_3e0f147311 FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: hd_session_patient_group_directions fk_rails_3e4958da13; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_patient_group_directions
    ADD CONSTRAINT fk_rails_3e4958da13 FOREIGN KEY (patient_group_direction_id) REFERENCES renalware.drug_patient_group_directions(id);


--
-- Name: pathology_requests_requests fk_rails_3e725c96fc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_requests
    ADD CONSTRAINT fk_rails_3e725c96fc FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: pd_peritonitis_episode_types fk_rails_3e924fb47c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episode_types
    ADD CONSTRAINT fk_rails_3e924fb47c FOREIGN KEY (peritonitis_episode_type_description_id) REFERENCES renalware.pd_peritonitis_episode_type_descriptions(id);


--
-- Name: drug_trade_family_classifications fk_rails_3efe65145a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_trade_family_classifications
    ADD CONSTRAINT fk_rails_3efe65145a FOREIGN KEY (drug_id) REFERENCES renalware.drugs(id);


--
-- Name: patient_bookmarks fk_rails_3f47dd9cc1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_bookmarks
    ADD CONSTRAINT fk_rails_3f47dd9cc1 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: ukrdc_treatments fk_rails_4011924f9c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_4011924f9c FOREIGN KEY (hd_profile_id) REFERENCES renalware.hd_profiles(id);


--
-- Name: pd_assessments fk_rails_408dde93e5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_assessments
    ADD CONSTRAINT fk_rails_408dde93e5 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_requests_global_rule_sets fk_rails_40e23de825; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_global_rule_sets
    ADD CONSTRAINT fk_rails_40e23de825 FOREIGN KEY (clinic_id) REFERENCES renalware.clinic_clinics(id);


--
-- Name: admission_admissions fk_rails_4137fdc9b4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions
    ADD CONSTRAINT fk_rails_4137fdc9b4 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: medication_prescriptions fk_rails_417030e9bc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_417030e9bc FOREIGN KEY (trade_family_id) REFERENCES renalware.drug_trade_families(id);


--
-- Name: user_group_memberships fk_rails_42022c51df; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_group_memberships
    ADD CONSTRAINT fk_rails_42022c51df FOREIGN KEY (user_id) REFERENCES renalware.users(id);


--
-- Name: system_downloads fk_rails_42cdf8956b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_downloads
    ADD CONSTRAINT fk_rails_42cdf8956b FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_pet_results fk_rails_44d212ba62; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_results
    ADD CONSTRAINT fk_rails_44d212ba62 FOREIGN KEY (dextrose_concentration_id) REFERENCES renalware.pd_pet_dextrose_concentrations(id);


--
-- Name: feed_outgoing_documents fk_rails_4a1ec98ea7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_outgoing_documents
    ADD CONSTRAINT fk_rails_4a1ec98ea7 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: drug_vmp_classifications fk_rails_4bbd30d10d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_vmp_classifications
    ADD CONSTRAINT fk_rails_4bbd30d10d FOREIGN KEY (unit_of_measure_id) REFERENCES renalware.drug_unit_of_measures(id);


--
-- Name: system_user_feedback fk_rails_4cc9cf2dca; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_user_feedback
    ADD CONSTRAINT fk_rails_4cc9cf2dca FOREIGN KEY (author_id) REFERENCES renalware.users(id);


--
-- Name: user_groups fk_rails_4d818c23e5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_groups
    ADD CONSTRAINT fk_rails_4d818c23e5 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: renal_aki_alerts fk_rails_4d907ef0f1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts
    ADD CONSTRAINT fk_rails_4d907ef0f1 FOREIGN KEY (action_id) REFERENCES renalware.renal_aki_alert_actions(id);


--
-- Name: feed_message_replays fk_rails_4ec42d8046; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_message_replays
    ADD CONSTRAINT fk_rails_4ec42d8046 FOREIGN KEY (replay_request_id) REFERENCES renalware.feed_replay_requests(id);


--
-- Name: patient_attachments fk_rails_4fe08d5c90; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachments
    ADD CONSTRAINT fk_rails_4fe08d5c90 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: access_assessments fk_rails_506a7ce21d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_assessments
    ADD CONSTRAINT fk_rails_506a7ce21d FOREIGN KEY (type_id) REFERENCES renalware.access_types(id);


--
-- Name: messaging_receipts fk_rails_50de46762d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_receipts
    ADD CONSTRAINT fk_rails_50de46762d FOREIGN KEY (message_id) REFERENCES renalware.messaging_messages(id);


--
-- Name: hd_prescription_administrations fk_rails_51e9a49d43; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_51e9a49d43 FOREIGN KEY (witnessed_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_slot_requests fk_rails_5262597fc7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests
    ADD CONSTRAINT fk_rails_5262597fc7 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: patients fk_rails_53c392b502; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_53c392b502 FOREIGN KEY (country_of_birth_id) REFERENCES renalware.system_countries(id);


--
-- Name: admission_consults fk_rails_53e81afb74; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults
    ADD CONSTRAINT fk_rails_53e81afb74 FOREIGN KEY (seen_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_letters fk_rails_54a74fd998; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT fk_rails_54a74fd998 FOREIGN KEY (submitted_for_approval_by_id) REFERENCES renalware.users(id);


--
-- Name: admission_requests fk_rails_54b568383c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_requests
    ADD CONSTRAINT fk_rails_54b568383c FOREIGN KEY (reason_id) REFERENCES renalware.admission_request_reasons(id);


--
-- Name: clinic_consultants fk_rails_553d00e0f9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_consultants
    ADD CONSTRAINT fk_rails_553d00e0f9 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_sessions fk_rails_563fedb262; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_563fedb262 FOREIGN KEY (dry_weight_id) REFERENCES renalware.clinical_dry_weights(id);


--
-- Name: renal_profiles fk_rails_568750244e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_profiles
    ADD CONSTRAINT fk_rails_568750244e FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: event_type_alert_triggers fk_rails_56eac5912d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_type_alert_triggers
    ADD CONSTRAINT fk_rails_56eac5912d FOREIGN KEY (event_type_id) REFERENCES renalware.event_types(id);


--
-- Name: transplant_recipient_workups fk_rails_571a3cadda; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_workups
    ADD CONSTRAINT fk_rails_571a3cadda FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: clinic_appointments fk_rails_57295b1aa7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments
    ADD CONSTRAINT fk_rails_57295b1aa7 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: virology_profiles fk_rails_58ffa1276c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_profiles
    ADD CONSTRAINT fk_rails_58ffa1276c FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_diary_slots fk_rails_5910319259; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots
    ADD CONSTRAINT fk_rails_5910319259 FOREIGN KEY (diary_id) REFERENCES renalware.hd_diaries(id);


--
-- Name: letter_mesh_transmissions fk_rails_594270c049; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mesh_transmissions
    ADD CONSTRAINT fk_rails_594270c049 FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: letter_letterheads fk_rails_5a6d729513; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letterheads
    ADD CONSTRAINT fk_rails_5a6d729513 FOREIGN KEY (hospital_department_id) REFERENCES renalware.hospital_departments(id);


--
-- Name: patients fk_rails_5b44e541da; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_5b44e541da FOREIGN KEY (ethnicity_id) REFERENCES renalware.patient_ethnicities(id);


--
-- Name: system_logs fk_rails_5b48840751; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_logs
    ADD CONSTRAINT fk_rails_5b48840751 FOREIGN KEY (owner_id) REFERENCES renalware.users(id);


--
-- Name: pd_training_sessions fk_rails_5cbe110e5f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sessions
    ADD CONSTRAINT fk_rails_5cbe110e5f FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: patient_practice_memberships fk_rails_5cc07e383f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_practice_memberships
    ADD CONSTRAINT fk_rails_5cc07e383f FOREIGN KEY (practice_id) REFERENCES renalware.patient_practices(id);


--
-- Name: clinic_visit_locations fk_rails_5e2f7e37cf; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visit_locations
    ADD CONSTRAINT fk_rails_5e2f7e37cf FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: low_clearance_profiles fk_rails_5e7ea491eb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_profiles
    ADD CONSTRAINT fk_rails_5e7ea491eb FOREIGN KEY (referrer_id) REFERENCES renalware.low_clearance_referrers(id);


--
-- Name: transplant_rejection_episodes fk_rails_5eed551513; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_episodes
    ADD CONSTRAINT fk_rails_5eed551513 FOREIGN KEY (followup_id) REFERENCES renalware.transplant_recipient_followups(id);


--
-- Name: pathology_code_group_memberships fk_rails_5fd19b0f12; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_group_memberships
    ADD CONSTRAINT fk_rails_5fd19b0f12 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_regime_terminations fk_rails_6021bed852; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_terminations
    ADD CONSTRAINT fk_rails_6021bed852 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: medication_delivery_events fk_rails_603a7f7a1f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_events
    ADD CONSTRAINT fk_rails_603a7f7a1f FOREIGN KEY (homecare_form_id) REFERENCES renalware.drug_homecare_forms(id);


--
-- Name: access_assessments fk_rails_604fdf3a9e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_assessments
    ADD CONSTRAINT fk_rails_604fdf3a9e FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: letter_signatures fk_rails_60aca3bf58; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_signatures
    ADD CONSTRAINT fk_rails_60aca3bf58 FOREIGN KEY (user_id) REFERENCES renalware.users(id);


--
-- Name: pathology_requests_requests fk_rails_617c726b94; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_requests
    ADD CONSTRAINT fk_rails_617c726b94 FOREIGN KEY (consultant_id) REFERENCES renalware.clinic_consultants(id);


--
-- Name: letter_letters fk_rails_6191e75b3b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT fk_rails_6191e75b3b FOREIGN KEY (author_id) REFERENCES renalware.users(id);


--
-- Name: access_needling_assessments fk_rails_61daace4f3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_needling_assessments
    ADD CONSTRAINT fk_rails_61daace4f3 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_pet_results fk_rails_6233b2801e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_results
    ADD CONSTRAINT fk_rails_6233b2801e FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_vnd_risk_assessments fk_rails_628a43fde7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_vnd_risk_assessments
    ADD CONSTRAINT fk_rails_628a43fde7 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_obx_mappings fk_rails_62ce548f09; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_obx_mappings
    ADD CONSTRAINT fk_rails_62ce548f09 FOREIGN KEY (sender_id) REFERENCES renalware.pathology_senders(id);


--
-- Name: ukrdc_treatments fk_rails_63f35ffdfe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_63f35ffdfe FOREIGN KEY (pd_regime_id) REFERENCES renalware.pd_regimes(id);


--
-- Name: patients fk_rails_6573b513a4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_6573b513a4 FOREIGN KEY (actual_death_location_id) REFERENCES renalware.death_locations(id);


--
-- Name: letter_batch_items fk_rails_65e38cb9dc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batch_items
    ADD CONSTRAINT fk_rails_65e38cb9dc FOREIGN KEY (batch_id) REFERENCES renalware.letter_batches(id);


--
-- Name: messaging_messages fk_rails_65f878b7cf; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_messages
    ADD CONSTRAINT fk_rails_65f878b7cf FOREIGN KEY (author_id) REFERENCES renalware.users(id);


--
-- Name: admission_consults fk_rails_66c44c0949; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults
    ADD CONSTRAINT fk_rails_66c44c0949 FOREIGN KEY (hospital_ward_id) REFERENCES renalware.hospital_wards(id);


--
-- Name: pathology_calculation_sources fk_rails_6725b36566; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_calculation_sources
    ADD CONSTRAINT fk_rails_6725b36566 FOREIGN KEY (source_observation_id) REFERENCES renalware.pathology_observations(id);


--
-- Name: transplant_recipient_followups fk_rails_6893ba0593; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_followups
    ADD CONSTRAINT fk_rails_6893ba0593 FOREIGN KEY (transplant_failure_cause_description_id) REFERENCES renalware.transplant_failure_cause_descriptions(id);


--
-- Name: hd_vnd_risk_assessments fk_rails_68a3593399; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_vnd_risk_assessments
    ADD CONSTRAINT fk_rails_68a3593399 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_preference_sets fk_rails_69555e3a94; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_preference_sets
    ADD CONSTRAINT fk_rails_69555e3a94 FOREIGN KEY (schedule_definition_id) REFERENCES renalware.hd_schedule_definitions(id);


--
-- Name: hd_slot_requests fk_rails_6a3ab1b8b9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests
    ADD CONSTRAINT fk_rails_6a3ab1b8b9 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: problem_notes fk_rails_6a44f3907b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_notes
    ADD CONSTRAINT fk_rails_6a44f3907b FOREIGN KEY (problem_id) REFERENCES renalware.problem_problems(id);


--
-- Name: medication_delivery_events fk_rails_6b50df295a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_events
    ADD CONSTRAINT fk_rails_6b50df295a FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: modality_change_types fk_rails_6b99818772; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_change_types
    ADD CONSTRAINT fk_rails_6b99818772 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_letters fk_rails_6dfb08492c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT fk_rails_6dfb08492c FOREIGN KEY (deleted_by_id) REFERENCES renalware.users(id);


--
-- Name: drug_trade_family_classifications fk_rails_6e6a5dc074; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_trade_family_classifications
    ADD CONSTRAINT fk_rails_6e6a5dc074 FOREIGN KEY (trade_family_id) REFERENCES renalware.drug_trade_families(id);


--
-- Name: pathology_code_group_memberships fk_rails_6ff53028fa; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_group_memberships
    ADD CONSTRAINT fk_rails_6ff53028fa FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: event_subtypes fk_rails_6ff855f23f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_subtypes
    ADD CONSTRAINT fk_rails_6ff855f23f FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_pet_results fk_rails_70a2d2908f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_results
    ADD CONSTRAINT fk_rails_70a2d2908f FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_observations fk_rails_70ef87ad18; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observations
    ADD CONSTRAINT fk_rails_70ef87ad18 FOREIGN KEY (request_id) REFERENCES renalware.pathology_observation_requests(id);


--
-- Name: geography_middle_super_output_areas fk_rails_7238531ba4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_middle_super_output_areas
    ADD CONSTRAINT fk_rails_7238531ba4 FOREIGN KEY (local_authority_district_id) REFERENCES renalware.geography_local_authority_districts(id);


--
-- Name: admission_admissions fk_rails_74bb0c40ab; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions
    ADD CONSTRAINT fk_rails_74bb0c40ab FOREIGN KEY (modality_at_admission_id) REFERENCES renalware.modality_modalities(id);


--
-- Name: hd_sessions fk_rails_751ed7515f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_751ed7515f FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: events fk_rails_75f14fef31; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.events
    ADD CONSTRAINT fk_rails_75f14fef31 FOREIGN KEY (event_type_id) REFERENCES renalware.event_types(id);


--
-- Name: patient_attachments fk_rails_76bb588f1f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachments
    ADD CONSTRAINT fk_rails_76bb588f1f FOREIGN KEY (attachment_type_id) REFERENCES renalware.patient_attachment_types(id);


--
-- Name: patients fk_rails_76ea7f2448; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_76ea7f2448 FOREIGN KEY (second_cause_id) REFERENCES renalware.death_causes(id);


--
-- Name: clinic_clinics fk_rails_76f414c91a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_clinics
    ADD CONSTRAINT fk_rails_76f414c91a FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_letters fk_rails_774d7e4879; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT fk_rails_774d7e4879 FOREIGN KEY (completed_by_id) REFERENCES renalware.users(id);


--
-- Name: medication_delivery_event_prescriptions fk_rails_779cfa5f0f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_event_prescriptions
    ADD CONSTRAINT fk_rails_779cfa5f0f FOREIGN KEY (prescription_id) REFERENCES renalware.medication_prescriptions(id);


--
-- Name: letter_mailshot_items fk_rails_77f8eb75d1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_items
    ADD CONSTRAINT fk_rails_77f8eb75d1 FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: letter_qr_encoded_online_reference_links fk_rails_7825abc09a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_qr_encoded_online_reference_links
    ADD CONSTRAINT fk_rails_7825abc09a FOREIGN KEY (online_reference_link_id) REFERENCES renalware.system_online_reference_links(id);


--
-- Name: transplant_recipient_followups fk_rails_78dc63040c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_followups
    ADD CONSTRAINT fk_rails_78dc63040c FOREIGN KEY (operation_id) REFERENCES renalware.transplant_recipient_operations(id);


--
-- Name: admission_consults fk_rails_7906df81db; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults
    ADD CONSTRAINT fk_rails_7906df81db FOREIGN KEY (specialty_id) REFERENCES renalware.admission_specialties(id);


--
-- Name: hd_profiles fk_rails_7d0453a2e8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT fk_rails_7d0453a2e8 FOREIGN KEY (dialysate_id) REFERENCES renalware.hd_dialysates(id);


--
-- Name: ukrdc_treatments fk_rails_7d0d8e5131; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_7d0d8e5131 FOREIGN KEY (modality_description_id) REFERENCES renalware.modality_descriptions(id);


--
-- Name: pd_regime_terminations fk_rails_7d318fdf1a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_terminations
    ADD CONSTRAINT fk_rails_7d318fdf1a FOREIGN KEY (regime_id) REFERENCES renalware.pd_regimes(id);


--
-- Name: ukrdc_treatments fk_rails_7d4def4f31; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_7d4def4f31 FOREIGN KEY (hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: snippets_snippets fk_rails_7d5fdddbd2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.snippets_snippets
    ADD CONSTRAINT fk_rails_7d5fdddbd2 FOREIGN KEY (author_id) REFERENCES renalware.users(id);


--
-- Name: letter_archives fk_rails_7dc4363735; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_archives
    ADD CONSTRAINT fk_rails_7dc4363735 FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: hd_session_patient_group_directions fk_rails_7f245d8477; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_patient_group_directions
    ADD CONSTRAINT fk_rails_7f245d8477 FOREIGN KEY (session_id) REFERENCES renalware.hd_sessions(id);


--
-- Name: clinic_visit_locations fk_rails_7f880fe872; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visit_locations
    ADD CONSTRAINT fk_rails_7f880fe872 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: research_participations fk_rails_8039d07f46; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_participations
    ADD CONSTRAINT fk_rails_8039d07f46 FOREIGN KEY (study_id) REFERENCES renalware.research_studies(id);


--
-- Name: pd_adequacy_results fk_rails_81e87b4414; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_adequacy_results
    ADD CONSTRAINT fk_rails_81e87b4414 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: system_downloads fk_rails_8344ecfc27; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_downloads
    ADD CONSTRAINT fk_rails_8344ecfc27 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: research_participations fk_rails_87bef0e757; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_participations
    ADD CONSTRAINT fk_rails_87bef0e757 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: patient_worries fk_rails_8837145e13; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worries
    ADD CONSTRAINT fk_rails_8837145e13 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_prescription_administrations fk_rails_885e37560e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_885e37560e FOREIGN KEY (prescription_id) REFERENCES renalware.medication_prescriptions(id);


--
-- Name: letter_batches fk_rails_88dce46ac4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batches
    ADD CONSTRAINT fk_rails_88dce46ac4 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_profiles fk_rails_89630f47ee; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT fk_rails_89630f47ee FOREIGN KEY (transport_decider_id) REFERENCES renalware.users(id);


--
-- Name: clinical_body_compositions fk_rails_8acc26446b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_body_compositions
    ADD CONSTRAINT fk_rails_8acc26446b FOREIGN KEY (modality_description_id) REFERENCES renalware.modality_descriptions(id);


--
-- Name: letter_mailshot_mailshots fk_rails_8b04a892b0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_mailshots
    ADD CONSTRAINT fk_rails_8b04a892b0 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: admission_requests fk_rails_8b3ff2812e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_requests
    ADD CONSTRAINT fk_rails_8b3ff2812e FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: renal_aki_alerts fk_rails_8b50e868dc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts
    ADD CONSTRAINT fk_rails_8b50e868dc FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: drug_vmp_classifications fk_rails_8d19e7bcfc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_vmp_classifications
    ADD CONSTRAINT fk_rails_8d19e7bcfc FOREIGN KEY (drug_id) REFERENCES renalware.drugs(id);


--
-- Name: hd_provider_units fk_rails_8d21a18a82; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_provider_units
    ADD CONSTRAINT fk_rails_8d21a18a82 FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: pd_pet_results fk_rails_8d6b2f0082; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_results
    ADD CONSTRAINT fk_rails_8d6b2f0082 FOREIGN KEY (overnight_dextrose_concentration_id) REFERENCES renalware.pd_pet_dextrose_concentrations(id);


--
-- Name: access_profiles fk_rails_8d75e5423f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_profiles
    ADD CONSTRAINT fk_rails_8d75e5423f FOREIGN KEY (decided_by_id) REFERENCES renalware.users(id);


--
-- Name: low_clearance_profiles fk_rails_8d84feb2ed; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_profiles
    ADD CONSTRAINT fk_rails_8d84feb2ed FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hospital_units fk_rails_8f3a7fc1c7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_units
    ADD CONSTRAINT fk_rails_8f3a7fc1c7 FOREIGN KEY (hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: pathology_request_descriptions_requests_requests fk_rails_8f574ed703; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions_requests_requests
    ADD CONSTRAINT fk_rails_8f574ed703 FOREIGN KEY (request_description_id) REFERENCES renalware.pathology_request_descriptions(id);


--
-- Name: hd_provider_units fk_rails_8f5e478f60; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_provider_units
    ADD CONSTRAINT fk_rails_8f5e478f60 FOREIGN KEY (hd_provider_id) REFERENCES renalware.hd_providers(id);


--
-- Name: hd_diary_slots fk_rails_8fd55142bd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots
    ADD CONSTRAINT fk_rails_8fd55142bd FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_chart_series fk_rails_903a56989c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_chart_series
    ADD CONSTRAINT fk_rails_903a56989c FOREIGN KEY (observation_description_id) REFERENCES renalware.pathology_observation_descriptions(id);


--
-- Name: clinic_appointments fk_rails_909dcaaf3d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments
    ADD CONSTRAINT fk_rails_909dcaaf3d FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: admission_requests fk_rails_9161088ec5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_requests
    ADD CONSTRAINT fk_rails_9161088ec5 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: transplant_failure_cause_descriptions fk_rails_9183cb4170; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_failure_cause_descriptions
    ADD CONSTRAINT fk_rails_9183cb4170 FOREIGN KEY (group_id) REFERENCES renalware.transplant_failure_cause_description_groups(id);


--
-- Name: clinical_allergies fk_rails_9193bda748; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_allergies
    ADD CONSTRAINT fk_rails_9193bda748 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: ukrdc_transmission_logs fk_rails_91c2e398c1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_transmission_logs
    ADD CONSTRAINT fk_rails_91c2e398c1 FOREIGN KEY (batch_id) REFERENCES renalware.ukrdc_batches(id);


--
-- Name: transplant_rejection_episodes fk_rails_93bb09b431; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_episodes
    ADD CONSTRAINT fk_rails_93bb09b431 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: transplant_donor_workups fk_rails_93dc1108f3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_workups
    ADD CONSTRAINT fk_rails_93dc1108f3 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: pd_adequacy_results fk_rails_93e753133f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_adequacy_results
    ADD CONSTRAINT fk_rails_93e753133f FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_regime_terminations fk_rails_93f7877530; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_terminations
    ADD CONSTRAINT fk_rails_93f7877530 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: system_dashboards fk_rails_9531eb310e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_dashboards
    ADD CONSTRAINT fk_rails_9531eb310e FOREIGN KEY (cloned_from_dashboard_id) REFERENCES renalware.system_dashboards(id);


--
-- Name: problem_comorbidities fk_rails_95894c755d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidities
    ADD CONSTRAINT fk_rails_95894c755d FOREIGN KEY (description_id) REFERENCES renalware.problem_comorbidity_descriptions(id);


--
-- Name: pd_exit_site_infections fk_rails_9702c22886; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_exit_site_infections
    ADD CONSTRAINT fk_rails_9702c22886 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: patients fk_rails_9739853ad1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_9739853ad1 FOREIGN KEY (primary_care_physician_id) REFERENCES renalware.patient_primary_care_physicians(id);


--
-- Name: letter_mailshot_mailshots fk_rails_973e755ca1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_mailshots
    ADD CONSTRAINT fk_rails_973e755ca1 FOREIGN KEY (author_id) REFERENCES renalware.users(id);


--
-- Name: research_investigatorships fk_rails_97cd654080; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_investigatorships
    ADD CONSTRAINT fk_rails_97cd654080 FOREIGN KEY (user_id) REFERENCES renalware.users(id);


--
-- Name: research_participations fk_rails_980af0ec33; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_participations
    ADD CONSTRAINT fk_rails_980af0ec33 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: transplant_rejection_episodes fk_rails_98de4be6aa; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_rejection_episodes
    ADD CONSTRAINT fk_rails_98de4be6aa FOREIGN KEY (treatment_id) REFERENCES renalware.transplant_rejection_treatments(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES renalware.active_storage_blobs(id);


--
-- Name: event_subtypes fk_rails_9a3dea7f8e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.event_subtypes
    ADD CONSTRAINT fk_rails_9a3dea7f8e FOREIGN KEY (event_type_id) REFERENCES renalware.event_types(id);


--
-- Name: admission_admissions fk_rails_9b1787c128; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions
    ADD CONSTRAINT fk_rails_9b1787c128 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: clinical_igan_risks fk_rails_9b3432e846; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_igan_risks
    ADD CONSTRAINT fk_rails_9b3432e846 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: research_participations fk_rails_9c3d41afbe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_participations
    ADD CONSTRAINT fk_rails_9c3d41afbe FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_recipients fk_rails_9c76b7ba29; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_recipients
    ADD CONSTRAINT fk_rails_9c76b7ba29 FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: roles_users fk_rails_9dada905f6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.roles_users
    ADD CONSTRAINT fk_rails_9dada905f6 FOREIGN KEY (role_id) REFERENCES renalware.roles(id);


--
-- Name: access_procedures fk_rails_9dbbc5bfd0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_procedures
    ADD CONSTRAINT fk_rails_9dbbc5bfd0 FOREIGN KEY (type_id) REFERENCES renalware.access_types(id);


--
-- Name: admission_consults fk_rails_9e878a7b22; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults
    ADD CONSTRAINT fk_rails_9e878a7b22 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: patient_alerts fk_rails_9efea309bb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_alerts
    ADD CONSTRAINT fk_rails_9efea309bb FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_slot_requests fk_rails_9f45813346; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests
    ADD CONSTRAINT fk_rails_9f45813346 FOREIGN KEY (location_id) REFERENCES renalware.hd_slot_request_locations(id);


--
-- Name: letter_batch_items fk_rails_a02ff59ff6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batch_items
    ADD CONSTRAINT fk_rails_a02ff59ff6 FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: pathology_request_descriptions fk_rails_a0b9cd97fe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_request_descriptions
    ADD CONSTRAINT fk_rails_a0b9cd97fe FOREIGN KEY (lab_id) REFERENCES renalware.pathology_labs(id);


--
-- Name: letter_contacts fk_rails_a0d87208a0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_contacts
    ADD CONSTRAINT fk_rails_a0d87208a0 FOREIGN KEY (description_id) REFERENCES renalware.letter_contact_descriptions(id);


--
-- Name: feed_outgoing_documents fk_rails_a13bc8d2e9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_outgoing_documents
    ADD CONSTRAINT fk_rails_a13bc8d2e9 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: system_view_calls fk_rails_a19fbf279e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_view_calls
    ADD CONSTRAINT fk_rails_a19fbf279e FOREIGN KEY (user_id) REFERENCES renalware.users(id);


--
-- Name: hd_diaries fk_rails_a30d12c65b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diaries
    ADD CONSTRAINT fk_rails_a30d12c65b FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: hd_sessions fk_rails_a3afae15cb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_a3afae15cb FOREIGN KEY (modality_description_id) REFERENCES renalware.modality_descriptions(id);


--
-- Name: letter_contacts fk_rails_a5852d1710; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_contacts
    ADD CONSTRAINT fk_rails_a5852d1710 FOREIGN KEY (person_id) REFERENCES renalware.directory_people(id);


--
-- Name: hd_patient_statistics fk_rails_a654a17f8d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_patient_statistics
    ADD CONSTRAINT fk_rails_a654a17f8d FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: modality_descriptions fk_rails_a6efc804a5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_descriptions
    ADD CONSTRAINT fk_rails_a6efc804a5 FOREIGN KEY (ukrdc_modality_code_id) REFERENCES renalware.ukrdc_modality_codes(id);


--
-- Name: pd_regimes fk_rails_a70920e237; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regimes
    ADD CONSTRAINT fk_rails_a70920e237 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: transplant_donor_stages fk_rails_a791cc53cd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stages
    ADD CONSTRAINT fk_rails_a791cc53cd FOREIGN KEY (stage_position_id) REFERENCES renalware.transplant_donor_stage_positions(id);


--
-- Name: transplant_donor_stages fk_rails_a7ac3785a4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stages
    ADD CONSTRAINT fk_rails_a7ac3785a4 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_stations fk_rails_a7fedf6e91; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_stations
    ADD CONSTRAINT fk_rails_a7fedf6e91 FOREIGN KEY (location_id) REFERENCES renalware.hd_station_locations(id);


--
-- Name: pathology_requests_drugs_drug_categories fk_rails_a850498c88; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_drugs_drug_categories
    ADD CONSTRAINT fk_rails_a850498c88 FOREIGN KEY (drug_category_id) REFERENCES renalware.pathology_requests_drug_categories(id);


--
-- Name: research_investigatorships fk_rails_a88d67c879; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_investigatorships
    ADD CONSTRAINT fk_rails_a88d67c879 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_requests_requests fk_rails_a8d58d31e6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_requests
    ADD CONSTRAINT fk_rails_a8d58d31e6 FOREIGN KEY (clinic_id) REFERENCES renalware.clinic_clinics(id);


--
-- Name: hd_prescription_administrations fk_rails_a9d677a6f8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_a9d677a6f8 FOREIGN KEY (reason_id) REFERENCES renalware.hd_prescription_administration_reasons(id);


--
-- Name: pathology_charts fk_rails_aa0712e9e6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_charts
    ADD CONSTRAINT fk_rails_aa0712e9e6 FOREIGN KEY (owner_id) REFERENCES renalware.users(id);


--
-- Name: drug_vmp_classifications fk_rails_aa68a82ecc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_vmp_classifications
    ADD CONSTRAINT fk_rails_aa68a82ecc FOREIGN KEY (form_id) REFERENCES renalware.drug_forms(id);


--
-- Name: letter_qr_encoded_online_reference_links fk_rails_aa725c813c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_qr_encoded_online_reference_links
    ADD CONSTRAINT fk_rails_aa725c813c FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: hd_diaries fk_rails_aab1b8f3e1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diaries
    ADD CONSTRAINT fk_rails_aab1b8f3e1 FOREIGN KEY (master_diary_id) REFERENCES renalware.hd_diaries(id);


--
-- Name: geography_output_areas fk_rails_ab0dd53286; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_output_areas
    ADD CONSTRAINT fk_rails_ab0dd53286 FOREIGN KEY (lower_super_output_area_id) REFERENCES renalware.geography_lower_super_output_areas(id);


--
-- Name: hd_preference_sets fk_rails_ac8e970c42; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_preference_sets
    ADD CONSTRAINT fk_rails_ac8e970c42 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: access_profiles fk_rails_acbcae03df; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_profiles
    ADD CONSTRAINT fk_rails_acbcae03df FOREIGN KEY (type_id) REFERENCES renalware.access_types(id);


--
-- Name: system_online_reference_links fk_rails_ace781d947; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_online_reference_links
    ADD CONSTRAINT fk_rails_ace781d947 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_peritonitis_episodes fk_rails_ae56e9fe7e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_ae56e9fe7e FOREIGN KEY (episode_type_id) REFERENCES renalware.pd_peritonitis_episode_type_descriptions(id);


--
-- Name: user_group_memberships fk_rails_aece7151f8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_group_memberships
    ADD CONSTRAINT fk_rails_aece7151f8 FOREIGN KEY (user_group_id) REFERENCES renalware.user_groups(id);


--
-- Name: virology_profiles fk_rails_af15bfebc8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.virology_profiles
    ADD CONSTRAINT fk_rails_af15bfebc8 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_stations fk_rails_af478cfba0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_stations
    ADD CONSTRAINT fk_rails_af478cfba0 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_code_group_memberships fk_rails_aff8ecb964; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_group_memberships
    ADD CONSTRAINT fk_rails_aff8ecb964 FOREIGN KEY (code_group_id) REFERENCES renalware.pathology_code_groups(id);


--
-- Name: pathology_requests_patient_rules fk_rails_b13e09c8a3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules
    ADD CONSTRAINT fk_rails_b13e09c8a3 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_patient_statistics fk_rails_b163068880; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_patient_statistics
    ADD CONSTRAINT fk_rails_b163068880 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: letter_section_snapshots fk_rails_b3fba09669; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_section_snapshots
    ADD CONSTRAINT fk_rails_b3fba09669 FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: clinical_body_compositions fk_rails_b4786e77de; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_body_compositions
    ADD CONSTRAINT fk_rails_b4786e77de FOREIGN KEY (assessor_id) REFERENCES renalware.users(id);


--
-- Name: system_view_metadata fk_rails_b499d6a5de; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_view_metadata
    ADD CONSTRAINT fk_rails_b499d6a5de FOREIGN KEY (parent_id) REFERENCES renalware.system_view_metadata(id);


--
-- Name: pathology_observation_descriptions fk_rails_b4b10c7e86; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_descriptions
    ADD CONSTRAINT fk_rails_b4b10c7e86 FOREIGN KEY (measurement_unit_id) REFERENCES renalware.pathology_measurement_units(id);


--
-- Name: admission_admissions fk_rails_b4edf9f5f8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions
    ADD CONSTRAINT fk_rails_b4edf9f5f8 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_prescription_administrations fk_rails_b56a7920ec; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_b56a7920ec FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: transplant_donor_operations fk_rails_b6ee03185c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_operations
    ADD CONSTRAINT fk_rails_b6ee03185c FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: admission_admissions fk_rails_b722288de2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions
    ADD CONSTRAINT fk_rails_b722288de2 FOREIGN KEY (hospital_ward_id) REFERENCES renalware.hospital_wards(id);


--
-- Name: pathology_requests_global_rules fk_rails_b77918cf71; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_global_rules
    ADD CONSTRAINT fk_rails_b77918cf71 FOREIGN KEY (rule_set_id) REFERENCES renalware.pathology_requests_global_rule_sets(id);


--
-- Name: hospital_wards fk_rails_b7949167d5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_wards
    ADD CONSTRAINT fk_rails_b7949167d5 FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: drug_homecare_forms fk_rails_b7b0cfbbfa; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_homecare_forms
    ADD CONSTRAINT fk_rails_b7b0cfbbfa FOREIGN KEY (supplier_id) REFERENCES renalware.drug_suppliers(id);


--
-- Name: clinic_appointments fk_rails_b7cc8fd5dd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments
    ADD CONSTRAINT fk_rails_b7cc8fd5dd FOREIGN KEY (clinic_id) REFERENCES renalware.clinic_clinics(id);


--
-- Name: clinic_visits fk_rails_b844dc9537; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visits
    ADD CONSTRAINT fk_rails_b844dc9537 FOREIGN KEY (clinic_id) REFERENCES renalware.clinic_clinics(id);


--
-- Name: access_plans fk_rails_b898a29af1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plans
    ADD CONSTRAINT fk_rails_b898a29af1 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_sessions fk_rails_b92ec653ce; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_b92ec653ce FOREIGN KEY (hd_station_id) REFERENCES renalware.hd_stations(id);


--
-- Name: clinic_visits fk_rails_bb1c2fadb7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_visits
    ADD CONSTRAINT fk_rails_bb1c2fadb7 FOREIGN KEY (location_id) REFERENCES renalware.clinic_visit_locations(id);


--
-- Name: problem_problems fk_rails_bbae3e065d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_problems
    ADD CONSTRAINT fk_rails_bbae3e065d FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_sessions fk_rails_bd995b497c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_bd995b497c FOREIGN KEY (signed_on_by_id) REFERENCES renalware.users(id);


--
-- Name: patient_alerts fk_rails_bf45802f3f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_alerts
    ADD CONSTRAINT fk_rails_bf45802f3f FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: patient_bookmarks fk_rails_c12b863727; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_bookmarks
    ADD CONSTRAINT fk_rails_c12b863727 FOREIGN KEY (user_id) REFERENCES renalware.users(id);


--
-- Name: medication_delivery_events fk_rails_c12f333218; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_events
    ADD CONSTRAINT fk_rails_c12f333218 FOREIGN KEY (drug_type_id) REFERENCES renalware.drug_types(id);


--
-- Name: letter_electronic_receipts fk_rails_c2013b0f76; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_electronic_receipts
    ADD CONSTRAINT fk_rails_c2013b0f76 FOREIGN KEY (user_group_id) REFERENCES renalware.user_groups(id) NOT VALID;


--
-- Name: modality_modalities fk_rails_c31cea56ac; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT fk_rails_c31cea56ac FOREIGN KEY (reason_id) REFERENCES renalware.modality_reasons(id);


--
-- Name: ukrdc_treatments fk_rails_c35a48f8d3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_c35a48f8d3 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: patient_alerts fk_rails_c37cc03264; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_alerts
    ADD CONSTRAINT fk_rails_c37cc03264 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES renalware.active_storage_blobs(id);


--
-- Name: problem_comorbidities fk_rails_c3b7d7c1d2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidities
    ADD CONSTRAINT fk_rails_c3b7d7c1d2 FOREIGN KEY (malignancy_site_id) REFERENCES renalware.problem_malignancy_sites(id);


--
-- Name: ukrdc_transmission_logs fk_rails_c59f71164c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_transmission_logs
    ADD CONSTRAINT fk_rails_c59f71164c FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: research_investigatorships fk_rails_c6186ba63f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_investigatorships
    ADD CONSTRAINT fk_rails_c6186ba63f FOREIGN KEY (study_id) REFERENCES renalware.research_studies(id);


--
-- Name: hd_prescription_administrations fk_rails_c654406492; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_c654406492 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_regimes fk_rails_c7333be3d4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regimes
    ADD CONSTRAINT fk_rails_c7333be3d4 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: transplant_donor_followups fk_rails_c75064199c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_followups
    ADD CONSTRAINT fk_rails_c75064199c FOREIGN KEY (operation_id) REFERENCES renalware.transplant_donor_operations(id);


--
-- Name: medication_prescriptions fk_rails_c7b1e35b07; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_c7b1e35b07 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_code_group_memberships fk_rails_c80615a8fc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_group_memberships
    ADD CONSTRAINT fk_rails_c80615a8fc FOREIGN KEY (observation_description_id) REFERENCES renalware.pathology_observation_descriptions(id);


--
-- Name: hd_profiles fk_rails_c89b2174e9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT fk_rails_c89b2174e9 FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: clinic_consultants fk_rails_ca15ceb91b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_consultants
    ADD CONSTRAINT fk_rails_ca15ceb91b FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_regime_bags fk_rails_ca16ec591e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_bags
    ADD CONSTRAINT fk_rails_ca16ec591e FOREIGN KEY (regime_id) REFERENCES renalware.pd_regimes(id);


--
-- Name: problem_comorbidities fk_rails_ca4adc8d18; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidities
    ADD CONSTRAINT fk_rails_ca4adc8d18 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: feed_logs fk_rails_cac6a935ca; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_logs
    ADD CONSTRAINT fk_rails_cac6a935ca FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_sessions fk_rails_cb86dc6d45; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_cb86dc6d45 FOREIGN KEY (provider_id) REFERENCES renalware.hd_providers(id);


--
-- Name: renal_profiles fk_rails_cd10bc0ddf; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_profiles
    ADD CONSTRAINT fk_rails_cd10bc0ddf FOREIGN KEY (prd_description_id) REFERENCES renalware.renal_prd_descriptions(id);


--
-- Name: access_profiles fk_rails_d04ba97fc5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_profiles
    ADD CONSTRAINT fk_rails_d04ba97fc5 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: survey_questions fk_rails_d0558bfd89; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.survey_questions
    ADD CONSTRAINT fk_rails_d0558bfd89 FOREIGN KEY (survey_id) REFERENCES renalware.survey_surveys(id);


--
-- Name: transplant_donor_stages fk_rails_d05e755f4a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donor_stages
    ADD CONSTRAINT fk_rails_d05e755f4a FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: renal_aki_alerts fk_rails_d15c835018; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts
    ADD CONSTRAINT fk_rails_d15c835018 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: events fk_rails_d1c8dd0ee5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.events
    ADD CONSTRAINT fk_rails_d1c8dd0ee5 FOREIGN KEY (subtype_id) REFERENCES renalware.event_subtypes(id);


--
-- Name: medication_prescriptions fk_rails_d2518aa67f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescriptions
    ADD CONSTRAINT fk_rails_d2518aa67f FOREIGN KEY (form_id) REFERENCES renalware.drug_forms(id);


--
-- Name: admission_requests fk_rails_d42c308e35; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_requests
    ADD CONSTRAINT fk_rails_d42c308e35 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_signatures fk_rails_d4aaa80dee; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_signatures
    ADD CONSTRAINT fk_rails_d4aaa80dee FOREIGN KEY (letter_id) REFERENCES renalware.letter_letters(id);


--
-- Name: ukrdc_treatments fk_rails_d5e9d1f118; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.ukrdc_treatments
    ADD CONSTRAINT fk_rails_d5e9d1f118 FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: feed_replay_requests fk_rails_d5fd4c152e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_replay_requests
    ADD CONSTRAINT fk_rails_d5fd4c152e FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: access_plans fk_rails_d61e7c4674; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plans
    ADD CONSTRAINT fk_rails_d61e7c4674 FOREIGN KEY (decided_by_id) REFERENCES renalware.users(id);


--
-- Name: clinic_clinics fk_rails_d7ca5ef0af; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_clinics
    ADD CONSTRAINT fk_rails_d7ca5ef0af FOREIGN KEY (default_modality_description_id) REFERENCES renalware.modality_descriptions(id);


--
-- Name: addresses fk_rails_d873e14e27; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.addresses
    ADD CONSTRAINT fk_rails_d873e14e27 FOREIGN KEY (country_id) REFERENCES renalware.system_countries(id);


--
-- Name: hd_profiles fk_rails_d92d27629e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT fk_rails_d92d27629e FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: access_plans fk_rails_d944a58ba2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plans
    ADD CONSTRAINT fk_rails_d944a58ba2 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: access_plans fk_rails_db0b9b356b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_plans
    ADD CONSTRAINT fk_rails_db0b9b356b FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_observation_requests fk_rails_db5255e417; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_requests
    ADD CONSTRAINT fk_rails_db5255e417 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: pathology_observations fk_rails_dc1b1799e7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observations
    ADD CONSTRAINT fk_rails_dc1b1799e7 FOREIGN KEY (description_id) REFERENCES renalware.pathology_observation_descriptions(id);


--
-- Name: messaging_messages fk_rails_dc393c1672; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_messages
    ADD CONSTRAINT fk_rails_dc393c1672 FOREIGN KEY (replying_to_message_id) REFERENCES renalware.messaging_messages(id);


--
-- Name: pd_pet_adequacy_results fk_rails_dd74a1d162; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_adequacy_results
    ADD CONSTRAINT fk_rails_dd74a1d162 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: messaging_receipts fk_rails_dd8a10c86f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.messaging_receipts
    ADD CONSTRAINT fk_rails_dd8a10c86f FOREIGN KEY (recipient_id) REFERENCES renalware.users(id);


--
-- Name: pathology_current_observation_sets fk_rails_dd99e95861; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_current_observation_sets
    ADD CONSTRAINT fk_rails_dd99e95861 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: patient_practice_memberships fk_rails_dd9db188d9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_practice_memberships
    ADD CONSTRAINT fk_rails_dd9db188d9 FOREIGN KEY (primary_care_physician_id) REFERENCES renalware.patient_primary_care_physicians(id);


--
-- Name: pd_regime_bags fk_rails_de0d26811a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regime_bags
    ADD CONSTRAINT fk_rails_de0d26811a FOREIGN KEY (bag_type_id) REFERENCES renalware.pd_bag_types(id);


--
-- Name: patients fk_rails_de32a1820e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_de32a1820e FOREIGN KEY (first_cause_id) REFERENCES renalware.death_causes(id);


--
-- Name: hospital_departments fk_rails_de41e48081; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hospital_departments
    ADD CONSTRAINT fk_rails_de41e48081 FOREIGN KEY (hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: letter_mailshot_items fk_rails_df39443cf5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mailshot_items
    ADD CONSTRAINT fk_rails_df39443cf5 FOREIGN KEY (mailshot_id) REFERENCES renalware.letter_mailshot_mailshots(id);


--
-- Name: problem_comorbidities fk_rails_df4ed1cba1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_comorbidities
    ADD CONSTRAINT fk_rails_df4ed1cba1 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_infection_organisms fk_rails_df82011585; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_infection_organisms
    ADD CONSTRAINT fk_rails_df82011585 FOREIGN KEY (organism_code_id) REFERENCES renalware.pd_organism_codes(id);


--
-- Name: admission_requests fk_rails_e0d84c3803; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_requests
    ADD CONSTRAINT fk_rails_e0d84c3803 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_stations fk_rails_e1203401d3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_stations
    ADD CONSTRAINT fk_rails_e1203401d3 FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: system_online_reference_links fk_rails_e129006acb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_online_reference_links
    ADD CONSTRAINT fk_rails_e129006acb FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: events fk_rails_e1899a68af; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.events
    ADD CONSTRAINT fk_rails_e1899a68af FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: roles_users fk_rails_e2a7142459; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.roles_users
    ADD CONSTRAINT fk_rails_e2a7142459 FOREIGN KEY (user_id) REFERENCES renalware.users(id);


--
-- Name: hd_diary_slots fk_rails_e2ba4fdc06; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots
    ADD CONSTRAINT fk_rails_e2ba4fdc06 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: pathology_observation_descriptions fk_rails_e31991c52c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_descriptions
    ADD CONSTRAINT fk_rails_e31991c52c FOREIGN KEY (suggested_measurement_unit_id) REFERENCES renalware.pathology_measurement_units(id);


--
-- Name: hd_sessions fk_rails_e32b0e0494; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT fk_rails_e32b0e0494 FOREIGN KEY (signed_off_by_id) REFERENCES renalware.users(id);


--
-- Name: medication_delivery_event_prescriptions fk_rails_e3558e7c0a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_delivery_event_prescriptions
    ADD CONSTRAINT fk_rails_e3558e7c0a FOREIGN KEY (event_id) REFERENCES renalware.medication_delivery_events(id);


--
-- Name: pathology_observation_descriptions fk_rails_e3a215e8ee; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_observation_descriptions
    ADD CONSTRAINT fk_rails_e3a215e8ee FOREIGN KEY (created_by_sender_id) REFERENCES renalware.pathology_senders(id);


--
-- Name: system_view_calls fk_rails_e3b785de75; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_view_calls
    ADD CONSTRAINT fk_rails_e3b785de75 FOREIGN KEY (view_metadata_id) REFERENCES renalware.system_view_metadata(id);


--
-- Name: hd_session_form_batches fk_rails_e3cb548b22; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_form_batches
    ADD CONSTRAINT fk_rails_e3cb548b22 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: geography_postcodes fk_rails_e3d9a6648a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_postcodes
    ADD CONSTRAINT fk_rails_e3d9a6648a FOREIGN KEY (lower_super_output_area_id) REFERENCES renalware.geography_lower_super_output_areas(id);


--
-- Name: transplant_recipient_operations fk_rails_e41edf9bc0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_recipient_operations
    ADD CONSTRAINT fk_rails_e41edf9bc0 FOREIGN KEY (hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: pathology_requests_global_rule_sets fk_rails_e53c500fcd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_global_rule_sets
    ADD CONSTRAINT fk_rails_e53c500fcd FOREIGN KEY (request_description_id) REFERENCES renalware.pathology_request_descriptions(id);


--
-- Name: patient_worry_categories fk_rails_e56eb26d75; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worry_categories
    ADD CONSTRAINT fk_rails_e56eb26d75 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: clinic_clinics fk_rails_e60b8ec1ee; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_clinics
    ADD CONSTRAINT fk_rails_e60b8ec1ee FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_code_groups fk_rails_e70dca7225; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_code_groups
    ADD CONSTRAINT fk_rails_e70dca7225 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: user_groups fk_rails_e74921894f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.user_groups
    ADD CONSTRAINT fk_rails_e74921894f FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_assessments fk_rails_e8c15c8c13; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_assessments
    ADD CONSTRAINT fk_rails_e8c15c8c13 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_peritonitis_episodes fk_rails_e97a696dd5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_e97a696dd5 FOREIGN KEY (fluid_description_id) REFERENCES renalware.pd_fluid_descriptions(id);


--
-- Name: hd_profiles fk_rails_eb5294f3df; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT fk_rails_eb5294f3df FOREIGN KEY (prescriber_id) REFERENCES renalware.users(id);


--
-- Name: access_needling_assessments fk_rails_ec033d247d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.access_needling_assessments
    ADD CONSTRAINT fk_rails_ec033d247d FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: users fk_rails_ec9881f9c2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.users
    ADD CONSTRAINT fk_rails_ec9881f9c2 FOREIGN KEY (hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: problem_problems fk_rails_edf3902cb0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_problems
    ADD CONSTRAINT fk_rails_edf3902cb0 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: clinical_igan_risks fk_rails_ef1fbb24e2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_igan_risks
    ADD CONSTRAINT fk_rails_ef1fbb24e2 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_chart_series fk_rails_ef96d4fa3a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_chart_series
    ADD CONSTRAINT fk_rails_ef96d4fa3a FOREIGN KEY (chart_id) REFERENCES renalware.pathology_charts(id);


--
-- Name: hd_slot_requests fk_rails_ef9e3e268a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_slot_requests
    ADD CONSTRAINT fk_rails_ef9e3e268a FOREIGN KEY (deletion_reason_id) REFERENCES renalware.hd_slot_request_deletion_reasons(id);


--
-- Name: letter_mesh_operations fk_rails_f0319e3bdb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mesh_operations
    ADD CONSTRAINT fk_rails_f0319e3bdb FOREIGN KEY (transmission_id) REFERENCES renalware.letter_mesh_transmissions(id);


--
-- Name: geography_lower_super_output_areas fk_rails_f033a11cb0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.geography_lower_super_output_areas
    ADD CONSTRAINT fk_rails_f033a11cb0 FOREIGN KEY (middle_super_output_area_id) REFERENCES renalware.geography_middle_super_output_areas(id);


--
-- Name: letter_electronic_receipts fk_rails_f0ab49c550; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_electronic_receipts
    ADD CONSTRAINT fk_rails_f0ab49c550 FOREIGN KEY (recipient_id) REFERENCES renalware.users(id);


--
-- Name: clinic_clinics fk_rails_f0adc9d29e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_clinics
    ADD CONSTRAINT fk_rails_f0adc9d29e FOREIGN KEY (user_id) REFERENCES renalware.users(id);


--
-- Name: hd_diary_slots fk_rails_f0b0195037; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diary_slots
    ADD CONSTRAINT fk_rails_f0b0195037 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_preference_sets fk_rails_f0bcae6feb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_preference_sets
    ADD CONSTRAINT fk_rails_f0bcae6feb FOREIGN KEY (hospital_unit_id) REFERENCES renalware.hospital_units(id);


--
-- Name: research_studies fk_rails_f10169e6a9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.research_studies
    ADD CONSTRAINT fk_rails_f10169e6a9 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: drug_vmp_classifications fk_rails_f1111cc6ef; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_vmp_classifications
    ADD CONSTRAINT fk_rails_f1111cc6ef FOREIGN KEY (route_id) REFERENCES renalware.medication_routes(id);


--
-- Name: pd_peritonitis_episodes fk_rails_f228a98e1b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_f228a98e1b FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: clinic_appointments fk_rails_f37cb95f48; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments
    ADD CONSTRAINT fk_rails_f37cb95f48 FOREIGN KEY (consultant_id) REFERENCES renalware.clinic_consultants(id);


--
-- Name: feed_message_replays fk_rails_f392a7199e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.feed_message_replays
    ADD CONSTRAINT fk_rails_f392a7199e FOREIGN KEY (message_id) REFERENCES renalware.feed_messages(id);


--
-- Name: modality_modalities fk_rails_f3af37ca67; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT fk_rails_f3af37ca67 FOREIGN KEY (source_hospital_centre_id) REFERENCES renalware.hospital_centres(id);


--
-- Name: hd_stations fk_rails_f4cc4cd5c4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_stations
    ADD CONSTRAINT fk_rails_f4cc4cd5c4 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_prescription_administrations fk_rails_f51a425d72; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_f51a425d72 FOREIGN KEY (hd_session_id) REFERENCES renalware.hd_sessions(id);


--
-- Name: patient_attachments fk_rails_f5a021419e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_attachments
    ADD CONSTRAINT fk_rails_f5a021419e FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: admission_consults fk_rails_f5abb5bad4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_consults
    ADD CONSTRAINT fk_rails_f5abb5bad4 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_session_form_batches fk_rails_f68439991d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_session_form_batches
    ADD CONSTRAINT fk_rails_f68439991d FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: clinic_appointments fk_rails_f6f9057d90; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinic_appointments
    ADD CONSTRAINT fk_rails_f6f9057d90 FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_mesh_operations fk_rails_f7de3b7808; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_mesh_operations
    ADD CONSTRAINT fk_rails_f7de3b7808 FOREIGN KEY (parent_id) REFERENCES renalware.letter_mesh_operations(id);


--
-- Name: patient_worries fk_rails_f866b9dc2f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patient_worries
    ADD CONSTRAINT fk_rails_f866b9dc2f FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_pet_adequacy_results fk_rails_f8ae33fdba; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_pet_adequacy_results
    ADD CONSTRAINT fk_rails_f8ae33fdba FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: pd_training_sessions fk_rails_f8d9e0a9b0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sessions
    ADD CONSTRAINT fk_rails_f8d9e0a9b0 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: drug_types_drugs fk_rails_f8ed99dfda; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.drug_types_drugs
    ADD CONSTRAINT fk_rails_f8ed99dfda FOREIGN KEY (drug_id) REFERENCES renalware.drugs(id);


--
-- Name: clinical_allergies fk_rails_f8f7b6daad; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_allergies
    ADD CONSTRAINT fk_rails_f8f7b6daad FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: patients fk_rails_fa2fba60f1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT fk_rails_fa2fba60f1 FOREIGN KEY (named_nurse_id) REFERENCES renalware.users(id);


--
-- Name: pd_training_sessions fk_rails_fa412bd095; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sessions
    ADD CONSTRAINT fk_rails_fa412bd095 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: letter_batches fk_rails_fa73ef427b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_batches
    ADD CONSTRAINT fk_rails_fa73ef427b FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: renal_aki_alerts fk_rails_fae5bb71b3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.renal_aki_alerts
    ADD CONSTRAINT fk_rails_fae5bb71b3 FOREIGN KEY (hospital_ward_id) REFERENCES renalware.hospital_wards(id);


--
-- Name: hd_prescription_administrations fk_rails_fb03f6bde8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_prescription_administrations
    ADD CONSTRAINT fk_rails_fb03f6bde8 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: problem_problems fk_rails_fb41553d96; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_problems
    ADD CONSTRAINT fk_rails_fb41553d96 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_requests_patient_rules_requests fk_rails_fc41021986; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_patient_rules_requests
    ADD CONSTRAINT fk_rails_fc41021986 FOREIGN KEY (request_id) REFERENCES renalware.pathology_requests_requests(id);


--
-- Name: system_dashboard_components fk_rails_fc4e7f516a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.system_dashboard_components
    ADD CONSTRAINT fk_rails_fc4e7f516a FOREIGN KEY (dashboard_id) REFERENCES renalware.system_dashboards(id);


--
-- Name: modality_change_types fk_rails_fcb9925881; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_change_types
    ADD CONSTRAINT fk_rails_fcb9925881 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: clinical_dry_weights fk_rails_fdc1dbcc6d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_dry_weights
    ADD CONSTRAINT fk_rails_fdc1dbcc6d FOREIGN KEY (assessor_id) REFERENCES renalware.users(id);


--
-- Name: medication_prescription_terminations fk_rails_fe1184d31a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.medication_prescription_terminations
    ADD CONSTRAINT fk_rails_fe1184d31a FOREIGN KEY (prescription_id) REFERENCES renalware.medication_prescriptions(id);


--
-- Name: low_clearance_profiles fk_rails_ff7b848263; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.low_clearance_profiles
    ADD CONSTRAINT fk_rails_ff7b848263 FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: hd_diaries fk_rails_ffb6b0d291; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_diaries
    ADD CONSTRAINT fk_rails_ffb6b0d291 FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: admission_admissions fk_rails_ffd7d79d65; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.admission_admissions
    ADD CONSTRAINT fk_rails_ffd7d79d65 FOREIGN KEY (summarised_by_id) REFERENCES renalware.users(id);


--
-- Name: clinical_dry_weights hd_dry_weights_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_dry_weights
    ADD CONSTRAINT hd_dry_weights_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: clinical_dry_weights hd_dry_weights_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.clinical_dry_weights
    ADD CONSTRAINT hd_dry_weights_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_preference_sets hd_preference_sets_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_preference_sets
    ADD CONSTRAINT hd_preference_sets_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_preference_sets hd_preference_sets_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_preference_sets
    ADD CONSTRAINT hd_preference_sets_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_profiles hd_profiles_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT hd_profiles_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_profiles hd_profiles_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_profiles
    ADD CONSTRAINT hd_profiles_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_sessions hd_sessions_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT hd_sessions_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: hd_sessions hd_sessions_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.hd_sessions
    ADD CONSTRAINT hd_sessions_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_archives letter_archives_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_archives
    ADD CONSTRAINT letter_archives_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_archives letter_archives_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_archives
    ADD CONSTRAINT letter_archives_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_letters letter_letters_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT letter_letters_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: letter_letters letter_letters_patient_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT letter_letters_patient_id_fk FOREIGN KEY (patient_id) REFERENCES renalware.patients(id);


--
-- Name: letter_letters letter_letters_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.letter_letters
    ADD CONSTRAINT letter_letters_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: modality_modalities modality_modalities_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT modality_modalities_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: modality_modalities modality_modalities_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.modality_modalities
    ADD CONSTRAINT modality_modalities_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_requests_requests pathology_requests_requests_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_requests
    ADD CONSTRAINT pathology_requests_requests_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: pathology_requests_requests pathology_requests_requests_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pathology_requests_requests
    ADD CONSTRAINT pathology_requests_requests_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: patients patients_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT patients_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: patients patients_practice_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT patients_practice_id_fk FOREIGN KEY (practice_id) REFERENCES renalware.patient_practices(id);


--
-- Name: patients patients_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.patients
    ADD CONSTRAINT patients_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: pd_regimes pd_regimes_system_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_regimes
    ADD CONSTRAINT pd_regimes_system_id_fk FOREIGN KEY (system_id) REFERENCES renalware.pd_systems(id);


--
-- Name: pd_training_sessions pd_training_sessions_site_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sessions
    ADD CONSTRAINT pd_training_sessions_site_id_fk FOREIGN KEY (training_site_id) REFERENCES renalware.pd_training_sites(id);


--
-- Name: pd_training_sessions pd_training_sessions_type_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.pd_training_sessions
    ADD CONSTRAINT pd_training_sessions_type_id_fk FOREIGN KEY (training_type_id) REFERENCES renalware.pd_training_types(id);


--
-- Name: problem_notes problem_notes_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_notes
    ADD CONSTRAINT problem_notes_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: problem_notes problem_notes_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.problem_notes
    ADD CONSTRAINT problem_notes_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- Name: transplant_donations transplant_donations_recipient_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_donations
    ADD CONSTRAINT transplant_donations_recipient_id_fk FOREIGN KEY (recipient_id) REFERENCES renalware.patients(id);


--
-- Name: transplant_registration_statuses transplant_registration_statuses_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_statuses
    ADD CONSTRAINT transplant_registration_statuses_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES renalware.users(id);


--
-- Name: transplant_registration_statuses transplant_registration_statuses_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renalware.transplant_registration_statuses
    ADD CONSTRAINT transplant_registration_statuses_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES renalware.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO renalware,renalware_demo,public,heroku_ext;

INSERT INTO "schema_migrations" (version) VALUES
('20241230130328'),
('20241220180547'),
('20241212115831'),
('20241205164429'),
('20241127162800'),
('20241126174455'),
('20241122100703'),
('20240917092223'),
('20240909111139'),
('20240830091929'),
('20240821160342'),
('20240819095023'),
('20240808154403'),
('20240807111645'),
('20240716103158'),
('20240709161234'),
('20240709161233'),
('20240709161232'),
('20240709161231'),
('20240709161230'),
('20240709161229'),
('20240709161228'),
('20240709161227'),
('20240709161226'),
('20240709080114'),
('20240628112023'),
('20240628111805'),
('20240627162732'),
('20240627145638'),
('20240625085012'),
('20240620135421'),
('20240612132844'),
('20240612105341'),
('20240607103238'),
('20240523145856'),
('20240521123515'),
('20240520100213'),
('20240519153121'),
('20240515125333'),
('20240515081225'),
('20240505190155'),
('20240502111740'),
('20240501155334'),
('20240501151609'),
('20240430130439'),
('20240430094851'),
('20240424134926'),
('20240418190439'),
('20240411164343'),
('20240409114257'),
('20240405092805'),
('20240405083738'),
('20240321174505'),
('20240321174504'),
('20240321174503'),
('20240321174502'),
('20240318191505'),
('20240318182553'),
('20240314134618'),
('20240314132659'),
('20240307171400'),
('20240305160414'),
('20240229210002'),
('20240227120942'),
('20240220091704'),
('20240206085751'),
('20240126163515'),
('20240118203934'),
('20240111043244'),
('20231221094630'),
('20231213170649'),
('20231212112543'),
('20231212065241'),
('20231211172855'),
('20231206115315'),
('20231130114143'),
('20231130102622'),
('20231121094056'),
('20231120203514'),
('20231120165114'),
('20231115160013'),
('20231115135028'),
('20231115125057'),
('20231113124516'),
('20231112080224'),
('20231106173109'),
('20231101152934'),
('20231025115724'),
('20231019083713'),
('20231009170342'),
('20231009170341'),
('20231006132259'),
('20231004172532'),
('20230918172419'),
('20230915220000'),
('20230915144448'),
('20230913133958'),
('20230913132527'),
('20230912091352'),
('20230911114828'),
('20230831162729'),
('20230825143006'),
('20230825141714'),
('20230825104746'),
('20230825083329'),
('20230816111543'),
('20230808150041'),
('20230718171106'),
('20230714135534'),
('20230706094637'),
('20230705153656'),
('20230705151013'),
('20230705144308'),
('20230704100221'),
('20230704072649'),
('20230703164605'),
('20230621103930'),
('20230609133900'),
('20230609133416'),
('20230608171855'),
('20230608154421'),
('20230608110737'),
('20230608081348'),
('20230607104435'),
('20230602083513'),
('20230531155854'),
('20230531112529'),
('20230525112511'),
('20230523121919'),
('20230511151434'),
('20230510144745'),
('20230503185921'),
('20230503161542'),
('20230503143211'),
('20230429094954'),
('20230427073423'),
('20230424121332'),
('20230416132329'),
('20230416122815'),
('20230411205557'),
('20230411202441'),
('20230406131911'),
('20230403210211'),
('20230329165043'),
('20230329130612'),
('20230329124526'),
('20230323223232'),
('20230302134826'),
('20230223102724'),
('20230221110514'),
('20230217163005'),
('20230217162648'),
('20230217155112'),
('20230217154430'),
('20230216115437'),
('20230216115337'),
('20230215105027'),
('20230213103715'),
('20230206192012'),
('20230206192011'),
('20230206192010'),
('20230203174407'),
('20230203174406'),
('20230112115053'),
('20230109182535'),
('20230105193358'),
('20230104102024'),
('20221222213600'),
('20221222212557'),
('20221221213000'),
('20221221212557'),
('20221221163602'),
('20221220201434'),
('20221220193005'),
('20221211013808'),
('20221210222443'),
('20221209223110'),
('20221209222847'),
('20221208202357'),
('20221206202033'),
('20221205223711'),
('20221027100532'),
('20221013094654'),
('20221012114542'),
('20221006200436'),
('20220928115421'),
('20220926211723'),
('20220926171513'),
('20220915151614'),
('20220915150710'),
('20220915145956'),
('20220915144534'),
('20220907174253'),
('20220824154208'),
('20220813081749'),
('20220812154454'),
('20220701153541'),
('20220621084947'),
('20220620141323'),
('20220606105217'),
('20220601162848'),
('20220520100619'),
('20220519120540'),
('20220518182012'),
('20220512161700'),
('20220512142640'),
('20220507073059'),
('20220407084109'),
('20220405114521'),
('20220307174658'),
('20220301162239'),
('20220210152018'),
('20220120172755'),
('20220116183123'),
('20220114171857'),
('20220113132731'),
('20220110135105'),
('20220107182152'),
('20220105160514'),
('20211216145755'),
('20211215111646'),
('20211209123828'),
('20211208132638'),
('20211208115229'),
('20211208114210'),
('20211208111353'),
('20211208110337'),
('20211208104601'),
('20211202085557'),
('20211125104700'),
('20211123105422'),
('20211121144203'),
('20211121142636'),
('20211119132257'),
('20211118173235'),
('20211118105354'),
('20211111141233'),
('20211110125711'),
('20211108142747'),
('20211107184117'),
('20211103075628'),
('20211029134446'),
('20211029134250'),
('20211029105908'),
('20211028195511'),
('20211028185908'),
('20211028165711'),
('20211028160832'),
('20211028142853'),
('20211022063251'),
('20211021151707'),
('20211021125142'),
('20211020092822'),
('20211008163436'),
('20210921140641'),
('20210920164222'),
('20210920164152'),
('20210920162339'),
('20210920153420'),
('20210903123803'),
('20210818142811'),
('20210818142810'),
('20210812011910'),
('20210812011726'),
('20210723131206'),
('20210722101902'),
('20210709132605'),
('20210705082359'),
('20210701161843'),
('20210611152736'),
('20210604070039'),
('20210531082528'),
('20210419161507'),
('20210419111931'),
('20210419110721'),
('20210414103735'),
('20210413180237'),
('20210412171437'),
('20210412120604'),
('20210410111406'),
('20210410111402'),
('20210410111401'),
('20210329090650'),
('20210315151618'),
('20210310154134'),
('20210308153253'),
('20210305191214'),
('20210305181345'),
('20210305105830'),
('20210305100015'),
('20210127122810'),
('20210126175527'),
('20210115181817'),
('20210105163944'),
('20201229174653'),
('20201217155107'),
('20201217154345'),
('20201112152752'),
('20201110164344'),
('20201105153422'),
('20201023092859'),
('20201021154809'),
('20201021153832'),
('20201020171139'),
('20201020170921'),
('20201020164524'),
('20201020155510'),
('20201015160542'),
('20201012171428'),
('20201012160414'),
('20201009090959'),
('20201001145452'),
('20201001144512'),
('20200817103930'),
('20200817085618'),
('20200815150303'),
('20200812074223'),
('20200628094228'),
('20200626090256'),
('20200626081248'),
('20200622120232'),
('20200618144228'),
('20200616115709'),
('20200427123229'),
('20200421143546'),
('20200421132911'),
('20200421082715'),
('20200408131217'),
('20200401115705'),
('20200320103052'),
('20200318134807'),
('20200316131136'),
('20200313120655'),
('20200306183423'),
('20200301124300'),
('20200301124200'),
('20200301113102'),
('20200226145010'),
('20200219113324'),
('20200205185151'),
('20200205121805'),
('20200204153231'),
('20200131133223'),
('20200129093835'),
('20200127170711'),
('20200127165951'),
('20200122190909'),
('20200122182036'),
('20200122182018'),
('20200114151225'),
('20200110160241'),
('20200110153522'),
('20200106210851'),
('20200106073329'),
('20191219145651'),
('20191213094611'),
('20191209163151'),
('20191209160151'),
('20191205185835'),
('20191203112310'),
('20191108105923'),
('20191105095304'),
('20191029095202'),
('20191026120029'),
('20191018144917'),
('20191018143635'),
('20191012121433'),
('20191008045159'),
('20191008030154'),
('20191008024636'),
('20191008010839'),
('20190928131032'),
('20190927130911'),
('20190927124840'),
('20190925173849'),
('20190925161724'),
('20190925130052'),
('20190925104902'),
('20190920063447'),
('20190919073410'),
('20190917124204'),
('20190916160231'),
('20190915083424'),
('20190915071451'),
('20190909084425'),
('20190902085216'),
('20190830153416'),
('20190830082736'),
('20190823105642'),
('20190823051014'),
('20190823044107'),
('20190822180201'),
('20190822175644'),
('20190723150737'),
('20190722145936'),
('20190718095851'),
('20190718091430'),
('20190716125837'),
('20190709101610'),
('20190705105921'),
('20190705083727'),
('20190627141751'),
('20190624130020'),
('20190617121528'),
('20190612124015'),
('20190611152859'),
('20190607134717'),
('20190603165812'),
('20190603143834'),
('20190603135247'),
('20190603084428'),
('20190602114659'),
('20190531172829'),
('20190520091324'),
('20190516093707'),
('20190513135312'),
('20190513131826'),
('20190512155900'),
('20190511164137'),
('20190424101709'),
('20190422095620'),
('20190401105149'),
('20190327100851'),
('20190325134823'),
('20190322120025'),
('20190315125638'),
('20190307123232'),
('20190306121545'),
('20190226162607'),
('20190225103005'),
('20190218142207'),
('20190213104817'),
('20190210143717'),
('20190210125211'),
('20190209135334'),
('20190201151346'),
('20190131152758'),
('20190128094652'),
('20190125132911'),
('20190125130940'),
('20190125111045'),
('20190121135548'),
('20190121125239'),
('20190121092403'),
('20190120105229'),
('20190117144832'),
('20190110100057'),
('20190109122032'),
('20190109121934'),
('20190107163734'),
('20190104170135'),
('20190104095254'),
('20181217124025'),
('20181126123745'),
('20181126090401'),
('20181109110616'),
('20181106133500'),
('20181026145459'),
('20181025170410'),
('20181013115138'),
('20181008145159'),
('20181008144324'),
('20181001162513'),
('20180907100545'),
('20180831134926'),
('20180831134606'),
('20180815144429'),
('20180814103916'),
('20180803131157'),
('20180802144507'),
('20180802132417'),
('20180802103013'),
('20180730154454'),
('20180725132808'),
('20180725132557'),
('20180718172750'),
('20180712143314'),
('20180702091352'),
('20180702091237'),
('20180702091222'),
('20180628132323'),
('20180625124431'),
('20180622130552'),
('20180605175211'),
('20180605141806'),
('20180605114332'),
('20180524074320'),
('20180524072633'),
('20180516111411'),
('20180514151627'),
('20180511171835'),
('20180511140415'),
('20180511100345'),
('20180510151959'),
('20180502110638'),
('20180502093256'),
('20180427133558'),
('20180422090043'),
('20180419141524'),
('20180328210434'),
('20180327100423'),
('20180326155400'),
('20180323150241'),
('20180319191942'),
('20180313124819'),
('20180313114927'),
('20180311104609'),
('20180311071146'),
('20180309140316'),
('20180307223111'),
('20180307191650'),
('20180306080518'),
('20180306071308'),
('20180305134959'),
('20180301095040'),
('20180226132410'),
('20180226124724'),
('20180223100420'),
('20180222090501'),
('20180221210458'),
('20180216132741'),
('20180214124317'),
('20180213171805'),
('20180213125734'),
('20180213124203'),
('20180208150629'),
('20180207082540'),
('20180206225525'),
('20180202184954'),
('20180201090444'),
('20180130165803'),
('20180126142314'),
('20180125201356'),
('20180122173922'),
('20180121115246'),
('20180119121243'),
('20180112151813'),
('20180112151706'),
('20180108185400'),
('20180105132358'),
('20180102155055'),
('20171222153815'),
('20171219154529'),
('20171215122454'),
('20171214190849'),
('20171214141335'),
('20171213111513'),
('20171211161400'),
('20171211131918'),
('20171211130716'),
('20171208211206'),
('20171206140738'),
('20171206121652'),
('20171204112150'),
('20171128163543'),
('20171127092359'),
('20171127092158'),
('20171127082158'),
('20171123154116'),
('20171123143534'),
('20171123123712'),
('20171118160030'),
('20171116103230'),
('20171114120904'),
('20171113120217'),
('20171109084751'),
('20171106100216'),
('20171101162244'),
('20171101121130'),
('20171017171625'),
('20171017132738'),
('20171016152223'),
('20171013145849'),
('20171012143050'),
('20171012110133'),
('20171009181615'),
('20171009104106'),
('20171005144505'),
('20171005130109'),
('20171005091202'),
('20171005081224'),
('20171004110909'),
('20171004092235'),
('20171003122425'),
('20171003111228'),
('20171003093347'),
('20171002175804'),
('20170926132845'),
('20170926081426'),
('20170925182738'),
('20170925161033'),
('20170920113628'),
('20170917185426'),
('20170916121019'),
('20170915115228'),
('20170915090544'),
('20170912092135'),
('20170911133224'),
('20170908160250'),
('20170908155011'),
('20170831142819'),
('20170831084331'),
('20170831082043'),
('20170830171726'),
('20170830085137'),
('20170824113401'),
('20170823084127'),
('20170821100353'),
('20170810093532'),
('20170810092953'),
('20170809080925'),
('20170725120242'),
('20170720080033'),
('20170712090217'),
('20170711140926'),
('20170711140607'),
('20170707110155'),
('20170705160726'),
('20170705150913'),
('20170705135512'),
('20170705090219'),
('20170703153949'),
('20170703144902'),
('20170628115247'),
('20170627110619'),
('20170627110058'),
('20170622145529'),
('20170621205538'),
('20170621102157'),
('20170620121255'),
('20170619100927'),
('20170615184503'),
('20170615144802'),
('20170615130714'),
('20170614140457'),
('20170609144233'),
('20170608192234'),
('20170608135953'),
('20170608135553'),
('20170606182242'),
('20170606160731'),
('20170606131948'),
('20170605161951'),
('20170605103133'),
('20170605102519'),
('20170602124855'),
('20170601142904'),
('20170526061000'),
('20170526060804'),
('20170524134229'),
('20170523125610'),
('20170522151032'),
('20170515105635'),
('20170515093430'),
('20170512150125'),
('20170505112521'),
('20170505104641'),
('20170502165422'),
('20170427130642'),
('20170427123530'),
('20170424064032'),
('20170403094115'),
('20170403092407'),
('20170403091407'),
('20170331153349'),
('20170331115718'),
('20170323100125'),
('20170320124532'),
('20170320112730'),
('20170315100152'),
('20170314120712'),
('20170314115111'),
('20170314114614'),
('20170313154020'),
('20170308173219'),
('20170306093012'),
('20170228131923'),
('20170227154311'),
('20170222135148'),
('20170220150611'),
('20170217161409'),
('20170217141529'),
('20170217132644'),
('20170217123531'),
('20170213140513'),
('20170210133517'),
('20170210124019'),
('20170207195029'),
('20170203145405'),
('20170203102941'),
('20170124153334'),
('20170120135631'),
('20170110161149'),
('20170106164639'),
('20170106161800'),
('20170103161015'),
('20161216155218'),
('20161216090417'),
('20161215090417'),
('20161214172314'),
('20161212181500'),
('20161212133822'),
('20161212095607'),
('20161207183903'),
('20161207115413'),
('20161202155429'),
('20161201183449'),
('20161201165330'),
('20161129122629'),
('20161124152732'),
('20161123142841'),
('20161123141041'),
('20161122112905'),
('20161121143011'),
('20161118165332'),
('20161118100149'),
('20161117133825'),
('20161117101457'),
('20161115164413'),
('20161114184444'),
('20161114174727'),
('20161111154939'),
('20161108123101'),
('20161107141354'),
('20161103091319'),
('20161101105519'),
('20161031170940'),
('20161028145040'),
('20161027165025'),
('20161019145606'),
('20161018174711'),
('20161014134639'),
('20161010191529'),
('20161004185820'),
('20161003204347'),
('20161003192717'),
('20160930111424'),
('20160922154638'),
('20160916113152'),
('20160906195949'),
('20160905140623'),
('20160830141439'),
('20160829114845'),
('20160824132805'),
('20160823173525'),
('20160822130644'),
('20160818131917'),
('20160817095514'),
('20160812073900'),
('20160812073616'),
('20160809095951'),
('20160805120015'),
('20160729095901'),
('20160729083654'),
('20160728103933'),
('20160728094200'),
('20160726170852'),
('20160726150709'),
('20160628141349'),
('20160620131148'),
('20160616163622'),
('20160613120910'),
('20160531141853'),
('20160530170058'),
('20160530162720'),
('20160530162708'),
('20160527104432'),
('20160525124151'),
('20160524171947'),
('20160518111325'),
('20160518110836'),
('20160510155932'),
('20160509171244'),
('20160509151927'),
('20160509134929'),
('20160509134401'),
('20160506151356'),
('20160506104710'),
('20160505151102'),
('20160505142813'),
('20160503113814'),
('20160426112409'),
('20160426093341'),
('20160420132524'),
('20160419132410'),
('20160412123106'),
('20160327221550'),
('20160314181446'),
('20160304162205'),
('20160304151540'),
('20160304151449'),
('20160303151540'),
('20160303151449'),
('20160302192055'),
('20160218220145'),
('20160209203446'),
('20160208153327'),
('20160203160041'),
('20160203160040'),
('20160202152252'),
('20160121175712'),
('20160121175711'),
('20160120213001'),
('20160120213000'),
('20160120203755'),
('20160120203754'),
('20160120203753'),
('20160120203748'),
('20160120203747'),
('20160114222043'),
('20160106167020'),
('20151207167020'),
('20151207163304'),
('20151207163303'),
('20151116170200'),
('20151116170100'),
('20151116111600'),
('20151111194419'),
('20151104183740'),
('20151103210628'),
('20151022190252'),
('20151022184845'),
('20151021194419'),
('20151014205537'),
('20150923201215'),
('20150717093153'),
('20150709152737'),
('20150702084036'),
('20150701104744'),
('20150623105816'),
('20150623083220'),
('20150608093002'),
('20150608093001'),
('20150608093000'),
('20150605151945'),
('20150605095934'),
('20150602151910'),
('20150515155052'),
('20150515154952'),
('20150514113239'),
('20150313124325'),
('20150312113937'),
('20150312112909'),
('20150302171638'),
('20150224140027'),
('20150213103857'),
('20150213103856'),
('20150213103855'),
('20150203161438'),
('20150120155952'),
('20150119160039'),
('20150109152145'),
('20150109113417'),
('20141223135724'),
('20141223135723'),
('20141222110119'),
('20141208160813'),
('20141107145615'),
('20141107145614'),
('20141107145549'),
('20141024111716'),
('20141024111715'),
('20141023111038'),
('20141020170329'),
('20141010170329'),
('20141004150240');

