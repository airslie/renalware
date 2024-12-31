module Renalware
  module System
    class Visit < ApplicationRecord
      # See https://github.com/ankane/ahoy
      has_many :events, class_name: "System::Event", dependent: :destroy
      belongs_to :user, optional: true
    end
  end
end
