CREATE OR REPLACE FUNCTION months_between (t_start timestamp, t_end timestamp)
RETURNS integer
AS $$
-- calculate the months between 2 timestamps
select ((extract('years' from $2)::int -  extract('years' from $1)::int) * 12)
    - extract('month' from $1)::int + extract('month' from $2)::int
$$
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;
