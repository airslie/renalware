module Renalware
  module System
    class Template < ApplicationRecord
      validates :name, presence: true
      validates :description, presence: true
      validates :body, presence: true
    end
  end
end
