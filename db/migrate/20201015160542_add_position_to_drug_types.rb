class AddPositionToDrugTypes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :drug_types,
        :position,
        :integer,
        default: 0,
        null: false,
        index: true,
        comment: "Controls display order"
      )
      add_column(
        :drug_types,
        :weighting,
        :integer,
        null: false,
        default: 0,
        comment: "More important drug types have a higher value so their colour trumps other " \
                 "types a drug might have."
      )
      add_column(
        :drug_types,
        :colour,
        :string,
        null: true,
        comment: "A CSS colour e.f. '#A12A12'"
      )
    end
  end
end
