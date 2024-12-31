class CreatePatientNagClincalFrailtyScoreFunction < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("patient_nag_clinical_frailty_score_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute(
        "DROP FUNCTION patient_nag_clinical_frailty_score(
        p_id integer,
        out out_severity system_nag_severity,
        out out_value text,
        out out_date date)"
      )
    end
  end
end
