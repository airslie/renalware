module Renalware
  module System
    class Event < ApplicationRecord
      include Ahoy::QueryMethods # See https://github.com/ankane/ahoy

      belongs_to :visit, class_name: "System::Visit"
      belongs_to :user, optional: true
    end
  end
end
