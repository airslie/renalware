class AddDefaultToGPMemberships < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        comment = <<-COMMENT.squish
          A membership with default_gp=true will be the default GP for a Practice in case the
          patient has no specific PrimaryCarePhysician assigned (one is required for letters etc).
          Only one (undeleted) membership per Practice can have default_gp=true.
          Generally this will be assigned to the system-level Generic PrimaryCarePhysician
          unless a specific PrimaryCarePhysician is assigned as default.
        COMMENT
        add_column :patient_practice_memberships,
                   :default_gp,
                   :boolean,
                   null: false,
                   default: false,
                   comment: comment
        add_index :patient_practice_memberships,
                  [:default_gp, :practice_id],
                  unique: true,
                  where: "default_gp = true and deleted_at IS NULL",
                  name: "index_unique_default_gp_per_practice"
      end
    end
  end
end
