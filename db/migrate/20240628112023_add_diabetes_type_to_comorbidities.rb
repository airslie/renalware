class AddDiabetesTypeToComorbidities < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column(
          :problem_comorbidities,
          :diabetes_type,
          :string
        )
      end
    end
  end
end
