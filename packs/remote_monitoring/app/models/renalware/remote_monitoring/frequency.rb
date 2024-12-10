# frozen_string_literal: true

module Renalware
  module RemoteMonitoring
    class Frequency < ApplicationRecord
      acts_as_paranoid
      validates :period, presence: true, uniqueness: true
      validates :position, presence: true
      scope :ordered, -> { order(position: :asc) }
      def to_s = period.inspect
    end
  end
end
