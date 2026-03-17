class RenameLowClearanceDialysisPlansUKRDCRr51OutcomeCode < ActiveRecord::Migration[8.0]
  def up
    within_renalware_schema do
      safety_assured do
        remove_column :low_clearance_dialysis_plans, :ukrdc_rr51_outcome_code, :integer
        add_column :low_clearance_dialysis_plans,
                   :ukrdc_assessment_outcome_code,
                   :integer,
                   comment: "For UKRDC Care Planning Assessments. See UKRR Dataset 5+. " \
                            "Valid values are 4 through 10."
        add_foreign_key :low_clearance_dialysis_plans,
                        :ukrdc_assessment_outcomes,
                        column: :ukrdc_assessment_outcome_code,
                        primary_key: :code

        {
          pd: 9,
          capd_la: 9,
          capd_ga: 9,
          capd_ga_avf: 9,
          capd_ga_hernia: 9,
          capd_la_avf: 9,
          capd_la_sedation: 9,
          capd_not_yet_assessed: 9,
          hd: 7,
          hd_via_avf: 7,
          hd_via_ptfe_graft: 7,
          hd_via_line: 7,
          pre_emptive_lrd: 6,
          pre_emptive_lrd_backup_hd: 6,
          pre_emptive_lrd_backup_pd: 6,
          not_for_dial_patient_choice: 10,
          not_for_dial_consensus: 10,
          refuse_to_plan_for_dial: 5,
          home_hd: 8,
          self_care_hd: 7,
          no_current_plan: 5
        }.each do |code, rr51_code|
          Renalware::LowClearance::DialysisPlan.transaction do
            plan = Renalware::LowClearance::DialysisPlan.find_by(code:)
            plan.presence&.update!(ukrdc_assessment_outcome_code: rr51_code)
          end
        end
      end
    end
  end

  def down
    within_renalware_schema do
      safety_assured do
        remove_foreign_key :low_clearance_dialysis_plans,
                           column: :ukrdc_assessment_outcome_code
        remove_column :low_clearance_dialysis_plans,
                      :ukrdc_assessment_outcome_code,
                      :string
        add_column :low_clearance_dialysis_plans,
                   :ukrdc_rr51_outcome_code,
                   :integer,
                   comment: "For UKRDC Care Planning Assessments. See UKRR Dataset 5+. " \
                            "Valid values are 4 through 10. Not using an enum here as codes " \
                            "may change in a future UKRDC release"
      end
    end
  end
end
