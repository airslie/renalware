SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: renalware; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA renalware;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: intarray; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;


--
-- Name: EXTENSION intarray; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION intarray IS 'functions, operators, and index support for 1-D arrays of integers';


--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = renalware, pg_catalog;

--
-- Name: audit_view_as_json(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION audit_view_as_json(view_name text) RETURNS json
    LANGUAGE plpgsql
    AS $$
  DECLARE result json;
  BEGIN
  EXECUTE format('
  select row_to_json(t)
    from (
      select
        current_timestamp as runat,
        (select array_to_json(array_agg(row_to_json(d))
      )
    from (select * from %s) d) as data) t;
    ', quote_ident(view_name)) into result;
  return result;
END
$$;


--
-- Name: convert_to_float(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION convert_to_float(v_input text) RETURNS double precision
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
-- Name: count_estimate(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION count_estimate(query text) RETURNS integer
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
-- Name: import_gps_csv(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION import_gps_csv(file text) RETURNS void
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

CREATE FUNCTION import_practice_memberships_csv(file text) RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN

  DROP TABLE IF EXISTS copied_memberships;
  CREATE TEMP TABLE copied_memberships (
    gp_code text NOT NULL,
    practice_code text NOT NULL,
    unused3 text,
    unused4 text,
    unused5 text,
    unused7 text
  );

  -- Import the CSV file into copied_memberships - note there is no CSV header in this file
  EXECUTE format ('COPY copied_memberships FROM %L DELIMITER %L CSV ', file, ',');

  DROP TABLE IF EXISTS tmp_memberships;
  CREATE TEMP TABLE tmp_memberships AS
    SELECT
      gp_code,
      practice_code,
      patient_primary_care_physicians.id primary_care_physician_id,
      patient_practices.id as practice_id
      from copied_memberships
      INNER JOIN patient_practices on patient_practices.code = practice_code
      INNER JOIN patient_primary_care_physicians on patient_primary_care_physicians.code = gp_code;

  -- Insert any new memberships, ignoring any conflicts where the
  -- practice_id + primary_care_physician_id already exists
  INSERT INTO renalware.patient_practice_memberships
    (practice_id, primary_care_physician_id, created_at, updated_at)
  SELECT
    practice_id,
    primary_care_physician_id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM tmp_memberships
  ON CONFLICT (practice_id, primary_care_physician_id) DO NOTHING;

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
-- Name: import_practices_csv(text); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION import_practices_csv(file text) RETURNS void
    LANGUAGE plpgsql
    AS $$
  BEGIN
  /*
  Imports a practices.csv file created by parsing out an HSCOrgRefData_Full_xxxxx.xml file.
  */
  DROP TABLE IF EXISTS tmp_practices;

  CREATE TEMP TABLE tmp_practices (
    code text NOT NULL,
    name text NOT NULL,
    tel text,
    street_1 text,
    street_2 text,
    street_3 text,
    town text,
    county text,
    postcode text NOT NULL,
    region text,
    country_id integer,
    active text NOT NULL,
    CONSTRAINT tmp_practices_pkey PRIMARY KEY (code)
  );

  /* Import the CSV file into tmp_practices, ignoring the first row which is a header */
  EXECUTE format ('COPY tmp_practices FROM %L DELIMITER %L CSV HEADER', file, ',');

  /* Upsert practices */
  WITH data(
      code,
      name,
      telephone,
      street_1,
      street_2,
      street_3,
      town,
      county,
      postcode,
      region,
      country_id,
      active)
    AS (select * from tmp_practices)
    , practice_changes AS (
        INSERT INTO patient_practices (code, name, telephone, created_at, updated_at)
        SELECT code, name, telephone, clock_timestamp(), clock_timestamp()
        FROM data
        ON CONFLICT (code) DO UPDATE
          SET
            name = excluded.name,
            telephone = excluded.telephone,
            updated_at = excluded.updated_at
          RETURNING code, id
      )

  /* Upsert practice addresses */
  INSERT INTO addresses (
    addressable_type,
    addressable_id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    region,
    country_id,
    created_at,
    updated_at)
  SELECT
    'Renalware::Patients::Practice',
    practice_changes.id,
    street_1,
    street_2,
    street_3,
    town,
    county,
    postcode,
    region,
    country_id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
    FROM data join practice_changes using(code)
  ON CONFLICT (addressable_type, addressable_id) DO UPDATE
    SET
    street_1 = excluded.street_1,
    street_2 = excluded.street_2,
    street_3 = excluded.street_3,
    town = excluded.town,
    county = excluded.county,
    postcode = excluded.postcode,
    region = excluded.region,
    country_id = excluded.country_id,
    updated_at = clock_timestamp();

  /* Update the deleted_at column of any practices which do not have an Active status_code */
  UPDATE patient_practices AS p
  SET deleted_at = CURRENT_TIMESTAMP
  FROM tmp_practices AS tp
  WHERE p.code = tp.code AND tp.active = 'false';

  /* Set deleted_at tp NULL for active practices */
  UPDATE patient_practices AS p
  SET deleted_at = NULL
  FROM tmp_practices AS tp
  WHERE p.code = tp.code AND tp.active != 'false';

  DROP TABLE tmp_practices;

  END;
  $$;


--
-- Name: preprocess_hl7_message(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION preprocess_hl7_message() RETURNS trigger
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

CREATE FUNCTION pseudo_encrypt(value integer) RETURNS integer
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

CREATE FUNCTION refresh_all_matierialized_views(_schema text DEFAULT '*'::text, _concurrently boolean DEFAULT false) RETURNS integer
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

CREATE FUNCTION refresh_current_observation_set(a_patient_id integer) RETURNS integer
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

CREATE FUNCTION update_current_observation_set_from_trigger() RETURNS trigger
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
  RAISE NOTICE 'TRIGGER called on %',TG_TABLE_NAME ;

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

    -- Output some info to helps us debug. This can be removed later.
    RAISE NOTICE '  Request id % Patient id % Code %', NEW.request_id, a_patient_id, a_code;
    RAISE NOTICE '  Last %: % at %', a_code, current_result, current_observed_at;
    RAISE NOTICE '  New  %: % at %', a_code, NEW.result, new_observed_at;

    IF current_observed_at IS NULL OR new_observed_at >= current_observed_at THEN
      -- The new pathology_observation row contain a more recent result that the old one.
      -- (note there may not be an old one if the patient has neve had this obs before).

      RAISE NOTICE '  Updating pathology_current_observation_sets..';

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
-- Name: update_research_study_participants_from_trigger(); Type: FUNCTION; Schema: renalware; Owner: -
--

CREATE FUNCTION update_research_study_participants_from_trigger() RETURNS trigger
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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


SET search_path = renalware, pg_catalog;

--
-- Name: access_assessments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_assessments (
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

CREATE SEQUENCE access_assessments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_assessments_id_seq OWNED BY access_assessments.id;


--
-- Name: access_catheter_insertion_techniques; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_catheter_insertion_techniques (
    id integer NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_catheter_insertion_techniques_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE access_catheter_insertion_techniques_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_catheter_insertion_techniques_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_catheter_insertion_techniques_id_seq OWNED BY access_catheter_insertion_techniques.id;


--
-- Name: access_plan_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_plan_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_plan_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE access_plan_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_plan_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_plan_types_id_seq OWNED BY access_plan_types.id;


--
-- Name: access_plans; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_plans (
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

CREATE SEQUENCE access_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_plans_id_seq OWNED BY access_plans.id;


--
-- Name: access_procedures; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_procedures (
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

CREATE SEQUENCE access_procedures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_procedures_id_seq OWNED BY access_procedures.id;


--
-- Name: access_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_profiles (
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

CREATE SEQUENCE access_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_profiles_id_seq OWNED BY access_profiles.id;


--
-- Name: access_sites; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_sites (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: access_sites_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE access_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_sites_id_seq OWNED BY access_sites.id;


--
-- Name: access_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    abbreviation character varying,
    rr02_code character varying,
    rr41_code character varying
);


--
-- Name: access_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE access_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_types_id_seq OWNED BY access_types.id;


--
-- Name: access_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE access_versions (
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

CREATE SEQUENCE access_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE access_versions_id_seq OWNED BY access_versions.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE active_storage_attachments (
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

CREATE SEQUENCE active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE active_storage_attachments_id_seq OWNED BY active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE active_storage_blobs_id_seq OWNED BY active_storage_blobs.id;


--
-- Name: addresses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE addresses (
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

CREATE SEQUENCE addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: admission_admissions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE admission_admissions (
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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admission_admissions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE admission_admissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_admissions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE admission_admissions_id_seq OWNED BY admission_admissions.id;


--
-- Name: admission_consult_sites; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE admission_consult_sites (
    id bigint NOT NULL,
    name character varying
);


--
-- Name: admission_consult_sites_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE admission_consult_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_consult_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE admission_consult_sites_id_seq OWNED BY admission_consult_sites.id;


--
-- Name: admission_consults; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE admission_consults (
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
    rrt boolean DEFAULT false NOT NULL
);


--
-- Name: admission_consults_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE admission_consults_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_consults_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE admission_consults_id_seq OWNED BY admission_consults.id;


--
-- Name: admission_request_reasons; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE admission_request_reasons (
    id bigint NOT NULL,
    description character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admission_request_reasons_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE admission_request_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_request_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE admission_request_reasons_id_seq OWNED BY admission_request_reasons.id;


--
-- Name: admission_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE admission_requests (
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

CREATE SEQUENCE admission_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admission_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE admission_requests_id_seq OWNED BY admission_requests.id;


--
-- Name: clinic_appointments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinic_appointments (
    id integer NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    patient_id integer NOT NULL,
    user_id integer NOT NULL,
    clinic_id integer NOT NULL,
    becomes_visit_id integer
);


--
-- Name: clinic_appointments_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE clinic_appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinic_appointments_id_seq OWNED BY clinic_appointments.id;


--
-- Name: clinic_clinics; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinic_clinics (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: clinic_clinics_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE clinic_clinics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_clinics_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinic_clinics_id_seq OWNED BY clinic_clinics.id;


--
-- Name: clinic_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinic_versions (
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

CREATE SEQUENCE clinic_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinic_versions_id_seq OWNED BY clinic_versions.id;


--
-- Name: clinic_visits; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinic_visits (
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
    standing_diastolic_bp integer
);


--
-- Name: clinic_visits_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE clinic_visits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinic_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinic_visits_id_seq OWNED BY clinic_visits.id;


--
-- Name: clinical_allergies; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinical_allergies (
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

CREATE SEQUENCE clinical_allergies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_allergies_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinical_allergies_id_seq OWNED BY clinical_allergies.id;


--
-- Name: clinical_body_compositions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinical_body_compositions (
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
    assessor_id integer NOT NULL
);


--
-- Name: clinical_body_compositions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE clinical_body_compositions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_body_compositions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinical_body_compositions_id_seq OWNED BY clinical_body_compositions.id;


--
-- Name: clinical_dry_weights; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinical_dry_weights (
    id integer NOT NULL,
    patient_id integer,
    weight double precision NOT NULL,
    assessed_on date NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    assessor_id integer NOT NULL
);


--
-- Name: clinical_dry_weights_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE clinical_dry_weights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_dry_weights_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinical_dry_weights_id_seq OWNED BY clinical_dry_weights.id;


--
-- Name: clinical_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE clinical_versions (
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

CREATE SEQUENCE clinical_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clinical_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE clinical_versions_id_seq OWNED BY clinical_versions.id;


--
-- Name: death_causes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE death_causes (
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

CREATE SEQUENCE death_causes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: death_causes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE death_causes_id_seq OWNED BY death_causes.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE delayed_jobs (
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

CREATE SEQUENCE delayed_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: directory_people; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE directory_people (
    id integer NOT NULL,
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

CREATE SEQUENCE directory_people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: directory_people_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE directory_people_id_seq OWNED BY directory_people.id;


--
-- Name: drug_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE drug_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: drug_types_drugs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE drug_types_drugs (
    drug_id integer NOT NULL,
    drug_type_id integer NOT NULL,
    id bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: drug_types_drugs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE drug_types_drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_types_drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE drug_types_drugs_id_seq OWNED BY drug_types_drugs.id;


--
-- Name: drug_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE drug_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drug_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE drug_types_id_seq OWNED BY drug_types.id;


--
-- Name: drugs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE drugs (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    vmpid bigint,
    description character varying
);


--
-- Name: drugs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE drugs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE drugs_id_seq OWNED BY drugs.id;


--
-- Name: event_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE event_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event_class_name character varying,
    slug character varying
);


--
-- Name: event_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE event_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE event_types_id_seq OWNED BY event_types.id;


--
-- Name: events; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE events (
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
    document jsonb
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: feed_file_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE feed_file_types (
    id integer NOT NULL,
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

CREATE SEQUENCE feed_file_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_file_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE feed_file_types_id_seq OWNED BY feed_file_types.id;


--
-- Name: feed_files; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE feed_files (
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

CREATE SEQUENCE feed_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_files_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE feed_files_id_seq OWNED BY feed_files.id;


--
-- Name: feed_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE feed_messages (
    id integer NOT NULL,
    event_code character varying NOT NULL,
    header_id character varying NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body_hash text,
    patient_identifier character varying
);


--
-- Name: feed_messages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE feed_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feed_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE feed_messages_id_seq OWNED BY feed_messages.id;


--
-- Name: hd_cannulation_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_cannulation_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_cannulation_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_cannulation_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_cannulation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_cannulation_types_id_seq OWNED BY hd_cannulation_types.id;


--
-- Name: hd_dialysates; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_dialysates (
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

CREATE SEQUENCE hd_dialysates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_dialysates_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_dialysates_id_seq OWNED BY hd_dialysates.id;


--
-- Name: hd_dialysers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_dialysers (
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

CREATE SEQUENCE hd_dialysers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_dialysers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_dialysers_id_seq OWNED BY hd_dialysers.id;


--
-- Name: hd_diaries; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_diaries (
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

CREATE SEQUENCE hd_diaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_diaries_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_diaries_id_seq OWNED BY hd_diaries.id;


--
-- Name: hd_diary_slots; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_diary_slots (
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
    CONSTRAINT day_of_week_in_valid_range CHECK (((day_of_week >= 1) AND (day_of_week <= 7)))
);


--
-- Name: hd_diary_slots_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_diary_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_diary_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_diary_slots_id_seq OWNED BY hd_diary_slots.id;


--
-- Name: hd_diurnal_period_codes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_diurnal_period_codes (
    id bigint NOT NULL,
    code character varying NOT NULL,
    description text,
    sort_order integer DEFAULT 0 NOT NULL
);


--
-- Name: hd_diurnal_period_codes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_diurnal_period_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_diurnal_period_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_diurnal_period_codes_id_seq OWNED BY hd_diurnal_period_codes.id;


--
-- Name: hd_transmission_logs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_transmission_logs (
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

CREATE VIEW hd_grouped_transmission_logs AS
 WITH RECURSIVE parent_child_logs(parent_id, id, uuid, level) AS (
         SELECT t.parent_id,
            t.id,
            t.uuid,
            1 AS level
           FROM hd_transmission_logs t
          WHERE (t.parent_id IS NULL)
        UNION ALL
         SELECT parent_child_logs.id,
            t.id,
            t.uuid,
            (parent_child_logs.level + 1)
           FROM (hd_transmission_logs t
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
     JOIN hd_transmission_logs h ON ((h.id = ordered_parent_child_logs.id)))
  WHERE (ordered_parent_child_logs.level = ordered_parent_child_logs.maxlevel)
  ORDER BY h.id, h.updated_at;


--
-- Name: hd_patient_statistics; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_patient_statistics (
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

CREATE SEQUENCE hd_patient_statistics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_patient_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_patient_statistics_id_seq OWNED BY hd_patient_statistics.id;


--
-- Name: hd_preference_sets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_preference_sets (
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

CREATE SEQUENCE hd_preference_sets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_preference_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_preference_sets_id_seq OWNED BY hd_preference_sets.id;


--
-- Name: hd_prescription_administrations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_prescription_administrations (
    id integer NOT NULL,
    hd_session_id integer NOT NULL,
    prescription_id integer NOT NULL,
    administered boolean,
    notes text,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_prescription_administrations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_prescription_administrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_prescription_administrations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_prescription_administrations_id_seq OWNED BY hd_prescription_administrations.id;


--
-- Name: hd_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_profiles (
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
    named_nurse_id integer,
    transport_decider_id integer,
    deactivated_at timestamp without time zone,
    active boolean DEFAULT true,
    schedule_definition_id integer,
    dialysate_id bigint
);


--
-- Name: hd_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_profiles_id_seq OWNED BY hd_profiles.id;


--
-- Name: hd_provider_units; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_provider_units (
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

CREATE SEQUENCE hd_provider_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_provider_units_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_provider_units_id_seq OWNED BY hd_provider_units.id;


--
-- Name: hd_providers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_providers (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hd_providers_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_providers_id_seq OWNED BY hd_providers.id;


--
-- Name: hd_schedule_definitions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_schedule_definitions (
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
-- Name: hd_schedule_definition_filters; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW hd_schedule_definition_filters AS
 SELECT filter.ids,
    ((filter.days_text || ' '::text) || upper((filter.dirunal_code)::text)) AS days
   FROM ( SELECT array_agg(s1.id) AS ids,
            0 AS dirunal_order,
            s1.days_text,
            ''::character varying AS dirunal_code
           FROM hd_schedule_definitions s1
          GROUP BY s1.days_text
        UNION ALL
         SELECT public.intset((s2.id)::integer) AS intset,
            hdpc.sort_order,
            s2.days_text,
            hdpc.code
           FROM (hd_schedule_definitions s2
             JOIN hd_diurnal_period_codes hdpc ON ((s2.diurnal_period_id = hdpc.id)))) filter
  ORDER BY filter.days_text, filter.dirunal_order;


--
-- Name: hd_schedule_definitions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_schedule_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_schedule_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_schedule_definitions_id_seq OWNED BY hd_schedule_definitions.id;


--
-- Name: hd_sessions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_sessions (
    id integer NOT NULL,
    patient_id integer,
    hospital_unit_id integer,
    modality_description_id integer,
    performed_on date NOT NULL,
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
    external_id bigint
);


--
-- Name: hd_sessions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_sessions_id_seq OWNED BY hd_sessions.id;


--
-- Name: hd_station_locations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_station_locations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    colour character varying NOT NULL
);


--
-- Name: hd_station_locations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_station_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_station_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_station_locations_id_seq OWNED BY hd_station_locations.id;


--
-- Name: hd_stations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_stations (
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
-- Name: hd_stations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_stations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_stations_id_seq OWNED BY hd_stations.id;


--
-- Name: hd_transmission_logs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hd_transmission_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_transmission_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_transmission_logs_id_seq OWNED BY hd_transmission_logs.id;


--
-- Name: hd_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hd_versions (
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

CREATE SEQUENCE hd_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hd_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hd_versions_id_seq OWNED BY hd_versions.id;


--
-- Name: hospital_centres; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hospital_centres (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    location character varying,
    active boolean,
    is_transplant_site boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hospital_centres_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hospital_centres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_centres_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hospital_centres_id_seq OWNED BY hospital_centres.id;


--
-- Name: hospital_units; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hospital_units (
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
-- Name: hospital_units_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE hospital_units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_units_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hospital_units_id_seq OWNED BY hospital_units.id;


--
-- Name: hospital_wards; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE hospital_wards (
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

CREATE SEQUENCE hospital_wards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hospital_wards_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE hospital_wards_id_seq OWNED BY hospital_wards.id;


--
-- Name: letter_archives; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_archives (
    id integer NOT NULL,
    content text NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    letter_id integer NOT NULL
);


--
-- Name: letter_archives_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE letter_archives_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_archives_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_archives_id_seq OWNED BY letter_archives.id;


--
-- Name: letter_contact_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_contact_descriptions (
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

CREATE SEQUENCE letter_contact_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_contact_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_contact_descriptions_id_seq OWNED BY letter_contact_descriptions.id;


--
-- Name: letter_contacts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_contacts (
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

CREATE SEQUENCE letter_contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_contacts_id_seq OWNED BY letter_contacts.id;


--
-- Name: letter_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_descriptions (
    id integer NOT NULL,
    text character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: letter_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE letter_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_descriptions_id_seq OWNED BY letter_descriptions.id;


--
-- Name: letter_electronic_receipts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_electronic_receipts (
    id bigint NOT NULL,
    letter_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    read_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: letter_electronic_receipts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE letter_electronic_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_electronic_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_electronic_receipts_id_seq OWNED BY letter_electronic_receipts.id;


--
-- Name: letter_letterheads; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_letterheads (
    id integer NOT NULL,
    name character varying NOT NULL,
    site_code character varying NOT NULL,
    unit_info character varying NOT NULL,
    trust_name character varying NOT NULL,
    trust_caption character varying NOT NULL,
    site_info text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    include_pathology_in_letter_body boolean DEFAULT true
);


--
-- Name: letter_letterheads_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE letter_letterheads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_letterheads_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_letterheads_id_seq OWNED BY letter_letterheads.id;


--
-- Name: letter_letters; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_letters (
    id integer NOT NULL,
    event_type character varying,
    event_id integer,
    patient_id integer,
    type character varying NOT NULL,
    issued_on date NOT NULL,
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
    page_count integer
);


--
-- Name: letter_letters_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE letter_letters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_letters_id_seq OWNED BY letter_letters.id;


--
-- Name: letter_recipients; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_recipients (
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

CREATE SEQUENCE letter_recipients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_recipients_id_seq OWNED BY letter_recipients.id;


--
-- Name: letter_signatures; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE letter_signatures (
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

CREATE SEQUENCE letter_signatures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letter_signatures_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE letter_signatures_id_seq OWNED BY letter_signatures.id;


--
-- Name: low_clearance_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE low_clearance_profiles (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    document jsonb,
    updated_by_id bigint NOT NULL,
    created_by_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: low_clearance_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE low_clearance_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: low_clearance_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE low_clearance_profiles_id_seq OWNED BY low_clearance_profiles.id;


--
-- Name: low_clearance_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE low_clearance_versions (
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

CREATE SEQUENCE low_clearance_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: low_clearance_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE low_clearance_versions_id_seq OWNED BY low_clearance_versions.id;


--
-- Name: medication_prescription_terminations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE medication_prescription_terminations (
    id integer NOT NULL,
    terminated_on date NOT NULL,
    notes text,
    prescription_id integer NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: medication_prescriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE medication_prescriptions (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    drug_id integer NOT NULL,
    treatable_type character varying NOT NULL,
    treatable_id integer NOT NULL,
    dose_amount character varying NOT NULL,
    dose_unit character varying NOT NULL,
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
    last_delivery_date date
);


--
-- Name: medication_current_prescriptions; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW medication_current_prescriptions AS
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
   FROM ((((medication_prescriptions mp
     FULL JOIN medication_prescription_terminations mpt ON ((mpt.prescription_id = mp.id)))
     JOIN drugs ON ((drugs.id = mp.drug_id)))
     FULL JOIN drug_types_drugs ON ((drug_types_drugs.drug_id = drugs.id)))
     FULL JOIN drug_types ON (((drug_types_drugs.drug_type_id = drug_types.id) AND ((mpt.terminated_on IS NULL) OR (mpt.terminated_on > now())))));


--
-- Name: medication_prescription_terminations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE medication_prescription_terminations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescription_terminations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE medication_prescription_terminations_id_seq OWNED BY medication_prescription_terminations.id;


--
-- Name: medication_prescription_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE medication_prescription_versions (
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

CREATE SEQUENCE medication_prescription_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescription_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE medication_prescription_versions_id_seq OWNED BY medication_prescription_versions.id;


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE medication_prescriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_prescriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE medication_prescriptions_id_seq OWNED BY medication_prescriptions.id;


--
-- Name: medication_routes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE medication_routes (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rr_code character varying
);


--
-- Name: medication_routes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE medication_routes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medication_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE medication_routes_id_seq OWNED BY medication_routes.id;


--
-- Name: messaging_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE messaging_messages (
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
    type character varying NOT NULL
);


--
-- Name: messaging_messages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE messaging_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messaging_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE messaging_messages_id_seq OWNED BY messaging_messages.id;


--
-- Name: messaging_receipts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE messaging_receipts (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    read_at timestamp without time zone
);


--
-- Name: messaging_receipts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE messaging_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messaging_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE messaging_receipts_id_seq OWNED BY messaging_receipts.id;


--
-- Name: modality_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE modality_descriptions (
    id integer NOT NULL,
    name character varying NOT NULL,
    type character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL
);


--
-- Name: modality_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE modality_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE modality_descriptions_id_seq OWNED BY modality_descriptions.id;


--
-- Name: modality_modalities; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE modality_modalities (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    description_id integer NOT NULL,
    reason_id integer,
    modal_change_type character varying,
    notes text,
    started_on date NOT NULL,
    ended_on date,
    state character varying DEFAULT 'current'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL
);


--
-- Name: modality_modalities_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE modality_modalities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_modalities_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE modality_modalities_id_seq OWNED BY modality_modalities.id;


--
-- Name: modality_reasons; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE modality_reasons (
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

CREATE SEQUENCE modality_reasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modality_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE modality_reasons_id_seq OWNED BY modality_reasons.id;


--
-- Name: pathology_current_observation_sets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_current_observation_sets (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    "values" jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: pathology_current_observation_sets_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_current_observation_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_current_observation_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_current_observation_sets_id_seq OWNED BY pathology_current_observation_sets.id;


--
-- Name: pathology_observation_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_observation_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    measurement_unit_id integer,
    loinc_code character varying,
    display_group integer,
    display_order integer,
    letter_group integer,
    letter_order integer
);


--
-- Name: pathology_observation_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_observation_requests (
    id integer NOT NULL,
    requestor_order_number character varying,
    requestor_name character varying NOT NULL,
    requested_at timestamp without time zone NOT NULL,
    patient_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description_id integer NOT NULL
);


--
-- Name: pathology_observations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_observations (
    id integer NOT NULL,
    result character varying NOT NULL,
    comment text,
    observed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description_id integer NOT NULL,
    request_id integer NOT NULL,
    cancelled boolean
);


--
-- Name: pathology_current_observations; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW pathology_current_observations AS
 SELECT DISTINCT ON (pathology_observation_requests.patient_id, pathology_observation_descriptions.id) pathology_observations.id,
    pathology_observations.result,
    pathology_observations.comment,
    pathology_observations.observed_at,
    pathology_observations.description_id,
    pathology_observations.request_id,
    pathology_observation_descriptions.code AS description_code,
    pathology_observation_descriptions.name AS description_name,
    pathology_observation_requests.patient_id
   FROM ((pathology_observations
     LEFT JOIN pathology_observation_requests ON ((pathology_observations.request_id = pathology_observation_requests.id)))
     LEFT JOIN pathology_observation_descriptions ON ((pathology_observations.description_id = pathology_observation_descriptions.id)))
  ORDER BY pathology_observation_requests.patient_id, pathology_observation_descriptions.id, pathology_observations.observed_at DESC;


--
-- Name: pathology_labs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_labs (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: pathology_labs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_labs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_labs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_labs_id_seq OWNED BY pathology_labs.id;


--
-- Name: pathology_measurement_units; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_measurement_units (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- Name: pathology_measurement_units_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_measurement_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_measurement_units_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_measurement_units_id_seq OWNED BY pathology_measurement_units.id;


--
-- Name: pathology_observation_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_observation_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observation_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_observation_descriptions_id_seq OWNED BY pathology_observation_descriptions.id;


--
-- Name: pathology_observation_digests; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW pathology_observation_digests AS
 SELECT obs_req.patient_id,
    (obs.observed_at)::date AS observed_on,
    jsonb_object_agg(obs_desc.code, obs.result) AS results
   FROM ((pathology_observations obs
     JOIN pathology_observation_requests obs_req ON ((obs.request_id = obs_req.id)))
     JOIN pathology_observation_descriptions obs_desc ON ((obs.description_id = obs_desc.id)))
  GROUP BY obs_req.patient_id, ((obs.observed_at)::date)
  ORDER BY obs_req.patient_id, ((obs.observed_at)::date) DESC;


--
-- Name: pathology_observation_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_observation_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observation_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_observation_requests_id_seq OWNED BY pathology_observation_requests.id;


--
-- Name: pathology_observations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_observations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_observations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_observations_id_seq OWNED BY pathology_observations.id;


--
-- Name: pathology_request_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_request_descriptions (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying,
    required_observation_description_id integer,
    expiration_days integer DEFAULT 0 NOT NULL,
    lab_id integer NOT NULL,
    bottle_type character varying
);


--
-- Name: pathology_request_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_request_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_request_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_request_descriptions_id_seq OWNED BY pathology_request_descriptions.id;


--
-- Name: pathology_request_descriptions_requests_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_request_descriptions_requests_requests (
    id integer NOT NULL,
    request_id integer NOT NULL,
    request_description_id integer NOT NULL
);


--
-- Name: pathology_request_descriptions_requests_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_request_descriptions_requests_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_request_descriptions_requests_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_request_descriptions_requests_requests_id_seq OWNED BY pathology_request_descriptions_requests_requests.id;


--
-- Name: pathology_requests_drug_categories; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_requests_drug_categories (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: pathology_requests_drug_categories_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_requests_drug_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_drug_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_requests_drug_categories_id_seq OWNED BY pathology_requests_drug_categories.id;


--
-- Name: pathology_requests_drugs_drug_categories; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_requests_drugs_drug_categories (
    id integer NOT NULL,
    drug_id integer NOT NULL,
    drug_category_id integer NOT NULL
);


--
-- Name: pathology_requests_drugs_drug_categories_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_requests_drugs_drug_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_drugs_drug_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_requests_drugs_drug_categories_id_seq OWNED BY pathology_requests_drugs_drug_categories.id;


--
-- Name: pathology_requests_global_rule_sets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_requests_global_rule_sets (
    id integer NOT NULL,
    request_description_id integer NOT NULL,
    frequency_type character varying NOT NULL,
    clinic_id integer
);


--
-- Name: pathology_requests_global_rule_sets_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_requests_global_rule_sets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_global_rule_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_requests_global_rule_sets_id_seq OWNED BY pathology_requests_global_rule_sets.id;


--
-- Name: pathology_requests_global_rules; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_requests_global_rules (
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

CREATE SEQUENCE pathology_requests_global_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_global_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_requests_global_rules_id_seq OWNED BY pathology_requests_global_rules.id;


--
-- Name: pathology_requests_patient_rules; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_requests_patient_rules (
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

CREATE SEQUENCE pathology_requests_patient_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_patient_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_requests_patient_rules_id_seq OWNED BY pathology_requests_patient_rules.id;


--
-- Name: pathology_requests_patient_rules_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_requests_patient_rules_requests (
    id integer NOT NULL,
    request_id integer NOT NULL,
    patient_rule_id integer NOT NULL
);


--
-- Name: pathology_requests_patient_rules_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_requests_patient_rules_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_patient_rules_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_requests_patient_rules_requests_id_seq OWNED BY pathology_requests_patient_rules_requests.id;


--
-- Name: pathology_requests_requests; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pathology_requests_requests (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    clinic_id integer NOT NULL,
    consultant_id integer NOT NULL,
    telephone character varying NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    template character varying NOT NULL,
    high_risk boolean NOT NULL
);


--
-- Name: pathology_requests_requests_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pathology_requests_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pathology_requests_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pathology_requests_requests_id_seq OWNED BY pathology_requests_requests.id;


--
-- Name: patient_alerts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_alerts (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    notes text,
    urgent boolean DEFAULT false NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_alerts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE patient_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_alerts_id_seq OWNED BY patient_alerts.id;


--
-- Name: patient_bookmarks; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_bookmarks (
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

CREATE SEQUENCE patient_bookmarks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_bookmarks_id_seq OWNED BY patient_bookmarks.id;


--
-- Name: patients; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patients (
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
    ukrdc_external_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    country_of_birth_id integer,
    legacy_patient_id integer,
    secure_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    sent_to_ukrdc_at timestamp without time zone,
    checked_for_ukrdc_changes_at timestamp without time zone
);


--
-- Name: patient_current_modalities; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW patient_current_modalities AS
 SELECT patients.id AS patient_id,
    patients.secure_id AS patient_secure_id,
    current_modality.id AS modality_id,
    modality_descriptions.id AS modality_description_id,
    modality_descriptions.name AS modality_name,
    current_modality.started_on
   FROM ((patients
     LEFT JOIN ( SELECT DISTINCT ON (modality_modalities.patient_id) modality_modalities.id,
            modality_modalities.patient_id,
            modality_modalities.description_id,
            modality_modalities.reason_id,
            modality_modalities.modal_change_type,
            modality_modalities.notes,
            modality_modalities.started_on,
            modality_modalities.ended_on,
            modality_modalities.state,
            modality_modalities.created_at,
            modality_modalities.updated_at,
            modality_modalities.created_by_id,
            modality_modalities.updated_by_id
           FROM modality_modalities
          ORDER BY modality_modalities.patient_id, modality_modalities.started_on DESC) current_modality ON ((patients.id = current_modality.patient_id)))
     LEFT JOIN modality_descriptions ON ((modality_descriptions.id = current_modality.description_id)));


--
-- Name: patient_ethnicities; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_ethnicities (
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

CREATE SEQUENCE patient_ethnicities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_ethnicities_id_seq OWNED BY patient_ethnicities.id;


--
-- Name: patient_languages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_languages (
    id integer NOT NULL,
    name character varying NOT NULL,
    code character varying
);


--
-- Name: patient_languages_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE patient_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_languages_id_seq OWNED BY patient_languages.id;


--
-- Name: patient_practice_memberships; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_practice_memberships (
    id integer NOT NULL,
    practice_id integer NOT NULL,
    primary_care_physician_id integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_practice_memberships_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE patient_practice_memberships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_practice_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_practice_memberships_id_seq OWNED BY patient_practice_memberships.id;


--
-- Name: patient_practices; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_practices (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    telephone character varying
);


--
-- Name: patient_practices_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE patient_practices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_practices_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_practices_id_seq OWNED BY patient_practices.id;


--
-- Name: patient_primary_care_physicians; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_primary_care_physicians (
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

CREATE SEQUENCE patient_primary_care_physicians_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_primary_care_physicians_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_primary_care_physicians_id_seq OWNED BY patient_primary_care_physicians.id;


--
-- Name: patient_religions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_religions (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: patient_religions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE patient_religions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_religions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_religions_id_seq OWNED BY patient_religions.id;


--
-- Name: problem_problems; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE problem_problems (
    id integer NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    patient_id integer NOT NULL,
    description character varying NOT NULL,
    date date,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer
);


--
-- Name: transplant_recipient_operations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_recipient_operations (
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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: patient_summaries; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW patient_summaries AS
 SELECT patients.id AS patient_id,
    ( SELECT count(*) AS count
           FROM events
          WHERE (events.patient_id = patients.id)) AS events_count,
    ( SELECT count(*) AS count
           FROM clinic_visits
          WHERE (clinic_visits.patient_id = patients.id)) AS clinic_visits_count,
    ( SELECT count(*) AS count
           FROM letter_letters
          WHERE (letter_letters.patient_id = patients.id)) AS letters_count,
    ( SELECT count(*) AS count
           FROM modality_modalities
          WHERE (modality_modalities.patient_id = patients.id)) AS modalities_count,
    ( SELECT count(*) AS count
           FROM problem_problems
          WHERE ((problem_problems.deleted_at IS NULL) AND (problem_problems.patient_id = patients.id))) AS problems_count,
    ( SELECT count(*) AS count
           FROM pathology_observation_requests
          WHERE (pathology_observation_requests.patient_id = patients.id)) AS observation_requests_count,
    ( SELECT count(*) AS count
           FROM (medication_prescriptions p
             FULL JOIN medication_prescription_terminations pt ON ((pt.prescription_id = p.id)))
          WHERE ((p.patient_id = patients.id) AND ((pt.terminated_on IS NULL) OR (pt.terminated_on > CURRENT_TIMESTAMP)))) AS prescriptions_count,
    ( SELECT count(*) AS count
           FROM letter_contacts
          WHERE (letter_contacts.patient_id = patients.id)) AS contacts_count,
    ( SELECT count(*) AS count
           FROM transplant_recipient_operations
          WHERE (transplant_recipient_operations.patient_id = patients.id)) AS recipient_operations_count,
    ( SELECT count(*) AS count
           FROM admission_admissions
          WHERE (admission_admissions.patient_id = patients.id)) AS admissions_count
   FROM patients;


--
-- Name: patient_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_versions (
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

CREATE SEQUENCE patient_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_versions_id_seq OWNED BY patient_versions.id;


--
-- Name: patient_worries; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE patient_worries (
    id integer NOT NULL,
    patient_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text
);


--
-- Name: patient_worries_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE patient_worries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patient_worries_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patient_worries_id_seq OWNED BY patient_worries.id;


--
-- Name: patients_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE patients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: patients_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE patients_id_seq OWNED BY patients.id;


--
-- Name: pd_assessments; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_assessments (
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

CREATE SEQUENCE pd_assessments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_assessments_id_seq OWNED BY pd_assessments.id;


--
-- Name: pd_bag_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_bag_types (
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

CREATE SEQUENCE pd_bag_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_bag_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_bag_types_id_seq OWNED BY pd_bag_types.id;


--
-- Name: pd_exit_site_infections; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_exit_site_infections (
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

CREATE SEQUENCE pd_exit_site_infections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_exit_site_infections_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_exit_site_infections_id_seq OWNED BY pd_exit_site_infections.id;


--
-- Name: pd_fluid_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_fluid_descriptions (
    id integer NOT NULL,
    description character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_fluid_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pd_fluid_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_fluid_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_fluid_descriptions_id_seq OWNED BY pd_fluid_descriptions.id;


--
-- Name: pd_infection_organisms; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_infection_organisms (
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

CREATE SEQUENCE pd_infection_organisms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_infection_organisms_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_infection_organisms_id_seq OWNED BY pd_infection_organisms.id;


--
-- Name: pd_organism_codes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_organism_codes (
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

CREATE SEQUENCE pd_organism_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_organism_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_organism_codes_id_seq OWNED BY pd_organism_codes.id;


--
-- Name: pd_peritonitis_episode_type_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_peritonitis_episode_type_descriptions (
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

CREATE SEQUENCE pd_peritonitis_episode_type_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_peritonitis_episode_type_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_peritonitis_episode_type_descriptions_id_seq OWNED BY pd_peritonitis_episode_type_descriptions.id;


--
-- Name: pd_peritonitis_episode_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_peritonitis_episode_types (
    id integer NOT NULL,
    peritonitis_episode_id integer NOT NULL,
    peritonitis_episode_type_description_id integer NOT NULL
);


--
-- Name: pd_peritonitis_episode_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pd_peritonitis_episode_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_peritonitis_episode_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_peritonitis_episode_types_id_seq OWNED BY pd_peritonitis_episode_types.id;


--
-- Name: pd_peritonitis_episodes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_peritonitis_episodes (
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
-- Name: pd_peritonitis_episodes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pd_peritonitis_episodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_peritonitis_episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_peritonitis_episodes_id_seq OWNED BY pd_peritonitis_episodes.id;


--
-- Name: pd_pet_adequacy_results; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_pet_adequacy_results (
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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_pet_adequacy_results_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pd_pet_adequacy_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_pet_adequacy_results_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_pet_adequacy_results_id_seq OWNED BY pd_pet_adequacy_results.id;


--
-- Name: pd_regime_bags; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_regime_bags (
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

CREATE SEQUENCE pd_regime_bags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regime_bags_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_regime_bags_id_seq OWNED BY pd_regime_bags.id;


--
-- Name: pd_regime_terminations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_regime_terminations (
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

CREATE SEQUENCE pd_regime_terminations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regime_terminations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_regime_terminations_id_seq OWNED BY pd_regime_terminations.id;


--
-- Name: pd_regimes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_regimes (
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
    dwell_time integer
);


--
-- Name: pd_regimes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pd_regimes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_regimes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_regimes_id_seq OWNED BY pd_regimes.id;


--
-- Name: pd_systems; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_systems (
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

CREATE SEQUENCE pd_systems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_systems_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_systems_id_seq OWNED BY pd_systems.id;


--
-- Name: pd_training_sessions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_training_sessions (
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

CREATE SEQUENCE pd_training_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_training_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_training_sessions_id_seq OWNED BY pd_training_sessions.id;


--
-- Name: pd_training_sites; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_training_sites (
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

CREATE SEQUENCE pd_training_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_training_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_training_sites_id_seq OWNED BY pd_training_sites.id;


--
-- Name: pd_training_types; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE pd_training_types (
    id integer NOT NULL,
    name character varying NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pd_training_types_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE pd_training_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pd_training_types_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE pd_training_types_id_seq OWNED BY pd_training_types.id;


--
-- Name: problem_notes; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE problem_notes (
    id integer NOT NULL,
    problem_id integer,
    description text NOT NULL,
    created_by_id integer NOT NULL,
    updated_by_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: problem_notes_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE problem_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE problem_notes_id_seq OWNED BY problem_notes.id;


--
-- Name: problem_problems_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE problem_problems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_problems_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE problem_problems_id_seq OWNED BY problem_problems.id;


--
-- Name: problem_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE problem_versions (
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

CREATE SEQUENCE problem_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: problem_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE problem_versions_id_seq OWNED BY problem_versions.id;


--
-- Name: renal_aki_alert_actions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renal_aki_alert_actions (
    id bigint NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: renal_aki_alert_actions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renal_aki_alert_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_aki_alert_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renal_aki_alert_actions_id_seq OWNED BY renal_aki_alert_actions.id;


--
-- Name: renal_aki_alerts; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renal_aki_alerts (
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
    aki_date date
);


--
-- Name: renal_aki_alerts_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renal_aki_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_aki_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renal_aki_alerts_id_seq OWNED BY renal_aki_alerts.id;


--
-- Name: renal_prd_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renal_prd_descriptions (
    id integer NOT NULL,
    code character varying,
    term character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: renal_prd_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renal_prd_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_prd_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renal_prd_descriptions_id_seq OWNED BY renal_prd_descriptions.id;


--
-- Name: renal_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renal_profiles (
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
-- Name: renal_profiles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE renal_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renal_profiles_id_seq OWNED BY renal_profiles.id;


--
-- Name: renal_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE renal_versions (
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

CREATE SEQUENCE renal_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: renal_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE renal_versions_id_seq OWNED BY renal_versions.id;


--
-- Name: reporting_anaemia_audit; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW reporting_anaemia_audit AS
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
            md.name AS modality_desc
           FROM ((patients p
             JOIN modality_modalities m ON ((m.patient_id = p.id)))
             JOIN modality_descriptions md ON ((m.description_id = md.id)))
          WHERE ((m.ended_on IS NULL) OR (m.ended_on > CURRENT_TIMESTAMP))) e1
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM medication_current_prescriptions mcp
          WHERE ((mcp.drug_type_code)::text = 'immunosuppressant'::text)
          GROUP BY mcp.patient_id) immunosuppressants ON ((e1.patient_id = immunosuppressants.patient_id)))
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM medication_current_prescriptions mcp
          WHERE ((mcp.drug_name)::text ~~ 'Mircer%'::text)
          GROUP BY mcp.patient_id) mircer ON ((e1.patient_id = mircer.patient_id)))
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM medication_current_prescriptions mcp
          WHERE ((mcp.drug_name)::text ~~ 'Neo%'::text)
          GROUP BY mcp.patient_id) neo ON ((e1.patient_id = neo.patient_id)))
     FULL JOIN ( SELECT mcp.patient_id,
            count(DISTINCT mcp.drug_id) AS ct
           FROM medication_current_prescriptions mcp
          WHERE ((mcp.drug_name)::text ~~ 'Ara%'::text)
          GROUP BY mcp.patient_id) ara ON ((e1.patient_id = ara.patient_id)))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS hgb
           FROM pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'HGB'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS fer
           FROM pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'FER'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_10
          WHERE (e2.hgb >= (10)::numeric)) e4 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_11
          WHERE (e2.hgb >= (11)::numeric)) e5 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.hgb AS hgb_gt_eq_13
          WHERE (e2.hgb >= (13)::numeric)) e6 ON (true))
     LEFT JOIN LATERAL ( SELECT e3.fer AS fer_gt_eq_150
          WHERE (e3.fer >= (150)::numeric)) e7 ON (true))
  WHERE ((e1.modality_desc)::text = ANY (ARRAY[('HD'::character varying)::text, ('PD'::character varying)::text, ('Transplant'::character varying)::text, ('Low Clearance'::character varying)::text, ('Nephrology'::character varying)::text]))
  GROUP BY e1.modality_desc;


--
-- Name: reporting_audits; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE reporting_audits (
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

CREATE SEQUENCE reporting_audits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reporting_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE reporting_audits_id_seq OWNED BY reporting_audits.id;


--
-- Name: reporting_bone_audit; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW reporting_bone_audit AS
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
            md.name AS modality_desc
           FROM ((patients p
             JOIN modality_modalities m ON ((m.patient_id = p.id)))
             JOIN modality_descriptions md ON ((m.description_id = md.id)))) e1
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS pth
           FROM pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'PTHI'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e2 ON (true))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS phos
           FROM pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'PHOS'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e3 ON (true))
     LEFT JOIN LATERAL ( SELECT (pathology_current_observations.result)::numeric AS cca
           FROM pathology_current_observations
          WHERE (((pathology_current_observations.description_code)::text = 'CCA'::text) AND (pathology_current_observations.patient_id = e1.patient_id))) e4 ON (true))
     LEFT JOIN LATERAL ( SELECT e3.phos AS phos_lt_1_8
          WHERE (e3.phos < 1.8)) e5 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_800
          WHERE (e2.pth > (800)::numeric)) e6 ON (true))
     LEFT JOIN LATERAL ( SELECT e2.pth AS pth_gt_300
          WHERE (e2.pth > (300)::numeric)) e7 ON (true))
     LEFT JOIN LATERAL ( SELECT e4.cca AS cca_2_1_to_2_4
          WHERE ((e4.cca >= 2.1) AND (e4.cca <= 2.4))) e8 ON (true))
  WHERE ((e1.modality_desc)::text = ANY (ARRAY[('HD'::character varying)::text, ('PD'::character varying)::text, ('Transplant'::character varying)::text, ('Low Clearance'::character varying)::text]))
  GROUP BY e1.modality_desc;


--
-- Name: reporting_daily_letters; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW reporting_daily_letters AS
 SELECT ( SELECT count(*) AS count
           FROM letter_letters
          WHERE ((letter_letters.created_at)::date = (now())::date)) AS letters_created_today,
    ( SELECT count(*) AS count
           FROM letter_letters
          WHERE ((letter_letters.completed_at)::date = (now())::date)) AS letters_printed_today,
    ( SELECT count(*) AS count
           FROM letter_letters
          WHERE (((letter_letters.type)::text = 'Renalware::Letters::Letter::Draft'::text) AND (letter_letters.issued_on < (CURRENT_DATE - '14 days'::interval)))) AS draft_letters_older_than_14_days;


--
-- Name: reporting_daily_pathology; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW reporting_daily_pathology AS
 SELECT ( SELECT count(*) AS count
           FROM delayed_jobs) AS delayed_jobs_total,
    ( SELECT count(*) AS count
           FROM delayed_jobs
          WHERE (delayed_jobs.attempts = 0)) AS delayed_jobs_unprocessed,
    ( SELECT count(*) AS count
           FROM delayed_jobs
          WHERE ((delayed_jobs.last_error IS NOT NULL) AND (delayed_jobs.failed_at IS NULL))) AS delayed_jobs_retrying,
    ( SELECT count(*) AS count
           FROM delayed_jobs
          WHERE ((delayed_jobs.last_error IS NOT NULL) AND (delayed_jobs.failed_at IS NOT NULL))) AS delayed_jobs_failed,
    ( SELECT max(delayed_jobs.created_at) AS max
           FROM delayed_jobs) AS delayed_jobs_latest_entry,
    ( SELECT count(*) AS count
           FROM delayed_jobs
          WHERE (delayed_jobs.created_at >= (now())::date)) AS delayed_jobs_added_today,
    ( SELECT json_object_agg(query.priority, query.count) AS json_object_agg
           FROM ( SELECT delayed_jobs.priority,
                    count(*) AS count
                   FROM delayed_jobs
                  GROUP BY delayed_jobs.priority) query) AS delayed_jobs_priority_counts,
    ( SELECT json_object_agg(COALESCE(query.queue, 'unset'::character varying), query.count) AS json_object_agg
           FROM ( SELECT delayed_jobs.queue,
                    count(*) AS count
                   FROM delayed_jobs
                  GROUP BY delayed_jobs.queue) query) AS delayed_jobs_queue_counts,
    ( SELECT json_object_agg(query.attempts, query.count) AS json_object_agg
           FROM ( SELECT delayed_jobs.attempts,
                    count(*) AS count
                   FROM delayed_jobs
                  GROUP BY delayed_jobs.attempts) query) AS delayed_jobs_attempts_counts,
    ( SELECT count(*) AS count
           FROM feed_messages) AS feed_messages_total,
    ( SELECT count(*) AS count
           FROM feed_messages
          WHERE (feed_messages.created_at >= (now())::date)) AS feed_messages_added_today,
    ( SELECT max(feed_messages.created_at) AS max
           FROM feed_messages) AS feed_messages_added_latest_entry,
    ( SELECT count(*) AS count
           FROM pathology_observations
          WHERE ((pathology_observations.created_at)::date >= (now())::date)) AS pathology_observations_added_today,
    ( SELECT max(pathology_observations.observed_at) AS max
           FROM pathology_observations) AS pathology_observations_latest_observed_at;


--
-- Name: reporting_daily_ukrdc; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW reporting_daily_ukrdc AS
 SELECT ( SELECT count(*) AS count
           FROM patients
          WHERE ((patients.sent_to_ukrdc_at)::date = CURRENT_DATE)) AS patients_sent_to_ukrdc_today;


--
-- Name: reporting_hd_blood_pressures_audit; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW reporting_hd_blood_pressures_audit AS
 WITH blood_pressures AS (
         SELECT hd_sessions.id AS session_id,
            patients.id AS patient_id,
            hd_sessions.hospital_unit_id,
            (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_pre,
            (((hd_sessions.document -> 'observations_before'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_pre,
            (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'systolic'::text) AS systolic_post,
            (((hd_sessions.document -> 'observations_after'::text) -> 'blood_pressure'::text) ->> 'diastolic'::text) AS diastolic_post
           FROM (hd_sessions
             JOIN patients ON ((patients.id = hd_sessions.patient_id)))
          WHERE (hd_sessions.signed_off_at IS NOT NULL)
        ), some_other_derived_table_variable AS (
         SELECT 1
           FROM blood_pressures blood_pressures_1
        )
 SELECT hu.name AS hospital_unit_name,
    round(avg((blood_pressures.systolic_pre)::integer)) AS systolic_pre_avg,
    round(avg((blood_pressures.diastolic_pre)::integer)) AS diastolic_pre_avg,
    round(avg((blood_pressures.systolic_post)::integer)) AS systolic_post_avg,
    round(avg((blood_pressures.diastolic_post)::integer)) AS distolic_post_avg
   FROM (blood_pressures
     JOIN hospital_units hu ON ((hu.id = blood_pressures.hospital_unit_id)))
  GROUP BY hu.name
  WITH NO DATA;


--
-- Name: reporting_hd_overall_audit; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW reporting_hd_overall_audit AS
 WITH fistula_or_graft_access_types AS (
         SELECT access_types.id
           FROM access_types
          WHERE (((access_types.name)::text ~~* '%fistula%'::text) OR ((access_types.name)::text ~~* '%graft%'::text))
        ), patients_w_fistula_or_graft AS (
         SELECT access_profiles.patient_id
           FROM access_profiles
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
            (convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (100)::double precision) AS hgb_gt_100,
            (convert_to_float(((s.pathology_snapshot -> 'HGB'::text) ->> 'result'::text)) > (130)::double precision) AS hgb_gt_130,
            (convert_to_float(((s.pathology_snapshot -> 'PTHI'::text) ->> 'result'::text)) < (300)::double precision) AS pth_lt_300,
            (convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (64)::double precision) AS urr_gt_64,
            (convert_to_float(((s.pathology_snapshot -> 'URR'::text) ->> 'result'::text)) > (69)::double precision) AS urr_gt_69,
            (convert_to_float(((s.pathology_snapshot -> 'PHOS'::text) ->> 'result'::text)) < (1.8)::double precision) AS phos_lt_1_8
           FROM hd_patient_statistics s
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
     JOIN hospital_units hu ON ((hu.id = stats.hospital_unit_id)))
  GROUP BY hu.name, stats.year, stats.month
  ORDER BY hu.name, stats.year, stats.month
  WITH NO DATA;


--
-- Name: users; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE users (
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
    authentication_token character varying
);


--
-- Name: reporting_main_authors_audit; Type: MATERIALIZED VIEW; Schema: renalware; Owner: -
--

CREATE MATERIALIZED VIEW reporting_main_authors_audit AS
 WITH archived_clinic_letters AS (
         SELECT date_part('year'::text, archive.created_at) AS year,
            to_char(archive.created_at, 'Month'::text) AS month,
            letters.author_id,
            date_part('day'::text, (archive.created_at - (visits.date)::timestamp without time zone)) AS days_to_archive
           FROM ((letter_letters letters
             JOIN letter_archives archive ON ((letters.id = archive.letter_id)))
             JOIN clinic_visits visits ON ((visits.id = letters.event_id)))
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
     JOIN users ON ((stats.author_id = users.id)))
  ORDER BY stats.total_letters DESC
  WITH NO DATA;


--
-- Name: reporting_pd_audit; Type: VIEW; Schema: renalware; Owner: -
--

CREATE VIEW reporting_pd_audit AS
 WITH pd_patients AS (
         SELECT patients.id
           FROM ((patients
             JOIN modality_modalities current_modality ON ((current_modality.patient_id = patients.id)))
             JOIN modality_descriptions current_modality_description ON ((current_modality_description.id = current_modality.description_id)))
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
           FROM pd_regimes
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
-- Name: research_studies; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE research_studies (
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
    application_url character varying
);


--
-- Name: research_studies_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE research_studies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: research_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE research_studies_id_seq OWNED BY research_studies.id;


--
-- Name: research_study_participations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE research_study_participations (
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
    external_id integer
);


--
-- Name: research_study_participations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE research_study_participations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: research_study_participations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE research_study_participations_id_seq OWNED BY research_study_participations.id;


--
-- Name: roles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE roles_users (
    role_id integer,
    user_id integer,
    id bigint NOT NULL
);


--
-- Name: roles_users_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE roles_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_users_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE roles_users_id_seq OWNED BY roles_users.id;


--
-- Name: snippets_snippets; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE snippets_snippets (
    id integer NOT NULL,
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

CREATE SEQUENCE snippets_snippets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snippets_snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE snippets_snippets_id_seq OWNED BY snippets_snippets.id;


--
-- Name: system_countries; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE system_countries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    alpha2 character varying NOT NULL,
    alpha3 character varying NOT NULL,
    "position" integer
);


--
-- Name: system_countries_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE system_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE system_countries_id_seq OWNED BY system_countries.id;


--
-- Name: system_events; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE system_events (
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

CREATE SEQUENCE system_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_events_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE system_events_id_seq OWNED BY system_events.id;


--
-- Name: system_messages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE system_messages (
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

CREATE SEQUENCE system_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE system_messages_id_seq OWNED BY system_messages.id;


--
-- Name: system_templates; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE system_templates (
    id integer NOT NULL,
    name character varying NOT NULL,
    title character varying,
    description character varying NOT NULL,
    body text NOT NULL
);


--
-- Name: system_templates_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE system_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE system_templates_id_seq OWNED BY system_templates.id;


--
-- Name: system_user_feedback; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE system_user_feedback (
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

CREATE SEQUENCE system_user_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_user_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE system_user_feedback_id_seq OWNED BY system_user_feedback.id;


--
-- Name: system_visits; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE system_visits (
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

CREATE SEQUENCE system_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE system_visits_id_seq OWNED BY system_visits.id;


--
-- Name: transplant_donations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_donations (
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

CREATE SEQUENCE transplant_donations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_donations_id_seq OWNED BY transplant_donations.id;


--
-- Name: transplant_donor_followups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_donor_followups (
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

CREATE SEQUENCE transplant_donor_followups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_donor_followups_id_seq OWNED BY transplant_donor_followups.id;


--
-- Name: transplant_donor_operations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_donor_operations (
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

CREATE SEQUENCE transplant_donor_operations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_donor_operations_id_seq OWNED BY transplant_donor_operations.id;


--
-- Name: transplant_donor_stage_positions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_donor_stage_positions (
    id integer NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_stage_positions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_donor_stage_positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_stage_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_donor_stage_positions_id_seq OWNED BY transplant_donor_stage_positions.id;


--
-- Name: transplant_donor_stage_statuses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_donor_stage_statuses (
    id integer NOT NULL,
    name character varying NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_stage_statuses_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_donor_stage_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_stage_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_donor_stage_statuses_id_seq OWNED BY transplant_donor_stage_statuses.id;


--
-- Name: transplant_donor_stages; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_donor_stages (
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

CREATE SEQUENCE transplant_donor_stages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_donor_stages_id_seq OWNED BY transplant_donor_stages.id;


--
-- Name: transplant_donor_workups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_donor_workups (
    id integer NOT NULL,
    patient_id integer,
    document jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_donor_workups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_donor_workups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_donor_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_donor_workups_id_seq OWNED BY transplant_donor_workups.id;


--
-- Name: transplant_failure_cause_description_groups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_failure_cause_description_groups (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_failure_cause_description_groups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_failure_cause_description_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_failure_cause_description_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_failure_cause_description_groups_id_seq OWNED BY transplant_failure_cause_description_groups.id;


--
-- Name: transplant_failure_cause_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_failure_cause_descriptions (
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

CREATE SEQUENCE transplant_failure_cause_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_failure_cause_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_failure_cause_descriptions_id_seq OWNED BY transplant_failure_cause_descriptions.id;


--
-- Name: transplant_recipient_followups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_recipient_followups (
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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transplant_recipient_followups_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_recipient_followups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_recipient_followups_id_seq OWNED BY transplant_recipient_followups.id;


--
-- Name: transplant_recipient_operations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_recipient_operations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_recipient_operations_id_seq OWNED BY transplant_recipient_operations.id;


--
-- Name: transplant_recipient_workups; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_recipient_workups (
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

CREATE SEQUENCE transplant_recipient_workups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_recipient_workups_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_recipient_workups_id_seq OWNED BY transplant_recipient_workups.id;


--
-- Name: transplant_registration_status_descriptions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_registration_status_descriptions (
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
-- Name: transplant_registration_status_descriptions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_registration_status_descriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registration_status_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_registration_status_descriptions_id_seq OWNED BY transplant_registration_status_descriptions.id;


--
-- Name: transplant_registration_statuses; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_registration_statuses (
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
-- Name: transplant_registration_statuses_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_registration_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registration_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_registration_statuses_id_seq OWNED BY transplant_registration_statuses.id;


--
-- Name: transplant_registrations; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_registrations (
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
-- Name: transplant_registrations_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE transplant_registrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_registrations_id_seq OWNED BY transplant_registrations.id;


--
-- Name: transplant_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE transplant_versions (
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

CREATE SEQUENCE transplant_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transplant_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE transplant_versions_id_seq OWNED BY transplant_versions.id;


--
-- Name: ukrdc_batch_numbers; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE ukrdc_batch_numbers (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ukrdc_batch_numbers_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE ukrdc_batch_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ukrdc_batch_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE ukrdc_batch_numbers_id_seq OWNED BY ukrdc_batch_numbers.id;


--
-- Name: ukrdc_transmission_logs; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE ukrdc_transmission_logs (
    id bigint NOT NULL,
    patient_id bigint NOT NULL,
    sent_at timestamp without time zone NOT NULL,
    status integer NOT NULL,
    request_uuid uuid NOT NULL,
    payload_hash text,
    payload xml,
    error text[] DEFAULT '{}'::text[],
    file_path character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ukrdc_transmission_logs_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE ukrdc_transmission_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ukrdc_transmission_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE ukrdc_transmission_logs_id_seq OWNED BY ukrdc_transmission_logs.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE versions (
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

CREATE SEQUENCE versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: virology_profiles; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE virology_profiles (
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

CREATE SEQUENCE virology_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virology_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE virology_profiles_id_seq OWNED BY virology_profiles.id;


--
-- Name: virology_versions; Type: TABLE; Schema: renalware; Owner: -
--

CREATE TABLE virology_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: virology_versions_id_seq; Type: SEQUENCE; Schema: renalware; Owner: -
--

CREATE SEQUENCE virology_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: virology_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: renalware; Owner: -
--

ALTER SEQUENCE virology_versions_id_seq OWNED BY virology_versions.id;


--
-- Name: access_assessments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_assessments ALTER COLUMN id SET DEFAULT nextval('access_assessments_id_seq'::regclass);


--
-- Name: access_catheter_insertion_techniques id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_catheter_insertion_techniques ALTER COLUMN id SET DEFAULT nextval('access_catheter_insertion_techniques_id_seq'::regclass);


--
-- Name: access_plan_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plan_types ALTER COLUMN id SET DEFAULT nextval('access_plan_types_id_seq'::regclass);


--
-- Name: access_plans id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plans ALTER COLUMN id SET DEFAULT nextval('access_plans_id_seq'::regclass);


--
-- Name: access_procedures id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_procedures ALTER COLUMN id SET DEFAULT nextval('access_procedures_id_seq'::regclass);


--
-- Name: access_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_profiles ALTER COLUMN id SET DEFAULT nextval('access_profiles_id_seq'::regclass);


--
-- Name: access_sites id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_sites ALTER COLUMN id SET DEFAULT nextval('access_sites_id_seq'::regclass);


--
-- Name: access_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_types ALTER COLUMN id SET DEFAULT nextval('access_types_id_seq'::regclass);


--
-- Name: access_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_versions ALTER COLUMN id SET DEFAULT nextval('access_versions_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('active_storage_blobs_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: admission_admissions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions ALTER COLUMN id SET DEFAULT nextval('admission_admissions_id_seq'::regclass);


--
-- Name: admission_consult_sites id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consult_sites ALTER COLUMN id SET DEFAULT nextval('admission_consult_sites_id_seq'::regclass);


--
-- Name: admission_consults id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consults ALTER COLUMN id SET DEFAULT nextval('admission_consults_id_seq'::regclass);


--
-- Name: admission_request_reasons id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_request_reasons ALTER COLUMN id SET DEFAULT nextval('admission_request_reasons_id_seq'::regclass);


--
-- Name: admission_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_requests ALTER COLUMN id SET DEFAULT nextval('admission_requests_id_seq'::regclass);


--
-- Name: clinic_appointments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_appointments ALTER COLUMN id SET DEFAULT nextval('clinic_appointments_id_seq'::regclass);


--
-- Name: clinic_clinics id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_clinics ALTER COLUMN id SET DEFAULT nextval('clinic_clinics_id_seq'::regclass);


--
-- Name: clinic_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_versions ALTER COLUMN id SET DEFAULT nextval('clinic_versions_id_seq'::regclass);


--
-- Name: clinic_visits id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_visits ALTER COLUMN id SET DEFAULT nextval('clinic_visits_id_seq'::regclass);


--
-- Name: clinical_allergies id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_allergies ALTER COLUMN id SET DEFAULT nextval('clinical_allergies_id_seq'::regclass);


--
-- Name: clinical_body_compositions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_body_compositions ALTER COLUMN id SET DEFAULT nextval('clinical_body_compositions_id_seq'::regclass);


--
-- Name: clinical_dry_weights id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_dry_weights ALTER COLUMN id SET DEFAULT nextval('clinical_dry_weights_id_seq'::regclass);


--
-- Name: clinical_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_versions ALTER COLUMN id SET DEFAULT nextval('clinical_versions_id_seq'::regclass);


--
-- Name: death_causes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY death_causes ALTER COLUMN id SET DEFAULT nextval('death_causes_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: directory_people id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY directory_people ALTER COLUMN id SET DEFAULT nextval('directory_people_id_seq'::regclass);


--
-- Name: drug_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drug_types ALTER COLUMN id SET DEFAULT nextval('drug_types_id_seq'::regclass);


--
-- Name: drug_types_drugs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drug_types_drugs ALTER COLUMN id SET DEFAULT nextval('drug_types_drugs_id_seq'::regclass);


--
-- Name: drugs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drugs ALTER COLUMN id SET DEFAULT nextval('drugs_id_seq'::regclass);


--
-- Name: event_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY event_types ALTER COLUMN id SET DEFAULT nextval('event_types_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: feed_file_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY feed_file_types ALTER COLUMN id SET DEFAULT nextval('feed_file_types_id_seq'::regclass);


--
-- Name: feed_files id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY feed_files ALTER COLUMN id SET DEFAULT nextval('feed_files_id_seq'::regclass);


--
-- Name: feed_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY feed_messages ALTER COLUMN id SET DEFAULT nextval('feed_messages_id_seq'::regclass);


--
-- Name: hd_cannulation_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_cannulation_types ALTER COLUMN id SET DEFAULT nextval('hd_cannulation_types_id_seq'::regclass);


--
-- Name: hd_dialysates id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_dialysates ALTER COLUMN id SET DEFAULT nextval('hd_dialysates_id_seq'::regclass);


--
-- Name: hd_dialysers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_dialysers ALTER COLUMN id SET DEFAULT nextval('hd_dialysers_id_seq'::regclass);


--
-- Name: hd_diaries id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diaries ALTER COLUMN id SET DEFAULT nextval('hd_diaries_id_seq'::regclass);


--
-- Name: hd_diary_slots id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots ALTER COLUMN id SET DEFAULT nextval('hd_diary_slots_id_seq'::regclass);


--
-- Name: hd_diurnal_period_codes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diurnal_period_codes ALTER COLUMN id SET DEFAULT nextval('hd_diurnal_period_codes_id_seq'::regclass);


--
-- Name: hd_patient_statistics id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics ALTER COLUMN id SET DEFAULT nextval('hd_patient_statistics_id_seq'::regclass);


--
-- Name: hd_preference_sets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_preference_sets ALTER COLUMN id SET DEFAULT nextval('hd_preference_sets_id_seq'::regclass);


--
-- Name: hd_prescription_administrations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_prescription_administrations ALTER COLUMN id SET DEFAULT nextval('hd_prescription_administrations_id_seq'::regclass);


--
-- Name: hd_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles ALTER COLUMN id SET DEFAULT nextval('hd_profiles_id_seq'::regclass);


--
-- Name: hd_provider_units id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_provider_units ALTER COLUMN id SET DEFAULT nextval('hd_provider_units_id_seq'::regclass);


--
-- Name: hd_providers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_providers ALTER COLUMN id SET DEFAULT nextval('hd_providers_id_seq'::regclass);


--
-- Name: hd_schedule_definitions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_schedule_definitions ALTER COLUMN id SET DEFAULT nextval('hd_schedule_definitions_id_seq'::regclass);


--
-- Name: hd_sessions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions ALTER COLUMN id SET DEFAULT nextval('hd_sessions_id_seq'::regclass);


--
-- Name: hd_station_locations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_station_locations ALTER COLUMN id SET DEFAULT nextval('hd_station_locations_id_seq'::regclass);


--
-- Name: hd_stations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_stations ALTER COLUMN id SET DEFAULT nextval('hd_stations_id_seq'::regclass);


--
-- Name: hd_transmission_logs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_transmission_logs ALTER COLUMN id SET DEFAULT nextval('hd_transmission_logs_id_seq'::regclass);


--
-- Name: hd_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_versions ALTER COLUMN id SET DEFAULT nextval('hd_versions_id_seq'::regclass);


--
-- Name: hospital_centres id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_centres ALTER COLUMN id SET DEFAULT nextval('hospital_centres_id_seq'::regclass);


--
-- Name: hospital_units id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_units ALTER COLUMN id SET DEFAULT nextval('hospital_units_id_seq'::regclass);


--
-- Name: hospital_wards id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_wards ALTER COLUMN id SET DEFAULT nextval('hospital_wards_id_seq'::regclass);


--
-- Name: letter_archives id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_archives ALTER COLUMN id SET DEFAULT nextval('letter_archives_id_seq'::regclass);


--
-- Name: letter_contact_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_contact_descriptions ALTER COLUMN id SET DEFAULT nextval('letter_contact_descriptions_id_seq'::regclass);


--
-- Name: letter_contacts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_contacts ALTER COLUMN id SET DEFAULT nextval('letter_contacts_id_seq'::regclass);


--
-- Name: letter_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_descriptions ALTER COLUMN id SET DEFAULT nextval('letter_descriptions_id_seq'::regclass);


--
-- Name: letter_electronic_receipts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_electronic_receipts ALTER COLUMN id SET DEFAULT nextval('letter_electronic_receipts_id_seq'::regclass);


--
-- Name: letter_letterheads id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letterheads ALTER COLUMN id SET DEFAULT nextval('letter_letterheads_id_seq'::regclass);


--
-- Name: letter_letters id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters ALTER COLUMN id SET DEFAULT nextval('letter_letters_id_seq'::regclass);


--
-- Name: letter_recipients id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_recipients ALTER COLUMN id SET DEFAULT nextval('letter_recipients_id_seq'::regclass);


--
-- Name: letter_signatures id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_signatures ALTER COLUMN id SET DEFAULT nextval('letter_signatures_id_seq'::regclass);


--
-- Name: low_clearance_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY low_clearance_profiles ALTER COLUMN id SET DEFAULT nextval('low_clearance_profiles_id_seq'::regclass);


--
-- Name: low_clearance_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY low_clearance_versions ALTER COLUMN id SET DEFAULT nextval('low_clearance_versions_id_seq'::regclass);


--
-- Name: medication_prescription_terminations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations ALTER COLUMN id SET DEFAULT nextval('medication_prescription_terminations_id_seq'::regclass);


--
-- Name: medication_prescription_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescription_versions ALTER COLUMN id SET DEFAULT nextval('medication_prescription_versions_id_seq'::regclass);


--
-- Name: medication_prescriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescriptions ALTER COLUMN id SET DEFAULT nextval('medication_prescriptions_id_seq'::regclass);


--
-- Name: medication_routes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_routes ALTER COLUMN id SET DEFAULT nextval('medication_routes_id_seq'::regclass);


--
-- Name: messaging_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_messages ALTER COLUMN id SET DEFAULT nextval('messaging_messages_id_seq'::regclass);


--
-- Name: messaging_receipts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_receipts ALTER COLUMN id SET DEFAULT nextval('messaging_receipts_id_seq'::regclass);


--
-- Name: modality_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_descriptions ALTER COLUMN id SET DEFAULT nextval('modality_descriptions_id_seq'::regclass);


--
-- Name: modality_modalities id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_modalities ALTER COLUMN id SET DEFAULT nextval('modality_modalities_id_seq'::regclass);


--
-- Name: modality_reasons id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_reasons ALTER COLUMN id SET DEFAULT nextval('modality_reasons_id_seq'::regclass);


--
-- Name: pathology_current_observation_sets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_current_observation_sets ALTER COLUMN id SET DEFAULT nextval('pathology_current_observation_sets_id_seq'::regclass);


--
-- Name: pathology_labs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_labs ALTER COLUMN id SET DEFAULT nextval('pathology_labs_id_seq'::regclass);


--
-- Name: pathology_measurement_units id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_measurement_units ALTER COLUMN id SET DEFAULT nextval('pathology_measurement_units_id_seq'::regclass);


--
-- Name: pathology_observation_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observation_descriptions ALTER COLUMN id SET DEFAULT nextval('pathology_observation_descriptions_id_seq'::regclass);


--
-- Name: pathology_observation_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests ALTER COLUMN id SET DEFAULT nextval('pathology_observation_requests_id_seq'::regclass);


--
-- Name: pathology_observations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observations ALTER COLUMN id SET DEFAULT nextval('pathology_observations_id_seq'::regclass);


--
-- Name: pathology_request_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions ALTER COLUMN id SET DEFAULT nextval('pathology_request_descriptions_id_seq'::regclass);


--
-- Name: pathology_request_descriptions_requests_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests ALTER COLUMN id SET DEFAULT nextval('pathology_request_descriptions_requests_requests_id_seq'::regclass);


--
-- Name: pathology_requests_drug_categories id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_drug_categories ALTER COLUMN id SET DEFAULT nextval('pathology_requests_drug_categories_id_seq'::regclass);


--
-- Name: pathology_requests_drugs_drug_categories id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories ALTER COLUMN id SET DEFAULT nextval('pathology_requests_drugs_drug_categories_id_seq'::regclass);


--
-- Name: pathology_requests_global_rule_sets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets ALTER COLUMN id SET DEFAULT nextval('pathology_requests_global_rule_sets_id_seq'::regclass);


--
-- Name: pathology_requests_global_rules id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rules ALTER COLUMN id SET DEFAULT nextval('pathology_requests_global_rules_id_seq'::regclass);


--
-- Name: pathology_requests_patient_rules id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules ALTER COLUMN id SET DEFAULT nextval('pathology_requests_patient_rules_id_seq'::regclass);


--
-- Name: pathology_requests_patient_rules_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests ALTER COLUMN id SET DEFAULT nextval('pathology_requests_patient_rules_requests_id_seq'::regclass);


--
-- Name: pathology_requests_requests id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests ALTER COLUMN id SET DEFAULT nextval('pathology_requests_requests_id_seq'::regclass);


--
-- Name: patient_alerts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_alerts ALTER COLUMN id SET DEFAULT nextval('patient_alerts_id_seq'::regclass);


--
-- Name: patient_bookmarks id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_bookmarks ALTER COLUMN id SET DEFAULT nextval('patient_bookmarks_id_seq'::regclass);


--
-- Name: patient_ethnicities id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_ethnicities ALTER COLUMN id SET DEFAULT nextval('patient_ethnicities_id_seq'::regclass);


--
-- Name: patient_languages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_languages ALTER COLUMN id SET DEFAULT nextval('patient_languages_id_seq'::regclass);


--
-- Name: patient_practice_memberships id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_practice_memberships ALTER COLUMN id SET DEFAULT nextval('patient_practice_memberships_id_seq'::regclass);


--
-- Name: patient_practices id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_practices ALTER COLUMN id SET DEFAULT nextval('patient_practices_id_seq'::regclass);


--
-- Name: patient_primary_care_physicians id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_primary_care_physicians ALTER COLUMN id SET DEFAULT nextval('patient_primary_care_physicians_id_seq'::regclass);


--
-- Name: patient_religions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_religions ALTER COLUMN id SET DEFAULT nextval('patient_religions_id_seq'::regclass);


--
-- Name: patient_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_versions ALTER COLUMN id SET DEFAULT nextval('patient_versions_id_seq'::regclass);


--
-- Name: patient_worries id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_worries ALTER COLUMN id SET DEFAULT nextval('patient_worries_id_seq'::regclass);


--
-- Name: patients id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients ALTER COLUMN id SET DEFAULT nextval('patients_id_seq'::regclass);


--
-- Name: pd_assessments id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_assessments ALTER COLUMN id SET DEFAULT nextval('pd_assessments_id_seq'::regclass);


--
-- Name: pd_bag_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_bag_types ALTER COLUMN id SET DEFAULT nextval('pd_bag_types_id_seq'::regclass);


--
-- Name: pd_exit_site_infections id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_exit_site_infections ALTER COLUMN id SET DEFAULT nextval('pd_exit_site_infections_id_seq'::regclass);


--
-- Name: pd_fluid_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_fluid_descriptions ALTER COLUMN id SET DEFAULT nextval('pd_fluid_descriptions_id_seq'::regclass);


--
-- Name: pd_infection_organisms id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_infection_organisms ALTER COLUMN id SET DEFAULT nextval('pd_infection_organisms_id_seq'::regclass);


--
-- Name: pd_organism_codes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_organism_codes ALTER COLUMN id SET DEFAULT nextval('pd_organism_codes_id_seq'::regclass);


--
-- Name: pd_peritonitis_episode_type_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episode_type_descriptions ALTER COLUMN id SET DEFAULT nextval('pd_peritonitis_episode_type_descriptions_id_seq'::regclass);


--
-- Name: pd_peritonitis_episode_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episode_types ALTER COLUMN id SET DEFAULT nextval('pd_peritonitis_episode_types_id_seq'::regclass);


--
-- Name: pd_peritonitis_episodes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes ALTER COLUMN id SET DEFAULT nextval('pd_peritonitis_episodes_id_seq'::regclass);


--
-- Name: pd_pet_adequacy_results id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_pet_adequacy_results ALTER COLUMN id SET DEFAULT nextval('pd_pet_adequacy_results_id_seq'::regclass);


--
-- Name: pd_regime_bags id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_bags ALTER COLUMN id SET DEFAULT nextval('pd_regime_bags_id_seq'::regclass);


--
-- Name: pd_regime_terminations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_terminations ALTER COLUMN id SET DEFAULT nextval('pd_regime_terminations_id_seq'::regclass);


--
-- Name: pd_regimes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regimes ALTER COLUMN id SET DEFAULT nextval('pd_regimes_id_seq'::regclass);


--
-- Name: pd_systems id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_systems ALTER COLUMN id SET DEFAULT nextval('pd_systems_id_seq'::regclass);


--
-- Name: pd_training_sessions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sessions ALTER COLUMN id SET DEFAULT nextval('pd_training_sessions_id_seq'::regclass);


--
-- Name: pd_training_sites id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sites ALTER COLUMN id SET DEFAULT nextval('pd_training_sites_id_seq'::regclass);


--
-- Name: pd_training_types id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_types ALTER COLUMN id SET DEFAULT nextval('pd_training_types_id_seq'::regclass);


--
-- Name: problem_notes id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_notes ALTER COLUMN id SET DEFAULT nextval('problem_notes_id_seq'::regclass);


--
-- Name: problem_problems id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_problems ALTER COLUMN id SET DEFAULT nextval('problem_problems_id_seq'::regclass);


--
-- Name: problem_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_versions ALTER COLUMN id SET DEFAULT nextval('problem_versions_id_seq'::regclass);


--
-- Name: renal_aki_alert_actions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alert_actions ALTER COLUMN id SET DEFAULT nextval('renal_aki_alert_actions_id_seq'::regclass);


--
-- Name: renal_aki_alerts id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alerts ALTER COLUMN id SET DEFAULT nextval('renal_aki_alerts_id_seq'::regclass);


--
-- Name: renal_prd_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_prd_descriptions ALTER COLUMN id SET DEFAULT nextval('renal_prd_descriptions_id_seq'::regclass);


--
-- Name: renal_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_profiles ALTER COLUMN id SET DEFAULT nextval('renal_profiles_id_seq'::regclass);


--
-- Name: renal_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_versions ALTER COLUMN id SET DEFAULT nextval('renal_versions_id_seq'::regclass);


--
-- Name: reporting_audits id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY reporting_audits ALTER COLUMN id SET DEFAULT nextval('reporting_audits_id_seq'::regclass);


--
-- Name: research_studies id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_studies ALTER COLUMN id SET DEFAULT nextval('research_studies_id_seq'::regclass);


--
-- Name: research_study_participations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_study_participations ALTER COLUMN id SET DEFAULT nextval('research_study_participations_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: roles_users id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY roles_users ALTER COLUMN id SET DEFAULT nextval('roles_users_id_seq'::regclass);


--
-- Name: snippets_snippets id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY snippets_snippets ALTER COLUMN id SET DEFAULT nextval('snippets_snippets_id_seq'::regclass);


--
-- Name: system_countries id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_countries ALTER COLUMN id SET DEFAULT nextval('system_countries_id_seq'::regclass);


--
-- Name: system_events id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_events ALTER COLUMN id SET DEFAULT nextval('system_events_id_seq'::regclass);


--
-- Name: system_messages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_messages ALTER COLUMN id SET DEFAULT nextval('system_messages_id_seq'::regclass);


--
-- Name: system_templates id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_templates ALTER COLUMN id SET DEFAULT nextval('system_templates_id_seq'::regclass);


--
-- Name: system_user_feedback id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_user_feedback ALTER COLUMN id SET DEFAULT nextval('system_user_feedback_id_seq'::regclass);


--
-- Name: system_visits id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_visits ALTER COLUMN id SET DEFAULT nextval('system_visits_id_seq'::regclass);


--
-- Name: transplant_donations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donations ALTER COLUMN id SET DEFAULT nextval('transplant_donations_id_seq'::regclass);


--
-- Name: transplant_donor_followups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_followups ALTER COLUMN id SET DEFAULT nextval('transplant_donor_followups_id_seq'::regclass);


--
-- Name: transplant_donor_operations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_operations ALTER COLUMN id SET DEFAULT nextval('transplant_donor_operations_id_seq'::regclass);


--
-- Name: transplant_donor_stage_positions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stage_positions ALTER COLUMN id SET DEFAULT nextval('transplant_donor_stage_positions_id_seq'::regclass);


--
-- Name: transplant_donor_stage_statuses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stage_statuses ALTER COLUMN id SET DEFAULT nextval('transplant_donor_stage_statuses_id_seq'::regclass);


--
-- Name: transplant_donor_stages id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stages ALTER COLUMN id SET DEFAULT nextval('transplant_donor_stages_id_seq'::regclass);


--
-- Name: transplant_donor_workups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_workups ALTER COLUMN id SET DEFAULT nextval('transplant_donor_workups_id_seq'::regclass);


--
-- Name: transplant_failure_cause_description_groups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_description_groups ALTER COLUMN id SET DEFAULT nextval('transplant_failure_cause_description_groups_id_seq'::regclass);


--
-- Name: transplant_failure_cause_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_descriptions ALTER COLUMN id SET DEFAULT nextval('transplant_failure_cause_descriptions_id_seq'::regclass);


--
-- Name: transplant_recipient_followups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups ALTER COLUMN id SET DEFAULT nextval('transplant_recipient_followups_id_seq'::regclass);


--
-- Name: transplant_recipient_operations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations ALTER COLUMN id SET DEFAULT nextval('transplant_recipient_operations_id_seq'::regclass);


--
-- Name: transplant_recipient_workups id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_workups ALTER COLUMN id SET DEFAULT nextval('transplant_recipient_workups_id_seq'::regclass);


--
-- Name: transplant_registration_status_descriptions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_status_descriptions ALTER COLUMN id SET DEFAULT nextval('transplant_registration_status_descriptions_id_seq'::regclass);


--
-- Name: transplant_registration_statuses id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses ALTER COLUMN id SET DEFAULT nextval('transplant_registration_statuses_id_seq'::regclass);


--
-- Name: transplant_registrations id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registrations ALTER COLUMN id SET DEFAULT nextval('transplant_registrations_id_seq'::regclass);


--
-- Name: transplant_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_versions ALTER COLUMN id SET DEFAULT nextval('transplant_versions_id_seq'::regclass);


--
-- Name: ukrdc_batch_numbers id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY ukrdc_batch_numbers ALTER COLUMN id SET DEFAULT nextval('ukrdc_batch_numbers_id_seq'::regclass);


--
-- Name: ukrdc_transmission_logs id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY ukrdc_transmission_logs ALTER COLUMN id SET DEFAULT nextval('ukrdc_transmission_logs_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: virology_profiles id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY virology_profiles ALTER COLUMN id SET DEFAULT nextval('virology_profiles_id_seq'::regclass);


--
-- Name: virology_versions id; Type: DEFAULT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY virology_versions ALTER COLUMN id SET DEFAULT nextval('virology_versions_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


SET search_path = renalware, pg_catalog;

--
-- Name: access_assessments access_assessments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT access_assessments_pkey PRIMARY KEY (id);


--
-- Name: access_catheter_insertion_techniques access_catheter_insertion_techniques_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_catheter_insertion_techniques
    ADD CONSTRAINT access_catheter_insertion_techniques_pkey PRIMARY KEY (id);


--
-- Name: access_plan_types access_plan_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plan_types
    ADD CONSTRAINT access_plan_types_pkey PRIMARY KEY (id);


--
-- Name: access_plans access_plans_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plans
    ADD CONSTRAINT access_plans_pkey PRIMARY KEY (id);


--
-- Name: access_procedures access_procedures_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT access_procedures_pkey PRIMARY KEY (id);


--
-- Name: access_profiles access_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT access_profiles_pkey PRIMARY KEY (id);


--
-- Name: access_sites access_sites_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_sites
    ADD CONSTRAINT access_sites_pkey PRIMARY KEY (id);


--
-- Name: access_types access_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_types
    ADD CONSTRAINT access_types_pkey PRIMARY KEY (id);


--
-- Name: access_versions access_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_versions
    ADD CONSTRAINT access_versions_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admission_admissions admission_admissions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions
    ADD CONSTRAINT admission_admissions_pkey PRIMARY KEY (id);


--
-- Name: admission_consult_sites admission_consult_sites_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consult_sites
    ADD CONSTRAINT admission_consult_sites_pkey PRIMARY KEY (id);


--
-- Name: admission_consults admission_consults_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consults
    ADD CONSTRAINT admission_consults_pkey PRIMARY KEY (id);


--
-- Name: admission_request_reasons admission_request_reasons_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_request_reasons
    ADD CONSTRAINT admission_request_reasons_pkey PRIMARY KEY (id);


--
-- Name: admission_requests admission_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_requests
    ADD CONSTRAINT admission_requests_pkey PRIMARY KEY (id);


--
-- Name: clinic_appointments clinic_appointments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_appointments
    ADD CONSTRAINT clinic_appointments_pkey PRIMARY KEY (id);


--
-- Name: clinic_clinics clinic_clinics_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_clinics
    ADD CONSTRAINT clinic_clinics_pkey PRIMARY KEY (id);


--
-- Name: clinic_versions clinic_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_versions
    ADD CONSTRAINT clinic_versions_pkey PRIMARY KEY (id);


--
-- Name: clinic_visits clinic_visits_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT clinic_visits_pkey PRIMARY KEY (id);


--
-- Name: clinical_allergies clinical_allergies_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_allergies
    ADD CONSTRAINT clinical_allergies_pkey PRIMARY KEY (id);


--
-- Name: clinical_body_compositions clinical_body_compositions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_body_compositions
    ADD CONSTRAINT clinical_body_compositions_pkey PRIMARY KEY (id);


--
-- Name: clinical_dry_weights clinical_dry_weights_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_dry_weights
    ADD CONSTRAINT clinical_dry_weights_pkey PRIMARY KEY (id);


--
-- Name: clinical_versions clinical_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_versions
    ADD CONSTRAINT clinical_versions_pkey PRIMARY KEY (id);


--
-- Name: hd_schedule_definitions days_array_unique_scoped_to_period; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_schedule_definitions
    ADD CONSTRAINT days_array_unique_scoped_to_period EXCLUDE USING gist (diurnal_period_id WITH =, days WITH =);


--
-- Name: death_causes death_causes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY death_causes
    ADD CONSTRAINT death_causes_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: directory_people directory_people_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY directory_people
    ADD CONSTRAINT directory_people_pkey PRIMARY KEY (id);


--
-- Name: drug_types_drugs drug_types_drugs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drug_types_drugs
    ADD CONSTRAINT drug_types_drugs_pkey PRIMARY KEY (id);


--
-- Name: drug_types drug_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drug_types
    ADD CONSTRAINT drug_types_pkey PRIMARY KEY (id);


--
-- Name: drugs drugs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: event_types event_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY event_types
    ADD CONSTRAINT event_types_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: feed_file_types feed_file_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY feed_file_types
    ADD CONSTRAINT feed_file_types_pkey PRIMARY KEY (id);


--
-- Name: feed_files feed_files_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY feed_files
    ADD CONSTRAINT feed_files_pkey PRIMARY KEY (id);


--
-- Name: feed_messages feed_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY feed_messages
    ADD CONSTRAINT feed_messages_pkey PRIMARY KEY (id);


--
-- Name: hd_cannulation_types hd_cannulation_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_cannulation_types
    ADD CONSTRAINT hd_cannulation_types_pkey PRIMARY KEY (id);


--
-- Name: hd_dialysates hd_dialysates_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_dialysates
    ADD CONSTRAINT hd_dialysates_pkey PRIMARY KEY (id);


--
-- Name: hd_dialysers hd_dialysers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_dialysers
    ADD CONSTRAINT hd_dialysers_pkey PRIMARY KEY (id);


--
-- Name: hd_diaries hd_diaries_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diaries
    ADD CONSTRAINT hd_diaries_pkey PRIMARY KEY (id);


--
-- Name: hd_diary_slots hd_diary_slots_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots
    ADD CONSTRAINT hd_diary_slots_pkey PRIMARY KEY (id);


--
-- Name: hd_diurnal_period_codes hd_diurnal_period_codes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diurnal_period_codes
    ADD CONSTRAINT hd_diurnal_period_codes_pkey PRIMARY KEY (id);


--
-- Name: hd_patient_statistics hd_patient_statistics_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics
    ADD CONSTRAINT hd_patient_statistics_pkey PRIMARY KEY (id);


--
-- Name: hd_preference_sets hd_preference_sets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT hd_preference_sets_pkey PRIMARY KEY (id);


--
-- Name: hd_prescription_administrations hd_prescription_administrations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_prescription_administrations
    ADD CONSTRAINT hd_prescription_administrations_pkey PRIMARY KEY (id);


--
-- Name: hd_profiles hd_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT hd_profiles_pkey PRIMARY KEY (id);


--
-- Name: hd_provider_units hd_provider_units_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_provider_units
    ADD CONSTRAINT hd_provider_units_pkey PRIMARY KEY (id);


--
-- Name: hd_providers hd_providers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_providers
    ADD CONSTRAINT hd_providers_pkey PRIMARY KEY (id);


--
-- Name: hd_schedule_definitions hd_schedule_definitions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_schedule_definitions
    ADD CONSTRAINT hd_schedule_definitions_pkey PRIMARY KEY (id);


--
-- Name: hd_sessions hd_sessions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT hd_sessions_pkey PRIMARY KEY (id);


--
-- Name: hd_station_locations hd_station_locations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_station_locations
    ADD CONSTRAINT hd_station_locations_pkey PRIMARY KEY (id);


--
-- Name: hd_stations hd_stations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_stations
    ADD CONSTRAINT hd_stations_pkey PRIMARY KEY (id);


--
-- Name: hd_transmission_logs hd_transmission_logs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_transmission_logs
    ADD CONSTRAINT hd_transmission_logs_pkey PRIMARY KEY (id);


--
-- Name: hd_versions hd_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_versions
    ADD CONSTRAINT hd_versions_pkey PRIMARY KEY (id);


--
-- Name: hospital_centres hospital_centres_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_centres
    ADD CONSTRAINT hospital_centres_pkey PRIMARY KEY (id);


--
-- Name: hospital_units hospital_units_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_units
    ADD CONSTRAINT hospital_units_pkey PRIMARY KEY (id);


--
-- Name: hospital_wards hospital_wards_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_wards
    ADD CONSTRAINT hospital_wards_pkey PRIMARY KEY (id);


--
-- Name: letter_archives letter_archives_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_archives
    ADD CONSTRAINT letter_archives_pkey PRIMARY KEY (id);


--
-- Name: letter_contact_descriptions letter_contact_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_contact_descriptions
    ADD CONSTRAINT letter_contact_descriptions_pkey PRIMARY KEY (id);


--
-- Name: letter_contacts letter_contacts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT letter_contacts_pkey PRIMARY KEY (id);


--
-- Name: letter_descriptions letter_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_descriptions
    ADD CONSTRAINT letter_descriptions_pkey PRIMARY KEY (id);


--
-- Name: letter_electronic_receipts letter_electronic_receipts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_electronic_receipts
    ADD CONSTRAINT letter_electronic_receipts_pkey PRIMARY KEY (id);


--
-- Name: letter_letterheads letter_letterheads_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letterheads
    ADD CONSTRAINT letter_letterheads_pkey PRIMARY KEY (id);


--
-- Name: letter_letters letter_letters_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT letter_letters_pkey PRIMARY KEY (id);


--
-- Name: letter_recipients letter_recipients_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_recipients
    ADD CONSTRAINT letter_recipients_pkey PRIMARY KEY (id);


--
-- Name: letter_signatures letter_signatures_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_signatures
    ADD CONSTRAINT letter_signatures_pkey PRIMARY KEY (id);


--
-- Name: low_clearance_profiles low_clearance_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY low_clearance_profiles
    ADD CONSTRAINT low_clearance_profiles_pkey PRIMARY KEY (id);


--
-- Name: low_clearance_versions low_clearance_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY low_clearance_versions
    ADD CONSTRAINT low_clearance_versions_pkey PRIMARY KEY (id);


--
-- Name: medication_prescription_terminations medication_prescription_terminations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT medication_prescription_terminations_pkey PRIMARY KEY (id);


--
-- Name: medication_prescription_versions medication_prescription_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescription_versions
    ADD CONSTRAINT medication_prescription_versions_pkey PRIMARY KEY (id);


--
-- Name: medication_prescriptions medication_prescriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT medication_prescriptions_pkey PRIMARY KEY (id);


--
-- Name: medication_routes medication_routes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_routes
    ADD CONSTRAINT medication_routes_pkey PRIMARY KEY (id);


--
-- Name: messaging_messages messaging_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_messages
    ADD CONSTRAINT messaging_messages_pkey PRIMARY KEY (id);


--
-- Name: messaging_receipts messaging_receipts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_receipts
    ADD CONSTRAINT messaging_receipts_pkey PRIMARY KEY (id);


--
-- Name: modality_descriptions modality_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_descriptions
    ADD CONSTRAINT modality_descriptions_pkey PRIMARY KEY (id);


--
-- Name: modality_modalities modality_modalities_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT modality_modalities_pkey PRIMARY KEY (id);


--
-- Name: modality_reasons modality_reasons_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_reasons
    ADD CONSTRAINT modality_reasons_pkey PRIMARY KEY (id);


--
-- Name: pathology_current_observation_sets pathology_current_observation_sets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_current_observation_sets
    ADD CONSTRAINT pathology_current_observation_sets_pkey PRIMARY KEY (id);


--
-- Name: pathology_labs pathology_labs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_labs
    ADD CONSTRAINT pathology_labs_pkey PRIMARY KEY (id);


--
-- Name: pathology_measurement_units pathology_measurement_units_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_measurement_units
    ADD CONSTRAINT pathology_measurement_units_pkey PRIMARY KEY (id);


--
-- Name: pathology_observation_descriptions pathology_observation_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observation_descriptions
    ADD CONSTRAINT pathology_observation_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pathology_observation_requests pathology_observation_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests
    ADD CONSTRAINT pathology_observation_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_observations pathology_observations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observations
    ADD CONSTRAINT pathology_observations_pkey PRIMARY KEY (id);


--
-- Name: pathology_request_descriptions pathology_request_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions
    ADD CONSTRAINT pathology_request_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pathology_request_descriptions_requests_requests pathology_request_descriptions_requests_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests
    ADD CONSTRAINT pathology_request_descriptions_requests_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_drug_categories pathology_requests_drug_categories_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_drug_categories
    ADD CONSTRAINT pathology_requests_drug_categories_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_drugs_drug_categories pathology_requests_drugs_drug_categories_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories
    ADD CONSTRAINT pathology_requests_drugs_drug_categories_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_global_rule_sets pathology_requests_global_rule_sets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets
    ADD CONSTRAINT pathology_requests_global_rule_sets_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_global_rules pathology_requests_global_rules_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rules
    ADD CONSTRAINT pathology_requests_global_rules_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_patient_rules pathology_requests_patient_rules_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules
    ADD CONSTRAINT pathology_requests_patient_rules_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_patient_rules_requests pathology_requests_patient_rules_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests
    ADD CONSTRAINT pathology_requests_patient_rules_requests_pkey PRIMARY KEY (id);


--
-- Name: pathology_requests_requests pathology_requests_requests_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT pathology_requests_requests_pkey PRIMARY KEY (id);


--
-- Name: patient_alerts patient_alerts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_alerts
    ADD CONSTRAINT patient_alerts_pkey PRIMARY KEY (id);


--
-- Name: patient_bookmarks patient_bookmarks_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_bookmarks
    ADD CONSTRAINT patient_bookmarks_pkey PRIMARY KEY (id);


--
-- Name: patient_ethnicities patient_ethnicities_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_ethnicities
    ADD CONSTRAINT patient_ethnicities_pkey PRIMARY KEY (id);


--
-- Name: patient_languages patient_languages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_languages
    ADD CONSTRAINT patient_languages_pkey PRIMARY KEY (id);


--
-- Name: patient_practice_memberships patient_practice_memberships_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_practice_memberships
    ADD CONSTRAINT patient_practice_memberships_pkey PRIMARY KEY (id);


--
-- Name: patient_practices patient_practices_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_practices
    ADD CONSTRAINT patient_practices_pkey PRIMARY KEY (id);


--
-- Name: patient_primary_care_physicians patient_primary_care_physicians_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_primary_care_physicians
    ADD CONSTRAINT patient_primary_care_physicians_pkey PRIMARY KEY (id);


--
-- Name: patient_religions patient_religions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_religions
    ADD CONSTRAINT patient_religions_pkey PRIMARY KEY (id);


--
-- Name: patient_versions patient_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_versions
    ADD CONSTRAINT patient_versions_pkey PRIMARY KEY (id);


--
-- Name: patient_worries patient_worries_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_worries
    ADD CONSTRAINT patient_worries_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: pd_assessments pd_assessments_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_assessments
    ADD CONSTRAINT pd_assessments_pkey PRIMARY KEY (id);


--
-- Name: pd_bag_types pd_bag_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_bag_types
    ADD CONSTRAINT pd_bag_types_pkey PRIMARY KEY (id);


--
-- Name: pd_exit_site_infections pd_exit_site_infections_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_exit_site_infections
    ADD CONSTRAINT pd_exit_site_infections_pkey PRIMARY KEY (id);


--
-- Name: pd_fluid_descriptions pd_fluid_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_fluid_descriptions
    ADD CONSTRAINT pd_fluid_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pd_infection_organisms pd_infection_organisms_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_infection_organisms
    ADD CONSTRAINT pd_infection_organisms_pkey PRIMARY KEY (id);


--
-- Name: pd_organism_codes pd_organism_codes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_organism_codes
    ADD CONSTRAINT pd_organism_codes_pkey PRIMARY KEY (id);


--
-- Name: pd_peritonitis_episode_type_descriptions pd_peritonitis_episode_type_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episode_type_descriptions
    ADD CONSTRAINT pd_peritonitis_episode_type_descriptions_pkey PRIMARY KEY (id);


--
-- Name: pd_peritonitis_episode_types pd_peritonitis_episode_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episode_types
    ADD CONSTRAINT pd_peritonitis_episode_types_pkey PRIMARY KEY (id);


--
-- Name: pd_peritonitis_episodes pd_peritonitis_episodes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT pd_peritonitis_episodes_pkey PRIMARY KEY (id);


--
-- Name: pd_pet_adequacy_results pd_pet_adequacy_results_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_pet_adequacy_results
    ADD CONSTRAINT pd_pet_adequacy_results_pkey PRIMARY KEY (id);


--
-- Name: pd_regime_bags pd_regime_bags_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_bags
    ADD CONSTRAINT pd_regime_bags_pkey PRIMARY KEY (id);


--
-- Name: pd_regime_terminations pd_regime_terminations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_terminations
    ADD CONSTRAINT pd_regime_terminations_pkey PRIMARY KEY (id);


--
-- Name: pd_regimes pd_regimes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regimes
    ADD CONSTRAINT pd_regimes_pkey PRIMARY KEY (id);


--
-- Name: pd_systems pd_systems_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_systems
    ADD CONSTRAINT pd_systems_pkey PRIMARY KEY (id);


--
-- Name: pd_training_sessions pd_training_sessions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sessions
    ADD CONSTRAINT pd_training_sessions_pkey PRIMARY KEY (id);


--
-- Name: pd_training_sites pd_training_sites_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sites
    ADD CONSTRAINT pd_training_sites_pkey PRIMARY KEY (id);


--
-- Name: pd_training_types pd_training_types_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_types
    ADD CONSTRAINT pd_training_types_pkey PRIMARY KEY (id);


--
-- Name: problem_notes problem_notes_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_notes
    ADD CONSTRAINT problem_notes_pkey PRIMARY KEY (id);


--
-- Name: problem_problems problem_problems_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_problems
    ADD CONSTRAINT problem_problems_pkey PRIMARY KEY (id);


--
-- Name: problem_versions problem_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_versions
    ADD CONSTRAINT problem_versions_pkey PRIMARY KEY (id);


--
-- Name: renal_aki_alert_actions renal_aki_alert_actions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alert_actions
    ADD CONSTRAINT renal_aki_alert_actions_pkey PRIMARY KEY (id);


--
-- Name: renal_aki_alerts renal_aki_alerts_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alerts
    ADD CONSTRAINT renal_aki_alerts_pkey PRIMARY KEY (id);


--
-- Name: renal_prd_descriptions renal_prd_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_prd_descriptions
    ADD CONSTRAINT renal_prd_descriptions_pkey PRIMARY KEY (id);


--
-- Name: renal_profiles renal_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_profiles
    ADD CONSTRAINT renal_profiles_pkey PRIMARY KEY (id);


--
-- Name: renal_versions renal_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_versions
    ADD CONSTRAINT renal_versions_pkey PRIMARY KEY (id);


--
-- Name: reporting_audits reporting_audits_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY reporting_audits
    ADD CONSTRAINT reporting_audits_pkey PRIMARY KEY (id);


--
-- Name: research_studies research_studies_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_studies
    ADD CONSTRAINT research_studies_pkey PRIMARY KEY (id);


--
-- Name: research_study_participations research_study_participations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_study_participations
    ADD CONSTRAINT research_study_participations_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles_users roles_users_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_pkey PRIMARY KEY (id);


--
-- Name: snippets_snippets snippets_snippets_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY snippets_snippets
    ADD CONSTRAINT snippets_snippets_pkey PRIMARY KEY (id);


--
-- Name: system_countries system_countries_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_countries
    ADD CONSTRAINT system_countries_pkey PRIMARY KEY (id);


--
-- Name: system_events system_events_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_events
    ADD CONSTRAINT system_events_pkey PRIMARY KEY (id);


--
-- Name: system_messages system_messages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_messages
    ADD CONSTRAINT system_messages_pkey PRIMARY KEY (id);


--
-- Name: system_templates system_templates_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_templates
    ADD CONSTRAINT system_templates_pkey PRIMARY KEY (id);


--
-- Name: system_user_feedback system_user_feedback_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_user_feedback
    ADD CONSTRAINT system_user_feedback_pkey PRIMARY KEY (id);


--
-- Name: system_visits system_visits_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_visits
    ADD CONSTRAINT system_visits_pkey PRIMARY KEY (id);


--
-- Name: transplant_donations transplant_donations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donations
    ADD CONSTRAINT transplant_donations_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_followups transplant_donor_followups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_followups
    ADD CONSTRAINT transplant_donor_followups_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_operations transplant_donor_operations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_operations
    ADD CONSTRAINT transplant_donor_operations_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_stage_positions transplant_donor_stage_positions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stage_positions
    ADD CONSTRAINT transplant_donor_stage_positions_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_stage_statuses transplant_donor_stage_statuses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stage_statuses
    ADD CONSTRAINT transplant_donor_stage_statuses_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_stages transplant_donor_stages_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stages
    ADD CONSTRAINT transplant_donor_stages_pkey PRIMARY KEY (id);


--
-- Name: transplant_donor_workups transplant_donor_workups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_workups
    ADD CONSTRAINT transplant_donor_workups_pkey PRIMARY KEY (id);


--
-- Name: transplant_failure_cause_description_groups transplant_failure_cause_description_groups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_description_groups
    ADD CONSTRAINT transplant_failure_cause_description_groups_pkey PRIMARY KEY (id);


--
-- Name: transplant_failure_cause_descriptions transplant_failure_cause_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_descriptions
    ADD CONSTRAINT transplant_failure_cause_descriptions_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_followups transplant_recipient_followups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups
    ADD CONSTRAINT transplant_recipient_followups_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_operations transplant_recipient_operations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations
    ADD CONSTRAINT transplant_recipient_operations_pkey PRIMARY KEY (id);


--
-- Name: transplant_recipient_workups transplant_recipient_workups_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_workups
    ADD CONSTRAINT transplant_recipient_workups_pkey PRIMARY KEY (id);


--
-- Name: transplant_registration_status_descriptions transplant_registration_status_descriptions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_status_descriptions
    ADD CONSTRAINT transplant_registration_status_descriptions_pkey PRIMARY KEY (id);


--
-- Name: transplant_registration_statuses transplant_registration_statuses_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT transplant_registration_statuses_pkey PRIMARY KEY (id);


--
-- Name: transplant_registrations transplant_registrations_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registrations
    ADD CONSTRAINT transplant_registrations_pkey PRIMARY KEY (id);


--
-- Name: transplant_versions transplant_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_versions
    ADD CONSTRAINT transplant_versions_pkey PRIMARY KEY (id);


--
-- Name: ukrdc_batch_numbers ukrdc_batch_numbers_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY ukrdc_batch_numbers
    ADD CONSTRAINT ukrdc_batch_numbers_pkey PRIMARY KEY (id);


--
-- Name: ukrdc_transmission_logs ukrdc_transmission_logs_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY ukrdc_transmission_logs
    ADD CONSTRAINT ukrdc_transmission_logs_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: virology_profiles virology_profiles_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY virology_profiles
    ADD CONSTRAINT virology_profiles_pkey PRIMARY KEY (id);


--
-- Name: virology_versions virology_versions_pkey; Type: CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY virology_versions
    ADD CONSTRAINT virology_versions_pkey PRIMARY KEY (id);


--
-- Name: access_plan_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX access_plan_uniqueness ON access_plans USING btree (patient_id, COALESCE(terminated_at, '1970-01-01 00:00:00'::timestamp without time zone));


--
-- Name: access_procedure_pd_catheter_tech_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX access_procedure_pd_catheter_tech_idx ON access_procedures USING btree (pd_catheter_insertion_technique_id);


--
-- Name: access_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX access_versions_type_id ON access_versions USING btree (item_type, item_id);


--
-- Name: clinic_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX clinic_versions_type_id ON clinic_versions USING btree (item_type, item_id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: hd_diary_slots_unique_by_day_period_patient; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX hd_diary_slots_unique_by_day_period_patient ON hd_diary_slots USING btree (diary_id, day_of_week, diurnal_period_code_id, patient_id) WHERE (deleted_at IS NULL);


--
-- Name: hd_diary_slots_unique_by_station_day_period; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX hd_diary_slots_unique_by_station_day_period ON hd_diary_slots USING btree (diary_id, station_id, day_of_week, diurnal_period_code_id) WHERE (deleted_at IS NULL);


--
-- Name: hd_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX hd_versions_type_id ON hd_versions USING btree (item_type, item_id);


--
-- Name: idx_drugs_vmpid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_drugs_vmpid ON drugs USING btree (vmpid);


--
-- Name: idx_infection_organisms; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_infection_organisms ON pd_infection_organisms USING btree (organism_code_id, infectable_id, infectable_type);


--
-- Name: idx_infection_organisms_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_infection_organisms_type ON pd_infection_organisms USING btree (infectable_id, infectable_type);


--
-- Name: idx_medication_prescriptions_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_medication_prescriptions_type ON medication_prescriptions USING btree (treatable_id, treatable_type);


--
-- Name: idx_mp_patient_id_medication_route_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_mp_patient_id_medication_route_id ON medication_prescriptions USING btree (patient_id, medication_route_id);


--
-- Name: idx_patients_on_lower_family_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX idx_patients_on_lower_family_name ON patients USING btree (lower((family_name)::text), given_name);


--
-- Name: idx_practice_membership; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_practice_membership ON patient_practice_memberships USING btree (practice_id, primary_care_physician_id);


--
-- Name: idx_unique_diaryslot_patients; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX idx_unique_diaryslot_patients ON hd_diary_slots USING btree (diary_id, diurnal_period_code_id, day_of_week, patient_id);


--
-- Name: index_access_assessments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_created_by_id ON access_assessments USING btree (created_by_id);


--
-- Name: index_access_assessments_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_document ON access_assessments USING gin (document);


--
-- Name: index_access_assessments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_patient_id ON access_assessments USING btree (patient_id);


--
-- Name: index_access_assessments_on_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_type_id ON access_assessments USING btree (type_id);


--
-- Name: index_access_assessments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_assessments_on_updated_by_id ON access_assessments USING btree (updated_by_id);


--
-- Name: index_access_plan_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plan_types_on_deleted_at ON access_plan_types USING btree (deleted_at);


--
-- Name: index_access_plans_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_created_by_id ON access_plans USING btree (created_by_id);


--
-- Name: index_access_plans_on_decided_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_decided_by_id ON access_plans USING btree (decided_by_id);


--
-- Name: index_access_plans_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_patient_id ON access_plans USING btree (patient_id);


--
-- Name: index_access_plans_on_plan_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_plan_type_id ON access_plans USING btree (plan_type_id);


--
-- Name: index_access_plans_on_terminated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_terminated_at ON access_plans USING btree (terminated_at);


--
-- Name: index_access_plans_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_plans_on_updated_by_id ON access_plans USING btree (updated_by_id);


--
-- Name: index_access_procedures_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_created_by_id ON access_procedures USING btree (created_by_id);


--
-- Name: index_access_procedures_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_patient_id ON access_procedures USING btree (patient_id);


--
-- Name: index_access_procedures_on_performed_by; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_performed_by ON access_procedures USING btree (performed_by);


--
-- Name: index_access_procedures_on_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_type_id ON access_procedures USING btree (type_id);


--
-- Name: index_access_procedures_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_procedures_on_updated_by_id ON access_procedures USING btree (updated_by_id);


--
-- Name: index_access_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_created_by_id ON access_profiles USING btree (created_by_id);


--
-- Name: index_access_profiles_on_decided_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_decided_by_id ON access_profiles USING btree (decided_by_id);


--
-- Name: index_access_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_patient_id ON access_profiles USING btree (patient_id);


--
-- Name: index_access_profiles_on_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_type_id ON access_profiles USING btree (type_id);


--
-- Name: index_access_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_access_profiles_on_updated_by_id ON access_profiles USING btree (updated_by_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON active_storage_blobs USING btree (key);


--
-- Name: index_addresses_on_addressable_type_and_addressable_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_addresses_on_addressable_type_and_addressable_id ON addresses USING btree (addressable_type, addressable_id);


--
-- Name: index_addresses_on_country_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_addresses_on_country_id ON addresses USING btree (country_id);


--
-- Name: index_admission_admissions_on_admitted_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_admitted_on ON admission_admissions USING btree (admitted_on);


--
-- Name: index_admission_admissions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_created_by_id ON admission_admissions USING btree (created_by_id);


--
-- Name: index_admission_admissions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_deleted_at ON admission_admissions USING btree (deleted_at);


--
-- Name: index_admission_admissions_on_discharged_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_discharged_on ON admission_admissions USING btree (discharged_on);


--
-- Name: index_admission_admissions_on_hospital_ward_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_hospital_ward_id ON admission_admissions USING btree (hospital_ward_id);


--
-- Name: index_admission_admissions_on_modality_at_admission_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_modality_at_admission_id ON admission_admissions USING btree (modality_at_admission_id);


--
-- Name: index_admission_admissions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_patient_id ON admission_admissions USING btree (patient_id);


--
-- Name: index_admission_admissions_on_summarised_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_summarised_by_id ON admission_admissions USING btree (summarised_by_id);


--
-- Name: index_admission_admissions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_admissions_on_updated_by_id ON admission_admissions USING btree (updated_by_id);


--
-- Name: index_admission_consult_sites_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consult_sites_on_name ON admission_consult_sites USING btree (name);


--
-- Name: index_admission_consults_on_consult_site_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_consult_site_id ON admission_consults USING btree (consult_site_id);


--
-- Name: index_admission_consults_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_created_by_id ON admission_consults USING btree (created_by_id);


--
-- Name: index_admission_consults_on_hospital_ward_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_hospital_ward_id ON admission_consults USING btree (hospital_ward_id);


--
-- Name: index_admission_consults_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_patient_id ON admission_consults USING btree (patient_id);


--
-- Name: index_admission_consults_on_seen_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_seen_by_id ON admission_consults USING btree (seen_by_id);


--
-- Name: index_admission_consults_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_consults_on_updated_by_id ON admission_consults USING btree (updated_by_id);


--
-- Name: index_admission_request_reasons_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_request_reasons_on_deleted_at ON admission_request_reasons USING btree (deleted_at);


--
-- Name: index_admission_requests_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_created_by_id ON admission_requests USING btree (created_by_id);


--
-- Name: index_admission_requests_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_deleted_at ON admission_requests USING btree (deleted_at);


--
-- Name: index_admission_requests_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_hospital_unit_id ON admission_requests USING btree (hospital_unit_id);


--
-- Name: index_admission_requests_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_patient_id ON admission_requests USING btree (patient_id);


--
-- Name: index_admission_requests_on_patient_id_and_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_admission_requests_on_patient_id_and_deleted_at ON admission_requests USING btree (patient_id, deleted_at);


--
-- Name: index_admission_requests_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_position ON admission_requests USING btree ("position");


--
-- Name: index_admission_requests_on_reason_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_reason_id ON admission_requests USING btree (reason_id);


--
-- Name: index_admission_requests_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_admission_requests_on_updated_by_id ON admission_requests USING btree (updated_by_id);


--
-- Name: index_clinic_appointments_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_clinic_id ON clinic_appointments USING btree (clinic_id);


--
-- Name: index_clinic_appointments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_patient_id ON clinic_appointments USING btree (patient_id);


--
-- Name: index_clinic_appointments_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_appointments_on_user_id ON clinic_appointments USING btree (user_id);


--
-- Name: index_clinic_clinics_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_clinics_on_user_id ON clinic_clinics USING btree (user_id);


--
-- Name: index_clinic_visits_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_clinic_id ON clinic_visits USING btree (clinic_id);


--
-- Name: index_clinic_visits_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_created_by_id ON clinic_visits USING btree (created_by_id);


--
-- Name: index_clinic_visits_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_patient_id ON clinic_visits USING btree (patient_id);


--
-- Name: index_clinic_visits_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinic_visits_on_updated_by_id ON clinic_visits USING btree (updated_by_id);


--
-- Name: index_clinical_allergies_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_created_by_id ON clinical_allergies USING btree (created_by_id);


--
-- Name: index_clinical_allergies_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_deleted_at ON clinical_allergies USING btree (deleted_at);


--
-- Name: index_clinical_allergies_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_patient_id ON clinical_allergies USING btree (patient_id);


--
-- Name: index_clinical_allergies_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_allergies_on_updated_by_id ON clinical_allergies USING btree (updated_by_id);


--
-- Name: index_clinical_body_compositions_on_assessor_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_assessor_id ON clinical_body_compositions USING btree (assessor_id);


--
-- Name: index_clinical_body_compositions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_created_by_id ON clinical_body_compositions USING btree (created_by_id);


--
-- Name: index_clinical_body_compositions_on_modality_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_modality_description_id ON clinical_body_compositions USING btree (modality_description_id);


--
-- Name: index_clinical_body_compositions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_patient_id ON clinical_body_compositions USING btree (patient_id);


--
-- Name: index_clinical_body_compositions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_body_compositions_on_updated_by_id ON clinical_body_compositions USING btree (updated_by_id);


--
-- Name: index_clinical_dry_weights_on_assessor_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_assessor_id ON clinical_dry_weights USING btree (assessor_id);


--
-- Name: index_clinical_dry_weights_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_created_by_id ON clinical_dry_weights USING btree (created_by_id);


--
-- Name: index_clinical_dry_weights_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_patient_id ON clinical_dry_weights USING btree (patient_id);


--
-- Name: index_clinical_dry_weights_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_dry_weights_on_updated_by_id ON clinical_dry_weights USING btree (updated_by_id);


--
-- Name: index_clinical_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_clinical_versions_on_item_type_and_item_id ON clinical_versions USING btree (item_type, item_id);


--
-- Name: index_directory_people_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_directory_people_on_created_by_id ON directory_people USING btree (created_by_id);


--
-- Name: index_directory_people_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_directory_people_on_updated_by_id ON directory_people USING btree (updated_by_id);


--
-- Name: index_drug_types_drugs_on_drug_id_and_drug_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_drug_types_drugs_on_drug_id_and_drug_type_id ON drug_types_drugs USING btree (drug_id, drug_type_id);


--
-- Name: index_drug_types_drugs_on_drug_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drug_types_drugs_on_drug_type_id ON drug_types_drugs USING btree (drug_type_id);


--
-- Name: index_drugs_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_drugs_on_deleted_at ON drugs USING btree (deleted_at);


--
-- Name: index_event_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_event_types_on_deleted_at ON event_types USING btree (deleted_at);


--
-- Name: index_event_types_on_slug; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_event_types_on_slug ON event_types USING btree (slug);


--
-- Name: index_events_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_created_by_id ON events USING btree (created_by_id);


--
-- Name: index_events_on_event_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_event_type_id ON events USING btree (event_type_id);


--
-- Name: index_events_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_patient_id ON events USING btree (patient_id);


--
-- Name: index_events_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_type ON events USING btree (type);


--
-- Name: index_events_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_events_on_updated_by_id ON events USING btree (updated_by_id);


--
-- Name: index_feed_file_types_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_file_types_on_name ON feed_file_types USING btree (name);


--
-- Name: index_feed_files_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_files_on_created_by_id ON feed_files USING btree (created_by_id);


--
-- Name: index_feed_files_on_file_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_files_on_file_type_id ON feed_files USING btree (file_type_id);


--
-- Name: index_feed_files_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_files_on_updated_by_id ON feed_files USING btree (updated_by_id);


--
-- Name: index_feed_messages_on_body_hash; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_feed_messages_on_body_hash ON feed_messages USING btree (body_hash);


--
-- Name: index_feed_messages_on_patient_identifier; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_feed_messages_on_patient_identifier ON feed_messages USING btree (patient_identifier);


--
-- Name: index_hd_cannulation_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_cannulation_types_on_deleted_at ON hd_cannulation_types USING btree (deleted_at);


--
-- Name: index_hd_dialysates_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_dialysates_on_deleted_at ON hd_dialysates USING btree (deleted_at);


--
-- Name: index_hd_diaries_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_created_by_id ON hd_diaries USING btree (created_by_id);


--
-- Name: index_hd_diaries_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_deleted_at ON hd_diaries USING btree (deleted_at);


--
-- Name: index_hd_diaries_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_hospital_unit_id ON hd_diaries USING btree (hospital_unit_id);


--
-- Name: index_hd_diaries_on_hospital_unit_id_and_week_number_and_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_diaries_on_hospital_unit_id_and_week_number_and_year ON hd_diaries USING btree (hospital_unit_id, week_number, year) WHERE (master = false);


--
-- Name: index_hd_diaries_on_master_diary_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_master_diary_id ON hd_diaries USING btree (master_diary_id);


--
-- Name: index_hd_diaries_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_type ON hd_diaries USING btree (type);


--
-- Name: index_hd_diaries_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_updated_by_id ON hd_diaries USING btree (updated_by_id);


--
-- Name: index_hd_diaries_on_week_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_week_number ON hd_diaries USING btree (week_number);


--
-- Name: index_hd_diaries_on_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diaries_on_year ON hd_diaries USING btree (year);


--
-- Name: index_hd_diary_slots_on_archived; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_archived ON hd_diary_slots USING btree (archived);


--
-- Name: index_hd_diary_slots_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_created_by_id ON hd_diary_slots USING btree (created_by_id);


--
-- Name: index_hd_diary_slots_on_day_of_week; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_day_of_week ON hd_diary_slots USING btree (day_of_week);


--
-- Name: index_hd_diary_slots_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_deleted_at ON hd_diary_slots USING btree (deleted_at);


--
-- Name: index_hd_diary_slots_on_diary_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_diary_id ON hd_diary_slots USING btree (diary_id);


--
-- Name: index_hd_diary_slots_on_diurnal_period_code_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_diurnal_period_code_id ON hd_diary_slots USING btree (diurnal_period_code_id);


--
-- Name: index_hd_diary_slots_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_patient_id ON hd_diary_slots USING btree (patient_id);


--
-- Name: index_hd_diary_slots_on_station_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_station_id ON hd_diary_slots USING btree (station_id);


--
-- Name: index_hd_diary_slots_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_diary_slots_on_updated_by_id ON hd_diary_slots USING btree (updated_by_id);


--
-- Name: index_hd_diurnal_period_codes_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_diurnal_period_codes_on_code ON hd_diurnal_period_codes USING btree (code);


--
-- Name: index_hd_patient_statistics_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_hospital_unit_id ON hd_patient_statistics USING btree (hospital_unit_id);


--
-- Name: index_hd_patient_statistics_on_month; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_month ON hd_patient_statistics USING btree (month);


--
-- Name: index_hd_patient_statistics_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_patient_id ON hd_patient_statistics USING btree (patient_id);


--
-- Name: index_hd_patient_statistics_on_patient_id_and_month_and_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_patient_statistics_on_patient_id_and_month_and_year ON hd_patient_statistics USING btree (patient_id, month, year);


--
-- Name: index_hd_patient_statistics_on_patient_id_and_rolling; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_patient_statistics_on_patient_id_and_rolling ON hd_patient_statistics USING btree (patient_id, rolling);


--
-- Name: index_hd_patient_statistics_on_rolling; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_rolling ON hd_patient_statistics USING btree (rolling);


--
-- Name: index_hd_patient_statistics_on_year; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_patient_statistics_on_year ON hd_patient_statistics USING btree (year);


--
-- Name: index_hd_preference_sets_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_created_by_id ON hd_preference_sets USING btree (created_by_id);


--
-- Name: index_hd_preference_sets_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_hospital_unit_id ON hd_preference_sets USING btree (hospital_unit_id);


--
-- Name: index_hd_preference_sets_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_patient_id ON hd_preference_sets USING btree (patient_id);


--
-- Name: index_hd_preference_sets_on_schedule_definition_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_schedule_definition_id ON hd_preference_sets USING btree (schedule_definition_id);


--
-- Name: index_hd_preference_sets_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_preference_sets_on_updated_by_id ON hd_preference_sets USING btree (updated_by_id);


--
-- Name: index_hd_prescription_administrations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_created_by_id ON hd_prescription_administrations USING btree (created_by_id);


--
-- Name: index_hd_prescription_administrations_on_hd_session_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_hd_session_id ON hd_prescription_administrations USING btree (hd_session_id);


--
-- Name: index_hd_prescription_administrations_on_prescription_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_prescription_id ON hd_prescription_administrations USING btree (prescription_id);


--
-- Name: index_hd_prescription_administrations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_prescription_administrations_on_updated_by_id ON hd_prescription_administrations USING btree (updated_by_id);


--
-- Name: index_hd_profiles_on_active_and_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_profiles_on_active_and_patient_id ON hd_profiles USING btree (active, patient_id);


--
-- Name: index_hd_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_created_by_id ON hd_profiles USING btree (created_by_id);


--
-- Name: index_hd_profiles_on_deactivated_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_deactivated_at ON hd_profiles USING btree (deactivated_at);


--
-- Name: index_hd_profiles_on_dialysate_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_dialysate_id ON hd_profiles USING btree (dialysate_id);


--
-- Name: index_hd_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_document ON hd_profiles USING gin (document);


--
-- Name: index_hd_profiles_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_hospital_unit_id ON hd_profiles USING btree (hospital_unit_id);


--
-- Name: index_hd_profiles_on_named_nurse_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_named_nurse_id ON hd_profiles USING btree (named_nurse_id);


--
-- Name: index_hd_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_patient_id ON hd_profiles USING btree (patient_id);


--
-- Name: index_hd_profiles_on_prescriber_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_prescriber_id ON hd_profiles USING btree (prescriber_id);


--
-- Name: index_hd_profiles_on_schedule_definition_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_schedule_definition_id ON hd_profiles USING btree (schedule_definition_id);


--
-- Name: index_hd_profiles_on_transport_decider_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_transport_decider_id ON hd_profiles USING btree (transport_decider_id);


--
-- Name: index_hd_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_profiles_on_updated_by_id ON hd_profiles USING btree (updated_by_id);


--
-- Name: index_hd_provider_units_on_hd_provider_id_and_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_provider_units_on_hd_provider_id_and_hospital_unit_id ON hd_provider_units USING btree (hd_provider_id, hospital_unit_id);


--
-- Name: index_hd_schedule_definitions_on_days; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_schedule_definitions_on_days ON hd_schedule_definitions USING gin (days);


--
-- Name: index_hd_schedule_definitions_on_diurnal_period_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_schedule_definitions_on_diurnal_period_id ON hd_schedule_definitions USING btree (diurnal_period_id);


--
-- Name: index_hd_sessions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_created_by_id ON hd_sessions USING btree (created_by_id);


--
-- Name: index_hd_sessions_on_dialysate_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_dialysate_id ON hd_sessions USING btree (dialysate_id);


--
-- Name: index_hd_sessions_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_document ON hd_sessions USING gin (document);


--
-- Name: index_hd_sessions_on_dry_weight_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_dry_weight_id ON hd_sessions USING btree (dry_weight_id);


--
-- Name: index_hd_sessions_on_external_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hd_sessions_on_external_id ON hd_sessions USING btree (external_id);


--
-- Name: index_hd_sessions_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_hospital_unit_id ON hd_sessions USING btree (hospital_unit_id);


--
-- Name: index_hd_sessions_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_id_and_type ON hd_sessions USING btree (id, type);


--
-- Name: index_hd_sessions_on_modality_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_modality_description_id ON hd_sessions USING btree (modality_description_id);


--
-- Name: index_hd_sessions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_patient_id ON hd_sessions USING btree (patient_id);


--
-- Name: index_hd_sessions_on_performed_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_performed_on ON hd_sessions USING btree (performed_on);


--
-- Name: index_hd_sessions_on_profile_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_profile_id ON hd_sessions USING btree (profile_id);


--
-- Name: index_hd_sessions_on_signed_off_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_off_at ON hd_sessions USING btree (signed_off_at);


--
-- Name: index_hd_sessions_on_signed_off_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_off_by_id ON hd_sessions USING btree (signed_off_by_id);


--
-- Name: index_hd_sessions_on_signed_on_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_signed_on_by_id ON hd_sessions USING btree (signed_on_by_id);


--
-- Name: index_hd_sessions_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_type ON hd_sessions USING btree (type);


--
-- Name: index_hd_sessions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_updated_by_id ON hd_sessions USING btree (updated_by_id);


--
-- Name: index_hd_sessions_on_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_sessions_on_uuid ON hd_sessions USING btree (uuid);


--
-- Name: index_hd_station_locations_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_station_locations_on_name ON hd_station_locations USING btree (name);


--
-- Name: index_hd_stations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_created_by_id ON hd_stations USING btree (created_by_id);


--
-- Name: index_hd_stations_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_deleted_at ON hd_stations USING btree (deleted_at);


--
-- Name: index_hd_stations_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_hospital_unit_id ON hd_stations USING btree (hospital_unit_id);


--
-- Name: index_hd_stations_on_location_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_location_id ON hd_stations USING btree (location_id);


--
-- Name: index_hd_stations_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_position ON hd_stations USING btree ("position");


--
-- Name: index_hd_stations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_stations_on_updated_by_id ON hd_stations USING btree (updated_by_id);


--
-- Name: index_hd_transmission_logs_on_session_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hd_transmission_logs_on_session_id ON hd_transmission_logs USING btree (session_id);


--
-- Name: index_hospital_centres_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_centres_on_code ON hospital_centres USING btree (code);


--
-- Name: index_hospital_units_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_units_on_hospital_centre_id ON hospital_units USING btree (hospital_centre_id);


--
-- Name: index_hospital_wards_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_wards_on_code ON hospital_wards USING btree (code);


--
-- Name: index_hospital_wards_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_hospital_wards_on_hospital_unit_id ON hospital_wards USING btree (hospital_unit_id);


--
-- Name: index_hospital_wards_on_name_and_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_hospital_wards_on_name_and_hospital_unit_id ON hospital_wards USING btree (name, hospital_unit_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: index_letter_archives_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_archives_on_created_by_id ON letter_archives USING btree (created_by_id);


--
-- Name: index_letter_archives_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_archives_on_letter_id ON letter_archives USING btree (letter_id);


--
-- Name: index_letter_archives_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_archives_on_updated_by_id ON letter_archives USING btree (updated_by_id);


--
-- Name: index_letter_contact_descriptions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_name ON letter_contact_descriptions USING btree (name);


--
-- Name: index_letter_contact_descriptions_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_position ON letter_contact_descriptions USING btree ("position");


--
-- Name: index_letter_contact_descriptions_on_system_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contact_descriptions_on_system_code ON letter_contact_descriptions USING btree (system_code);


--
-- Name: index_letter_contacts_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_contacts_on_description_id ON letter_contacts USING btree (description_id);


--
-- Name: index_letter_contacts_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_contacts_on_patient_id ON letter_contacts USING btree (patient_id);


--
-- Name: index_letter_contacts_on_person_id_and_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_letter_contacts_on_person_id_and_patient_id ON letter_contacts USING btree (person_id, patient_id);


--
-- Name: index_letter_electronic_receipts_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_electronic_receipts_on_letter_id ON letter_electronic_receipts USING btree (letter_id);


--
-- Name: index_letter_electronic_receipts_on_read_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_electronic_receipts_on_read_at ON letter_electronic_receipts USING btree (read_at);


--
-- Name: index_letter_electronic_receipts_on_recipient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_electronic_receipts_on_recipient_id ON letter_electronic_receipts USING btree (recipient_id);


--
-- Name: index_letter_letters_on_approved_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_approved_at ON letter_letters USING btree (approved_at);


--
-- Name: index_letter_letters_on_approved_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_approved_by_id ON letter_letters USING btree (approved_by_id);


--
-- Name: index_letter_letters_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_author_id ON letter_letters USING btree (author_id);


--
-- Name: index_letter_letters_on_completed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_completed_at ON letter_letters USING btree (completed_at);


--
-- Name: index_letter_letters_on_completed_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_completed_by_id ON letter_letters USING btree (completed_by_id);


--
-- Name: index_letter_letters_on_created_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_created_at ON letter_letters USING btree (created_at);


--
-- Name: index_letter_letters_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_created_by_id ON letter_letters USING btree (created_by_id);


--
-- Name: index_letter_letters_on_event_type_and_event_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_event_type_and_event_id ON letter_letters USING btree (event_type, event_id);


--
-- Name: index_letter_letters_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_id_and_type ON letter_letters USING btree (id, type);


--
-- Name: index_letter_letters_on_letterhead_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_letterhead_id ON letter_letters USING btree (letterhead_id);


--
-- Name: index_letter_letters_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_patient_id ON letter_letters USING btree (patient_id);


--
-- Name: index_letter_letters_on_submitted_for_approval_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_submitted_for_approval_at ON letter_letters USING btree (submitted_for_approval_at);


--
-- Name: index_letter_letters_on_submitted_for_approval_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_submitted_for_approval_by_id ON letter_letters USING btree (submitted_for_approval_by_id);


--
-- Name: index_letter_letters_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_updated_by_id ON letter_letters USING btree (updated_by_id);


--
-- Name: index_letter_letters_on_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_letters_on_uuid ON letter_letters USING btree (uuid);


--
-- Name: index_letter_recipients_on_addressee_type_and_addressee_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_addressee_type_and_addressee_id ON letter_recipients USING btree (addressee_type, addressee_id);


--
-- Name: index_letter_recipients_on_emailed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_emailed_at ON letter_recipients USING btree (emailed_at);


--
-- Name: index_letter_recipients_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_letter_id ON letter_recipients USING btree (letter_id);


--
-- Name: index_letter_recipients_on_printed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_recipients_on_printed_at ON letter_recipients USING btree (printed_at);


--
-- Name: index_letter_signatures_on_letter_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_signatures_on_letter_id ON letter_signatures USING btree (letter_id);


--
-- Name: index_letter_signatures_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_letter_signatures_on_user_id ON letter_signatures USING btree (user_id);


--
-- Name: index_low_clearance_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_created_by_id ON low_clearance_profiles USING btree (created_by_id);


--
-- Name: index_low_clearance_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_document ON low_clearance_profiles USING gin (document);


--
-- Name: index_low_clearance_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_low_clearance_profiles_on_patient_id ON low_clearance_profiles USING btree (patient_id);


--
-- Name: index_low_clearance_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_profiles_on_updated_by_id ON low_clearance_profiles USING btree (updated_by_id);


--
-- Name: index_low_clearance_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_low_clearance_versions_on_item_type_and_item_id ON low_clearance_versions USING btree (item_type, item_id);


--
-- Name: index_medication_prescription_terminations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_created_by_id ON medication_prescription_terminations USING btree (created_by_id);


--
-- Name: index_medication_prescription_terminations_on_prescription_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_prescription_id ON medication_prescription_terminations USING btree (prescription_id);


--
-- Name: index_medication_prescription_terminations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_terminations_on_updated_by_id ON medication_prescription_terminations USING btree (updated_by_id);


--
-- Name: index_medication_prescription_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescription_versions_on_item_type_and_item_id ON medication_prescription_versions USING btree (item_type, item_id);


--
-- Name: index_medication_prescriptions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_created_by_id ON medication_prescriptions USING btree (created_by_id);


--
-- Name: index_medication_prescriptions_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_drug_id ON medication_prescriptions USING btree (drug_id);


--
-- Name: index_medication_prescriptions_on_drug_id_and_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_drug_id_and_patient_id ON medication_prescriptions USING btree (drug_id, patient_id);


--
-- Name: index_medication_prescriptions_on_medication_route_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_medication_route_id ON medication_prescriptions USING btree (medication_route_id);


--
-- Name: index_medication_prescriptions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_patient_id ON medication_prescriptions USING btree (patient_id);


--
-- Name: index_medication_prescriptions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_medication_prescriptions_on_updated_by_id ON medication_prescriptions USING btree (updated_by_id);


--
-- Name: index_messaging_messages_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_author_id ON messaging_messages USING btree (author_id);


--
-- Name: index_messaging_messages_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_patient_id ON messaging_messages USING btree (patient_id);


--
-- Name: index_messaging_messages_on_replying_to_message_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_replying_to_message_id ON messaging_messages USING btree (replying_to_message_id);


--
-- Name: index_messaging_messages_on_subject; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_subject ON messaging_messages USING btree (subject);


--
-- Name: index_messaging_messages_on_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_messages_on_type ON messaging_messages USING btree (type);


--
-- Name: index_messaging_receipts_on_message_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_receipts_on_message_id ON messaging_receipts USING btree (message_id);


--
-- Name: index_messaging_receipts_on_read_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_receipts_on_read_at ON messaging_receipts USING btree (read_at);


--
-- Name: index_messaging_receipts_on_recipient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_messaging_receipts_on_recipient_id ON messaging_receipts USING btree (recipient_id);


--
-- Name: index_modality_descriptions_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_deleted_at ON modality_descriptions USING btree (deleted_at);


--
-- Name: index_modality_descriptions_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_id_and_type ON modality_descriptions USING btree (id, type);


--
-- Name: index_modality_descriptions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_descriptions_on_name ON modality_descriptions USING btree (name);


--
-- Name: index_modality_modalities_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_created_by_id ON modality_modalities USING btree (created_by_id);


--
-- Name: index_modality_modalities_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_description_id ON modality_modalities USING btree (description_id);


--
-- Name: index_modality_modalities_on_ended_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_ended_on ON modality_modalities USING btree (ended_on);


--
-- Name: index_modality_modalities_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_patient_id ON modality_modalities USING btree (patient_id);


--
-- Name: index_modality_modalities_on_patient_id_and_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_patient_id_and_description_id ON modality_modalities USING btree (patient_id, description_id);


--
-- Name: index_modality_modalities_on_reason_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_reason_id ON modality_modalities USING btree (reason_id);


--
-- Name: index_modality_modalities_on_state; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_state ON modality_modalities USING btree (state);


--
-- Name: index_modality_modalities_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_modalities_on_updated_by_id ON modality_modalities USING btree (updated_by_id);


--
-- Name: index_modality_reasons_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_modality_reasons_on_id_and_type ON modality_reasons USING btree (id, type);


--
-- Name: index_pathology_current_observation_sets_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_current_observation_sets_on_patient_id ON pathology_current_observation_sets USING btree (patient_id);


--
-- Name: index_pathology_current_observation_sets_on_values; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_current_observation_sets_on_values ON pathology_current_observation_sets USING gin ("values");


--
-- Name: index_pathology_measurement_units_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_measurement_units_on_name ON pathology_measurement_units USING btree (name);


--
-- Name: index_pathology_observation_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_observation_descriptions_on_code ON pathology_observation_descriptions USING btree (code);


--
-- Name: index_pathology_observation_descriptions_on_measurement_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_descriptions_on_measurement_unit_id ON pathology_observation_descriptions USING btree (measurement_unit_id);


--
-- Name: index_pathology_observation_requests_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_description_id ON pathology_observation_requests USING btree (description_id);


--
-- Name: index_pathology_observation_requests_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_patient_id ON pathology_observation_requests USING btree (patient_id);


--
-- Name: index_pathology_observation_requests_on_requested_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_requested_at ON pathology_observation_requests USING btree (requested_at);


--
-- Name: index_pathology_observation_requests_on_requestor_order_number; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observation_requests_on_requestor_order_number ON pathology_observation_requests USING btree (requestor_order_number);


--
-- Name: index_pathology_observations_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observations_on_description_id ON pathology_observations USING btree (description_id);


--
-- Name: index_pathology_observations_on_observed_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observations_on_observed_at ON pathology_observations USING btree (observed_at);


--
-- Name: index_pathology_observations_on_request_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_observations_on_request_id ON pathology_observations USING btree (request_id);


--
-- Name: index_pathology_request_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_pathology_request_descriptions_on_code ON pathology_request_descriptions USING btree (code);


--
-- Name: index_pathology_request_descriptions_on_lab_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_request_descriptions_on_lab_id ON pathology_request_descriptions USING btree (lab_id);


--
-- Name: index_pathology_requests_drug_categories_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_drug_categories_on_name ON pathology_requests_drug_categories USING btree (name);


--
-- Name: index_pathology_requests_drugs_drug_categories_on_drug_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_drugs_drug_categories_on_drug_id ON pathology_requests_drugs_drug_categories USING btree (drug_id);


--
-- Name: index_pathology_requests_global_rule_sets_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_global_rule_sets_on_clinic_id ON pathology_requests_global_rule_sets USING btree (clinic_id);


--
-- Name: index_pathology_requests_global_rules_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_global_rules_on_id_and_type ON pathology_requests_global_rules USING btree (id, type);


--
-- Name: index_pathology_requests_patient_rules_on_lab_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_patient_rules_on_lab_id ON pathology_requests_patient_rules USING btree (lab_id);


--
-- Name: index_pathology_requests_patient_rules_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_patient_rules_on_patient_id ON pathology_requests_patient_rules USING btree (patient_id);


--
-- Name: index_pathology_requests_patient_rules_requests_on_request_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_patient_rules_requests_on_request_id ON pathology_requests_patient_rules_requests USING btree (request_id);


--
-- Name: index_pathology_requests_requests_on_clinic_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_clinic_id ON pathology_requests_requests USING btree (clinic_id);


--
-- Name: index_pathology_requests_requests_on_consultant_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_consultant_id ON pathology_requests_requests USING btree (consultant_id);


--
-- Name: index_pathology_requests_requests_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_created_by_id ON pathology_requests_requests USING btree (created_by_id);


--
-- Name: index_pathology_requests_requests_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_patient_id ON pathology_requests_requests USING btree (patient_id);


--
-- Name: index_pathology_requests_requests_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pathology_requests_requests_on_updated_by_id ON pathology_requests_requests USING btree (updated_by_id);


--
-- Name: index_patient_alerts_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_created_by_id ON patient_alerts USING btree (created_by_id);


--
-- Name: index_patient_alerts_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_deleted_at ON patient_alerts USING btree (deleted_at);


--
-- Name: index_patient_alerts_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_patient_id ON patient_alerts USING btree (patient_id);


--
-- Name: index_patient_alerts_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_alerts_on_updated_by_id ON patient_alerts USING btree (updated_by_id);


--
-- Name: index_patient_bookmarks_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_deleted_at ON patient_bookmarks USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: index_patient_bookmarks_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_patient_id ON patient_bookmarks USING btree (patient_id);


--
-- Name: index_patient_bookmarks_on_urgent; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_urgent ON patient_bookmarks USING btree (urgent);


--
-- Name: index_patient_bookmarks_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_bookmarks_on_user_id ON patient_bookmarks USING btree (user_id);


--
-- Name: index_patient_ethnicities_on_cfh_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_ethnicities_on_cfh_name ON patient_ethnicities USING btree (cfh_name);


--
-- Name: index_patient_languages_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_languages_on_code ON patient_languages USING btree (code);


--
-- Name: index_patient_practice_memberships_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_practice_memberships_on_deleted_at ON patient_practice_memberships USING btree (deleted_at);


--
-- Name: index_patient_practice_memberships_on_practice_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_practice_memberships_on_practice_id ON patient_practice_memberships USING btree (practice_id);


--
-- Name: index_patient_practice_memberships_on_primary_care_physician_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_practice_memberships_on_primary_care_physician_id ON patient_practice_memberships USING btree (primary_care_physician_id);


--
-- Name: index_patient_practices_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_practices_on_code ON patient_practices USING btree (code);


--
-- Name: index_patient_practices_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_practices_on_deleted_at ON patient_practices USING btree (deleted_at);


--
-- Name: index_patient_primary_care_physicians_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_primary_care_physicians_on_code ON patient_primary_care_physicians USING btree (code);


--
-- Name: index_patient_primary_care_physicians_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_primary_care_physicians_on_deleted_at ON patient_primary_care_physicians USING btree (deleted_at);


--
-- Name: index_patient_primary_care_physicians_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_primary_care_physicians_on_name ON patient_primary_care_physicians USING btree (name);


--
-- Name: index_patient_worries_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worries_on_created_by_id ON patient_worries USING btree (created_by_id);


--
-- Name: index_patient_worries_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patient_worries_on_patient_id ON patient_worries USING btree (patient_id);


--
-- Name: index_patient_worries_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patient_worries_on_updated_by_id ON patient_worries USING btree (updated_by_id);


--
-- Name: index_patients_on_country_of_birth_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_country_of_birth_id ON patients USING btree (country_of_birth_id);


--
-- Name: index_patients_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_created_by_id ON patients USING btree (created_by_id);


--
-- Name: index_patients_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_document ON patients USING gin (document);


--
-- Name: index_patients_on_ethnicity_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_ethnicity_id ON patients USING btree (ethnicity_id);


--
-- Name: index_patients_on_external_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_external_patient_id ON patients USING btree (external_patient_id);


--
-- Name: index_patients_on_first_cause_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_first_cause_id ON patients USING btree (first_cause_id);


--
-- Name: index_patients_on_language_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_language_id ON patients USING btree (language_id);


--
-- Name: index_patients_on_legacy_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_legacy_patient_id ON patients USING btree (legacy_patient_id);


--
-- Name: index_patients_on_local_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_local_patient_id ON patients USING btree (local_patient_id);


--
-- Name: index_patients_on_local_patient_id_2; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_local_patient_id_2 ON patients USING btree (local_patient_id_2);


--
-- Name: index_patients_on_local_patient_id_3; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_local_patient_id_3 ON patients USING btree (local_patient_id_3);


--
-- Name: index_patients_on_local_patient_id_4; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_local_patient_id_4 ON patients USING btree (local_patient_id_4);


--
-- Name: index_patients_on_local_patient_id_5; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_local_patient_id_5 ON patients USING btree (local_patient_id_5);


--
-- Name: index_patients_on_practice_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_practice_id ON patients USING btree (practice_id);


--
-- Name: index_patients_on_primary_care_physician_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_primary_care_physician_id ON patients USING btree (primary_care_physician_id);


--
-- Name: index_patients_on_religion_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_religion_id ON patients USING btree (religion_id);


--
-- Name: index_patients_on_second_cause_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_second_cause_id ON patients USING btree (second_cause_id);


--
-- Name: index_patients_on_secure_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_patients_on_secure_id ON patients USING btree (secure_id);


--
-- Name: index_patients_on_send_to_renalreg; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_send_to_renalreg ON patients USING btree (send_to_renalreg);


--
-- Name: index_patients_on_send_to_rpv; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_send_to_rpv ON patients USING btree (send_to_rpv);


--
-- Name: index_patients_on_sent_to_ukrdc_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_sent_to_ukrdc_at ON patients USING btree (sent_to_ukrdc_at);


--
-- Name: index_patients_on_ukrdc_external_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_ukrdc_external_id ON patients USING btree (ukrdc_external_id);


--
-- Name: index_patients_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_patients_on_updated_by_id ON patients USING btree (updated_by_id);


--
-- Name: index_pd_assessments_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_assessments_on_created_by_id ON pd_assessments USING btree (created_by_id);


--
-- Name: index_pd_assessments_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_assessments_on_patient_id ON pd_assessments USING btree (patient_id);


--
-- Name: index_pd_assessments_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_assessments_on_updated_by_id ON pd_assessments USING btree (updated_by_id);


--
-- Name: index_pd_bag_types_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_bag_types_on_deleted_at ON pd_bag_types USING btree (deleted_at);


--
-- Name: index_pd_exit_site_infections_on_clinical_presentation; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_exit_site_infections_on_clinical_presentation ON pd_exit_site_infections USING gin (clinical_presentation);


--
-- Name: index_pd_exit_site_infections_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_exit_site_infections_on_patient_id ON pd_exit_site_infections USING btree (patient_id);


--
-- Name: index_pd_peritonitis_episode_types_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episode_types_description_id ON pd_peritonitis_episode_types USING btree (peritonitis_episode_type_description_id);


--
-- Name: index_pd_peritonitis_episodes_on_episode_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_episode_type_id ON pd_peritonitis_episodes USING btree (episode_type_id);


--
-- Name: index_pd_peritonitis_episodes_on_fluid_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_fluid_description_id ON pd_peritonitis_episodes USING btree (fluid_description_id);


--
-- Name: index_pd_peritonitis_episodes_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_peritonitis_episodes_on_patient_id ON pd_peritonitis_episodes USING btree (patient_id);


--
-- Name: index_pd_pet_adequacy_results_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_adequacy_results_on_created_by_id ON pd_pet_adequacy_results USING btree (created_by_id);


--
-- Name: index_pd_pet_adequacy_results_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_adequacy_results_on_patient_id ON pd_pet_adequacy_results USING btree (patient_id);


--
-- Name: index_pd_pet_adequacy_results_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_pet_adequacy_results_on_updated_by_id ON pd_pet_adequacy_results USING btree (updated_by_id);


--
-- Name: index_pd_regime_bags_on_bag_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_bags_on_bag_type_id ON pd_regime_bags USING btree (bag_type_id);


--
-- Name: index_pd_regime_bags_on_regime_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_bags_on_regime_id ON pd_regime_bags USING btree (regime_id);


--
-- Name: index_pd_regime_terminations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_terminations_on_created_by_id ON pd_regime_terminations USING btree (created_by_id);


--
-- Name: index_pd_regime_terminations_on_regime_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_terminations_on_regime_id ON pd_regime_terminations USING btree (regime_id);


--
-- Name: index_pd_regime_terminations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regime_terminations_on_updated_by_id ON pd_regime_terminations USING btree (updated_by_id);


--
-- Name: index_pd_regimes_on_id_and_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_id_and_type ON pd_regimes USING btree (id, type);


--
-- Name: index_pd_regimes_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_patient_id ON pd_regimes USING btree (patient_id);


--
-- Name: index_pd_regimes_on_system_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_regimes_on_system_id ON pd_regimes USING btree (system_id);


--
-- Name: index_pd_systems_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_systems_on_deleted_at ON pd_systems USING btree (deleted_at);


--
-- Name: index_pd_systems_on_pd_type; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_systems_on_pd_type ON pd_systems USING btree (pd_type);


--
-- Name: index_pd_training_sessions_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_created_by_id ON pd_training_sessions USING btree (created_by_id);


--
-- Name: index_pd_training_sessions_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_patient_id ON pd_training_sessions USING btree (patient_id);


--
-- Name: index_pd_training_sessions_on_training_site_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_training_site_id ON pd_training_sessions USING btree (training_site_id);


--
-- Name: index_pd_training_sessions_on_training_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_training_type_id ON pd_training_sessions USING btree (training_type_id);


--
-- Name: index_pd_training_sessions_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_pd_training_sessions_on_updated_by_id ON pd_training_sessions USING btree (updated_by_id);


--
-- Name: index_problem_notes_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_notes_on_created_by_id ON problem_notes USING btree (created_by_id);


--
-- Name: index_problem_notes_on_problem_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_notes_on_problem_id ON problem_notes USING btree (problem_id);


--
-- Name: index_problem_notes_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_notes_on_updated_by_id ON problem_notes USING btree (updated_by_id);


--
-- Name: index_problem_problems_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_created_by_id ON problem_problems USING btree (created_by_id);


--
-- Name: index_problem_problems_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_deleted_at ON problem_problems USING btree (deleted_at);


--
-- Name: index_problem_problems_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_patient_id ON problem_problems USING btree (patient_id);


--
-- Name: index_problem_problems_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_position ON problem_problems USING btree ("position");


--
-- Name: index_problem_problems_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_problems_on_updated_by_id ON problem_problems USING btree (updated_by_id);


--
-- Name: index_problem_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_problem_versions_on_item_type_and_item_id ON problem_versions USING btree (item_type, item_id);


--
-- Name: index_renal_aki_alert_actions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alert_actions_on_name ON renal_aki_alert_actions USING btree (name);


--
-- Name: index_renal_aki_alerts_on_action; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_action ON renal_aki_alerts USING btree (action);


--
-- Name: index_renal_aki_alerts_on_action_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_action_id ON renal_aki_alerts USING btree (action_id);


--
-- Name: index_renal_aki_alerts_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_created_by_id ON renal_aki_alerts USING btree (created_by_id);


--
-- Name: index_renal_aki_alerts_on_hospital_ward_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_hospital_ward_id ON renal_aki_alerts USING btree (hospital_ward_id);


--
-- Name: index_renal_aki_alerts_on_hotlist; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_hotlist ON renal_aki_alerts USING btree (hotlist);


--
-- Name: index_renal_aki_alerts_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_patient_id ON renal_aki_alerts USING btree (patient_id);


--
-- Name: index_renal_aki_alerts_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_aki_alerts_on_updated_by_id ON renal_aki_alerts USING btree (updated_by_id);


--
-- Name: index_renal_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_profiles_on_document ON renal_profiles USING gin (document);


--
-- Name: index_renal_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_profiles_on_patient_id ON renal_profiles USING btree (patient_id);


--
-- Name: index_renal_profiles_on_prd_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_profiles_on_prd_description_id ON renal_profiles USING btree (prd_description_id);


--
-- Name: index_renal_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_renal_versions_on_item_type_and_item_id ON renal_versions USING btree (item_type, item_id);


--
-- Name: index_renalware.hd_provider_units_on_hd_provider_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_provider_units_on_hd_provider_id" ON hd_provider_units USING btree (hd_provider_id);


--
-- Name: index_renalware.hd_provider_units_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_provider_units_on_hospital_unit_id" ON hd_provider_units USING btree (hospital_unit_id);


--
-- Name: index_renalware.hd_provider_units_on_providers_reference; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_provider_units_on_providers_reference" ON hd_provider_units USING btree (providers_reference);


--
-- Name: index_renalware.hd_transmission_logs_on_direction; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_direction" ON hd_transmission_logs USING btree (direction);


--
-- Name: index_renalware.hd_transmission_logs_on_format; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_format" ON hd_transmission_logs USING btree (format);


--
-- Name: index_renalware.hd_transmission_logs_on_hd_provider_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_hd_provider_unit_id" ON hd_transmission_logs USING btree (hd_provider_unit_id);


--
-- Name: index_renalware.hd_transmission_logs_on_parent_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_parent_id" ON hd_transmission_logs USING btree (parent_id);


--
-- Name: index_renalware.hd_transmission_logs_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_patient_id" ON hd_transmission_logs USING btree (patient_id);


--
-- Name: index_renalware.hd_transmission_logs_on_result; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_result" ON hd_transmission_logs USING gin (result);


--
-- Name: index_renalware.hd_transmission_logs_on_status; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_status" ON hd_transmission_logs USING btree (status);


--
-- Name: index_renalware.hd_transmission_logs_on_transmitted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX "index_renalware.hd_transmission_logs_on_transmitted_at" ON hd_transmission_logs USING btree (transmitted_at);


--
-- Name: index_reporting_hd_blood_pressures_audit_on_hospital_unit_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_reporting_hd_blood_pressures_audit_on_hospital_unit_name ON reporting_hd_blood_pressures_audit USING btree (hospital_unit_name);


--
-- Name: index_research_studies_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_research_studies_on_code ON research_studies USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: index_research_studies_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_created_by_id ON research_studies USING btree (created_by_id);


--
-- Name: index_research_studies_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_deleted_at ON research_studies USING btree (deleted_at);


--
-- Name: index_research_studies_on_description; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_description ON research_studies USING btree (description);


--
-- Name: index_research_studies_on_leader; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_leader ON research_studies USING btree (leader);


--
-- Name: index_research_studies_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_studies_on_updated_by_id ON research_studies USING btree (updated_by_id);


--
-- Name: index_research_study_participations_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_study_participations_on_created_by_id ON research_study_participations USING btree (created_by_id);


--
-- Name: index_research_study_participations_on_deleted_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_study_participations_on_deleted_at ON research_study_participations USING btree (deleted_at);


--
-- Name: index_research_study_participations_on_external_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_research_study_participations_on_external_id ON research_study_participations USING btree (external_id);


--
-- Name: index_research_study_participations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_study_participations_on_patient_id ON research_study_participations USING btree (patient_id);


--
-- Name: index_research_study_participations_on_study_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_study_participations_on_study_id ON research_study_participations USING btree (study_id);


--
-- Name: index_research_study_participations_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_research_study_participations_on_updated_by_id ON research_study_participations USING btree (updated_by_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_roles_users_on_role_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_roles_users_on_role_id ON roles_users USING btree (role_id);


--
-- Name: index_roles_users_on_user_id_and_role_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_roles_users_on_user_id_and_role_id ON roles_users USING btree (user_id, role_id);


--
-- Name: index_snippets_snippets_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_snippets_snippets_on_author_id ON snippets_snippets USING btree (author_id);


--
-- Name: index_snippets_snippets_on_title; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_snippets_snippets_on_title ON snippets_snippets USING btree (title);


--
-- Name: index_system_countries_on_alpha2; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_countries_on_alpha2 ON system_countries USING btree (alpha2);


--
-- Name: index_system_countries_on_alpha3; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_countries_on_alpha3 ON system_countries USING btree (alpha3);


--
-- Name: index_system_countries_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_countries_on_name ON system_countries USING btree (name);


--
-- Name: index_system_countries_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_countries_on_position ON system_countries USING btree ("position");


--
-- Name: index_system_events_on_name_and_time; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_name_and_time ON system_events USING btree (name, "time");


--
-- Name: index_system_events_on_properties_jsonb_path_ops; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_properties_jsonb_path_ops ON system_events USING gin (properties jsonb_path_ops);


--
-- Name: index_system_events_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_user_id ON system_events USING btree (user_id);


--
-- Name: index_system_events_on_visit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_events_on_visit_id ON system_events USING btree (visit_id);


--
-- Name: index_system_templates_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_templates_on_name ON system_templates USING btree (name);


--
-- Name: index_system_user_feedback_on_author_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_user_feedback_on_author_id ON system_user_feedback USING btree (author_id);


--
-- Name: index_system_user_feedback_on_category; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_user_feedback_on_category ON system_user_feedback USING btree (category);


--
-- Name: index_system_visits_on_user_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_system_visits_on_user_id ON system_visits USING btree (user_id);


--
-- Name: index_system_visits_on_visit_token; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_system_visits_on_visit_token ON system_visits USING btree (visit_token);


--
-- Name: index_transplant_donations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donations_on_patient_id ON transplant_donations USING btree (patient_id);


--
-- Name: index_transplant_donations_on_recipient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donations_on_recipient_id ON transplant_donations USING btree (recipient_id);


--
-- Name: index_transplant_donor_followups_on_operation_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_followups_on_operation_id ON transplant_donor_followups USING btree (operation_id);


--
-- Name: index_transplant_donor_operations_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_operations_on_document ON transplant_donor_operations USING gin (document);


--
-- Name: index_transplant_donor_operations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_operations_on_patient_id ON transplant_donor_operations USING btree (patient_id);


--
-- Name: index_transplant_donor_stage_positions_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_donor_stage_positions_on_name ON transplant_donor_stage_positions USING btree (name);


--
-- Name: index_transplant_donor_stage_positions_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stage_positions_on_position ON transplant_donor_stage_positions USING btree ("position");


--
-- Name: index_transplant_donor_stage_statuses_on_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_donor_stage_statuses_on_name ON transplant_donor_stage_statuses USING btree (name);


--
-- Name: index_transplant_donor_stage_statuses_on_position; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stage_statuses_on_position ON transplant_donor_stage_statuses USING btree ("position");


--
-- Name: index_transplant_donor_stages_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stages_on_created_by_id ON transplant_donor_stages USING btree (created_by_id);


--
-- Name: index_transplant_donor_stages_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stages_on_patient_id ON transplant_donor_stages USING btree (patient_id);


--
-- Name: index_transplant_donor_stages_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_stages_on_updated_by_id ON transplant_donor_stages USING btree (updated_by_id);


--
-- Name: index_transplant_donor_workups_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_workups_on_document ON transplant_donor_workups USING gin (document);


--
-- Name: index_transplant_donor_workups_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_donor_workups_on_patient_id ON transplant_donor_workups USING btree (patient_id);


--
-- Name: index_transplant_failure_cause_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_transplant_failure_cause_descriptions_on_code ON transplant_failure_cause_descriptions USING btree (code);


--
-- Name: index_transplant_failure_cause_descriptions_on_group_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_failure_cause_descriptions_on_group_id ON transplant_failure_cause_descriptions USING btree (group_id);


--
-- Name: index_transplant_recipient_followups_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_followups_on_document ON transplant_recipient_followups USING gin (document);


--
-- Name: index_transplant_recipient_followups_on_operation_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_followups_on_operation_id ON transplant_recipient_followups USING btree (operation_id);


--
-- Name: index_transplant_recipient_operations_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_document ON transplant_recipient_operations USING gin (document);


--
-- Name: index_transplant_recipient_operations_on_hospital_centre_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_hospital_centre_id ON transplant_recipient_operations USING btree (hospital_centre_id);


--
-- Name: index_transplant_recipient_operations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_operations_on_patient_id ON transplant_recipient_operations USING btree (patient_id);


--
-- Name: index_transplant_recipient_workups_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_created_by_id ON transplant_recipient_workups USING btree (created_by_id);


--
-- Name: index_transplant_recipient_workups_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_document ON transplant_recipient_workups USING gin (document);


--
-- Name: index_transplant_recipient_workups_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_patient_id ON transplant_recipient_workups USING btree (patient_id);


--
-- Name: index_transplant_recipient_workups_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_recipient_workups_on_updated_by_id ON transplant_recipient_workups USING btree (updated_by_id);


--
-- Name: index_transplant_registration_status_descriptions_on_code; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_status_descriptions_on_code ON transplant_registration_status_descriptions USING btree (code);


--
-- Name: index_transplant_registration_statuses_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_created_by_id ON transplant_registration_statuses USING btree (created_by_id);


--
-- Name: index_transplant_registration_statuses_on_description_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_description_id ON transplant_registration_statuses USING btree (description_id);


--
-- Name: index_transplant_registration_statuses_on_registration_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_registration_id ON transplant_registration_statuses USING btree (registration_id);


--
-- Name: index_transplant_registration_statuses_on_started_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_started_on ON transplant_registration_statuses USING btree (started_on);


--
-- Name: index_transplant_registration_statuses_on_terminated_on; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_terminated_on ON transplant_registration_statuses USING btree (terminated_on);


--
-- Name: index_transplant_registration_statuses_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registration_statuses_on_updated_by_id ON transplant_registration_statuses USING btree (updated_by_id);


--
-- Name: index_transplant_registrations_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registrations_on_document ON transplant_registrations USING gin (document);


--
-- Name: index_transplant_registrations_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_transplant_registrations_on_patient_id ON transplant_registrations USING btree (patient_id);


--
-- Name: index_ukrdc_transmission_logs_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_transmission_logs_on_patient_id ON ukrdc_transmission_logs USING btree (patient_id);


--
-- Name: index_ukrdc_transmission_logs_on_request_uuid; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_ukrdc_transmission_logs_on_request_uuid ON ukrdc_transmission_logs USING btree (request_uuid);


--
-- Name: index_users_on_approved; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_approved ON users USING btree (approved);


--
-- Name: index_users_on_email; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_expired_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_expired_at ON users USING btree (expired_at);


--
-- Name: index_users_on_family_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_family_name ON users USING btree (family_name);


--
-- Name: index_users_on_given_name; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_given_name ON users USING btree (given_name);


--
-- Name: index_users_on_last_activity_at; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_last_activity_at ON users USING btree (last_activity_at);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_signature; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_users_on_signature ON users USING btree (signature);


--
-- Name: index_users_on_username; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_virology_profiles_on_created_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_profiles_on_created_by_id ON virology_profiles USING btree (created_by_id);


--
-- Name: index_virology_profiles_on_document; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_profiles_on_document ON virology_profiles USING gin (document);


--
-- Name: index_virology_profiles_on_patient_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX index_virology_profiles_on_patient_id ON virology_profiles USING btree (patient_id);


--
-- Name: index_virology_profiles_on_updated_by_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_profiles_on_updated_by_id ON virology_profiles USING btree (updated_by_id);


--
-- Name: index_virology_versions_on_item_type_and_item_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX index_virology_versions_on_item_type_and_item_id ON virology_versions USING btree (item_type, item_id);


--
-- Name: letter_effective_date_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX letter_effective_date_idx ON letter_letters USING btree (COALESCE(completed_at, approved_at, submitted_for_approval_at, created_at));


--
-- Name: master_index_hd_diaries_on_hospital_unit_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX master_index_hd_diaries_on_hospital_unit_id ON hd_diaries USING btree (hospital_unit_id) WHERE (master = true);


--
-- Name: obx_unique_display_grouping; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX obx_unique_display_grouping ON pathology_observation_descriptions USING btree (display_group, display_order);


--
-- Name: obx_unique_letter_grouping; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX obx_unique_letter_grouping ON pathology_observation_descriptions USING btree (letter_group, letter_order);


--
-- Name: patient_bookmarks_uniqueness; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX patient_bookmarks_uniqueness ON patient_bookmarks USING btree (patient_id, user_id, COALESCE(deleted_at, '1970-01-01 00:00:00'::timestamp without time zone));


--
-- Name: patient_versions_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX patient_versions_versions_type_id ON patient_versions USING btree (item_type, item_id);


--
-- Name: pd_peritonitis_episode_types_unique_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX pd_peritonitis_episode_types_unique_id ON pd_peritonitis_episode_types USING btree (peritonitis_episode_id, peritonitis_episode_type_description_id);


--
-- Name: prd_required_observation_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prd_required_observation_description_id_idx ON pathology_request_descriptions USING btree (required_observation_description_id);


--
-- Name: prddc_drug_category_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prddc_drug_category_id_idx ON pathology_requests_drugs_drug_categories USING btree (drug_category_id);


--
-- Name: prddc_request_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prddc_request_description_id_idx ON pathology_requests_global_rule_sets USING btree (request_description_id);


--
-- Name: prdr_requests_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prdr_requests_description_id_idx ON pathology_request_descriptions_requests_requests USING btree (request_description_id);


--
-- Name: prdr_requests_request_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prdr_requests_request_id_idx ON pathology_request_descriptions_requests_requests USING btree (request_id);


--
-- Name: prgr_rule_set_id_and_rule_set_type_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prgr_rule_set_id_and_rule_set_type_idx ON pathology_requests_global_rules USING btree (rule_set_id, rule_set_type);


--
-- Name: prprr_patient_rule_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX prprr_patient_rule_id_idx ON pathology_requests_patient_rules_requests USING btree (patient_rule_id);


--
-- Name: tx_donor_stage_position_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_donor_stage_position_idx ON transplant_donor_stages USING btree (stage_position_id);


--
-- Name: tx_donor_stage_status_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_donor_stage_status_idx ON transplant_donor_stages USING btree (stage_status_id);


--
-- Name: tx_recip_fol_failure_cause_description_id_idx; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_recip_fol_failure_cause_description_id_idx ON transplant_recipient_followups USING btree (transplant_failure_cause_description_id);


--
-- Name: tx_versions_type_id; Type: INDEX; Schema: renalware; Owner: -
--

CREATE INDEX tx_versions_type_id ON transplant_versions USING btree (item_type, item_id);


--
-- Name: unique_study_participants; Type: INDEX; Schema: renalware; Owner: -
--

CREATE UNIQUE INDEX unique_study_participants ON research_study_participations USING btree (patient_id, study_id) WHERE (deleted_at IS NULL);


--
-- Name: delayed_jobs feed_messages_preprocessing_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER feed_messages_preprocessing_trigger BEFORE INSERT ON delayed_jobs FOR EACH ROW EXECUTE PROCEDURE preprocess_hl7_message();


--
-- Name: pathology_observations update_current_observation_set_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER update_current_observation_set_trigger AFTER INSERT OR UPDATE ON pathology_observations FOR EACH ROW EXECUTE PROCEDURE update_current_observation_set_from_trigger();


--
-- Name: research_study_participations update_research_study_participants_trigger; Type: TRIGGER; Schema: renalware; Owner: -
--

CREATE TRIGGER update_research_study_participants_trigger BEFORE INSERT ON research_study_participations FOR EACH ROW EXECUTE PROCEDURE update_research_study_participants_from_trigger();


--
-- Name: access_assessments access_assessments_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT access_assessments_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: access_assessments access_assessments_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT access_assessments_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: access_procedures access_procedures_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT access_procedures_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: access_procedures access_procedures_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT access_procedures_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: access_profiles access_profiles_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT access_profiles_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: access_profiles access_profiles_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT access_profiles_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: clinic_visits clinic_visits_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT clinic_visits_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: clinic_visits clinic_visits_patient_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT clinic_visits_patient_id_fk FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: clinic_visits clinic_visits_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT clinic_visits_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: directory_people directory_people_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY directory_people
    ADD CONSTRAINT directory_people_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: directory_people directory_people_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY directory_people
    ADD CONSTRAINT directory_people_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: events events_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: events events_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: patients fk_rails_01ec61436d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_01ec61436d FOREIGN KEY (religion_id) REFERENCES patient_religions(id);


--
-- Name: patients fk_rails_042462eeb9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_042462eeb9 FOREIGN KEY (language_id) REFERENCES patient_languages(id);


--
-- Name: modality_modalities fk_rails_0447199042; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT fk_rails_0447199042 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: pathology_observation_requests fk_rails_050f679712; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests
    ADD CONSTRAINT fk_rails_050f679712 FOREIGN KEY (description_id) REFERENCES pathology_request_descriptions(id);


--
-- Name: virology_profiles fk_rails_05a8d28840; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY virology_profiles
    ADD CONSTRAINT fk_rails_05a8d28840 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: pathology_requests_patient_rules_requests fk_rails_06517764c3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests
    ADD CONSTRAINT fk_rails_06517764c3 FOREIGN KEY (patient_rule_id) REFERENCES pathology_requests_patient_rules(id);


--
-- Name: hd_diaries fk_rails_07d7a349f6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diaries
    ADD CONSTRAINT fk_rails_07d7a349f6 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_schedule_definitions fk_rails_083e4d9774; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_schedule_definitions
    ADD CONSTRAINT fk_rails_083e4d9774 FOREIGN KEY (diurnal_period_id) REFERENCES hd_diurnal_period_codes(id);


--
-- Name: hd_profiles fk_rails_0aab25a07c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_0aab25a07c FOREIGN KEY (named_nurse_id) REFERENCES users(id);


--
-- Name: transplant_donations fk_rails_0b66891291; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donations
    ADD CONSTRAINT fk_rails_0b66891291 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: renal_aki_alerts fk_rails_0bac5aa8d3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alerts
    ADD CONSTRAINT fk_rails_0bac5aa8d3 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: letter_electronic_receipts fk_rails_0c14df6b87; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_electronic_receipts
    ADD CONSTRAINT fk_rails_0c14df6b87 FOREIGN KEY (letter_id) REFERENCES letter_letters(id);


--
-- Name: clinical_allergies fk_rails_0d8b5ebbad; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_allergies
    ADD CONSTRAINT fk_rails_0d8b5ebbad FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: access_procedures fk_rails_11c7f6fec3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT fk_rails_11c7f6fec3 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: transplant_donor_stages fk_rails_15abd8aa8d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stages
    ADD CONSTRAINT fk_rails_15abd8aa8d FOREIGN KEY (stage_status_id) REFERENCES transplant_donor_stage_statuses(id);


--
-- Name: pathology_requests_patient_rules fk_rails_15f58845a2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules
    ADD CONSTRAINT fk_rails_15f58845a2 FOREIGN KEY (lab_id) REFERENCES pathology_labs(id);


--
-- Name: medication_prescriptions fk_rails_17327d4301; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_17327d4301 FOREIGN KEY (medication_route_id) REFERENCES medication_routes(id);


--
-- Name: medication_prescription_terminations fk_rails_1f3fb8ef97; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT fk_rails_1f3fb8ef97 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: pd_pet_adequacy_results fk_rails_1f91303c21; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_pet_adequacy_results
    ADD CONSTRAINT fk_rails_1f91303c21 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_diary_slots fk_rails_206582e5c0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots
    ADD CONSTRAINT fk_rails_206582e5c0 FOREIGN KEY (station_id) REFERENCES hd_stations(id);


--
-- Name: low_clearance_profiles fk_rails_20f40e75a5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY low_clearance_profiles
    ADD CONSTRAINT fk_rails_20f40e75a5 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: modality_modalities fk_rails_21e1b74109; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT fk_rails_21e1b74109 FOREIGN KEY (description_id) REFERENCES modality_descriptions(id);


--
-- Name: pd_assessments fk_rails_22dc579c4a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_assessments
    ADD CONSTRAINT fk_rails_22dc579c4a FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_sessions fk_rails_23d8c477eb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_23d8c477eb FOREIGN KEY (dialysate_id) REFERENCES hd_dialysates(id);


--
-- Name: pathology_requests_drugs_drug_categories fk_rails_24de49b694; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories
    ADD CONSTRAINT fk_rails_24de49b694 FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: medication_prescriptions fk_rails_25e627b557; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_25e627b557 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: patient_worries fk_rails_27dc6e2dc8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_worries
    ADD CONSTRAINT fk_rails_27dc6e2dc8 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: medication_prescriptions fk_rails_27e92c81fe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_27e92c81fe FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: admission_consults fk_rails_2805127005; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consults
    ADD CONSTRAINT fk_rails_2805127005 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: medication_prescriptions fk_rails_2ae6a3ad59; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_2ae6a3ad59 FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: medication_prescription_terminations fk_rails_2bd34b98f9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT fk_rails_2bd34b98f9 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_profiles fk_rails_2c988cf1f6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_2c988cf1f6 FOREIGN KEY (schedule_definition_id) REFERENCES hd_schedule_definitions(id);


--
-- Name: clinic_appointments fk_rails_2eaec177ff; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_appointments
    ADD CONSTRAINT fk_rails_2eaec177ff FOREIGN KEY (becomes_visit_id) REFERENCES clinic_visits(id);


--
-- Name: pd_peritonitis_episode_types fk_rails_2f135fd6d9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episode_types
    ADD CONSTRAINT fk_rails_2f135fd6d9 FOREIGN KEY (peritonitis_episode_id) REFERENCES pd_peritonitis_episodes(id);


--
-- Name: hd_transmission_logs fk_rails_30b8eea154; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_transmission_logs
    ADD CONSTRAINT fk_rails_30b8eea154 FOREIGN KEY (hd_provider_unit_id) REFERENCES hd_provider_units(id);


--
-- Name: clinical_dry_weights fk_rails_31546389ab; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_dry_weights
    ADD CONSTRAINT fk_rails_31546389ab FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: feed_files fk_rails_3196424d66; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY feed_files
    ADD CONSTRAINT fk_rails_3196424d66 FOREIGN KEY (file_type_id) REFERENCES feed_file_types(id);


--
-- Name: access_plans fk_rails_32c8b62063; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plans
    ADD CONSTRAINT fk_rails_32c8b62063 FOREIGN KEY (plan_type_id) REFERENCES access_plan_types(id);


--
-- Name: transplant_registration_statuses fk_rails_32f4ff205a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT fk_rails_32f4ff205a FOREIGN KEY (registration_id) REFERENCES transplant_registrations(id);


--
-- Name: transplant_registrations fk_rails_33f3612955; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registrations
    ADD CONSTRAINT fk_rails_33f3612955 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: letter_contacts fk_rails_33f61c70e6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT fk_rails_33f61c70e6 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: messaging_messages fk_rails_3567fcbb87; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_messages
    ADD CONSTRAINT fk_rails_3567fcbb87 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: research_studies fk_rails_36273417ff; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_studies
    ADD CONSTRAINT fk_rails_36273417ff FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_diary_slots fk_rails_36ae60c09d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots
    ADD CONSTRAINT fk_rails_36ae60c09d FOREIGN KEY (diurnal_period_code_id) REFERENCES hd_diurnal_period_codes(id);


--
-- Name: transplant_registration_statuses fk_rails_36cb307ab5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT fk_rails_36cb307ab5 FOREIGN KEY (description_id) REFERENCES transplant_registration_status_descriptions(id);


--
-- Name: pathology_request_descriptions_requests_requests fk_rails_3916726775; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests
    ADD CONSTRAINT fk_rails_3916726775 FOREIGN KEY (request_id) REFERENCES pathology_requests_requests(id);


--
-- Name: letter_letters fk_rails_39983ddc03; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT fk_rails_39983ddc03 FOREIGN KEY (letterhead_id) REFERENCES letter_letterheads(id);


--
-- Name: pathology_request_descriptions fk_rails_39da21b3fe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions
    ADD CONSTRAINT fk_rails_39da21b3fe FOREIGN KEY (required_observation_description_id) REFERENCES pathology_observation_descriptions(id);


--
-- Name: transplant_donor_stages fk_rails_3a0cb37b2f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stages
    ADD CONSTRAINT fk_rails_3a0cb37b2f FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: transplant_recipient_operations fk_rails_3a852d1667; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations
    ADD CONSTRAINT fk_rails_3a852d1667 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_transmission_logs fk_rails_3b842bb40e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_transmission_logs
    ADD CONSTRAINT fk_rails_3b842bb40e FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: drug_types_drugs fk_rails_3bafe36805; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drug_types_drugs
    ADD CONSTRAINT fk_rails_3bafe36805 FOREIGN KEY (drug_type_id) REFERENCES drug_types(id);


--
-- Name: clinical_body_compositions fk_rails_3cab0126da; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_body_compositions
    ADD CONSTRAINT fk_rails_3cab0126da FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: letter_letters fk_rails_3de9a678b4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT fk_rails_3de9a678b4 FOREIGN KEY (approved_by_id) REFERENCES users(id);


--
-- Name: hd_sessions fk_rails_3e035fe47f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_3e035fe47f FOREIGN KEY (profile_id) REFERENCES hd_profiles(id);


--
-- Name: hd_sessions fk_rails_3e0f147311; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_3e0f147311 FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: pathology_requests_requests fk_rails_3e725c96fc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT fk_rails_3e725c96fc FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: pd_peritonitis_episode_types fk_rails_3e924fb47c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episode_types
    ADD CONSTRAINT fk_rails_3e924fb47c FOREIGN KEY (peritonitis_episode_type_description_id) REFERENCES pd_peritonitis_episode_type_descriptions(id);


--
-- Name: patient_bookmarks fk_rails_3f47dd9cc1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_bookmarks
    ADD CONSTRAINT fk_rails_3f47dd9cc1 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: pd_assessments fk_rails_408dde93e5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_assessments
    ADD CONSTRAINT fk_rails_408dde93e5 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: pathology_requests_global_rule_sets fk_rails_40e23de825; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets
    ADD CONSTRAINT fk_rails_40e23de825 FOREIGN KEY (clinic_id) REFERENCES clinic_clinics(id);


--
-- Name: admission_admissions fk_rails_4137fdc9b4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions
    ADD CONSTRAINT fk_rails_4137fdc9b4 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: system_user_feedback fk_rails_4cc9cf2dca; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY system_user_feedback
    ADD CONSTRAINT fk_rails_4cc9cf2dca FOREIGN KEY (author_id) REFERENCES users(id);


--
-- Name: renal_aki_alerts fk_rails_4d907ef0f1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alerts
    ADD CONSTRAINT fk_rails_4d907ef0f1 FOREIGN KEY (action_id) REFERENCES renal_aki_alert_actions(id);


--
-- Name: access_assessments fk_rails_506a7ce21d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT fk_rails_506a7ce21d FOREIGN KEY (type_id) REFERENCES access_types(id);


--
-- Name: messaging_receipts fk_rails_50de46762d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_receipts
    ADD CONSTRAINT fk_rails_50de46762d FOREIGN KEY (message_id) REFERENCES messaging_messages(id);


--
-- Name: patients fk_rails_53c392b502; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_53c392b502 FOREIGN KEY (country_of_birth_id) REFERENCES system_countries(id);


--
-- Name: admission_consults fk_rails_53e81afb74; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consults
    ADD CONSTRAINT fk_rails_53e81afb74 FOREIGN KEY (seen_by_id) REFERENCES users(id);


--
-- Name: letter_letters fk_rails_54a74fd998; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT fk_rails_54a74fd998 FOREIGN KEY (submitted_for_approval_by_id) REFERENCES users(id);


--
-- Name: admission_requests fk_rails_54b568383c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_requests
    ADD CONSTRAINT fk_rails_54b568383c FOREIGN KEY (reason_id) REFERENCES admission_request_reasons(id);


--
-- Name: hd_sessions fk_rails_563fedb262; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_563fedb262 FOREIGN KEY (dry_weight_id) REFERENCES clinical_dry_weights(id);


--
-- Name: renal_profiles fk_rails_568750244e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_profiles
    ADD CONSTRAINT fk_rails_568750244e FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: transplant_recipient_workups fk_rails_571a3cadda; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_workups
    ADD CONSTRAINT fk_rails_571a3cadda FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: virology_profiles fk_rails_58ffa1276c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY virology_profiles
    ADD CONSTRAINT fk_rails_58ffa1276c FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_diary_slots fk_rails_5910319259; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots
    ADD CONSTRAINT fk_rails_5910319259 FOREIGN KEY (diary_id) REFERENCES hd_diaries(id);


--
-- Name: patients fk_rails_5b44e541da; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_5b44e541da FOREIGN KEY (ethnicity_id) REFERENCES patient_ethnicities(id);


--
-- Name: pd_training_sessions fk_rails_5cbe110e5f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sessions
    ADD CONSTRAINT fk_rails_5cbe110e5f FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: patient_practice_memberships fk_rails_5cc07e383f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_practice_memberships
    ADD CONSTRAINT fk_rails_5cc07e383f FOREIGN KEY (practice_id) REFERENCES patient_practices(id);


--
-- Name: pd_regime_terminations fk_rails_6021bed852; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_terminations
    ADD CONSTRAINT fk_rails_6021bed852 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: access_assessments fk_rails_604fdf3a9e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_assessments
    ADD CONSTRAINT fk_rails_604fdf3a9e FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: letter_signatures fk_rails_60aca3bf58; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_signatures
    ADD CONSTRAINT fk_rails_60aca3bf58 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: pathology_requests_requests fk_rails_617c726b94; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT fk_rails_617c726b94 FOREIGN KEY (consultant_id) REFERENCES users(id);


--
-- Name: letter_letters fk_rails_6191e75b3b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT fk_rails_6191e75b3b FOREIGN KEY (author_id) REFERENCES users(id);


--
-- Name: messaging_messages fk_rails_65f878b7cf; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_messages
    ADD CONSTRAINT fk_rails_65f878b7cf FOREIGN KEY (author_id) REFERENCES users(id);


--
-- Name: admission_consults fk_rails_66c44c0949; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consults
    ADD CONSTRAINT fk_rails_66c44c0949 FOREIGN KEY (hospital_ward_id) REFERENCES hospital_wards(id);


--
-- Name: transplant_recipient_followups fk_rails_6893ba0593; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups
    ADD CONSTRAINT fk_rails_6893ba0593 FOREIGN KEY (transplant_failure_cause_description_id) REFERENCES transplant_failure_cause_descriptions(id);


--
-- Name: hd_preference_sets fk_rails_69555e3a94; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT fk_rails_69555e3a94 FOREIGN KEY (schedule_definition_id) REFERENCES hd_schedule_definitions(id);


--
-- Name: problem_notes fk_rails_6a44f3907b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_notes
    ADD CONSTRAINT fk_rails_6a44f3907b FOREIGN KEY (problem_id) REFERENCES problem_problems(id);


--
-- Name: pathology_observations fk_rails_70ef87ad18; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observations
    ADD CONSTRAINT fk_rails_70ef87ad18 FOREIGN KEY (request_id) REFERENCES pathology_observation_requests(id);


--
-- Name: admission_admissions fk_rails_74bb0c40ab; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions
    ADD CONSTRAINT fk_rails_74bb0c40ab FOREIGN KEY (modality_at_admission_id) REFERENCES modality_modalities(id);


--
-- Name: hd_sessions fk_rails_751ed7515f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_751ed7515f FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: events fk_rails_75f14fef31; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_75f14fef31 FOREIGN KEY (event_type_id) REFERENCES event_types(id);


--
-- Name: patients fk_rails_76ea7f2448; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_76ea7f2448 FOREIGN KEY (second_cause_id) REFERENCES death_causes(id);


--
-- Name: letter_letters fk_rails_774d7e4879; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT fk_rails_774d7e4879 FOREIGN KEY (completed_by_id) REFERENCES users(id);


--
-- Name: transplant_recipient_followups fk_rails_78dc63040c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_followups
    ADD CONSTRAINT fk_rails_78dc63040c FOREIGN KEY (operation_id) REFERENCES transplant_recipient_operations(id);


--
-- Name: hd_profiles fk_rails_7d0453a2e8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_7d0453a2e8 FOREIGN KEY (dialysate_id) REFERENCES hd_dialysates(id);


--
-- Name: pd_regime_terminations fk_rails_7d318fdf1a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_terminations
    ADD CONSTRAINT fk_rails_7d318fdf1a FOREIGN KEY (regime_id) REFERENCES pd_regimes(id);


--
-- Name: snippets_snippets fk_rails_7d5fdddbd2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY snippets_snippets
    ADD CONSTRAINT fk_rails_7d5fdddbd2 FOREIGN KEY (author_id) REFERENCES users(id);


--
-- Name: letter_archives fk_rails_7dc4363735; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_archives
    ADD CONSTRAINT fk_rails_7dc4363735 FOREIGN KEY (letter_id) REFERENCES letter_letters(id);


--
-- Name: research_study_participations fk_rails_8039d07f46; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_study_participations
    ADD CONSTRAINT fk_rails_8039d07f46 FOREIGN KEY (study_id) REFERENCES research_studies(id);


--
-- Name: research_study_participations fk_rails_87bef0e757; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_study_participations
    ADD CONSTRAINT fk_rails_87bef0e757 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: patient_worries fk_rails_8837145e13; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_worries
    ADD CONSTRAINT fk_rails_8837145e13 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_prescription_administrations fk_rails_885e37560e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_prescription_administrations
    ADD CONSTRAINT fk_rails_885e37560e FOREIGN KEY (prescription_id) REFERENCES medication_prescriptions(id);


--
-- Name: hd_profiles fk_rails_89630f47ee; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_89630f47ee FOREIGN KEY (transport_decider_id) REFERENCES users(id);


--
-- Name: clinical_body_compositions fk_rails_8acc26446b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_body_compositions
    ADD CONSTRAINT fk_rails_8acc26446b FOREIGN KEY (modality_description_id) REFERENCES modality_descriptions(id);


--
-- Name: admission_requests fk_rails_8b3ff2812e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_requests
    ADD CONSTRAINT fk_rails_8b3ff2812e FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: renal_aki_alerts fk_rails_8b50e868dc; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alerts
    ADD CONSTRAINT fk_rails_8b50e868dc FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_provider_units fk_rails_8d21a18a82; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_provider_units
    ADD CONSTRAINT fk_rails_8d21a18a82 FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: access_profiles fk_rails_8d75e5423f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_8d75e5423f FOREIGN KEY (decided_by_id) REFERENCES users(id);


--
-- Name: low_clearance_profiles fk_rails_8d84feb2ed; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY low_clearance_profiles
    ADD CONSTRAINT fk_rails_8d84feb2ed FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hospital_units fk_rails_8f3a7fc1c7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_units
    ADD CONSTRAINT fk_rails_8f3a7fc1c7 FOREIGN KEY (hospital_centre_id) REFERENCES hospital_centres(id);


--
-- Name: pathology_request_descriptions_requests_requests fk_rails_8f574ed703; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions_requests_requests
    ADD CONSTRAINT fk_rails_8f574ed703 FOREIGN KEY (request_description_id) REFERENCES pathology_request_descriptions(id);


--
-- Name: hd_provider_units fk_rails_8f5e478f60; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_provider_units
    ADD CONSTRAINT fk_rails_8f5e478f60 FOREIGN KEY (hd_provider_id) REFERENCES hd_providers(id);


--
-- Name: hd_diary_slots fk_rails_8fd55142bd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots
    ADD CONSTRAINT fk_rails_8fd55142bd FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: clinic_appointments fk_rails_909dcaaf3d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_appointments
    ADD CONSTRAINT fk_rails_909dcaaf3d FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: admission_requests fk_rails_9161088ec5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_requests
    ADD CONSTRAINT fk_rails_9161088ec5 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: transplant_failure_cause_descriptions fk_rails_9183cb4170; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_failure_cause_descriptions
    ADD CONSTRAINT fk_rails_9183cb4170 FOREIGN KEY (group_id) REFERENCES transplant_failure_cause_description_groups(id);


--
-- Name: clinical_allergies fk_rails_9193bda748; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_allergies
    ADD CONSTRAINT fk_rails_9193bda748 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: transplant_donor_workups fk_rails_93dc1108f3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_workups
    ADD CONSTRAINT fk_rails_93dc1108f3 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: pd_regime_terminations fk_rails_93f7877530; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_terminations
    ADD CONSTRAINT fk_rails_93f7877530 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: pd_exit_site_infections fk_rails_9702c22886; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_exit_site_infections
    ADD CONSTRAINT fk_rails_9702c22886 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: patients fk_rails_9739853ad1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_9739853ad1 FOREIGN KEY (primary_care_physician_id) REFERENCES patient_primary_care_physicians(id);


--
-- Name: research_study_participations fk_rails_980af0ec33; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_study_participations
    ADD CONSTRAINT fk_rails_980af0ec33 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: admission_admissions fk_rails_9b1787c128; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions
    ADD CONSTRAINT fk_rails_9b1787c128 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: research_study_participations fk_rails_9c3d41afbe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_study_participations
    ADD CONSTRAINT fk_rails_9c3d41afbe FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: letter_recipients fk_rails_9c76b7ba29; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_recipients
    ADD CONSTRAINT fk_rails_9c76b7ba29 FOREIGN KEY (letter_id) REFERENCES letter_letters(id);


--
-- Name: roles_users fk_rails_9dada905f6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT fk_rails_9dada905f6 FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: access_procedures fk_rails_9dbbc5bfd0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_procedures
    ADD CONSTRAINT fk_rails_9dbbc5bfd0 FOREIGN KEY (type_id) REFERENCES access_types(id);


--
-- Name: admission_consults fk_rails_9e878a7b22; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consults
    ADD CONSTRAINT fk_rails_9e878a7b22 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: patient_alerts fk_rails_9efea309bb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_alerts
    ADD CONSTRAINT fk_rails_9efea309bb FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: pathology_request_descriptions fk_rails_a0b9cd97fe; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_request_descriptions
    ADD CONSTRAINT fk_rails_a0b9cd97fe FOREIGN KEY (lab_id) REFERENCES pathology_labs(id);


--
-- Name: letter_contacts fk_rails_a0d87208a0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT fk_rails_a0d87208a0 FOREIGN KEY (description_id) REFERENCES letter_contact_descriptions(id);


--
-- Name: hd_diaries fk_rails_a30d12c65b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diaries
    ADD CONSTRAINT fk_rails_a30d12c65b FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: hd_sessions fk_rails_a3afae15cb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_a3afae15cb FOREIGN KEY (modality_description_id) REFERENCES modality_descriptions(id);


--
-- Name: letter_contacts fk_rails_a5852d1710; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_contacts
    ADD CONSTRAINT fk_rails_a5852d1710 FOREIGN KEY (person_id) REFERENCES directory_people(id);


--
-- Name: hd_patient_statistics fk_rails_a654a17f8d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics
    ADD CONSTRAINT fk_rails_a654a17f8d FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: pd_regimes fk_rails_a70920e237; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regimes
    ADD CONSTRAINT fk_rails_a70920e237 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: transplant_donor_stages fk_rails_a791cc53cd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stages
    ADD CONSTRAINT fk_rails_a791cc53cd FOREIGN KEY (stage_position_id) REFERENCES transplant_donor_stage_positions(id);


--
-- Name: transplant_donor_stages fk_rails_a7ac3785a4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stages
    ADD CONSTRAINT fk_rails_a7ac3785a4 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_stations fk_rails_a7fedf6e91; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_stations
    ADD CONSTRAINT fk_rails_a7fedf6e91 FOREIGN KEY (location_id) REFERENCES hd_station_locations(id);


--
-- Name: pathology_requests_drugs_drug_categories fk_rails_a850498c88; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_drugs_drug_categories
    ADD CONSTRAINT fk_rails_a850498c88 FOREIGN KEY (drug_category_id) REFERENCES pathology_requests_drug_categories(id);


--
-- Name: pathology_requests_requests fk_rails_a8d58d31e6; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT fk_rails_a8d58d31e6 FOREIGN KEY (clinic_id) REFERENCES clinic_clinics(id);


--
-- Name: hd_diaries fk_rails_aab1b8f3e1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diaries
    ADD CONSTRAINT fk_rails_aab1b8f3e1 FOREIGN KEY (master_diary_id) REFERENCES hd_diaries(id);


--
-- Name: hd_preference_sets fk_rails_ac8e970c42; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT fk_rails_ac8e970c42 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: access_profiles fk_rails_acbcae03df; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_acbcae03df FOREIGN KEY (type_id) REFERENCES access_types(id);


--
-- Name: pd_peritonitis_episodes fk_rails_ae56e9fe7e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_ae56e9fe7e FOREIGN KEY (episode_type_id) REFERENCES pd_peritonitis_episode_type_descriptions(id);


--
-- Name: virology_profiles fk_rails_af15bfebc8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY virology_profiles
    ADD CONSTRAINT fk_rails_af15bfebc8 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_stations fk_rails_af478cfba0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_stations
    ADD CONSTRAINT fk_rails_af478cfba0 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: pathology_requests_patient_rules fk_rails_b13e09c8a3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules
    ADD CONSTRAINT fk_rails_b13e09c8a3 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_patient_statistics fk_rails_b163068880; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_patient_statistics
    ADD CONSTRAINT fk_rails_b163068880 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: clinical_body_compositions fk_rails_b4786e77de; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_body_compositions
    ADD CONSTRAINT fk_rails_b4786e77de FOREIGN KEY (assessor_id) REFERENCES users(id);


--
-- Name: pathology_observation_descriptions fk_rails_b4b10c7e86; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observation_descriptions
    ADD CONSTRAINT fk_rails_b4b10c7e86 FOREIGN KEY (measurement_unit_id) REFERENCES pathology_measurement_units(id);


--
-- Name: admission_admissions fk_rails_b4edf9f5f8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions
    ADD CONSTRAINT fk_rails_b4edf9f5f8 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: transplant_donor_operations fk_rails_b6ee03185c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_operations
    ADD CONSTRAINT fk_rails_b6ee03185c FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: admission_admissions fk_rails_b722288de2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions
    ADD CONSTRAINT fk_rails_b722288de2 FOREIGN KEY (hospital_ward_id) REFERENCES hospital_wards(id);


--
-- Name: pathology_requests_global_rules fk_rails_b77918cf71; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rules
    ADD CONSTRAINT fk_rails_b77918cf71 FOREIGN KEY (rule_set_id) REFERENCES pathology_requests_global_rule_sets(id);


--
-- Name: hospital_wards fk_rails_b7949167d5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hospital_wards
    ADD CONSTRAINT fk_rails_b7949167d5 FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: clinic_appointments fk_rails_b7cc8fd5dd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_appointments
    ADD CONSTRAINT fk_rails_b7cc8fd5dd FOREIGN KEY (clinic_id) REFERENCES clinic_clinics(id);


--
-- Name: clinic_visits fk_rails_b844dc9537; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_visits
    ADD CONSTRAINT fk_rails_b844dc9537 FOREIGN KEY (clinic_id) REFERENCES clinic_clinics(id);


--
-- Name: access_plans fk_rails_b898a29af1; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plans
    ADD CONSTRAINT fk_rails_b898a29af1 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: problem_problems fk_rails_bbae3e065d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_problems
    ADD CONSTRAINT fk_rails_bbae3e065d FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_sessions fk_rails_bd995b497c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_bd995b497c FOREIGN KEY (signed_on_by_id) REFERENCES users(id);


--
-- Name: patient_alerts fk_rails_bf45802f3f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_alerts
    ADD CONSTRAINT fk_rails_bf45802f3f FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: patient_bookmarks fk_rails_c12b863727; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_bookmarks
    ADD CONSTRAINT fk_rails_c12b863727 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: modality_modalities fk_rails_c31cea56ac; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT fk_rails_c31cea56ac FOREIGN KEY (reason_id) REFERENCES modality_reasons(id);


--
-- Name: patient_alerts fk_rails_c37cc03264; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_alerts
    ADD CONSTRAINT fk_rails_c37cc03264 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES active_storage_blobs(id);


--
-- Name: ukrdc_transmission_logs fk_rails_c59f71164c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY ukrdc_transmission_logs
    ADD CONSTRAINT fk_rails_c59f71164c FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_prescription_administrations fk_rails_c654406492; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_prescription_administrations
    ADD CONSTRAINT fk_rails_c654406492 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: transplant_donor_followups fk_rails_c75064199c; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_followups
    ADD CONSTRAINT fk_rails_c75064199c FOREIGN KEY (operation_id) REFERENCES transplant_donor_operations(id);


--
-- Name: medication_prescriptions fk_rails_c7b1e35b07; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescriptions
    ADD CONSTRAINT fk_rails_c7b1e35b07 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_profiles fk_rails_c89b2174e9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_c89b2174e9 FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: pd_regime_bags fk_rails_ca16ec591e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_bags
    ADD CONSTRAINT fk_rails_ca16ec591e FOREIGN KEY (regime_id) REFERENCES pd_regimes(id);


--
-- Name: renal_profiles fk_rails_cd10bc0ddf; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_profiles
    ADD CONSTRAINT fk_rails_cd10bc0ddf FOREIGN KEY (prd_description_id) REFERENCES renal_prd_descriptions(id);


--
-- Name: access_profiles fk_rails_d04ba97fc5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_profiles
    ADD CONSTRAINT fk_rails_d04ba97fc5 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: transplant_donor_stages fk_rails_d05e755f4a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donor_stages
    ADD CONSTRAINT fk_rails_d05e755f4a FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: renal_aki_alerts fk_rails_d15c835018; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alerts
    ADD CONSTRAINT fk_rails_d15c835018 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: admission_requests fk_rails_d42c308e35; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_requests
    ADD CONSTRAINT fk_rails_d42c308e35 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: letter_signatures fk_rails_d4aaa80dee; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_signatures
    ADD CONSTRAINT fk_rails_d4aaa80dee FOREIGN KEY (letter_id) REFERENCES letter_letters(id);


--
-- Name: access_plans fk_rails_d61e7c4674; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plans
    ADD CONSTRAINT fk_rails_d61e7c4674 FOREIGN KEY (decided_by_id) REFERENCES users(id);


--
-- Name: addresses fk_rails_d873e14e27; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT fk_rails_d873e14e27 FOREIGN KEY (country_id) REFERENCES system_countries(id);


--
-- Name: hd_profiles fk_rails_d92d27629e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_d92d27629e FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: access_plans fk_rails_d944a58ba2; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plans
    ADD CONSTRAINT fk_rails_d944a58ba2 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: access_plans fk_rails_db0b9b356b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY access_plans
    ADD CONSTRAINT fk_rails_db0b9b356b FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: pathology_observation_requests fk_rails_db5255e417; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observation_requests
    ADD CONSTRAINT fk_rails_db5255e417 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: pathology_observations fk_rails_dc1b1799e7; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_observations
    ADD CONSTRAINT fk_rails_dc1b1799e7 FOREIGN KEY (description_id) REFERENCES pathology_observation_descriptions(id);


--
-- Name: messaging_messages fk_rails_dc393c1672; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_messages
    ADD CONSTRAINT fk_rails_dc393c1672 FOREIGN KEY (replying_to_message_id) REFERENCES messaging_messages(id);


--
-- Name: pd_pet_adequacy_results fk_rails_dd74a1d162; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_pet_adequacy_results
    ADD CONSTRAINT fk_rails_dd74a1d162 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: messaging_receipts fk_rails_dd8a10c86f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY messaging_receipts
    ADD CONSTRAINT fk_rails_dd8a10c86f FOREIGN KEY (recipient_id) REFERENCES users(id);


--
-- Name: pathology_current_observation_sets fk_rails_dd99e95861; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_current_observation_sets
    ADD CONSTRAINT fk_rails_dd99e95861 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: patient_practice_memberships fk_rails_dd9db188d9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_practice_memberships
    ADD CONSTRAINT fk_rails_dd9db188d9 FOREIGN KEY (primary_care_physician_id) REFERENCES patient_primary_care_physicians(id);


--
-- Name: pd_regime_bags fk_rails_de0d26811a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regime_bags
    ADD CONSTRAINT fk_rails_de0d26811a FOREIGN KEY (bag_type_id) REFERENCES pd_bag_types(id);


--
-- Name: patients fk_rails_de32a1820e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT fk_rails_de32a1820e FOREIGN KEY (first_cause_id) REFERENCES death_causes(id);


--
-- Name: pd_infection_organisms fk_rails_df82011585; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_infection_organisms
    ADD CONSTRAINT fk_rails_df82011585 FOREIGN KEY (organism_code_id) REFERENCES pd_organism_codes(id);


--
-- Name: clinic_appointments fk_rails_e03d4a27ce; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_appointments
    ADD CONSTRAINT fk_rails_e03d4a27ce FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: admission_requests fk_rails_e0d84c3803; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_requests
    ADD CONSTRAINT fk_rails_e0d84c3803 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_stations fk_rails_e1203401d3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_stations
    ADD CONSTRAINT fk_rails_e1203401d3 FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: events fk_rails_e1899a68af; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_e1899a68af FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: roles_users fk_rails_e2a7142459; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT fk_rails_e2a7142459 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: hd_diary_slots fk_rails_e2ba4fdc06; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots
    ADD CONSTRAINT fk_rails_e2ba4fdc06 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_sessions fk_rails_e32b0e0494; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT fk_rails_e32b0e0494 FOREIGN KEY (signed_off_by_id) REFERENCES users(id);


--
-- Name: transplant_recipient_operations fk_rails_e41edf9bc0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_recipient_operations
    ADD CONSTRAINT fk_rails_e41edf9bc0 FOREIGN KEY (hospital_centre_id) REFERENCES hospital_centres(id);


--
-- Name: pathology_requests_global_rule_sets fk_rails_e53c500fcd; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_global_rule_sets
    ADD CONSTRAINT fk_rails_e53c500fcd FOREIGN KEY (request_description_id) REFERENCES pathology_request_descriptions(id);


--
-- Name: pd_assessments fk_rails_e8c15c8c13; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_assessments
    ADD CONSTRAINT fk_rails_e8c15c8c13 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: pd_peritonitis_episodes fk_rails_e97a696dd5; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_e97a696dd5 FOREIGN KEY (fluid_description_id) REFERENCES pd_fluid_descriptions(id);


--
-- Name: hd_profiles fk_rails_eb5294f3df; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT fk_rails_eb5294f3df FOREIGN KEY (prescriber_id) REFERENCES users(id);


--
-- Name: problem_problems fk_rails_edf3902cb0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_problems
    ADD CONSTRAINT fk_rails_edf3902cb0 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: letter_electronic_receipts fk_rails_f0ab49c550; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_electronic_receipts
    ADD CONSTRAINT fk_rails_f0ab49c550 FOREIGN KEY (recipient_id) REFERENCES users(id);


--
-- Name: clinic_clinics fk_rails_f0adc9d29e; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinic_clinics
    ADD CONSTRAINT fk_rails_f0adc9d29e FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: hd_diary_slots fk_rails_f0b0195037; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diary_slots
    ADD CONSTRAINT fk_rails_f0b0195037 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_preference_sets fk_rails_f0bcae6feb; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT fk_rails_f0bcae6feb FOREIGN KEY (hospital_unit_id) REFERENCES hospital_units(id);


--
-- Name: research_studies fk_rails_f10169e6a9; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY research_studies
    ADD CONSTRAINT fk_rails_f10169e6a9 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: pd_peritonitis_episodes fk_rails_f228a98e1b; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_peritonitis_episodes
    ADD CONSTRAINT fk_rails_f228a98e1b FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_stations fk_rails_f4cc4cd5c4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_stations
    ADD CONSTRAINT fk_rails_f4cc4cd5c4 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_prescription_administrations fk_rails_f51a425d72; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_prescription_administrations
    ADD CONSTRAINT fk_rails_f51a425d72 FOREIGN KEY (hd_session_id) REFERENCES hd_sessions(id);


--
-- Name: admission_consults fk_rails_f5abb5bad4; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_consults
    ADD CONSTRAINT fk_rails_f5abb5bad4 FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: patient_worries fk_rails_f866b9dc2f; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patient_worries
    ADD CONSTRAINT fk_rails_f866b9dc2f FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: pd_pet_adequacy_results fk_rails_f8ae33fdba; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_pet_adequacy_results
    ADD CONSTRAINT fk_rails_f8ae33fdba FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: pd_training_sessions fk_rails_f8d9e0a9b0; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sessions
    ADD CONSTRAINT fk_rails_f8d9e0a9b0 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: drug_types_drugs fk_rails_f8ed99dfda; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY drug_types_drugs
    ADD CONSTRAINT fk_rails_f8ed99dfda FOREIGN KEY (drug_id) REFERENCES drugs(id);


--
-- Name: clinical_allergies fk_rails_f8f7b6daad; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_allergies
    ADD CONSTRAINT fk_rails_f8f7b6daad FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: pd_training_sessions fk_rails_fa412bd095; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sessions
    ADD CONSTRAINT fk_rails_fa412bd095 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: renal_aki_alerts fk_rails_fae5bb71b3; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY renal_aki_alerts
    ADD CONSTRAINT fk_rails_fae5bb71b3 FOREIGN KEY (hospital_ward_id) REFERENCES hospital_wards(id);


--
-- Name: hd_prescription_administrations fk_rails_fb03f6bde8; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_prescription_administrations
    ADD CONSTRAINT fk_rails_fb03f6bde8 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: problem_problems fk_rails_fb41553d96; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_problems
    ADD CONSTRAINT fk_rails_fb41553d96 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: pathology_requests_patient_rules_requests fk_rails_fc41021986; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_patient_rules_requests
    ADD CONSTRAINT fk_rails_fc41021986 FOREIGN KEY (request_id) REFERENCES pathology_requests_requests(id);


--
-- Name: clinical_dry_weights fk_rails_fdc1dbcc6d; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_dry_weights
    ADD CONSTRAINT fk_rails_fdc1dbcc6d FOREIGN KEY (assessor_id) REFERENCES users(id);


--
-- Name: medication_prescription_terminations fk_rails_fe1184d31a; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY medication_prescription_terminations
    ADD CONSTRAINT fk_rails_fe1184d31a FOREIGN KEY (prescription_id) REFERENCES medication_prescriptions(id);


--
-- Name: low_clearance_profiles fk_rails_ff7b848263; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY low_clearance_profiles
    ADD CONSTRAINT fk_rails_ff7b848263 FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: hd_diaries fk_rails_ffb6b0d291; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_diaries
    ADD CONSTRAINT fk_rails_ffb6b0d291 FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: admission_admissions fk_rails_ffd7d79d65; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY admission_admissions
    ADD CONSTRAINT fk_rails_ffd7d79d65 FOREIGN KEY (summarised_by_id) REFERENCES users(id);


--
-- Name: clinical_dry_weights hd_dry_weights_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_dry_weights
    ADD CONSTRAINT hd_dry_weights_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: clinical_dry_weights hd_dry_weights_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY clinical_dry_weights
    ADD CONSTRAINT hd_dry_weights_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_preference_sets hd_preference_sets_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT hd_preference_sets_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_preference_sets hd_preference_sets_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_preference_sets
    ADD CONSTRAINT hd_preference_sets_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_profiles hd_profiles_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT hd_profiles_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_profiles hd_profiles_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_profiles
    ADD CONSTRAINT hd_profiles_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: hd_sessions hd_sessions_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT hd_sessions_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: hd_sessions hd_sessions_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY hd_sessions
    ADD CONSTRAINT hd_sessions_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: letter_archives letter_archives_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_archives
    ADD CONSTRAINT letter_archives_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: letter_archives letter_archives_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_archives
    ADD CONSTRAINT letter_archives_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: letter_letters letter_letters_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT letter_letters_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: letter_letters letter_letters_patient_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT letter_letters_patient_id_fk FOREIGN KEY (patient_id) REFERENCES patients(id);


--
-- Name: letter_letters letter_letters_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY letter_letters
    ADD CONSTRAINT letter_letters_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: modality_modalities modality_modalities_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT modality_modalities_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: modality_modalities modality_modalities_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY modality_modalities
    ADD CONSTRAINT modality_modalities_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: pathology_requests_requests pathology_requests_requests_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT pathology_requests_requests_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: pathology_requests_requests pathology_requests_requests_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pathology_requests_requests
    ADD CONSTRAINT pathology_requests_requests_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: patients patients_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: patients patients_practice_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_practice_id_fk FOREIGN KEY (practice_id) REFERENCES patient_practices(id);


--
-- Name: patients patients_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY patients
    ADD CONSTRAINT patients_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: pd_regimes pd_regimes_system_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_regimes
    ADD CONSTRAINT pd_regimes_system_id_fk FOREIGN KEY (system_id) REFERENCES pd_systems(id);


--
-- Name: pd_training_sessions pd_training_sessions_site_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sessions
    ADD CONSTRAINT pd_training_sessions_site_id_fk FOREIGN KEY (training_site_id) REFERENCES pd_training_sites(id);


--
-- Name: pd_training_sessions pd_training_sessions_type_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY pd_training_sessions
    ADD CONSTRAINT pd_training_sessions_type_id_fk FOREIGN KEY (training_type_id) REFERENCES pd_training_types(id);


--
-- Name: problem_notes problem_notes_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_notes
    ADD CONSTRAINT problem_notes_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: problem_notes problem_notes_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY problem_notes
    ADD CONSTRAINT problem_notes_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- Name: transplant_donations transplant_donations_recipient_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_donations
    ADD CONSTRAINT transplant_donations_recipient_id_fk FOREIGN KEY (recipient_id) REFERENCES patients(id);


--
-- Name: transplant_registration_statuses transplant_registration_statuses_created_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT transplant_registration_statuses_created_by_id_fk FOREIGN KEY (created_by_id) REFERENCES users(id);


--
-- Name: transplant_registration_statuses transplant_registration_statuses_updated_by_id_fk; Type: FK CONSTRAINT; Schema: renalware; Owner: -
--

ALTER TABLE ONLY transplant_registration_statuses
    ADD CONSTRAINT transplant_registration_statuses_updated_by_id_fk FOREIGN KEY (updated_by_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO renalware,public;

INSERT INTO "schema_migrations" (version) VALUES
('20141004150240'),
('20141010170329'),
('20141020170329'),
('20141023111038'),
('20141024111715'),
('20141024111716'),
('20141107145549'),
('20141107145614'),
('20141107145615'),
('20141208160813'),
('20141222110119'),
('20141223135723'),
('20141223135724'),
('20150109113417'),
('20150109152145'),
('20150119160039'),
('20150120155952'),
('20150203161438'),
('20150213103855'),
('20150213103856'),
('20150213103857'),
('20150224140027'),
('20150302171638'),
('20150312112909'),
('20150312113937'),
('20150313124325'),
('20150514113239'),
('20150515154952'),
('20150515155052'),
('20150602151910'),
('20150605095934'),
('20150605151945'),
('20150608093000'),
('20150608093001'),
('20150608093002'),
('20150623083220'),
('20150623105816'),
('20150701104744'),
('20150702084036'),
('20150709152737'),
('20150717093153'),
('20150923201215'),
('20151014205537'),
('20151021194419'),
('20151022184845'),
('20151022190252'),
('20151103210628'),
('20151104183740'),
('20151111194419'),
('20151116111600'),
('20151116170100'),
('20151116170200'),
('20151207163303'),
('20151207163304'),
('20151207167020'),
('20160106167020'),
('20160114222043'),
('20160120203747'),
('20160120203748'),
('20160120203753'),
('20160120203754'),
('20160120203755'),
('20160120213000'),
('20160120213001'),
('20160121175711'),
('20160121175712'),
('20160202152252'),
('20160203160040'),
('20160203160041'),
('20160208153327'),
('20160209203446'),
('20160218220145'),
('20160302192055'),
('20160303151449'),
('20160303151540'),
('20160304151449'),
('20160304151540'),
('20160304162205'),
('20160314181446'),
('20160327221550'),
('20160412123106'),
('20160419132410'),
('20160420132524'),
('20160426093341'),
('20160426112409'),
('20160503113814'),
('20160505142813'),
('20160505151102'),
('20160506104710'),
('20160506151356'),
('20160509134401'),
('20160509134929'),
('20160509151927'),
('20160509171244'),
('20160510155932'),
('20160518110836'),
('20160518111325'),
('20160524171947'),
('20160525124151'),
('20160527104432'),
('20160530162708'),
('20160530162720'),
('20160530170058'),
('20160531141853'),
('20160613120910'),
('20160616163622'),
('20160620131148'),
('20160628141349'),
('20160726150709'),
('20160726170852'),
('20160728094200'),
('20160728103933'),
('20160729083654'),
('20160729095901'),
('20160805120015'),
('20160809095951'),
('20160812073616'),
('20160812073900'),
('20160817095514'),
('20160818131917'),
('20160822130644'),
('20160823173525'),
('20160824132805'),
('20160829114845'),
('20160830141439'),
('20160905140623'),
('20160906195949'),
('20160916113152'),
('20160922154638'),
('20160930111424'),
('20161003192717'),
('20161003204347'),
('20161004185820'),
('20161010191529'),
('20161014134639'),
('20161018174711'),
('20161019145606'),
('20161027165025'),
('20161028145040'),
('20161031170940'),
('20161101105519'),
('20161103091319'),
('20161107141354'),
('20161108123101'),
('20161111154939'),
('20161114174727'),
('20161114184444'),
('20161115164413'),
('20161117101457'),
('20161117133825'),
('20161118100149'),
('20161118165332'),
('20161121143011'),
('20161122112905'),
('20161123141041'),
('20161123142841'),
('20161124152732'),
('20161129122629'),
('20161201165330'),
('20161201183449'),
('20161202155429'),
('20161207115413'),
('20161207183903'),
('20161212095607'),
('20161212133822'),
('20161212181500'),
('20161214172314'),
('20161215090417'),
('20161216090417'),
('20161216155218'),
('20170103161015'),
('20170106161800'),
('20170106164639'),
('20170110161149'),
('20170120135631'),
('20170124153334'),
('20170203102941'),
('20170203145405'),
('20170207195029'),
('20170210124019'),
('20170210133517'),
('20170213140513'),
('20170217123531'),
('20170217132644'),
('20170217141529'),
('20170217161409'),
('20170220150611'),
('20170222135148'),
('20170227154311'),
('20170228131923'),
('20170306093012'),
('20170308173219'),
('20170313154020'),
('20170314114614'),
('20170314115111'),
('20170314120712'),
('20170315100152'),
('20170320112730'),
('20170320124532'),
('20170323100125'),
('20170331115718'),
('20170331153349'),
('20170403091407'),
('20170403092407'),
('20170403094115'),
('20170424064032'),
('20170427123530'),
('20170427130642'),
('20170502165422'),
('20170505104641'),
('20170505112521'),
('20170512150125'),
('20170515093430'),
('20170515105635'),
('20170522151032'),
('20170523125610'),
('20170524134229'),
('20170526060804'),
('20170526061000'),
('20170601142904'),
('20170602124855'),
('20170605102519'),
('20170605103133'),
('20170605161951'),
('20170606131948'),
('20170606160731'),
('20170606182242'),
('20170608135553'),
('20170608135953'),
('20170608192234'),
('20170609144233'),
('20170614140457'),
('20170615130714'),
('20170615144802'),
('20170615184503'),
('20170619100927'),
('20170620121255'),
('20170621102157'),
('20170621205538'),
('20170622145529'),
('20170627110058'),
('20170627110619'),
('20170628115247'),
('20170703144902'),
('20170703153949'),
('20170705090219'),
('20170705135512'),
('20170705150913'),
('20170705160726'),
('20170707110155'),
('20170711140607'),
('20170711140926'),
('20170712090217'),
('20170720080033'),
('20170725120242'),
('20170809080925'),
('20170810092953'),
('20170810093532'),
('20170821100353'),
('20170823084127'),
('20170824113401'),
('20170830085137'),
('20170830171726'),
('20170831082043'),
('20170831084331'),
('20170831142819'),
('20170908155011'),
('20170908160250'),
('20170911133224'),
('20170912092135'),
('20170915090544'),
('20170915115228'),
('20170916121019'),
('20170917185426'),
('20170920113628'),
('20170925161033'),
('20170925182738'),
('20170926081426'),
('20170926132845'),
('20171002175804'),
('20171003093347'),
('20171003111228'),
('20171003122425'),
('20171004092235'),
('20171004110909'),
('20171005081224'),
('20171005091202'),
('20171005130109'),
('20171005144505'),
('20171009104106'),
('20171009181615'),
('20171012110133'),
('20171012143050'),
('20171013145849'),
('20171016152223'),
('20171017132738'),
('20171017171625'),
('20171101121130'),
('20171101162244'),
('20171106100216'),
('20171109084751'),
('20171113120217'),
('20171114120904'),
('20171116103230'),
('20171118160030'),
('20171123123712'),
('20171123143534'),
('20171123154116'),
('20171127082158'),
('20171127092158'),
('20171127092359'),
('20171128163543'),
('20171204112150'),
('20171206121652'),
('20171206140738'),
('20171208211206'),
('20171211130716'),
('20171211131918'),
('20171211161400'),
('20171213111513'),
('20171214141335'),
('20171214190849'),
('20171215122454'),
('20171219154529'),
('20171222153815'),
('20180102155055'),
('20180105132358'),
('20180108185400'),
('20180112151706'),
('20180112151813'),
('20180119121243'),
('20180121115246'),
('20180122173922'),
('20180125201356'),
('20180126142314'),
('20180130165803'),
('20180201090444'),
('20180202184954'),
('20180206225525'),
('20180207082540'),
('20180208150629'),
('20180213124203'),
('20180213125734'),
('20180213171805'),
('20180214124317'),
('20180216132741'),
('20180221210458'),
('20180222090501'),
('20180223100420'),
('20180226124724'),
('20180226132410'),
('20180301095040'),
('20180305134959'),
('20180306071308'),
('20180306080518'),
('20180307191650'),
('20180307223111'),
('20180309140316'),
('20180311071146'),
('20180311104609'),
('20180313114927'),
('20180313124819'),
('20180319191942'),
('20180323150241'),
('20180326155400'),
('20180327100423'),
('20180328210434'),
('20180419141524'),
('20180422090043'),
('20180427133558'),
('20180502093256'),
('20180502110638'),
('20180510151959'),
('20180511100345'),
('20180511140415'),
('20180511171835'),
('20180514151627'),
('20180516111411'),
('20180524072633'),
('20180524074320'),
('20180605114332'),
('20180605141806'),
('20180605175211'),
('20180622130552'),
('20180625124431'),
('20180628132323'),
('20180702091222'),
('20180702091237'),
('20180702091352'),
('20180712143314'),
('20180718172750'),
('20180725132557'),
('20180725132808'),
('20180730154454'),
('20180802103013'),
('20180802132417'),
('20180802144507'),
('20180803131157'),
('20180814103916'),
('20180815144429'),
('20180831134606'),
('20180831134926'),
('20180907100545'),
('20181001162513'),
('20181008144324'),
('20181008145159'),
('20181013115138'),
('20181025170410'),
('20181026145459'),
('20181106133500'),
('20181109110616'),
('20181126090401'),
('20181126123745'),
('20181217124025'),
('20190104095254'),
('20190117144832');


