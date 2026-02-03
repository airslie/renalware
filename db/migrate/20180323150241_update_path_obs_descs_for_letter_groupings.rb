class UpdatePathObsDescsForLetterGroupings < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      sql = <<~SQL.squish
        UPDATE renalware.pathology_observation_descriptions set letter_group = NULL, letter_order = NULL;
        UPDATE renalware.pathology_observation_descriptions set letter_group=1, letter_order=1 where code = 'HGB';
        UPDATE renalware.pathology_observation_descriptions set letter_group=1, letter_order=2 where code = 'WBC';
        UPDATE renalware.pathology_observation_descriptions set letter_group=1, letter_order=3 where code = 'PLT';
        UPDATE renalware.pathology_observation_descriptions set letter_group=2, letter_order=1 where code = 'URE';
        UPDATE renalware.pathology_observation_descriptions set letter_group=3, letter_order=1 where code = 'CRE';
        UPDATE renalware.pathology_observation_descriptions set letter_group=3, letter_order=2 where code = 'EGFR';
        UPDATE renalware.pathology_observation_descriptions set letter_group=4, letter_order=1 where code = 'NA';
        UPDATE renalware.pathology_observation_descriptions set letter_group=4, letter_order=2 where code = 'POT';
        UPDATE renalware.pathology_observation_descriptions set letter_group=5, letter_order=1 where code = 'BIC';
        UPDATE renalware.pathology_observation_descriptions set letter_group=6, letter_order=1 where code = 'CCA';
        UPDATE renalware.pathology_observation_descriptions set letter_group=6, letter_order=2 where code = 'PHOS';
        UPDATE renalware.pathology_observation_descriptions set letter_group=7, letter_order=1 where code = 'PTHI';
        UPDATE renalware.pathology_observation_descriptions set letter_group=8, letter_order=1  where code = 'ALB';
        UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=1 where code = 'BIL';
        UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=2 where code = 'AST';
        UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=3 where code = 'ALP';
        UPDATE renalware.pathology_observation_descriptions set letter_group=9, letter_order=4 where code = 'GGT';
        UPDATE renalware.pathology_observation_descriptions set letter_group=10, letter_order=1 where code = 'HBA';
        UPDATE renalware.pathology_observation_descriptions set letter_group=11, letter_order=1 where code = 'CHOL';
      SQL
      connection.execute(sql)
    end
  end
end
