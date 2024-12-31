class AddTypeToSessions < ActiveRecord::Migration[4.2]
  class HDSession < ActiveRecord::Base
  end

  def up
    add_column :hd_sessions, :type, :string, index: true, null: true
    HDSession.where(type: nil).where.not(signed_off_by_id: nil).update_all(type: "Renalware::HD::Session::Closed")
    HDSession.where(type: nil, signed_off_by_id: nil).update_all(type: "Renalware::HD::Session::Open")
    change_column :hd_sessions, :type, :string, index: true, null: false
  end

  def down
    remove_column :hd_sessions, :type
  end
end
