# frozen_string_literal: true

module Renalware
  module Patients
    class Religion < ApplicationRecord
      validates :name, presence: true

      def to_s
        name
      end
    end
  end
end
