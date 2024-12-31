class CreateHDVNDRiskAssessments < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_enum(
        :hd_vnd_risk_level_itemised,
        %w(0_very_low 0_low 1_low 1_medium 2_medium 2_high)
      )

      create_enum(
        :hd_vnd_risk_level_overall,
        %w(low medium high)
      )

      create_table :hd_vnd_risk_assessments do |t|
        t.references(
          :patient,
          foreign_key: true,
          index: true,
          null: false
        )
        t.enum(
          :risk1,
          enum_type: :hd_vnd_risk_level_itemised,
          null: false,
          comment: "What is the likelihood that the staff (or carer) will fail to observe an " \
                   "actual or potential VND for this patient?"
        )
        t.enum(
          :risk2,
          enum_type: :hd_vnd_risk_level_itemised,
          null: false,
          comment: "What is the likelihood that the patient will fail to raise the alarm if they " \
                   "experience VND?"
        )
        t.enum(
          :risk3,
          enum_type: :hd_vnd_risk_level_itemised,
          null: false,
          comment: "What is the likelihood of the patient behaving in a way that could lead to VND?"
        )
        t.enum(
          :risk4,
          enum_type: :hd_vnd_risk_level_itemised,
          null: false,
          comment: "What is the likelihood of the taping failing to ensure that the needle is " \
                   "secure throughout dialysis?"
        )
        t.integer(
          :overall_risk_score,
          null: false,
          comment: "Overall risk score for a serious Venous Needle Dislodgement incident eg 6"
        )
        t.enum(
          :overall_risk_level,
          enum_type: :hd_vnd_risk_level_overall,
          null: false,
          comment: "Overall risk level for a serious Venous Needle Dislodgement incident eg 'high'"
        )
        t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
        t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end
    end
  end
end
