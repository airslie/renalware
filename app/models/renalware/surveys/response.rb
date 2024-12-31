module Renalware
  module Surveys
    class Response < ApplicationRecord
      belongs_to :question, class_name: "Question"
      validates :patient_id, presence: true
      validates :answered_on, presence: true
      validates :question, presence: true
      validate :value_is_in_range

      private

      def value_is_in_range
        return if question&.validation_regex.blank?

        unless value =~ /#{question.validation_regex}/
          errors.add(
            :value,
            "(#{value}) must comply to regular expression /#{question.validation_regex}/"
          )
        end
      end
    end
  end
end
