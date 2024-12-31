module Renalware
  Rails.benchmark "Adding POS-S Renal Survey" do
    survey = Surveys::Survey.create(
      name: "PROM",
      code: "prom",
      description: "Patient health status"
    )
    file_path = File.join(File.dirname(__FILE__), "pos_s_questions.csv")

    questions = CSV.foreach(file_path, headers: true).map do |row|
      {
        survey_id: survey.id,
        code: row["code"],
        position: row["position"],
        label: row["label"],
        validation_regex: row["validation_regex"],
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Surveys::Question.upsert_all(questions, unique_by: [:survey_id, :code])
  end
end
