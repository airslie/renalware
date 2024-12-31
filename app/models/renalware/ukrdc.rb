module Renalware
  module UKRDC
    class SurveyNotFoundError < StandardError; end

    class QuestionNotFoundError < StandardError; end

    def self.table_name_prefix = "ukrdc_"
  end
end
