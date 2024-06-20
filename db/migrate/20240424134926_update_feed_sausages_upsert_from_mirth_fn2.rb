class UpdateFeedSausagesUpsertFromMirthFn2 < ActiveRecord::Migration[7.1]
  def up
    within_renalware_schema do
      load_function("feed_sausages_upsert_from_mirth_v04.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("feed_sausages_upsert_from_mirth_v03.sql")
    end
  end
end
