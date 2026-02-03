class AddColsToProblemRaDaRDiagnoses < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      comment = <<~COMMENT.squish
        Optional regex eg 'AH (amyloidosis|amylidos.*)' against which patient problem
        descriptions will be matched (in addition to matching purely against the
        diagnosis.name) when trying to ascertain if the patient has this rare renal diagnosis.
        Supporting regexes allows for problem variants and for spelling mistakes in non-SNOMED coded
        problems.
      COMMENT
      add_column :problem_radar_diagnoses, :description_regex, :text, comment: comment

      comment = <<~COMMENT.squish
        Optional regex eg '(123123|345345|123123123123.*)' against which patient problem
        snomed_codes will be matched (in addition to matching purely against the
        diagnosis.name) when trying to ascertain if the patient has this rare renal disease.
        Supporting regexes allows us to match a problem that has a SNOMED code that is the exact
        match, parent or child of the target RaDaR diagnosis SNOMED code.
      COMMENT
      add_column :problem_radar_diagnoses, :snomed_regex, :text, comment: comment
    end
  end
end
