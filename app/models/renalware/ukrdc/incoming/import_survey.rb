module Renalware
  module UKRDC
    module Incoming
      class ImportSurvey
        pattr_initialize [:patient, :survey_hash]

        # Note that each question's answer may be a value like "1" or be an array where the second
        # element is the user-entered question text e.g. ["1", "Paranoia"]
        # This is used in POS-S so that a user can enter their own question text.
        def call
          responses.each do |question_code, answer|
            question = question_having_code(question_code)
            answer = Array(answer)
            Surveys::Response.create!(
              patient_id: patient.id,
              question: question,
              value: answer[0],
              patient_question_text: answer[1],
              answered_on: answered_on
            )
          end
        end

        private

        def responses
          survey_hash[:responses]
        end

        def survey
          @survey ||= begin
            survey_code = survey_hash[:code].downcase
            Surveys::Survey.includes(:questions).find_by!(code: survey_code)
          end
        rescue ActiveRecord::RecordNotFound
          raise UKRDC::SurveyNotFoundError, "Survey with name #{survey_hash[:code]} not found"
        end

        def question_having_code(code)
          survey.questions.detect { |q| q.code == code }.tap do |question|
            if question.nil?
              raise(
                UKRDC::QuestionNotFoundError,
                "Question with code #{code} not found in survey #{survey.name}"
              )
            end
          end
        end

        def answered_on
          survey_hash[:time]
        end
      end
    end
  end
end
