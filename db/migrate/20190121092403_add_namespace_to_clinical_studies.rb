class AddNamespaceToClinicalStudies < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :research_studies, :namespace, :string, index: true
    end
  end
end
