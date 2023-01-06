# frozen_string_literal: true

module Renalware
  module Events
    class Simple < Event
      validates :description, presence: true
    end
  end
end
