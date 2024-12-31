# For use only in rake task! See comments below
module Renalware
  module UKRDC
    module TreatmentTimeline
      # When generating the treatment timeline, sites may want to pre-prepare a massaged version
      # of say hd_profiles, in order to correct any anomalies. This service object
      # will remap the table_name of the supplied (or default models) to the
      # 'ukrdc_prepared_*' version if it exists. Otherwise it will not change the table name.
      # Note that this can only be done when executing as a rake task (which has its own process)
      # as I believe changing the table_name will affect all threads in the same process - so doing
      # this in a puma process would mean users start to see only the contents of the
      # ukrdc_prepared_tables. Not good :0.
      class RemapModelTableNamesToTheirPreparedEquivalents
        ALLOWED_PROCESSES = %w(rake rspec).freeze
        MODELS = [
          Renalware::HD::Profile
        ].freeze
        class ExecutionNotAllowedError < StandardError; end

        # Saves the original table names for the array of models classes
        # remaps to its ukrdc_prepared_* variant if it exists, yields to allow
        # the calling process to do its thing, then importantly winds back to
        # the original table names.
        def call(models = MODELS)
          fail_unless_running_in_rake_or_rspec
          models = Array(models)
          original_table_names = models.map(&:table_name)

          models.each do |model_class|
            prepared_table_name = prepared_table_name_for(model_class.table_name)
            model_class.table_name = prepared_table_name if table_exists?(prepared_table_name)
          end

          yield if block_given?

          models.each_with_index do |model_class, index|
            model_class.table_name = original_table_names[index]
          end
        end

        private

        def fail_unless_running_in_rake_or_rspec
          unless ALLOWED_PROCESSES.include?(File.basename($PROGRAM_NAME))
            raise(
              ExecutionNotAllowedError,
              "Can only be called from #{ALLOWED_PROCESSES.join(', ')}"
            )
          end
        end

        def prepared_table_name_for(table_name)
          "ukrdc_prepared_#{table_name}"
        end

        def table_exists?(table_name)
          result = connection.execute(<<-SQL.squish)
            SELECT 1
            WHERE EXISTS (
              SELECT 1 FROM information_schema.tables WHERE table_name = '#{table_name}')
          SQL
          result.ntuples == 1
        end

        def connection
          ActiveRecord::Base.connection
        end
      end

      module X
        def table_name
          "ukrdc_prepared_#{super}"
        end
      end
    end
  end
end
