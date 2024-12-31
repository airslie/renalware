class CreateImportFeedGps < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("import_feed_gps_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("drop function import_feed_gps;")
    end
  end
end
