module Renalware
  Rails.benchmark "Adding EQ5D survey responses" do
    patient = Patient.find_by!(family_name: "RABBIT", given_name: "Roger")
    survey = Surveys::Survey.find_by!(code: "eq5d")
    (1..4).each do |month|
      survey.questions.each do |question|
        question.responses.create!(
          patient_id: patient.id,
          answered_on: month.months.ago,
          value: rand(1..5)
        )
      end
    end
  end

  Rails.benchmark "Adding POS-S survey responses" do
    patient = Patient.find_by!(family_name: "RABBIT", given_name: "Roger")
    survey = Surveys::Survey.find_by!(code: "prom")
    (1..4).each do |month|
      survey.questions.each do |question|
        question.responses.create!(
          patient_id: patient.id,
          answered_on: month.months.ago,
          value: rand(0..4)
        )
      end
    end
  end
end
