class CreateHDDNANag < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("patient_nag_hd_dna_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute(<<~SQL.squish)
        DROP FUNCTION patient_nag_hd_dna(
          p_id integer,
          out out_severity system_nag_severity,
          out out_value text,
          out out_date date
        )
      SQL
    end
  end
end
