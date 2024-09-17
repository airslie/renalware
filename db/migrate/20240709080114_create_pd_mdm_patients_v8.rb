class CreatePDMDMPatientsV8 < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      update_view :pd_mdm_patients, version: 8, revert_to_version: 7

      # Note the filter update below is for the benefit of consuming applications.
      # When seeding the demo app in this project, the view_metadata seeds file may overwrite
      # whatever we do here, as it runs afterwards.
      reversible do |direction|
        direction.down do
          # noop
        end
        direction.up do
          Renalware::System::ViewMetadata
            .where(view_name: "pd_mdm_patients")
            .update(
              filters: [
                {
                  code: "on_worryboard",
                  type: 0
                },
                {
                  code: "hospital_centre",
                  type: 0
                },
                {
                  code: "named_consultant",
                  type: 0
                },
                {
                  code: "named_nurse",
                  type: 0
                }
              ]
            )
        end
      end
    end
  end
end
