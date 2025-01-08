namespace :db do
  namespace :schema do
    # Overriding db:structure:dump to remove the COMMENT ON EXTENSION ... statements which
    # cause an error if commenting on an Heroku-installed extension that we do not have permission
    # on,
    task dump: [:environment, :load_config] do
      db_dir = ActiveRecord::Tasks::DatabaseTasks.db_dir
      filename = ENV["SCHEMA"] || File.join(db_dir, "structure.sql")
      sql = File.read(filename).each_line.grep_v(/\ACOMMENT ON EXTENSION.+/).join

      File.write(filename, sql)
    end
  end

  desc "Check that we are not about to drop an anonymised database"
  task drop_check: :environment do
    db_name = "rw_anon"
    if Rails.configuration.database_configuration[Rails.env]["database"] == db_name
      raise ActiveRecord::ProtectedEnvironmentError, "Cannot drop #{db_name}"
    end
  end

  desc "Refreshes all materialized views e.g. audits. May take a while so only run overnight."
  task refresh_all_materialized_views: :environment do
    Rails.benchmark "Refreshing materialized views" do
      ActiveRecord::Base.connection.execute("SELECT refresh_all_matierialized_views();")
    end
  end

  namespace :demo do
    desc "Loads demo seed data from the renalware-core gem"
    task seed: :environment do
      if Rails.env.development? || ENV["ALLOW_DEMO_SEEDS"] == "1"
        require Renalware::Engine.root.join("demo/db/seeds")
      else
        puts "Task currently only possible in development environment"
      end
    end
  end

  desc "Refresh a materialized view (optionally concurrently)"
  task refresh_materialized_view: :environment do
    RefreshMaterializedViewJob.perform_now(
      view_name: ENV.fetch("view_name"),
      concurrently: "true" == ENV.fetch("concurrently", "false")
    )
  end
end

task("db:drop").enhance ["db:drop_check"]
