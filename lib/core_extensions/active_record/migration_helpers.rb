module CoreExtensions
  module ActiveRecord
    module MigrationHelpers
      require "activerecord/postgres_enum"
      # Used in migrations to ensure the objects created/updated/found are in the correct schema.
      # We ensure that the original schema_search_path defined in the database.yml in the host app
      # is restored - this particularly important for migrations in an engine.
      #
      # Within this renalware core engine, use:
      #
      # def change
      #   within_renalware_schema do
      #     ...make database changes
      #     ...any new objects will be created in the renalware schema
      #   end
      # end
      #
      # Within another engine eg renalware-diaverum:
      #
      # def change
      #   within_renalware_schema(:diaverum) do
      #     ...make database changes
      #     ...any new objects will be created in the renalware_diaverum schema
      #   end
      # end
      #
      # If using from a host app eg renalware_blt (actually this is optional):
      #
      # def change
      #   within_renalware_schema(:blt) do
      #     ...make database changes
      #     ...any new objects will be created in the renalware_blt schema
      #   end
      # end
      def within_renalware_schema(suffix: nil)
        schemas = if suffix.present?
                    "renalware_#{suffix},renalware,public,heroku_ext"
                  else
                    "renalware,public,heroku_ext"
                  end
        original_schema_search_path = connection.schema_search_path
        connection.schema_search_path = schemas
        yield if block_given?
        connection.schema_search_path = original_schema_search_path
      end

      def within_public_schema
        original_schema_search_path = connection.schema_search_path
        connection.schema_search_path = "public,heroku_ext"
        yield if block_given?
        connection.schema_search_path = original_schema_search_path
      end

      # Can be called from a migration to load in a function from a sql file
      # at e.g. db/functions/my_function_v01.sql
      #
      # Example usage:
      #  load_function("my_function_v01.sql")
      #
      def load_function(filename)
        load_sql_file(DatabaseObjectPaths.functions, filename)
      end

      # Can be called from a migration to load in a trigger from a sql file
      # at e.g. db/functions/my_trigger_v01.sql
      #
      # Example usage:
      #  load_trigger("my_trigger_v01.sql")
      #
      def load_trigger(filename)
        load_sql_file(DatabaseObjectPaths.triggers, filename)
      end

      def load_sql_file(paths, filename)
        found = false
        paths.each do |path|
          file_path = path.join(filename)
          if File.exist?(file_path)
            connection.execute(File.read(file_path))
            found = true
          end
        end
        raise "Cannot file #{filename} in #{paths.join(', ')}" unless found
      end

      # Make sure to look in the host Rails app as well as in the engine
      class DatabaseObjectPaths
        class << self
          def triggers
            [
              Rails.root.join("db/triggers"),
              Renalware::Engine.root.join("db", "triggers")
            ]
          end

          def functions
            [
              Rails.root.join("db/functions"),
              Renalware::Engine.root.join("db", "functions")
            ]
          end
        end
      end
    end
  end
end

ActiveRecord::Migration.prepend(CoreExtensions::ActiveRecord::MigrationHelpers)
