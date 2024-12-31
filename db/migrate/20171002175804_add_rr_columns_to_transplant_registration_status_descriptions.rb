class AddRrColumnsToTransplantRegistrationStatusDescriptions < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :transplant_registration_status_descriptions,
                 :rr_code,
                 :integer,
                 index: true

      add_column :transplant_registration_status_descriptions,
                 :rr_comment,
                 :text
    end
  end
end
