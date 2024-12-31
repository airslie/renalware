module Renalware
  Rails.benchmark "Adding EQ5D Survey" do
    survey = Surveys::Survey.create(
      name: "EQ5D-5L",
      code: "eq5d",
      description: "Patient health status"
    )
    file_path = File.join(File.dirname(__FILE__), "eq5d_5l_questions.csv")
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
