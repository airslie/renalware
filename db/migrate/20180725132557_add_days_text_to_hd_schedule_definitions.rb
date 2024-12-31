class AddDaysTextToHDScheduleDefinitions < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :hd_schedule_definitions, :days_text, :text
      add_column :hd_schedule_definitions, :sort_order, :integer, null: false, default: 0

      reversible do |direction|
        direction.up do
          sql = <<-SQL.squish
          update hd_schedule_definitions set days_text = 'Mon Wed Fri' where days::text = '{1,3,5}';
          update hd_schedule_definitions set days_text = 'Tue Thu Sat' where days::text = '{2,4,6}';
          SQL
          connection.execute(sql)
        end
      end

      add_column :hd_diurnal_period_codes, :sort_order, :integer, default: 0, null: false
      reversible do |direction|
        direction.up {
          connection.execute(<<-SQL.squish)
            update hd_diurnal_period_codes set sort_order = 1 where code = 'am';
            update hd_diurnal_period_codes set sort_order = 2 where code = 'pm';
            update hd_diurnal_period_codes set sort_order = 3 where code = 'eve';
          SQL
        }
      end
    end
  end
end
