# frozen_string_literal: true

require_dependency "renalware/surveys"

module Renalware
  module Surveys
    class Survey < ApplicationRecord
      acts_as_paranoid
      has_many :questions, dependent: :destroy
      validates :name, presence: true, uniqueness: true

      def to_s
        name
      end
    end
  end
end
