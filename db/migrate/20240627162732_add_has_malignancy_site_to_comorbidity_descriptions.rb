class AddHasMalignancySiteToComorbidityDescriptions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :problem_comorbidity_descriptions,
                 :has_malignancy_site,
                 :boolean,
                 default: false,
                 null: false
    end
  end
end
