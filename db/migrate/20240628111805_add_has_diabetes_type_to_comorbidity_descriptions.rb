class AddHasDiabetesTypeToComorbidityDescriptions < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :problem_comorbidity_descriptions,
                 :has_diabetes_type,
                 :boolean,
                 default: false,
                 null: false
    end
  end
end
