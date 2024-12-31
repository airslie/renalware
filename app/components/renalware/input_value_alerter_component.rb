module Renalware
  class InputValueAlerterComponent < ApplicationComponent
    include IconHelper
    renders_one :input

    attr_reader :not_recommended_values, :message

    def initialize(not_recommended_values:, message:)
      @not_recommended_values = not_recommended_values.to_json
      @message = message
      super
    end

    def input_date_attributes
      { action: "change->input-value-alerter#change", "input-value-alerter-target": "input" }
    end
  end
end
