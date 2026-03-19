/*
A plpgsql function by Michael Fuhr for faster counting.
See https://wiki.postgresql.org/wiki/Count_estimate
Normal count(*) can be slow where that are millions of rows.
This is a faster way to count filtered rows by parsing the output of an explain query.
*/
CREATE OR REPLACE FUNCTION count_estimate(query text) RETURNS INTEGER AS
$func$
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
$func$ LANGUAGE plpgsql;
