class UpdateFeedSausagesUpsertFromMirthFn < ActiveRecord::Migration[7.1]
  def up
    within_renalware_schema do
      load_function("feed_sausages_upsert_from_mirth_v02.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("feed_sausages_upsert_from_mirth_v01.sql")
    end
  end
end
