module Renalware
  module UKRDC
    module TreatmentTimeline
      # If the host site has defined a SQL function called ukrdc_prepare_tables() in any schema in
      # the current SEARCH_PATH, then we call it here. It will (we hope) generate massaged copies of
      # tables needed to later generate e.g. UKRDC treatments - for example at KCH the hd_profiles
      # table is massaged to correct migration artefacts and issues prior to the generation of the
      # UKRDC Treatment Timeline. Elsewhere we detect the presence of these prepared
      # tables (eg ukrdc_prepared_hd_profiles) and use them as the underlying table behind, in this
      # example, Renalware::HD::Profile, by setting class.table_name = 'ukrdc_prepared_hd_profiles'.
      # If the site has not defined the ukrdc_prepare_tables SQL function then we exit gracefully.
      class PrepareTables
        def self.call
          Treatment.delete_all
          connection = ActiveRecord::Base.connection
          result = connection.execute(<<-SQL.squish)
            select 1 where exists(select 1 from pg_proc where proname = 'ukrdc_prepare_tables');
          SQL
          if result.ntuples == 1
            connection.execute("select ukrdc_prepare_tables();")
            true
          end
        end
      end
    end
  end
end
