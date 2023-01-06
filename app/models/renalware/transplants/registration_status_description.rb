# frozen_string_literal: true

module Renalware
  module Transplants
    class RegistrationStatusDescription < ApplicationRecord
      scope :ordered, -> { order(position: :asc) }

      validates :name, presence: true

      def to_s
        name
      end
    end
  end
end
