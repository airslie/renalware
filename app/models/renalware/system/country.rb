# frozen_string_literal: true

require_dependency "renalware/system"

module Renalware
  module System
    class Country < ApplicationRecord
      validates :name, presence: true, uniqueness: true
      validates :alpha2, presence: true, uniqueness: true
      validates :alpha3, presence: true, uniqueness: true

      default_scope ->{ order(position: :asc) }

      def to_s
        name
      end

      def uk?
        (alpha3 || "").casecmp("GBR").zero?
      end
    end
  end
end
