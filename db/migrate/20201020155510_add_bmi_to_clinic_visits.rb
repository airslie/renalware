class AddBMIToClinicVisits < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :clinic_visits,
        :bmi,
        :decimal,
        precision: 10,
        scale: 1,
        null: true,
        comment: "Body Mass Index calculated using a before_save when the clinic visit is updated"
      )

      reversible do |direction|
        direction.up do
          # Update the bmi for existing clinic visits, but restrict to avoid generating a
          # non-sense value in case height or weight were entered incorrectly.
          # NB: height is in metres and weight in kg
          connection.execute(
            "update renalware.clinic_visits " \
            "set bmi = round(((weight / height)::decimal / height::decimal), 1) " \
            "where height > 0 and height < 3 and weight > 0 and weight < 500;"
          )
        end
        direction.down do
          # noop
        end
      end
    end
  end
end
