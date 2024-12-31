module Renalware
  module Surveys
    class EQ5DComponent < ApplicationComponent
      rattr_initialize [:patient!]

      # If the survey is not found in the survey_surveys table then do not render the
      # component at all
      def render?
        survey.present?
      end

      def rows
        @rows ||= EQ5DPivotedResponse.where(patient_id: patient.id)
      end

      def question_labels
        survey
          .questions
          .order(:position)
          .select(:code, :label)
          .each_with_object({}) { |q, hash| hash[q.code] = q.label }
      end

      def data_for_question_code(_code)
        Renalware::Surveys::Response
          .where(patient_id: patient.id, question_id: 1)
          .pluck(:answered_on, :value)
          .to_h
      end

      def column_headings
        @column_headings ||= begin
          headings = ["Date"]

          headings.concat(
            Renalware::Survey
            .find_by!(code: "eq5d")
            .questions
            .order(:position)
            .pluck(:label)
          )
          headings
        end
      end

      def survey
        @survey ||= Renalware::Surveys::Survey.find_by(code: "eq5d")
      end
    end
  end
end
