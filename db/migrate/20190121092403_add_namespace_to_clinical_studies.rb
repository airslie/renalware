class AddNamespaceToClinicalStudies < ActiveRecord::Migration[5.2]
  def change
    add_column :research_studies, :namespace, :string, index: true
  end
end
