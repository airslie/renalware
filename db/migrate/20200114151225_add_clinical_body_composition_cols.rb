class AddClinicalBodyCompositionCols < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :clinical_body_composition_pre_post_hd, %w(pre post)
      change_table :clinical_body_compositions do |t|
        t.enum :pre_post_hd, enum_type: :clinical_body_composition_pre_post_hd
        t.float :weight
      end
    end
  end
end
