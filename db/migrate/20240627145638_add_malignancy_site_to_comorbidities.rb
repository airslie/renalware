class AddMalignancySiteToComorbidities < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_reference(
          :problem_comorbidities,
          :malignancy_site,
          references: :problem_malignancy_sites,
          foreign_key: { to_table: "problem_malignancy_sites" }
        )
      end
    end
  end
end
