class AddGPSendStatusToLetters < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        create_enum :enum_letters_gp_send_status,
                    %w(not_applicable pending success failure)

        add_column :letter_letters,
                   :gp_send_status,
                   :enum_letters_gp_send_status,
                   null: false,
                   default: :not_applicable,
                   comment: "Captures the status of out attempt to send a copy of the letter to " \
                            "the GP over MESH using eg GP Connect."
        add_index :letter_letters, :gp_send_status
      end
    end
  end
end
