# This default Rails task normally just dumps the structure.sql file to the
# file system as :sql is the schema_format specified in config/application.rb.
# We want to additionally dump the schema.rb file, which is easier
# to parse for humans and machines.
Rake::Task["db:schema:dump"].enhance do
  Rails.root.join("db/schema.rb").open("w") do |stream|
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection_pool, stream)
  end
end
