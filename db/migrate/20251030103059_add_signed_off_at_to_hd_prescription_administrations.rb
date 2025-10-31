class AddSignedOffAtToHDPrescriptionAdministrations < ActiveRecord::Migration[8.0]
  def change
    add_column :hd_prescription_administrations, :signed_off_at, :datetime
  end
end
