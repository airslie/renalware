class AddPublicFlagToMessages < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :messaging_messages,
        :public,
        :boolean,
        null: false,
        default: false,
        comment: "If true, the message will be displayed on a patient's clinical summary and " \
                 "their messages page. If false (ie private), the message can only be viewed " \
                 "by the sender (in their sent messages) and by the recipients. " \
                 "New messages once this migration is run will always have public=true. " \
                 "Historical messages will remain private."
      )
    end
  end
end
