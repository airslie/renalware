/*
This view returns all possible drug names - ie the base drug, and any instances where the drug
has an enabled trade family (eg 'Tacrolimus (Adoport)'). Its a materialised view as these
change not too often, and the speed up lookup is useful when using ajax/type-ahead lookups.
Note the associated migration adds an index on eg 'name'
*/
select * from
(
  (
    select id::varchar, name from drugs
    where deleted_at is null and inactive = false
  )
  union
  (
    select
      drugs.id::varchar || ':' || drug_trade_families.id::varchar,
      (drugs.name || ' (' || drug_trade_families.name || ')')
    from
      "drugs"
    inner join "drug_trade_family_classifications" on
      "drug_trade_family_classifications"."drug_id" = "drugs"."id"
    inner join "drug_trade_families" on
      "drug_trade_families"."id" = "drug_trade_family_classifications"."trade_family_id"
      and "drug_trade_family_classifications"."enabled" = true
    where
      "drugs"."deleted_at" is null
      and "drugs"."inactive" = false
  )
) t
order by name asc;
