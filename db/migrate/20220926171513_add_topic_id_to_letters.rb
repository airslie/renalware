class AddTopicIdToLetters < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :letter_letters, :topic, index: { algorithm: :concurrently }

    # We might not even need to update the topic id for any previous letters :hm?:
    up_only do
      Renalware::Letters::Topic.all.each do |topic|
        Renalware::Letters::Letter.where(description: topic.text).update_all(topic_id: topic.id)
      end
    end
  end
end
