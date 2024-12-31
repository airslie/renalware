# This migration moves all engine-specific objects into the renalware schema.
# See also
#   schema_search_path: "renalware,public"
# in database.yml - we look for objects in the renalware schema first.
#
# Someone developing a host application can create custom tables, views etc in the
# public schema and these will be found provided either
# - their name is unique and does not clash with a name in the renalware schema, or
# - they specify the schema in the model. For example if they are creating their own Patient model
#   and `patients` table, they will need to use
#     self.table_name = "public.patients"
#   in order to avoid a clash with renalware.patients, which is the first entry
#   in schema_search_path.
# - . This lets us ring fence renalware db objects and prevent
# name clashes as long as if for instance a host app defines a patients table in the public schema
# they reference it as public.patients otherwise renalware.patients will be used.
#
class MoveObjectsToRenalwareSchema < ActiveRecord::Migration[5.1]
  FUNCTIONS = [
    "refresh_all_matierialized_views(text, boolean)",
    "audit_view_as_json(text)"
  ]

  def db_objects_of_type(type:, in_schema:)
    results = execute "SELECT table_name FROM information_schema.tables " \
                      "WHERE table_schema='#{in_schema}' AND table_type='#{type}' " \
                      "and table_name not in ('schema_migrations','ar_internal_metadata')"
    results.map { |obj| obj["table_name"] }
  end

  def views(in_schema:)
    db_objects_of_type(type: "VIEW", in_schema: in_schema)
  end

  def materialized_views(in_schema:)
    results = execute(
      "SELECT oid::regclass::text as table_name FROM pg_class WHERE  relkind = 'm';"
    )
    results.map { |obj| obj["table_name"] }
  end

  def tables(in_schema:)
    db_objects_of_type(type: "BASE TABLE", in_schema: in_schema)
  end

  def up
    execute "CREATE SCHEMA IF NOT EXISTS renalware"

    tables(in_schema: "public").each { |table| execute("ALTER TABLE #{table} SET SCHEMA renalware") }
    # Removing views(in_schema.. call as it tried to move pg_stat_statements* views and this
    # causes an error on Heroku
    # views(in_schema: "public").each{ |view| execute("ALTER VIEW #{view} SET SCHEMA renalware") }
    materialized_views(in_schema: "public").each { |view| execute("ALTER MATERIALIZED VIEW #{view} SET SCHEMA renalware") }
    FUNCTIONS.each { |fn| execute "ALTER FUNCTION #{fn} SET SCHEMA renalware" }
    # This causes an error on Heroku
    # execute "ALTER EXTENSION \"uuid-ossp\" SET SCHEMA public;"
  end

  def down
    tables(in_schema: "renalware").each { |table| execute("ALTER TABLE #{table} SET SCHEMA public") }
    views(in_schema: "renalware").each { |view| execute("ALTER VIEW #{view} SET SCHEMA public") }
    materialized_views(in_schema: "renalware").each { |view| execute("ALTER MATERIALIZED VIEW #{view} SET SCHEMA public") }
    FUNCTIONS.each { |fn| execute "ALTER FUNCTION #{fn} SET SCHEMA public" }
  end
end
