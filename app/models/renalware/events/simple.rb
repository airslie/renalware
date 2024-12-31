module Renalware
  module Events
    class Simple < Event
      validates :description, presence: true
    end
  end
end
