class AddOnsetOnToProblemProblems < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_enum :problem_date_display_style_enum, %w(y my dmy)
      change_table :problem_problems do |t|
        t.enum :date_display_style, enum_type: :problem_date_display_style_enum, null: true
      end
    end
  end
end
