class CreateTriggerToPreprocessHL7Msg < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      # load_function("preprocess_hl7_message_v01.sql")
      # connection.execute("drop trigger if exists feed_messages_preprocessing_trigger on delayed_jobs;")
      # load_trigger("feed_messages_preprocessing_trigger_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      # connection.execute(
      #   "drop trigger if exists feed_messages_preprocessing_trigger on delayed_jobs; " \
      #   "drop function if exists preprocess_hl7_message();"
      # )
    end
  end
end
