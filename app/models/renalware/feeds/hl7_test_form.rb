# frozen_string_literal: true

module Renalware
  module Feeds
    class HL7TestForm
      include ActiveModel::Model
      attr_accessor :body
    end
  end
end
